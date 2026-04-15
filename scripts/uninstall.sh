#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Uninstaller
#
# Removes components that were installed by scripts/installer.sh
# from $CLAUDE_HOME (default ~/.claude), using decisions/install.tsv
# as the source of truth for which items to delete.
#
# Protected (NEVER touched):
#   - .credentials.json      (Claude Code login)
#   - projects/              (per-project memory)
#   - Anything not listed in install.tsv or the installer manifest
#
# Removed:
#   - skills/<id>/           for each skill in install.tsv
#   - agents/<id>.md         for each agent in install.tsv
#   - commands/<id>.md       for each command in install.tsv
#   - skills/project-lifecycle, commands/start-project.md,
#     config/lifecycle.json, rules/agent-decision-tree.md
#     (orchestrator assets written by installer)
#   - CLAUDE.md, settings.json — ONLY if they match the generator
#     header string; otherwise left alone.
#
# Env vars:
#   CLAUDE_HOME    Target (default: ~/.claude)
#
# Flags:
#   --dry-run      Show what would be removed, make no changes
#   --yes          Skip confirmation prompt
#   --keep-generated  Don't touch CLAUDE.md / settings.json
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cygpath -w "$ROOT_BASH" 2>/dev/null || echo "$ROOT_BASH")"
DECISIONS_BASH="$ROOT_BASH/decisions"
# Prefer profiles/full.tsv (superset of all profiles) so we remove anything
# any profile could have installed. Fall back to install.tsv for old checkouts.
if [ -f "$DECISIONS_BASH/profiles/full.tsv" ]; then
    INSTALL_TSV_BASH="$DECISIONS_BASH/profiles/full.tsv"
else
    INSTALL_TSV_BASH="$DECISIONS_BASH/install.tsv"
fi
INSTALL_TSV="$(cygpath -w "$INSTALL_TSV_BASH" 2>/dev/null || echo "$INSTALL_TSV_BASH")"

CLAUDE_HOME_BASH="${CLAUDE_HOME:-$HOME/.claude}"
CLAUDE_HOME="$(cygpath -w "$CLAUDE_HOME_BASH" 2>/dev/null || echo "$CLAUDE_HOME_BASH")"

detect_python() {
    local candidate
    for candidate in python3 python; do
        if command -v "$candidate" >/dev/null 2>&1; then
            if "$candidate" --version 2>&1 | grep -q "^Python 3"; then
                PYTHON="$candidate"
                return 0
            fi
        fi
    done
    return 1
}

if [ -n "${PYTHON:-}" ]; then
    :
elif ! detect_python; then
    echo "ERROR: Python 3 not found." >&2
    exit 1
fi

if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi

DRY_RUN=0
ASSUME_YES=0
KEEP_GENERATED=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --yes|-y) ASSUME_YES=1 ;;
        --keep-generated) KEEP_GENERATED=1 ;;
        --help|-h)
            grep -E "^#" "$0" | head -40
            exit 0
            ;;
    esac
done

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${BOLD}  ClaudeCodeCTO Uninstaller${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

[ -f "$INSTALL_TSV_BASH" ] || { echo -e "${RED}ERROR:${NC} $INSTALL_TSV_BASH not found"; exit 1; }
[ -d "$CLAUDE_HOME_BASH" ] || { echo -e "${RED}ERROR:${NC} $CLAUDE_HOME_BASH does not exist"; exit 1; }

echo -e "  Target:  $CLAUDE_HOME_BASH"
echo -e "  Source:  decisions/install.tsv"
[ "$DRY_RUN" -eq 1 ] && echo -e "  ${YELLOW}[DRY-RUN MODE]${NC}"
echo ""

if [ "$ASSUME_YES" -eq 0 ] && [ "$DRY_RUN" -eq 0 ]; then
    echo -e "${YELLOW}This will remove all components installed by ClaudeCodeCTO.${NC}"
    echo -e "Protected: .credentials.json, projects/, and anything not installed by us."
    echo ""
    printf "Proceed? [y/N] "
    read -r reply
    case "$reply" in
        y|Y|yes|YES) ;;
        *) echo "Aborted."; exit 0 ;;
    esac
    echo ""
fi

DRY_INT=$DRY_RUN KEEP_GEN=$KEEP_GENERATED "$PYTHON" - << PYEOF
import os
import shutil
import sys
from pathlib import Path

TARGET = Path(r"$CLAUDE_HOME")
TSV = Path(r"$INSTALL_TSV")
DRY = int(os.environ.get("DRY_INT", "0"))
KEEP_GEN = int(os.environ.get("KEEP_GEN", "0"))

removed = {"skill": 0, "agent": 0, "command": 0, "orchestrator": 0, "generated": 0}
missing = {"skill": 0, "agent": 0, "command": 0}

def rm(path: Path, kind: str) -> bool:
    if not path.exists():
        return False
    if DRY:
        print(f"  would remove: {path.name}")
        return True
    try:
        if path.is_dir():
            shutil.rmtree(path)
        else:
            path.unlink()
        return True
    except OSError as e:
        print(f"  ERROR removing {path}: {e}", file=sys.stderr)
        return False

# [1/3] Remove TSV-listed items
print("[1/3] Remove installed skills/agents/commands")
with TSV.open(encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\r\n")
        if not line or line.startswith("#"):
            continue
        parts = line.split("\t")
        if len(parts) != 3:
            continue
        ctype, cid, _ = parts
        if ctype == "skill":
            target = TARGET / "skills" / cid
        elif ctype == "agent":
            target = TARGET / "agents" / f"{cid}.md"
        elif ctype == "command":
            target = TARGET / "commands" / f"{cid}.md"
        else:
            continue
        if target.exists():
            if rm(target, ctype):
                removed[ctype] += 1
        else:
            missing[ctype] += 1

print(f"  Skills:   {removed['skill']} removed ({missing['skill']} already gone)")
print(f"  Agents:   {removed['agent']} removed ({missing['agent']} already gone)")
print(f"  Commands: {removed['command']} removed ({missing['command']} already gone)")
print()

# [2/3] Remove orchestrator assets
print("[2/3] Remove orchestrator assets")
for rel in [
    "skills/project-lifecycle",
    "commands/start-project.md",
    "config/lifecycle.json",
    "rules/agent-decision-tree.md",
]:
    if rm(TARGET / rel, "orchestrator"):
        removed["orchestrator"] += 1
        print(f"  - {rel}")
print(f"  ({removed['orchestrator']} orchestrator files removed)")
print()

# [3/4] Remove runtime (scripts/hooks/)
print("[3/4] Remove runtime scripts/hooks/")
runtime_scripts = TARGET / "scripts" / "hooks"
if runtime_scripts.is_dir():
    js_count = len(list(runtime_scripts.glob("*.js")))
    if rm(runtime_scripts, "generated"):
        removed["generated"] += 1
        print(f"  - scripts/hooks/ ({js_count} JS files)")
    scripts_parent = TARGET / "scripts"
    if scripts_parent.is_dir() and not any(scripts_parent.iterdir()):
        if not DRY:
            try:
                scripts_parent.rmdir()
                print("  rmdir empty: scripts/")
            except OSError:
                pass
else:
    print("  (nothing to remove)")
print()

# [4/4] Remove generator-stamped CLAUDE.md / settings.json
print("[4/4] Remove generator-stamped CLAUDE.md / settings.json")
if KEEP_GEN:
    print("  SKIP (--keep-generated)")
else:
    claude_md = TARGET / "CLAUDE.md"
    if claude_md.exists():
        try:
            content = claude_md.read_text(encoding="utf-8", errors="replace")
            if "curated by ClaudeCodeCTO" in content:
                if rm(claude_md, "generated"):
                    removed["generated"] += 1
                    print("  - CLAUDE.md")
            else:
                print("  KEEP CLAUDE.md (user-modified, no signature)")
        except OSError:
            pass

    settings = TARGET / "settings.json"
    if settings.exists():
        try:
            content = settings.read_text(encoding="utf-8", errors="replace")
            if "Generated by ClaudeCodeCTO installer" in content:
                if rm(settings, "generated"):
                    removed["generated"] += 1
                    print("  - settings.json")
            else:
                print("  KEEP settings.json (user-modified, no signature)")
        except OSError:
            pass
print()

# Cleanup empty top-level dirs we created (but never delete projects/ or the root)
for d in ["skills", "agents", "commands", "hooks", "rules", "config", "scripts"]:
    p = TARGET / d
    if p.is_dir() and not any(p.iterdir()):
        if not DRY:
            try:
                p.rmdir()
                print(f"  rmdir empty: {d}/")
            except OSError:
                pass
        else:
            print(f"  would rmdir empty: {d}/")

total = removed["skill"] + removed["agent"] + removed["command"] + removed["orchestrator"] + removed["generated"]
print()
print(f"Total removed: {total}")
if DRY:
    print("[DRY-RUN — no changes applied]")
PYEOF

rc=$?

echo ""
if [ "$rc" -eq 0 ]; then
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${BOLD}  Uninstall complete${NC}"
    echo -e "${GREEN}==========================================${NC}"
    echo -e "  Protected: .credentials.json, projects/"
else
    echo -e "${RED}==========================================${NC}"
    echo -e "${BOLD}  Uninstall finished with errors${NC}"
    echo -e "${RED}==========================================${NC}"
fi
echo ""

exit "$rc"
