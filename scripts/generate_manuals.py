#!/usr/bin/env python3
"""
ClaudeCodeCTO Manual Generator

Produces timestamped reference manuals for the current state of all
skills, agents, and commands in the catalog. Each manual is a detailed
markdown file grouped by source repository.

Output:
  docs/manuals/skills_<DD>_<MM>_<YYYY>.md
  docs/manuals/agents_<DD>_<MM>_<YYYY>.md
  docs/manuals/commands_<DD>_<MM>_<YYYY>.md
  docs/manuals/INDEX.md  (chronological list of all snapshots)

Run after any change to the catalog (i.e. after extractor.py produces
a new decisions/catalog.json):

    python scripts/extractor.py
    python scripts/generate_manuals.py

Flags:
  --date=DD-MM-YYYY  Override the date stamp (default: today)
  --force            Overwrite existing snapshot for the same date
"""
from __future__ import annotations

import json
import re
import sys
from collections import defaultdict
from datetime import date
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / "decisions" / "catalog.json"
OUT_DIR = ROOT / "docs" / "manuals"
OUT_DIR.mkdir(parents=True, exist_ok=True)

BODY_EXCERPT_CHARS = 220
INDEX_FILE = OUT_DIR / "INDEX.md"


def slugify(s: str) -> str:
    """Make a string safe to use as a markdown anchor."""
    s = s.lower()
    s = re.sub(r"[^a-z0-9\s-]", "", s)
    s = re.sub(r"\s+", "-", s).strip("-")
    return s or "x"


def trim(text: str, n: int) -> str:
    if not text:
        return ""
    text = re.sub(r"\s+", " ", text).strip()
    if len(text) <= n:
        return text
    return text[:n].rstrip() + "…"


def short_desc(fm: dict, body: str) -> str:
    """One-line description from frontmatter or body fallback."""
    desc = fm.get("description") or fm.get("summary") or ""
    if isinstance(desc, list):
        desc = " ".join(str(x) for x in desc)
    desc = str(desc)
    if not desc and body:
        # Fall back to first non-heading sentence from body
        first = next((ln for ln in body.splitlines() if ln.strip() and not ln.startswith("#")), "")
        desc = first
    return trim(desc, 200)


def metadata_badges(fm: dict) -> str:
    """Compact one-line metadata: tools/model/version/domain."""
    bits = []
    if fm.get("version"):
        bits.append(f"v{fm['version']}")
    if fm.get("model"):
        bits.append(f"model:{fm['model']}")
    if fm.get("domain"):
        bits.append(f"domain:{fm['domain']}")
    tools = fm.get("tools") or fm.get("allowed-tools")
    if tools:
        if isinstance(tools, list):
            tools_str = ",".join(str(t) for t in tools[:3])
            if len(tools) > 3:
                tools_str += f",+{len(tools)-3}"
        else:
            tools_str = str(tools)[:60]
        bits.append(f"tools:{tools_str}")
    tags = fm.get("tags")
    if tags:
        if isinstance(tags, list):
            bits.append(f"tags:{','.join(str(t) for t in tags[:3])}")
    return " · ".join(bits)


def load_catalog() -> dict:
    if not CATALOG.exists():
        print(f"ERROR: {CATALOG} not found — run scripts/extractor.py first.", file=sys.stderr)
        sys.exit(1)
    return json.loads(CATALOG.read_text(encoding="utf-8"))


def dedupe_by_id(components: list) -> list:
    """Keep the first occurrence of each (type, id). Prefer non-i18n paths."""
    by_key: dict[tuple, dict] = {}
    for c in components:
        key = (c["type"], c["id"])
        existing = by_key.get(key)
        if existing is None:
            by_key[key] = c
            continue
        # Tie-break: prefer non-i18n-docs path
        existing_i18n = "/docs/" in existing["path"]
        new_i18n = "/docs/" in c["path"]
        if existing_i18n and not new_i18n:
            by_key[key] = c
    return list(by_key.values())


def generate_manual(ctype: str, components: list, when: str) -> str:
    """Generate a markdown document for one component type."""
    items = [c for c in components if c["type"] == ctype]
    items.sort(key=lambda c: (c["source_repo"], c["id"]))

    by_repo: dict[str, list] = defaultdict(list)
    for c in items:
        by_repo[c["source_repo"]].append(c)

    lines: list[str] = []
    plural = {"skill": "Skills", "agent": "Agents", "command": "Commands"}[ctype]
    icon = {"skill": "🧩", "agent": "🤖", "command": "⚡"}[ctype]

    lines.append(f"# {icon} {plural} Manual — {when}")
    lines.append("")
    lines.append(f"> Snapshot of all {plural.lower()} in the ClaudeCodeCTO catalog on **{when}**.")
    lines.append("")
    lines.append(f"- **Total unique {plural.lower()}:** {len(items)}")
    lines.append(f"- **Source repositories:** {len(by_repo)}")
    lines.append(f"- **Catalog file:** `decisions/catalog.json`")
    lines.append(f"- **Generator:** `scripts/generate_manuals.py`")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## Index by Source Repository")
    lines.append("")
    for repo in sorted(by_repo):
        anchor = slugify(repo)
        lines.append(f"- [{repo}](#{anchor}) — {len(by_repo[repo])} {plural.lower()}")
    lines.append("")
    lines.append("---")
    lines.append("")

    for repo in sorted(by_repo):
        anchor = slugify(repo)
        lines.append(f'## <a id="{anchor}"></a>{repo}')
        lines.append("")
        lines.append(f"*{len(by_repo[repo])} {plural.lower()} from this repository*")
        lines.append("")
        for c in by_repo[repo]:
            fm = c.get("frontmatter", {}) or {}
            desc = short_desc(fm, c.get("body_excerpt", ""))
            meta = metadata_badges(fm)
            path = c.get("path", "")

            lines.append(f"### `{c['id']}`")
            lines.append("")
            if desc:
                lines.append(desc)
                lines.append("")
            details = []
            details.append(f"**Path:** [`{path}`](../../{path})")
            if meta:
                details.append(f"**Meta:** {meta}")
            lines.append(" · ".join(details))
            lines.append("")
            # body excerpt if distinct from description
            body = c.get("body_excerpt", "")
            if body:
                body_trim = trim(body, BODY_EXCERPT_CHARS)
                # Only include if it adds info beyond description
                if body_trim and body_trim.lower() not in desc.lower():
                    lines.append(f"> {body_trim}")
                    lines.append("")
        lines.append("---")
        lines.append("")

    lines.append("")
    lines.append(f"*Generated by `scripts/generate_manuals.py` on {when}*")
    lines.append("")
    return "\n".join(lines)


def update_index(out_dir: Path) -> None:
    """Rebuild docs/manuals/INDEX.md listing every snapshot chronologically."""
    files = sorted(out_dir.glob("*.md"))
    # Group by date
    by_date: dict[str, dict[str, Path]] = defaultdict(dict)
    for f in files:
        if f.name == "INDEX.md":
            continue
        # Expect pattern <type>_DD_MM_YYYY.md
        m = re.match(r"^(skills|agents|commands)_(\d{2})_(\d{2})_(\d{4})\.md$", f.name)
        if not m:
            continue
        ctype, dd, mm, yyyy = m.groups()
        iso = f"{yyyy}-{mm}-{dd}"
        by_date[iso][ctype] = f

    lines = []
    lines.append("# 📚 ClaudeCodeCTO Manuals Index")
    lines.append("")
    lines.append("> Chronological list of catalog snapshots. Each snapshot is a detailed reference of every skill, agent, and command at a point in time. Generated by [`scripts/generate_manuals.py`](../../scripts/generate_manuals.py).")
    lines.append("")
    if not by_date:
        lines.append("*No snapshots yet.*")
    else:
        lines.append("| Date | Skills | Agents | Commands |")
        lines.append("|---|---|---|---|")
        for iso in sorted(by_date.keys(), reverse=True):
            group = by_date[iso]
            dd, mm, yyyy = iso.split("-")[2], iso.split("-")[1], iso.split("-")[0]
            human = f"{dd}-{mm}-{yyyy}"
            cells = []
            for ctype in ("skills", "agents", "commands"):
                f = group.get(ctype)
                if f:
                    cells.append(f"[📖]({f.name})")
                else:
                    cells.append("—")
            lines.append(f"| **{human}** | {cells[0]} | {cells[1]} | {cells[2]} |")
    lines.append("")
    lines.append("---")
    lines.append("")
    lines.append("## How to regenerate")
    lines.append("")
    lines.append("```bash")
    lines.append("# 1. Rescan sources/ submodules into decisions/catalog.json")
    lines.append("python scripts/extractor.py")
    lines.append("")
    lines.append("# 2. Generate a new dated snapshot in this directory")
    lines.append("python scripts/generate_manuals.py")
    lines.append("```")
    lines.append("")
    lines.append("Use `--date=DD-MM-YYYY` to override the timestamp, or `--force` to overwrite an existing snapshot.")
    lines.append("")

    with open(INDEX_FILE, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines))


def main() -> int:
    args = sys.argv[1:]
    force = "--force" in args
    date_override = None
    for a in args:
        if a.startswith("--date="):
            date_override = a.split("=", 1)[1]
        elif a in {"--help", "-h"}:
            print(__doc__)
            return 0

    if date_override:
        # Expect DD-MM-YYYY
        m = re.match(r"^(\d{2})-(\d{2})-(\d{4})$", date_override)
        if not m:
            print("ERROR: --date must be DD-MM-YYYY", file=sys.stderr)
            return 1
        dd, mm, yyyy = m.groups()
    else:
        today = date.today()
        dd = f"{today.day:02d}"
        mm = f"{today.month:02d}"
        yyyy = f"{today.year}"

    when = f"{dd}-{mm}-{yyyy}"

    catalog = load_catalog()
    components = dedupe_by_id(catalog.get("components", []))

    counts = {"skill": 0, "agent": 0, "command": 0}
    for c in components:
        counts[c["type"]] = counts.get(c["type"], 0) + 1

    print(f"Loaded {len(components)} unique components from catalog.json")
    print(f"  Skills:   {counts['skill']}")
    print(f"  Agents:   {counts['agent']}")
    print(f"  Commands: {counts['command']}")
    print(f"  Snapshot date: {when}")
    print()

    for ctype, fname in [
        ("skill", f"skills_{dd}_{mm}_{yyyy}.md"),
        ("agent", f"agents_{dd}_{mm}_{yyyy}.md"),
        ("command", f"commands_{dd}_{mm}_{yyyy}.md"),
    ]:
        out = OUT_DIR / fname
        if out.exists() and not force:
            print(f"  SKIP {fname} (exists — use --force to overwrite)")
            continue
        text = generate_manual(ctype, components, when)
        with open(out, "w", encoding="utf-8", newline="\n") as f:
            f.write(text)
        size_kb = out.stat().st_size // 1024
        print(f"  WROTE {fname} ({counts[ctype]} entries, {size_kb} KB)")

    update_index(OUT_DIR)
    print(f"\n  WROTE {INDEX_FILE.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
