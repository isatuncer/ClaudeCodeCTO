#!/usr/bin/env python3
"""
CloaudeCodeCTO Rubric Scorer — Stage 3a

Input:  decisions/catalog.json
Output: decisions/scored-catalog.json

Scoring: 0-100 points, purely deterministic, no API calls.
- No hard size cap
- No count cap
- No size-based penalty
- Eliminates only truly broken components (no frontmatter + no body)

Rubric breakdown:
  A. Structural signals         (30 pts)  frontmatter, description, examples
  B. Content quality            (30 pts)  TODO-free, headings, code blocks
  C. Cross-repo signals         (20 pts)  richness vs duplicates, provenance
  D. Domain classification      (20 pts)  informational only, not punitive
"""

from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parent.parent
DECISIONS = ROOT / "decisions"
CATALOG_PATH = DECISIONS / "catalog.json"
OUTPUT_PATH = DECISIONS / "scored-catalog.json"

# Domain vocabulary — for classification and partial scoring
DOMAIN_KEYWORDS = {
    "project-mgmt": [
        "project", "sprint", "roadmap", "plan", "milestone", "backlog", "prd",
        "okr", "scrum", "agile", "stakeholder", "estimation", "task",
    ],
    "docs": [
        "documentation", "readme", "changelog", "api-doc", "api docs", "tutorial",
        "guide", "markdown", "docstring", "commentary", "reference",
    ],
    "testing": [
        "test", "tdd", "bdd", "e2e", "coverage", "mutation", "qa", "playwright",
        "jest", "pytest", "vitest", "unit test", "integration test", "smoke",
    ],
    "coding": [
        "refactor", "review", "clean code", "lint", "format", "debug", "fix",
        "bug", "code quality", "style", "convention", "naming",
    ],
    "architecture": [
        "architect", "design pattern", "c4", "ddd", "hexagonal", "microservice",
        "monolith", "cqrs", "event source", "system design", "boundary",
    ],
    "devops": [
        "docker", "kubernetes", "k8s", "ci", "cd", "deploy", "terraform", "aws",
        "azure", "gcp", "pipeline", "helm", "ansible", "rollout", "canary",
    ],
    "security": [
        "security", "auth", "owasp", "xss", "injection", "csrf", "crypto",
        "secret", "vault", "permission", "rbac", "oauth", "jwt", "vulnerability",
    ],
    "data-ai": [
        "ml", "llm", "rag", "embedding", "vector", "pytorch", "tensorflow",
        "fine-tune", "prompt", "inference", "training", "pipeline", "etl",
    ],
    "frontend": [
        "react", "vue", "angular", "svelte", "css", "tailwind", "nextjs", "ui",
        "component", "hook", "accessibility", "a11y", "responsive",
    ],
    "backend": [
        "api", "rest", "graphql", "database", "sql", "redis", "queue", "worker",
        "grpc", "fastapi", "django", "rails", "nodejs", "express",
    ],
}

TODO_MARKERS = ("todo:", "tbd", "wip", "fixme", "xxx:", "hack:")

# Trusted source bonus
PROVENANCE_BONUS = {
    "anthropics-skills": 8,
    "everything-claude-code": 5,
    "continuous-claude-v3": 4,
    "alirezarezvani-claude-skills": 3,
    "voltagent-subagents": 3,
    "antigravity-awesome-skills": 2,
    "rohitg00-toolkit": 2,
    "awesome-claude-code": 1,
    "enterprise-software-house": 0,
    "awesome-chatgpt-prompts": 0,
}


def score_structural(comp: dict[str, Any]) -> tuple[int, dict[str, int]]:
    """A. Structural signals — max 30."""
    qs = comp["quality_signals"]
    cm = comp["content_metrics"]
    breakdown: dict[str, int] = {}
    score = 0

    # Valid frontmatter (8)
    if qs["has_valid_frontmatter"]:
        score += 8
        breakdown["frontmatter"] = 8

    # Description length (6)
    dlen = qs["description_length"]
    if dlen >= 50:
        score += 6
        breakdown["description_length"] = 6
    elif dlen >= 20:
        score += 3
        breakdown["description_length"] = 3

    # Description domain-aware (4) — contains recognizable domain term
    desc = str(comp["frontmatter"].get("description", "")).lower()
    if desc:
        all_kws = [kw for kws in DOMAIN_KEYWORDS.values() for kw in kws]
        if any(kw in desc for kw in all_kws):
            score += 4
            breakdown["description_domain"] = 4

    # Trigger / when-to-use hint (4)
    if cm["has_trigger_hint"] or cm["has_when_to_use"]:
        score += 4
        breakdown["trigger_hint"] = 4

    # Examples block (4)
    if cm["has_examples"]:
        score += 4
        breakdown["examples"] = 4

    # Heading hierarchy (4)
    if cm["heading_count"] >= 3:
        score += 4
        breakdown["headings"] = 4
    elif cm["heading_count"] >= 1:
        score += 2
        breakdown["headings"] = 2

    return score, breakdown


def score_content(comp: dict[str, Any]) -> tuple[int, dict[str, int]]:
    """B. Content quality — max 30."""
    qs = comp["quality_signals"]
    cm = comp["content_metrics"]
    body = comp.get("body_excerpt", "")
    breakdown: dict[str, int] = {}
    score = 0

    # No TODO markers (10) — strong negative signal if present
    if not qs["has_todo_markers"]:
        score += 10
        breakdown["no_todo"] = 10

    # Has at least one code block (5)
    if cm["code_block_count"] >= 1:
        score += 5
        breakdown["code_block"] = 5

    # Body substantial (5) — >= 300 chars of actual body
    if len(body) >= 300:
        score += 5
        breakdown["substantial_body"] = 5
    elif len(body) >= 100:
        score += 2
        breakdown["substantial_body"] = 2

    # Specific (not generic) description (5)
    desc = str(comp["frontmatter"].get("description", "")).lower()
    generic_patterns = (
        "a skill for",
        "this is a",
        "todo",
        "description",
        "placeholder",
    )
    if desc and not any(gp in desc for gp in generic_patterns):
        score += 5
        breakdown["specific_desc"] = 5

    # Proper structure: multiple headings and body (5)
    if cm["heading_count"] >= 2 and cm["body_line_count"] >= 10:
        score += 5
        breakdown["proper_structure"] = 5

    return score, breakdown


def score_crossrepo(
    comp: dict[str, Any],
    by_id: dict[tuple[str, str], list[dict[str, Any]]],
) -> tuple[int, dict[str, int]]:
    """C. Cross-repo signals — max 20."""
    breakdown: dict[str, int] = {}
    score = 0

    # Provenance bonus (8)
    repo = comp["source_repo"]
    bonus = PROVENANCE_BONUS.get(repo, 0)
    score += bonus
    if bonus:
        breakdown["provenance"] = bonus

    # Richness vs duplicates (7)
    key = (comp["type"], comp["id"])
    duplicates = by_id.get(key, [])
    if len(duplicates) > 1:
        sizes = [d["content_metrics"]["size_bytes"] for d in duplicates]
        my_size = comp["content_metrics"]["size_bytes"]
        if my_size == max(sizes):
            score += 7
            breakdown["richest_version"] = 7
        elif my_size >= sum(sizes) / len(sizes):
            score += 3
            breakdown["above_average"] = 3
    else:
        # Unique — not a duplicate at all
        score += 5
        breakdown["unique_id"] = 5

    # Unique content (5) — body differs from simple boilerplate
    body = comp.get("body_excerpt", "").strip()
    if len(body) >= 200 and body.count("\n") >= 5:
        score += 5
        breakdown["substantive_body"] = 5

    return min(score, 20), breakdown


def classify_domain(comp: dict[str, Any]) -> tuple[str, int, dict[str, int]]:
    """D. Domain classification — max 20. Returns (primary domain, score, hits)."""
    text_parts = [
        comp["id"],
        str(comp["frontmatter"].get("description", "")),
        str(comp["frontmatter"].get("name", "")),
        comp.get("body_excerpt", "")[:300],
    ]
    text = " ".join(text_parts).lower()

    hits: dict[str, int] = {}
    for domain, kws in DOMAIN_KEYWORDS.items():
        count = sum(text.count(kw) for kw in kws)
        if count > 0:
            hits[domain] = count

    if not hits:
        return "other", 0, {}

    primary = max(hits.items(), key=lambda x: x[1])[0]
    # Score: up to 20 points based on strongest match
    top_count = hits[primary]
    score = min(20, top_count * 4)
    return primary, score, hits


def verdict_for_score(total: int, qs: dict[str, Any]) -> str:
    """Assign verdict bucket based on total score and hard signals."""
    # Hard elimination: empty or no frontmatter AND no body
    if qs["is_empty"]:
        return "eliminate"
    # Score thresholds
    if total < 25:
        return "eliminate"
    if total < 50:
        return "borderline"
    if total < 75:
        return "candidate"
    return "auto-keep"


def main() -> int:
    if not CATALOG_PATH.exists():
        print(f"ERROR: {CATALOG_PATH} not found. Run extractor.py first.", file=sys.stderr)
        return 1

    catalog = json.loads(CATALOG_PATH.read_text(encoding="utf-8"))
    components: list[dict[str, Any]] = catalog["components"]

    # Build id index for cross-repo lookups
    by_id: dict[tuple[str, str], list[dict[str, Any]]] = defaultdict(list)
    for c in components:
        by_id[(c["type"], c["id"])].append(c)

    print(f"Scoring {len(components)} components...")
    print()

    verdict_counts: dict[str, int] = defaultdict(int)
    domain_counts: dict[str, int] = defaultdict(int)
    type_verdict: dict[str, dict[str, int]] = defaultdict(lambda: defaultdict(int))

    for comp in components:
        a_score, a_break = score_structural(comp)
        b_score, b_break = score_content(comp)
        c_score, c_break = score_crossrepo(comp, by_id)
        domain, d_score, d_hits = classify_domain(comp)

        total = a_score + b_score + c_score + d_score
        verdict = verdict_for_score(total, comp["quality_signals"])

        comp["score"] = {
            "total": total,
            "structural": a_score,
            "content": b_score,
            "crossrepo": c_score,
            "domain": d_score,
            "breakdown": {
                "A_structural": a_break,
                "B_content": b_break,
                "C_crossrepo": c_break,
            },
        }
        comp["domain"] = {
            "primary": domain,
            "hits": d_hits,
        }
        comp["verdict"] = verdict

        verdict_counts[verdict] += 1
        domain_counts[domain] += 1
        type_verdict[comp["type"]][verdict] += 1

    # Sort components by score descending
    components.sort(key=lambda c: c["score"]["total"], reverse=True)

    catalog["scoring"] = {
        "verdict_counts": dict(verdict_counts),
        "domain_counts": dict(domain_counts),
        "type_verdict": {t: dict(v) for t, v in type_verdict.items()},
    }

    OUTPUT_PATH.write_text(
        json.dumps(catalog, indent=2, ensure_ascii=False, default=str),
        encoding="utf-8",
    )

    # Print summary
    print("=" * 60)
    print("  SCORING COMPLETE")
    print("=" * 60)
    print()
    print("  VERDICT DISTRIBUTION")
    for v in ("auto-keep", "candidate", "borderline", "eliminate"):
        n = verdict_counts.get(v, 0)
        bar = "#" * (n // 30)
        print(f"    {v:<12}  {n:>5}  {bar}")
    print(f"    {'TOTAL':<12}  {sum(verdict_counts.values()):>5}")
    print()
    print("  BY TYPE")
    for t in ("skill", "agent", "command"):
        v = type_verdict.get(t, {})
        total = sum(v.values())
        print(
            f"    {t:<8}  total={total:>5}  "
            f"keep={v.get('auto-keep', 0):>4}  "
            f"cand={v.get('candidate', 0):>4}  "
            f"border={v.get('borderline', 0):>4}  "
            f"elim={v.get('eliminate', 0):>4}"
        )
    print()
    print("  DOMAIN DISTRIBUTION")
    for d in sorted(domain_counts, key=lambda x: -domain_counts[x]):
        n = domain_counts[d]
        bar = "#" * (n // 30)
        print(f"    {d:<14}  {n:>5}  {bar}")
    print()
    print(f"  Output: decisions/scored-catalog.json ({OUTPUT_PATH.stat().st_size // 1024} KB)")

    return 0


if __name__ == "__main__":
    sys.exit(main())
