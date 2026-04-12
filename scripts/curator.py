#!/usr/bin/env python3
"""
CloaudeCodeCTO Curator — Stage 4

Input:  decisions/scored-catalog.json (with self-scoring merged in)
Output: decisions/selected.json

Selection rules:
  1. final_verdict in {"keep", "auto-keep"} -> selected
  2. Also include candidate items with score >= 60 and no skip verdict
  3. Resolve duplicate IDs: pick the highest-scoring version
  4. Group by corrected_domain
  5. Sort within each domain by combined score

No hard caps on count. No size-based elimination.
"""

from __future__ import annotations

import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
DECISIONS = ROOT / "decisions"
SCORED = DECISIONS / "scored-catalog.json"
SELECTED = DECISIONS / "selected.json"


def combined_score(comp: dict[str, Any]) -> float:
    """Combine rubric score (0-100) + self-score average (0-10) into 0-100."""
    rubric = comp["score"]["total"]
    self_avg = comp.get("self_score", {}).get("average")
    if self_avg is None:
        return float(rubric)
    # Self-score is 0-10, scale to 0-100, blend 60/40
    return round(rubric * 0.6 + self_avg * 10 * 0.4, 2)


def is_selected(comp: dict[str, Any]) -> bool:
    fv = comp["final_verdict"]
    if fv in ("keep", "auto-keep"):
        return True
    if fv == "candidate" and comp["score"]["total"] >= 60:
        return True
    return False


def main() -> int:
    if not SCORED.exists():
        print(f"ERROR: {SCORED} not found", file=sys.stderr)
        return 1

    catalog = json.loads(SCORED.read_text(encoding="utf-8"))
    components: list[dict[str, Any]] = catalog["components"]

    # Filter: selected items
    selected_items = [c for c in components if is_selected(c)]
    print(f"Pre-dedup selection: {len(selected_items)} items")

    # Deduplicate by (type, id) — keep highest combined score
    best: dict[tuple[str, str], dict[str, Any]] = {}
    for c in selected_items:
        key = (c["type"], c["id"])
        cs = combined_score(c)
        if key not in best or combined_score(best[key]) < cs:
            best[key] = c

    deduped = list(best.values())
    print(f"Post-dedup:          {len(deduped)} items")

    # Attach combined score
    for c in deduped:
        c["combined_score"] = combined_score(c)

    # Sort each by domain
    by_domain: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for c in deduped:
        domain = c.get("corrected_domain") or c["domain"]["primary"]
        by_domain[domain].append(c)

    for domain in by_domain:
        by_domain[domain].sort(key=lambda c: -c["combined_score"])

    # Split by type for easier downstream consumption
    by_type: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for c in deduped:
        by_type[c["type"]].append(c)

    for t in by_type:
        by_type[t].sort(key=lambda c: -c["combined_score"])

    selected_doc = {
        "generated_at": __import__("datetime").datetime.now().isoformat(timespec="seconds"),
        "total": len(deduped),
        "by_type": {t: len(items) for t, items in by_type.items()},
        "by_domain": {d: len(items) for d, items in by_domain.items()},
        "components": [
            {
                "id": c["id"],
                "type": c["type"],
                "source_repo": c["source_repo"],
                "path": c["path"],
                "domain": c.get("corrected_domain") or c["domain"]["primary"],
                "rubric_score": c["score"]["total"],
                "self_score_avg": c.get("self_score", {}).get("average"),
                "combined_score": c["combined_score"],
                "final_verdict": c["final_verdict"],
                "description": str(c["frontmatter"].get("description", ""))[:300],
                "frontmatter_name": c["frontmatter"].get("name"),
            }
            for c in sorted(deduped, key=lambda c: (-c["combined_score"], c["type"], c["id"]))
        ],
    }

    SELECTED.write_text(json.dumps(selected_doc, indent=2, ensure_ascii=False, default=str), encoding="utf-8")

    # Print summary
    print()
    print("=" * 60)
    print("  CURATION COMPLETE")
    print("=" * 60)
    print()
    print("  BY TYPE")
    for t in ("skill", "agent", "command"):
        n = len(by_type.get(t, []))
        if n:
            print(f"    {t:<10}  {n:>5}")
    print()
    print("  BY DOMAIN (priority order)")
    priority = ["project-mgmt", "docs", "testing", "coding", "architecture", "devops"]
    other = [d for d in by_domain if d not in priority]
    for d in priority + sorted(other):
        n = len(by_domain.get(d, []))
        if n:
            bar = "#" * (n // 10)
            print(f"    {d:<14}  {n:>5}  {bar}")
    print()
    print(f"  TOTAL SELECTED: {len(deduped)}")
    print()
    print(f"  Output: decisions/selected.json ({SELECTED.stat().st_size // 1024} KB)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
