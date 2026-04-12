#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Installer — Stage 5
#
# Installs selected components + orchestrator (from install-assets.json)
# + rules into ~/.claude/ with atomic staging + backup.
#
# Single source of truth: decisions/ folder only.
#   - decisions/selected.json      — curated component list
#   - decisions/install-assets.json — embedded orchestrator files
#
# Factory reset aware: assumes ~/.claude/ only has .credentials.json.
# ============================================================

set -euo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
# Windows path for Python (so Python's pathlib finds files)
ROOT="$(cygpath -w "$ROOT_BASH" 2>/dev/null || echo "$ROOT_BASH")"
DECISIONS="$ROOT_BASH/decisions"
INSTALL_ASSETS_BASH="$DECISIONS/install-assets.json"
INSTALL_ASSETS="$(cygpath -w "$INSTALL_ASSETS_BASH" 2>/dev/null || echo "$INSTALL_ASSETS_BASH")"
SELECTED_BASH="$DECISIONS/selected.json"
SELECTED="$(cygpath -w "$SELECTED_BASH" 2>/dev/null || echo "$SELECTED_BASH")"
MANIFEST_BASH="$DECISIONS/install-manifest.json"
MANIFEST="$(cygpath -w "$MANIFEST_BASH" 2>/dev/null || echo "$MANIFEST_BASH")"

CLAUDE_HOME_BASH="${CLAUDE_HOME:-$HOME/.claude}"
CLAUDE_HOME="$(cygpath -w "$CLAUDE_HOME_BASH" 2>/dev/null || echo "$CLAUDE_HOME_BASH")"
TS=$(date +%Y%m%d-%H%M%S)
STAGE_DIR_BASH="/c/tmp/claude-install-stage-$TS"
STAGE_DIR="$(cygpath -w "$STAGE_DIR_BASH" 2>/dev/null || echo "$STAGE_DIR_BASH")"
BACKUP_DIR_BASH="/c/tmp/claude-install-backup-$TS"
BACKUP_DIR="$(cygpath -w "$BACKUP_DIR_BASH" 2>/dev/null || echo "$BACKUP_DIR_BASH")"

if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' CYAN='' BOLD='' NC=''
fi

DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
    esac
done

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${BOLD}  CloaudeCodeCTO Installer${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

[ -f "$SELECTED_BASH" ] || { echo -e "${RED}ERROR:${NC} $SELECTED_BASH not found"; exit 1; }
[ -f "$INSTALL_ASSETS_BASH" ] || { echo -e "${RED}ERROR:${NC} $INSTALL_ASSETS_BASH not found"; exit 1; }
[ -d "$CLAUDE_HOME_BASH" ] || { echo -e "${RED}ERROR:${NC} $CLAUDE_HOME_BASH does not exist"; exit 1; }

TOTAL=$(python -c "import json; print(json.load(open(r'$SELECTED','r',encoding='utf-8'))['total'])")
echo -e "  Components:  ${BOLD}$TOTAL${NC}"
echo -e "  Target:      $CLAUDE_HOME"
echo -e "  Stage:       $STAGE_DIR"
echo -e "  Backup:      $BACKUP_DIR"
[ "$DRY_RUN" -eq 1 ] && echo -e "  ${YELLOW}[DRY-RUN MODE]${NC}"
echo ""

# --- [1/9] Backup ---
echo -e "${CYAN}[1/9] Backup${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$BACKUP_DIR_BASH"
    cp -r "$CLAUDE_HOME_BASH/." "$BACKUP_DIR_BASH/" 2>/dev/null || true
    echo -e "  ${GREEN}OK${NC}"
fi
echo ""

# --- [2/9] Stage structure ---
echo -e "${CYAN}[2/9] Create stage structure${NC}"
mkdir -p "$STAGE_DIR_BASH"/{skills,agents,commands,hooks,rules,projects,config}
echo -e "  ${GREEN}OK${NC} $STAGE_DIR_BASH"
echo ""

# --- [3/9] Copy components from selected.json ---
echo -e "${CYAN}[3/9] Copy selected components${NC}"

python << PYEOF
import json
import shutil
import sys
from pathlib import Path

ROOT = Path(r"$ROOT")
STAGE = Path(r"$STAGE_DIR")
DRY = int("$DRY_RUN")

if not ROOT.exists():
    print(f"  ERROR: ROOT does not exist: {ROOT}", file=sys.stderr)
    sys.exit(1)

selected = json.loads((ROOT / "decisions" / "selected.json").read_text(encoding="utf-8"))

copied = {"skill": 0, "agent": 0, "command": 0}
skipped = []

for c in selected["components"]:
    src = ROOT / c["path"]
    if not src.exists():
        skipped.append((c["id"], "source missing"))
        continue

    ctype = c["type"]

    if ctype == "skill":
        src_dir = src.parent
        dst_dir = STAGE / "skills" / c["id"]
        if not DRY:
            if dst_dir.exists():
                shutil.rmtree(dst_dir)
            try:
                shutil.copytree(src_dir, dst_dir)
            except OSError as e:
                skipped.append((c["id"], str(e)))
                continue
    elif ctype == "agent":
        dst = STAGE / "agents" / f"{c['id']}.md"
        if not DRY:
            try:
                shutil.copy2(src, dst)
            except OSError as e:
                skipped.append((c["id"], str(e)))
                continue
    elif ctype == "command":
        dst = STAGE / "commands" / f"{c['id']}.md"
        if not DRY:
            try:
                shutil.copy2(src, dst)
            except OSError as e:
                skipped.append((c["id"], str(e)))
                continue

    copied[ctype] = copied.get(ctype, 0) + 1

print(f"  Skills:   {copied.get('skill', 0)}")
print(f"  Agents:   {copied.get('agent', 0)}")
print(f"  Commands: {copied.get('command', 0)}")
if skipped:
    print(f"  Skipped:  {len(skipped)}")
    for id_, reason in skipped[:3]:
        print(f"    - {id_}: {reason[:50]}")
PYEOF

echo ""

# --- [4/9] Install orchestrator (from decisions/install-assets.json) ---
echo -e "${CYAN}[4/9] Install orchestrator${NC}"
python << PYEOF
import json
import sys
from pathlib import Path

STAGE = Path(r"$STAGE_DIR")
assets_path = Path(r"$INSTALL_ASSETS")

try:
    data = json.loads(assets_path.read_text(encoding="utf-8"))
except Exception as e:
    print(f"  ERROR: cannot read install-assets.json: {e}", file=sys.stderr)
    sys.exit(1)

written = 0
for rel_path, content in data.get("assets", {}).items():
    dst = STAGE / rel_path
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(content, encoding="utf-8")
    print(f"  + {rel_path}")
    written += 1

print(f"  ({written} asset files written)")
PYEOF
echo ""

# --- [5/9] Install rules (decision tree + global rules) ---
echo -e "${CYAN}[5/9] Install rules${NC}"
if [ -f "$DECISIONS/agent-decision-tree.md" ]; then
    cp "$DECISIONS/agent-decision-tree.md" "$STAGE_DIR_BASH/rules/agent-decision-tree.md"
    echo -e "  ${GREEN}+${NC} rules/agent-decision-tree.md"
fi

# Generate a minimal global CLAUDE.md
cat > "$STAGE_DIR_BASH/CLAUDE.md" << 'CMEOF'
# Claude Code — Global Configuration

This Claude Code installation was curated by CloaudeCodeCTO.

## Project Lifecycle

When starting a new project, run `/start-project` to enter the 8-phase
project lifecycle orchestrator. Claude will guide you through:

Discovery → Planning → Design → Build → Test → Document → Ship → Maintain

Each phase has preferred agents and skills that will be used automatically.
See `~/.claude/config/lifecycle.json` for the phase mapping.

## Agent Selection

When picking an agent for a task, consult `~/.claude/rules/agent-decision-tree.md`.
It groups agents by trigger (review, debug, test, build, etc.) in priority order.

## Key Commands

- `/start-project` — begin the lifecycle orchestrator for a new project
- Language-specific: `/cpp-review`, `/go-test`, `/python-review`, etc.
- `/plan` — restate requirements and produce a step-by-step plan
- `/review` — comprehensive parallel code review

## Memory

Per-project memory is stored in `~/.claude/projects/<project-id>/MEMORY.md`.
Claude Code reads this at session start.
CMEOF
echo -e "  ${GREEN}+${NC} CLAUDE.md (global)"
echo ""

# --- [6/9] Generate settings.json ---
echo -e "${CYAN}[6/9] Generate settings.json${NC}"
cat > "$STAGE_DIR_BASH/settings.json" << 'SETTINGS'
{
  "alwaysThinkingEnabled": true,
  "hooks": {},
  "$comment": "Generated by CloaudeCodeCTO installer. Edit to add hooks."
}
SETTINGS
echo -e "  ${GREEN}+${NC} settings.json"
echo ""

# --- [7/9] Commit to target ---
echo -e "${CYAN}[7/9] Commit stage -> $CLAUDE_HOME_BASH${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    for d in skills agents commands hooks rules projects config; do
        if [ -d "$STAGE_DIR_BASH/$d" ]; then
            mkdir -p "$CLAUDE_HOME_BASH/$d"
            cp -r "$STAGE_DIR_BASH/$d/." "$CLAUDE_HOME_BASH/$d/" 2>/dev/null || true
            count=$(find "$STAGE_DIR_BASH/$d" -maxdepth 1 | wc -l)
            echo -e "  ${GREEN}+${NC} $d ($((count - 1)) items)"
        fi
    done
    for f in settings.json CLAUDE.md; do
        if [ -f "$STAGE_DIR_BASH/$f" ]; then
            cp "$STAGE_DIR_BASH/$f" "$CLAUDE_HOME_BASH/$f"
            echo -e "  ${GREEN}+${NC} $f"
        fi
    done
else
    echo -e "  ${YELLOW}SKIP${NC} (dry-run)"
fi
echo ""

# --- [8/9] Verify ---
echo -e "${CYAN}[8/9] Verify${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    skills_c=$(ls "$CLAUDE_HOME_BASH/skills/" 2>/dev/null | wc -l)
    agents_c=$(ls "$CLAUDE_HOME_BASH/agents/" 2>/dev/null | wc -l)
    cmds_c=$(ls "$CLAUDE_HOME_BASH/commands/" 2>/dev/null | wc -l)
    echo -e "  Target has: skills=$skills_c  agents=$agents_c  commands=$cmds_c"
fi
echo ""

# --- [9/9] Manifest ---
echo -e "${CYAN}[9/9] Write manifest${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    python << MFEOF
import json
from pathlib import Path
from datetime import datetime
sel = json.loads(Path(r"$SELECTED").read_text(encoding="utf-8"))
manifest = {
    "installed_at": datetime.now().isoformat(timespec="seconds"),
    "target": r"$CLAUDE_HOME",
    "backup": r"$BACKUP_DIR",
    "stage": r"$STAGE_DIR",
    "total": sel["total"],
    "by_type": sel.get("by_type", {}),
    "by_domain": sel.get("by_domain", {}),
    "orchestrator": {
        "lifecycle_skill": "skills/project-lifecycle/SKILL.md",
        "meta_command": "commands/start-project.md",
        "config": "config/lifecycle.json",
    },
    "rules": ["rules/agent-decision-tree.md"],
    "generated": ["CLAUDE.md", "settings.json"],
}
Path(r"$MANIFEST").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print("  OK install-manifest.json")
MFEOF
fi
echo ""

echo -e "${GREEN}==========================================${NC}"
echo -e "${BOLD}  Install complete${NC}"
echo -e "${GREEN}==========================================${NC}"
echo -e "  Backup:   $BACKUP_DIR"
echo -e "  Manifest: decisions/install-manifest.json"
[ "$DRY_RUN" -eq 1 ] && echo -e "  ${YELLOW}[DRY-RUN — no changes applied]${NC}"
echo ""
