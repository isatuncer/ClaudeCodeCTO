#!/usr/bin/env python3
"""
CloaudeCodeCTO Budget — Stage 4.6

Measures (does NOT enforce) token cost of the curated selection.

User directive: no hard cap, no elimination by count or size.
This script produces a *profile* so we know the actual cost, identify
outliers, and suggest description shortening candidates.

Output: decisions/budget-profile.json
"""

from __future__ import annotations

import json
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
DECISIONS = ROOT / "decisions"
SELECTED = DECISIONS / "selected.json"
OUTPUT = DECISIONS / "budget-profile.json"

# Rough heuristic: ~4 chars per token (English text, slightly conservative)
CHARS_PER_TOKEN = 4.0


def estimate_tokens(text: str) -> int:
    if not text:
        return 0
    return max(1, round(len(text) / CHARS_PER_TOKEN))


def main() -> int:
    if not SELECTED.exists():
        print(f"ERROR: {SELECTED} not found", file=sys.stderr)
        return 1

    selected = json.loads(SELECTED.read_text(encoding="utf-8"))
    components = selected["components"]

    print(f"Calculating budget profile for {len(components)} components...")
    print()

    # Per-component cost
    per_comp_costs: list[dict[str, Any]] = []
    totals_by_type: dict[str, dict[str, Any]] = defaultdict(
        lambda: {"count": 0, "id_tokens": 0, "desc_tokens": 0, "total_tokens": 0}
    )
    totals_by_domain: dict[str, dict[str, Any]] = defaultdict(
        lambda: {"count": 0, "desc_tokens": 0}
    )

    long_descriptions: list[dict[str, Any]] = []  # >200 chars, shortening candidates
    missing_descriptions: list[str] = []

    for c in components:
        comp_type = c["type"]
        comp_id = c["id"]
        desc = (c.get("description") or "").strip()

        id_tokens = estimate_tokens(comp_id)
        desc_tokens = estimate_tokens(desc)
        total = id_tokens + desc_tokens

        per_comp_costs.append({
            "id": comp_id,
            "type": comp_type,
            "domain": c["domain"],
            "id_tokens": id_tokens,
            "desc_tokens": desc_tokens,
            "desc_chars": len(desc),
        })

        totals_by_type[comp_type]["count"] += 1
        totals_by_type[comp_type]["id_tokens"] += id_tokens
        totals_by_type[comp_type]["desc_tokens"] += desc_tokens
        totals_by_type[comp_type]["total_tokens"] += total

        totals_by_domain[c["domain"]]["count"] += 1
        totals_by_domain[c["domain"]]["desc_tokens"] += desc_tokens

        if len(desc) > 200:
            long_descriptions.append({
                "id": comp_id,
                "type": comp_type,
                "source_repo": c["source_repo"],
                "chars": len(desc),
                "tokens": desc_tokens,
                "excerpt": desc[:120] + "...",
            })
        elif not desc:
            missing_descriptions.append(f"{comp_type}:{comp_id}")

    long_descriptions.sort(key=lambda x: -x["chars"])

    # Startup budget composition (rough approximation)
    sys_prompt_fixed = 2000                       # base Claude Code system
    rules_estimated = 5000                        # CLAUDE.md + rules/common
    buffer = 3000                                 # project CLAUDE.md + misc

    comp_total = sum(t["total_tokens"] for t in totals_by_type.values())
    startup_total = sys_prompt_fixed + rules_estimated + comp_total + buffer

    profile = {
        "totals_by_type": {k: dict(v) for k, v in totals_by_type.items()},
        "totals_by_domain": {k: dict(v) for k, v in totals_by_domain.items()},
        "startup_budget": {
            "system_prompt": sys_prompt_fixed,
            "rules": rules_estimated,
            "components_total": comp_total,
            "buffer": buffer,
            "estimated_total": startup_total,
        },
        "long_descriptions_count": len(long_descriptions),
        "long_descriptions_top50": long_descriptions[:50],
        "missing_descriptions_count": len(missing_descriptions),
        "missing_descriptions": missing_descriptions[:50],
        "shortening_suggestion": {
            "threshold_chars": 200,
            "candidates": len(long_descriptions),
            "potential_savings_tokens": sum(
                max(0, d["tokens"] - estimate_tokens("x" * 150))
                for d in long_descriptions
            ),
        },
    }

    OUTPUT.write_text(
        json.dumps(profile, indent=2, ensure_ascii=False, default=str),
        encoding="utf-8",
    )

    # Print summary
    print("=" * 60)
    print("  BUDGET PROFILE")
    print("=" * 60)
    print()
    print("  BY TYPE")
    for t in ("skill", "agent", "command"):
        v = totals_by_type.get(t, {})
        if not v:
            continue
        avg_desc = v["desc_tokens"] // max(1, v["count"])
        print(
            f"    {t:<9}  count={v['count']:>5}  "
            f"desc_tokens={v['desc_tokens']:>7,}  "
            f"total={v['total_tokens']:>7,}  "
            f"avg_desc={avg_desc}"
        )
    print()
    print("  STARTUP BUDGET (rough estimate)")
    sb = profile["startup_budget"]
    print(f"    System prompt:       {sb['system_prompt']:>8,}")
    print(f"    Rules (CLAUDE.md):   {sb['rules']:>8,}")
    print(f"    Components total:    {sb['components_total']:>8,}")
    print(f"    Buffer:              {sb['buffer']:>8,}")
    print(f"    {'─' * 30}")
    print(f"    TOTAL (estimated):   {sb['estimated_total']:>8,}")
    print()
    print("  OUTLIERS")
    print(f"    Long descriptions (>200 chars):  {len(long_descriptions)}")
    print(f"    Missing descriptions:            {len(missing_descriptions)}")
    ss = profile["shortening_suggestion"]
    print(f"    Potential savings if shortened:  {ss['potential_savings_tokens']:,} tokens")
    print()
    print(f"  Output: decisions/budget-profile.json")
    print()
    print("  NOTE: No caps enforced — this is measurement only.")
    print("  Full component set kept. Shortening is optional and interactive.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
