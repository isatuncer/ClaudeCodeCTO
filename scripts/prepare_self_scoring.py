#!/usr/bin/env python3
"""
Prepare self-scoring batches (Stage 3b, Option C).

Selects:
  1. All borderline components (score 25-50)
  2. Random 200 from auto-keep (false positive check)
  3. All candidates with score 50-60 (lower edge of candidate bucket)

Writes batch files to decisions/self-scoring/pending/batch-NN.json
Each batch has 30 items max. Batch is resumable — if result file exists,
it's skipped.
"""

from __future__ import annotations

import json
import random
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
DECISIONS = ROOT / "decisions"
SCORED = DECISIONS / "scored-catalog.json"
OUT_DIR = DECISIONS / "self-scoring"
PENDING_DIR = OUT_DIR / "pending"
RESULTS_DIR = OUT_DIR / "results"

BATCH_SIZE = 30
RANDOM_SEED = 42
AUTO_KEEP_SAMPLE = 200


def main() -> int:
    if not SCORED.exists():
        print(f"ERROR: {SCORED} not found", file=sys.stderr)
        return 1

    OUT_DIR.mkdir(exist_ok=True)
    PENDING_DIR.mkdir(exist_ok=True)
    RESULTS_DIR.mkdir(exist_ok=True)

    catalog = json.loads(SCORED.read_text(encoding="utf-8"))
    components: list[dict[str, Any]] = catalog["components"]

    borderline = [c for c in components if c["verdict"] == "borderline"]

    auto_keep = [c for c in components if c["verdict"] == "auto-keep"]
    random.seed(RANDOM_SEED)
    auto_keep_sample = random.sample(auto_keep, min(AUTO_KEEP_SAMPLE, len(auto_keep)))

    low_candidates = [
        c for c in components
        if c["verdict"] == "candidate" and 50 <= c["score"]["total"] <= 60
    ]

    print("Self-scoring selection:")
    print(f"  Borderline (all):               {len(borderline)}")
    print(f"  Auto-keep (random sample):      {len(auto_keep_sample)}")
    print(f"  Low candidates (score 50-60):   {len(low_candidates)}")

    total_items = borderline + auto_keep_sample + low_candidates
    # Dedup (in case low_candidates accidentally picked something sampled)
    seen: set[tuple[str, str, str]] = set()
    unique: list[dict[str, Any]] = []
    for c in total_items:
        key = (c["type"], c["id"], c["source_repo"])
        if key not in seen:
            seen.add(key)
            unique.append(c)

    print(f"  Total unique to score:          {len(unique)}")

    num_batches = (len(unique) + BATCH_SIZE - 1) // BATCH_SIZE
    print(f"  Batch size:                     {BATCH_SIZE}")
    print(f"  Total batches:                  {num_batches}")
    print()

    # Trim to essentials in the batch file (keep size small)
    def trim(c: dict[str, Any]) -> dict[str, Any]:
        return {
            "id": c["id"],
            "type": c["type"],
            "source_repo": c["source_repo"],
            "path": c["path"],
            "current_score": c["score"]["total"],
            "current_domain": c["domain"]["primary"],
            "current_verdict": c["verdict"],
            "description": str(c["frontmatter"].get("description", ""))[:400],
        }

    for i in range(num_batches):
        batch_num = i + 1
        batch_items = unique[i * BATCH_SIZE:(i + 1) * BATCH_SIZE]
        batch_file = PENDING_DIR / f"batch-{batch_num:02d}.json"

        # Skip if result already exists
        result_file = RESULTS_DIR / f"batch-{batch_num:02d}.json"
        if result_file.exists():
            print(f"  [skip] batch-{batch_num:02d} already has result")
            continue

        batch_data = {
            "batch_num": batch_num,
            "size": len(batch_items),
            "items": [trim(c) for c in batch_items],
        }
        batch_file.write_text(
            json.dumps(batch_data, indent=2, ensure_ascii=False),
            encoding="utf-8",
        )

    remaining = num_batches - len(list(RESULTS_DIR.glob("batch-*.json")))
    print(f"  Batches ready for scoring:      {remaining}")
    print()
    print(f"  Pending: {PENDING_DIR}")
    print(f"  Results: {RESULTS_DIR}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
