#!/usr/bin/env python3
"""
CloaudeCodeCTO Agent Validator — Stage 4.7

Detects agent description overlap so Claude Code can unambiguously
pick the right agent. Uses Jaccard similarity on word sets (no external
deps). Generates:

  decisions/agent-overlap-report.json
  decisions/agent-decision-tree.md

Overlaps with Jaccard >= 0.4 are flagged. The decision tree groups
agents by common trigger keywords so a user (or Claude) can pick
unambiguously.
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
SELECTED = DECISIONS / "selected.json"
OVERLAP_REPORT = DECISIONS / "agent-overlap-report.json"
DECISION_TREE = DECISIONS / "agent-decision-tree.md"

OVERLAP_THRESHOLD = 0.4

STOPWORDS = {
    "the", "a", "an", "is", "are", "was", "were", "be", "been", "being",
    "and", "or", "but", "in", "on", "at", "to", "for", "with", "without",
    "of", "from", "by", "as", "this", "that", "these", "those", "it", "its",
    "when", "where", "why", "what", "which", "who", "whom", "how", "use",
    "uses", "using", "used", "needs", "need", "needed", "agent", "claude",
    "code", "you", "your", "assistant", "helper", "user", "task", "tasks",
    "specialist", "expert", "all", "any", "some", "each", "every", "no",
    "not", "nor", "so", "than", "too", "very", "can", "will", "just", "only",
    "also", "do", "does", "done", "make", "makes", "making", "helps", "help",
    "please", "should", "must", "may", "might",
}


def tokenize(text: str) -> set[str]:
    """Lowercase, strip non-alphanumeric, remove stopwords."""
    if not text:
        return set()
    words = re.findall(r"[a-zA-Z][a-zA-Z0-9\-]{2,}", text.lower())
    return {w for w in words if w not in STOPWORDS and len(w) > 2}


def jaccard(a: set[str], b: set[str]) -> float:
    if not a and not b:
        return 0.0
    inter = len(a & b)
    union = len(a | b)
    return inter / union if union else 0.0


# Domain triggers for the decision tree
TRIGGER_PATTERNS = {
    "review code": ["review", "quality", "inspect", "audit"],
    "fix bug / debug": ["debug", "bug", "fix", "error", "issue", "troubleshoot"],
    "test / TDD": ["test", "tdd", "coverage", "e2e", "integration"],
    "write code": ["build", "implement", "develop", "create", "scaffold"],
    "refactor / clean": ["refactor", "clean", "simplify", "optimize", "improve"],
    "design / architect": ["architect", "design", "pattern", "structure"],
    "deploy / devops": ["deploy", "docker", "kubernetes", "ci", "cd", "pipeline", "infra"],
    "document": ["document", "readme", "api-doc", "tutorial", "guide", "docs"],
    "secure / audit": ["security", "vulnerability", "auth", "owasp", "compliance"],
    "optimize performance": ["performance", "profile", "benchmark", "latency", "throughput"],
    "plan project": ["plan", "roadmap", "sprint", "milestone", "backlog", "prd"],
    "data / ML / AI": ["ml", "llm", "ai", "rag", "embedding", "vector", "model"],
}


def match_triggers(text: str) -> list[str]:
    text = text.lower()
    matched = []
    for trigger, kws in TRIGGER_PATTERNS.items():
        if any(kw in text for kw in kws):
            matched.append(trigger)
    return matched


def main() -> int:
    if not SELECTED.exists():
        print(f"ERROR: {SELECTED} not found", file=sys.stderr)
        return 1

    selected = json.loads(SELECTED.read_text(encoding="utf-8"))
    agents = [c for c in selected["components"] if c["type"] == "agent"]
    print(f"Validating {len(agents)} agents for overlap and ambiguity...")
    print()

    # Tokenize each agent's description
    tokens: list[set[str]] = []
    for a in agents:
        text = f"{a['id']} {a.get('description') or ''}"
        tokens.append(tokenize(text))

    # Compute pairwise Jaccard
    overlaps: list[dict[str, Any]] = []
    for i in range(len(agents)):
        for j in range(i + 1, len(agents)):
            sim = jaccard(tokens[i], tokens[j])
            if sim >= OVERLAP_THRESHOLD:
                overlaps.append({
                    "a": agents[i]["id"],
                    "b": agents[j]["id"],
                    "similarity": round(sim, 3),
                    "a_source": agents[i]["source_repo"],
                    "b_source": agents[j]["source_repo"],
                    "a_domain": agents[i]["domain"],
                    "b_domain": agents[j]["domain"],
                })

    overlaps.sort(key=lambda o: -o["similarity"])

    # Group agents by trigger
    by_trigger: dict[str, list[dict[str, Any]]] = defaultdict(list)
    untagged: list[dict[str, Any]] = []
    for a in agents:
        text = f"{a['id']} {a.get('description') or ''}"
        triggers = match_triggers(text)
        if triggers:
            for t in triggers:
                by_trigger[t].append(a)
        else:
            untagged.append(a)

    # Sort each trigger group by combined_score
    for t in by_trigger:
        by_trigger[t].sort(key=lambda a: -a["combined_score"])

    # Overlap report JSON
    report = {
        "total_agents": len(agents),
        "overlap_threshold": OVERLAP_THRESHOLD,
        "overlap_count": len(overlaps),
        "overlaps_top50": overlaps[:50],
        "trigger_groups": {
            t: [{"id": a["id"], "score": a["combined_score"], "source": a["source_repo"]}
                for a in agents_list[:10]]
            for t, agents_list in by_trigger.items()
        },
        "untagged_count": len(untagged),
    }
    OVERLAP_REPORT.write_text(
        json.dumps(report, indent=2, ensure_ascii=False, default=str),
        encoding="utf-8",
    )

    # Decision tree markdown
    lines = [
        "# Agent Decision Tree",
        "",
        "Her kullanıcı isteğinde Claude Code'un hangi agent'ı çağıracağı bu tabloya göre seçilmelidir. Her tetikleyici için agent'lar skor sırasıyla listelenir.",
        "",
        f"**Toplam agent:** {len(agents)}",
        f"**Overlap eşiği (Jaccard >= {OVERLAP_THRESHOLD}):** {len(overlaps)} çift",
        "",
    ]

    for trigger in sorted(by_trigger.keys()):
        agents_list = by_trigger[trigger]
        if not agents_list:
            continue
        lines.append(f"## {trigger}")
        lines.append("")
        lines.append("| Öncelik | Agent | Skor | Kaynak | Açıklama |")
        lines.append("|---------|-------|------|--------|----------|")
        for i, a in enumerate(agents_list[:8], 1):
            desc = (a.get("description") or "").replace("\n", " ").replace("|", "\\|")[:80]
            lines.append(f"| {i} | `{a['id']}` | {a['combined_score']:.0f} | {a['source_repo'][:20]} | {desc} |")
        lines.append("")

    # Top overlaps section
    if overlaps:
        lines.append("## Yüksek Overlap'ler (manuel inceleme)")
        lines.append("")
        lines.append("| A | B | Similarity | A Domain | B Domain |")
        lines.append("|---|---|------------|----------|----------|")
        for o in overlaps[:30]:
            lines.append(f"| `{o['a']}` | `{o['b']}` | {o['similarity']} | {o['a_domain']} | {o['b_domain']} |")
        lines.append("")

    DECISION_TREE.write_text("\n".join(lines) + "\n", encoding="utf-8")

    # Print summary
    print("=" * 60)
    print("  AGENT VALIDATION COMPLETE")
    print("=" * 60)
    print(f"  Total agents:      {len(agents)}")
    print(f"  Overlapping pairs: {len(overlaps)}")
    print(f"  Trigger groups:    {len(by_trigger)}")
    print(f"  Untagged:          {len(untagged)}")
    print()
    print("  TOP 5 HIGHEST OVERLAPS")
    for o in overlaps[:5]:
        print(f"    {o['similarity']:.3f}  {o['a']:<30} <-> {o['b']}")
    print()
    print("  BIGGEST TRIGGER GROUPS")
    for t in sorted(by_trigger.keys(), key=lambda k: -len(by_trigger[k])):
        print(f"    {t:<25}  {len(by_trigger[t]):>4} agents")
    print()
    print(f"  -> decisions/agent-overlap-report.json")
    print(f"  -> decisions/agent-decision-tree.md")

    return 0


if __name__ == "__main__":
    sys.exit(main())
