#!/usr/bin/env python3
"""
Merge self-scoring batch results into scored-catalog.json.

Reads all batch result files from decisions/self-scoring/results/
Updates the catalog's components with:
  - self_score (aggregate of clarity/specificity/utility/reusability)
  - self_verdict (keep/maybe/skip from subagent)
  - corrected_domain (if subagent gave a different domain)
  - final_verdict (combination of rubric + self-scoring)

Output: decisions/scored-catalog.json (updated)
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
RESULTS_DIR = DECISIONS / "self-scoring" / "results"


def main() -> int:
    if not SCORED.exists():
        print(f"ERROR: {SCORED} not found", file=sys.stderr)
        return 1
    if not RESULTS_DIR.is_dir():
        print(f"ERROR: {RESULTS_DIR} not found", file=sys.stderr)
        return 1

    catalog = json.loads(SCORED.read_text(encoding="utf-8"))
    components: list[dict[str, Any]] = catalog["components"]

    # Index components by (type, id, source_repo) for quick lookup
    index: dict[tuple[str, str, str], dict[str, Any]] = {}
    for c in components:
        key = (c["type"], c["id"], c["source_repo"])
        index[key] = c

    # Collect all batch results
    batch_files = sorted(RESULTS_DIR.glob("batch-*.json"))
    if not batch_files:
        print(f"ERROR: no batch results found in {RESULTS_DIR}", file=sys.stderr)
        return 1

    print(f"Merging {len(batch_files)} batch result files...")

    total_scored = 0
    missing_matches = 0
    verdict_changes = {"keep_to_skip": 0, "keep_to_maybe": 0, "candidate_to_keep": 0, "candidate_to_skip": 0, "borderline_to_keep": 0, "borderline_to_skip": 0}
    domain_corrections = 0
    batch_summaries: list[dict[str, Any]] = []

    for bf in batch_files:
        try:
            data = json.loads(bf.read_text(encoding="utf-8"))
        except json.JSONDecodeError as e:
            print(f"  WARN: {bf.name} invalid JSON: {e}")
            continue

        batch_num = data.get("batch_num", "?")
        summary = data.get("summary", {})
        batch_summaries.append({"batch": batch_num, **summary})

        for r in data.get("results", []):
            key = (r["type"], r["id"], r["source_repo"])
            comp = index.get(key)
            if comp is None:
                missing_matches += 1
                continue

            # Aggregate self-score (0-10 scale, avg of 4 dims)
            dims = [r.get("clarity", 0), r.get("specificity", 0), r.get("utility", 0), r.get("reusability", 0)]
            avg = sum(dims) / 4 if dims else 0

            # Track verdict changes
            old_v = comp["verdict"]
            new_v = r.get("verdict", "maybe")
            if old_v == "auto-keep" and new_v == "skip":
                verdict_changes["keep_to_skip"] += 1
            elif old_v == "auto-keep" and new_v == "maybe":
                verdict_changes["keep_to_maybe"] += 1
            elif old_v == "candidate" and new_v == "keep":
                verdict_changes["candidate_to_keep"] += 1
            elif old_v == "candidate" and new_v == "skip":
                verdict_changes["candidate_to_skip"] += 1
            elif old_v == "borderline" and new_v == "keep":
                verdict_changes["borderline_to_keep"] += 1
            elif old_v == "borderline" and new_v == "skip":
                verdict_changes["borderline_to_skip"] += 1

            # Check domain correction
            correct_domain = r.get("correct_domain", "other")
            if correct_domain != comp["domain"]["primary"]:
                domain_corrections += 1

            comp["self_score"] = {
                "clarity": r.get("clarity", 0),
                "specificity": r.get("specificity", 0),
                "utility": r.get("utility", 0),
                "reusability": r.get("reusability", 0),
                "average": round(avg, 2),
                "verdict": new_v,
                "reasoning": r.get("reasoning", ""),
            }
            comp["corrected_domain"] = correct_domain
            comp["final_verdict"] = compute_final_verdict(comp)
            total_scored += 1

    # For items that were NOT self-scored, final_verdict = rubric verdict
    for c in components:
        if "final_verdict" not in c:
            c["final_verdict"] = c["verdict"]
            c["corrected_domain"] = c["domain"]["primary"]

    # Recompute verdict distribution
    final_dist: dict[str, int] = defaultdict(int)
    by_type_verdict: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))
    for c in components:
        final_dist[c["final_verdict"]] += 1
        by_type_verdict[c["type"]][c["final_verdict"]] += 1

    catalog["self_scoring"] = {
        "total_self_scored": total_scored,
        "missing_matches": missing_matches,
        "verdict_changes": verdict_changes,
        "domain_corrections": domain_corrections,
        "batches": batch_summaries,
    }
    catalog["final_verdicts"] = {
        "overall": dict(final_dist),
        "by_type": {t: dict(v) for t, v in by_type_verdict.items()},
    }

    SCORED.write_text(json.dumps(catalog, indent=2, ensure_ascii=False, default=str), encoding="utf-8")

    # Print summary
    print()
    print("=" * 60)
    print("  MERGE COMPLETE")
    print("=" * 60)
    print(f"  Total self-scored:       {total_scored}")
    print(f"  Missing matches:         {missing_matches}")
    print(f"  Domain corrections:      {domain_corrections}")
    print()
    print("  VERDICT CHANGES (rubric -> self-scoring)")
    for k, v in verdict_changes.items():
        print(f"    {k:<22}  {v:>5}")
    print()
    print("  FINAL VERDICT DISTRIBUTION")
    order = ["keep", "auto-keep", "candidate", "maybe", "borderline", "skip", "eliminate"]
    for v in order:
        n = final_dist.get(v, 0)
        if n:
            bar = "#" * (n // 30)
            print(f"    {v:<12}  {n:>5}  {bar}")
    print(f"    {'TOTAL':<12}  {sum(final_dist.values()):>5}")
    print()
    print("  BY TYPE")
    for t in ("skill", "agent", "command"):
        v = by_type_verdict.get(t, {})
        total = sum(v.values())
        parts = "  ".join(f"{k}={v.get(k, 0):>4}" for k in ("keep", "auto-keep", "candidate", "maybe", "borderline", "skip") if v.get(k))
        print(f"    {t:<8}  total={total:>5}  {parts}")
    print()
    print(f"  Output: decisions/scored-catalog.json")

    return 0


def compute_final_verdict(comp: dict[str, Any]) -> str:
    """Combine rubric verdict and self-scoring verdict into a final decision."""
    rubric_v = comp["verdict"]
    self = comp.get("self_score", {})
    self_v = self.get("verdict", "")
    avg = self.get("average", 0)

    # If self-scoring explicitly said skip, honor it
    if self_v == "skip":
        return "skip"
    # If self-scoring said keep with high confidence (avg >= 7), upgrade to keep
    if self_v == "keep" and avg >= 7:
        return "keep"
    # If self-scoring said keep but score is modest, mark as candidate
    if self_v == "keep":
        return "candidate"
    # If self-scoring said maybe, keep as borderline/candidate depending on avg
    if self_v == "maybe":
        return "candidate" if avg >= 6 else "borderline"
    # No self-scoring: pass through rubric
    return rubric_v


if __name__ == "__main__":
    sys.exit(main())
