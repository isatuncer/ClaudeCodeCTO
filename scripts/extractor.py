#!/usr/bin/env python3
"""
CloaudeCodeCTO Extractor — Stage 2
Recursively scans sources/ and extracts rich metadata for every
skill, agent, and command found. Output: decisions/catalog.json

Auto-detects patterns:
  - Skills:   */skills/<name>/SKILL.md, */skills/<name>/README.md
  - Agents:   */agents/*.md, */.claude/agents/*.md, */categories/**/*.md
  - Commands: */commands/*.md, */.claude/commands/*.md

No external dependencies beyond PyYAML.
"""

from __future__ import annotations

import json
import re
import sys
from dataclasses import dataclass, asdict, field
from pathlib import Path
from typing import Any

import yaml

ROOT = Path(__file__).resolve().parent.parent
SOURCES = ROOT / "sources"
DECISIONS = ROOT / "decisions"
OUTPUT = DECISIONS / "catalog.json"

# Platform mirror dirs we skip (duplicates of main content)
SKIP_DIRS = {".codex", ".gemini", ".cursor", ".opencode", ".github", "node_modules", ".git"}

# Frontmatter regex: matches --- ... ---\n at start of file
FRONTMATTER_RE = re.compile(r"^---\s*\n(.*?)\n---\s*\n(.*)", re.DOTALL)


@dataclass
class Component:
    id: str                          # unique name (from frontmatter or filename)
    type: str                        # skill | agent | command
    source_repo: str                 # top-level repo name
    path: str                        # relative path from ROOT
    frontmatter: dict[str, Any] = field(default_factory=dict)
    body_excerpt: str = ""           # first ~500 chars of body (post-frontmatter)
    content_metrics: dict[str, Any] = field(default_factory=dict)
    quality_signals: dict[str, Any] = field(default_factory=dict)


def parse_frontmatter(text: str) -> tuple[dict[str, Any], str]:
    """Extract YAML frontmatter. Returns (frontmatter dict, body text)."""
    m = FRONTMATTER_RE.match(text)
    if not m:
        return {}, text
    try:
        fm = yaml.safe_load(m.group(1)) or {}
        if not isinstance(fm, dict):
            fm = {}
    except yaml.YAMLError:
        fm = {}
    return fm, m.group(2)


def content_metrics(text: str, body: str) -> dict[str, Any]:
    lines = text.splitlines()
    return {
        "size_bytes": len(text.encode("utf-8")),
        "line_count": len(lines),
        "body_line_count": len(body.splitlines()),
        "has_code_block": "```" in body,
        "code_block_count": body.count("```") // 2,
        "has_examples": bool(re.search(r"(?i)^#+\s*examples?", body, re.MULTILINE)),
        "has_when_to_use": bool(re.search(r"(?i)when to (use|activate|apply)", body)),
        "has_trigger_hint": bool(re.search(r"(?i)trigger|activate when|use when", body)),
        "heading_count": len(re.findall(r"^#+\s", body, re.MULTILINE)),
    }


def quality_signals(text: str, fm: dict[str, Any]) -> dict[str, Any]:
    lower = text.lower()
    return {
        "has_valid_frontmatter": bool(fm),
        "has_name": bool(fm.get("name")),
        "has_description": bool(fm.get("description")),
        "description_length": len(str(fm.get("description", ""))),
        "has_todo_markers": any(m in lower for m in ["todo", "tbd", "wip", "fixme"]),
        "is_empty": len(text.strip()) < 100,
        "is_huge": len(text) > 30000,
    }


def read_component(path: Path, comp_type: str, repo: str) -> Component | None:
    try:
        text = path.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return None

    fm, body = parse_frontmatter(text)

    # Determine id: prefer frontmatter name, fall back to filename/dirname
    name_from_fm = fm.get("name")
    if comp_type == "skill":
        # Skills live in their own dir; dirname is canonical
        comp_id = str(name_from_fm or path.parent.name)
    else:
        comp_id = str(name_from_fm or path.stem)

    return Component(
        id=comp_id,
        type=comp_type,
        source_repo=repo,
        path=str(path.relative_to(ROOT)).replace("\\", "/"),
        frontmatter=fm,
        body_excerpt=body[:500].strip(),
        content_metrics=content_metrics(text, body),
        quality_signals=quality_signals(text, fm),
    )


def walk_skippable(base: Path):
    """Walk base directory, skipping platform mirrors and junk dirs."""
    for p in base.rglob("*"):
        if any(part in SKIP_DIRS for part in p.parts):
            continue
        yield p


def find_skills(repo_path: Path, repo_name: str) -> list[Component]:
    """A skill = a directory containing SKILL.md (preferred) or README.md inside a 'skills' parent."""
    components: list[Component] = []
    seen_ids: set[str] = set()

    for md in walk_skippable(repo_path):
        if not md.is_file() or md.suffix != ".md":
            continue

        # Must be named SKILL.md or live under a skills/ parent
        is_skill_file = md.name == "SKILL.md"
        parent_is_skills = "skills" in [p.lower() for p in md.parent.parent.parts[-3:]]

        if not (is_skill_file or (md.name == "README.md" and parent_is_skills)):
            continue

        comp = read_component(md, "skill", repo_name)
        if comp is None:
            continue

        # Dedup by id
        dedup_key = f"{repo_name}::{comp.id}"
        if dedup_key in seen_ids:
            continue
        seen_ids.add(dedup_key)

        components.append(comp)

    return components


def find_agents(repo_path: Path, repo_name: str) -> list[Component]:
    """An agent = a .md file under agents/, .claude/agents/, or categories/ (voltagent)."""
    components: list[Component] = []
    seen_ids: set[str] = set()

    agent_parent_hints = {"agents", "categories"}
    skip_files = {"README.md", "CLAUDE.md", "AGENTS.md", "SKILL.md"}

    for md in walk_skippable(repo_path):
        if not md.is_file() or md.suffix != ".md":
            continue
        if md.name in skip_files:
            continue

        # Must be under agents/ or categories/
        parents_lower = [p.lower() for p in md.parts]
        if not any(hint in parents_lower for hint in agent_parent_hints):
            continue

        # Skip commands and skills under similar dirs
        if "commands" in parents_lower or "skills" in parents_lower:
            continue

        comp = read_component(md, "agent", repo_name)
        if comp is None:
            continue

        # Agents need frontmatter with description to be valid
        if not comp.frontmatter.get("description") and not comp.body_excerpt:
            continue

        dedup_key = f"{repo_name}::{comp.id}"
        if dedup_key in seen_ids:
            continue
        seen_ids.add(dedup_key)

        components.append(comp)

    return components


def find_commands(repo_path: Path, repo_name: str) -> list[Component]:
    """A command = a .md file under commands/ or .claude/commands/."""
    components: list[Component] = []
    seen_ids: set[str] = set()
    skip_files = {"README.md", "CLAUDE.md", "AGENTS.md"}

    for md in walk_skippable(repo_path):
        if not md.is_file() or md.suffix != ".md":
            continue
        if md.name in skip_files:
            continue

        parents_lower = [p.lower() for p in md.parts]
        if "commands" not in parents_lower:
            continue

        comp = read_component(md, "command", repo_name)
        if comp is None:
            continue

        dedup_key = f"{repo_name}::{comp.id}"
        if dedup_key in seen_ids:
            continue
        seen_ids.add(dedup_key)

        components.append(comp)

    return components


def main() -> int:
    if not SOURCES.is_dir():
        print(f"ERROR: sources directory not found at {SOURCES}", file=sys.stderr)
        return 1

    DECISIONS.mkdir(exist_ok=True)

    repos = sorted(p for p in SOURCES.iterdir() if p.is_dir())
    if not repos:
        print("ERROR: no repos found under sources/", file=sys.stderr)
        return 1

    print(f"CloaudeCodeCTO Extractor — scanning {len(repos)} repos")
    print(f"Sources: {SOURCES}")
    print()

    all_components: list[Component] = []
    stats: dict[str, dict[str, int]] = {}

    for repo in repos:
        repo_name = repo.name
        skills = find_skills(repo, repo_name)
        agents = find_agents(repo, repo_name)
        commands = find_commands(repo, repo_name)

        stats[repo_name] = {
            "skills": len(skills),
            "agents": len(agents),
            "commands": len(commands),
        }

        all_components.extend(skills)
        all_components.extend(agents)
        all_components.extend(commands)

        total_repo = len(skills) + len(agents) + len(commands)
        marker = "OK  " if total_repo > 0 else "--  "
        print(
            f"  [{marker}] {repo_name:<35} "
            f"skills={len(skills):>5}  agents={len(agents):>4}  commands={len(commands):>4}"
        )

    # Global dedup detection: same id across multiple repos = conflict
    by_id: dict[tuple[str, str], list[Component]] = {}
    for c in all_components:
        key = (c.type, c.id)
        by_id.setdefault(key, []).append(c)

    conflicts: list[dict[str, Any]] = []
    for (comp_type, comp_id), entries in by_id.items():
        if len(entries) > 1:
            conflicts.append({
                "type": comp_type,
                "id": comp_id,
                "count": len(entries),
                "sources": [e.source_repo for e in entries],
            })

    # Totals
    total_skills = sum(1 for c in all_components if c.type == "skill")
    total_agents = sum(1 for c in all_components if c.type == "agent")
    total_commands = sum(1 for c in all_components if c.type == "command")

    unique_skills = len({c.id for c in all_components if c.type == "skill"})
    unique_agents = len({c.id for c in all_components if c.type == "agent"})
    unique_commands = len({c.id for c in all_components if c.type == "command"})

    catalog = {
        "generated_at": __import__("datetime").datetime.now().isoformat(timespec="seconds"),
        "root": str(ROOT).replace("\\", "/"),
        "repos_scanned": len(repos),
        "summary": {
            "total": {
                "skills": total_skills,
                "agents": total_agents,
                "commands": total_commands,
            },
            "unique": {
                "skills": unique_skills,
                "agents": unique_agents,
                "commands": unique_commands,
            },
            "conflicts": len(conflicts),
        },
        "by_repo": stats,
        "conflicts": sorted(conflicts, key=lambda c: -c["count"])[:50],
        "components": [asdict(c) for c in all_components],
    }

    def _json_safe(o: Any) -> str:
        # Convert datetime/date and other unserializable objects to strings
        return str(o)

    OUTPUT.write_text(
        json.dumps(catalog, indent=2, ensure_ascii=False, default=_json_safe),
        encoding="utf-8",
    )

    print()
    print("=" * 60)
    print("  EXTRACTION COMPLETE")
    print("=" * 60)
    print(f"  Skills:    {total_skills:>5} total / {unique_skills:>5} unique")
    print(f"  Agents:    {total_agents:>5} total / {unique_agents:>5} unique")
    print(f"  Commands:  {total_commands:>5} total / {unique_commands:>5} unique")
    print(f"  Conflicts: {len(conflicts)}")
    print()
    print(f"  Output: decisions/catalog.json ({OUTPUT.stat().st_size // 1024} KB)")
    print()

    return 0


if __name__ == "__main__":
    sys.exit(main())
