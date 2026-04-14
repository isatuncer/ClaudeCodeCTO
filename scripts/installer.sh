#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Installer — Stage 5
#
# Reads decisions/install.tsv and copies components from
# sources/ into ~/.claude/ with atomic staging + backup.
#
# Uses Python for the hot-path file copying (fast, single process).
# Pure bash is ~10x slower on Windows git-bash due to subprocess
# spawn overhead, so we stick with Python here.
#
# Python detection: python3 > python > error. Setup scripts
# handle installation prompts before we get called here.
#
# Single source of truth: decisions/ folder
#   - decisions/install.tsv   — TSV list: type\tid\tsrc_path
#   - decisions/assets/       — orchestrator files (plain dirs)
#
# Env vars:
#   CLAUDE_HOME       Target Claude home (default: ~/.claude)
#   CCCTO_TMP         Temp base dir (default: /c/tmp on Windows, $TMPDIR)
#   CCCTO_PROFILE     Install profile: minimal|standard|full (default: standard)
#
# Flags:
#   --dry-run              Show what would happen, make no changes
#   --profile=<name>       Install profile: minimal|standard|full
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
# Windows path for Python pathlib
ROOT="$(cygpath -w "$ROOT_BASH" 2>/dev/null || echo "$ROOT_BASH")"
DECISIONS_BASH="$ROOT_BASH/decisions"
# Profile defaults to standard (software project dev scope, ~12-15k tokens).
# Override via --profile=minimal|standard|full or CCCTO_PROFILE env var.
PROFILE="${CCCTO_PROFILE:-standard}"
ASSETS_DIR_BASH="$DECISIONS_BASH/assets"
ASSETS_DIR="$(cygpath -w "$ASSETS_DIR_BASH" 2>/dev/null || echo "$ASSETS_DIR_BASH")"
MANIFEST_BASH="$DECISIONS_BASH/install-manifest.json"
MANIFEST="$(cygpath -w "$MANIFEST_BASH" 2>/dev/null || echo "$MANIFEST_BASH")"

CLAUDE_HOME_BASH="${CLAUDE_HOME:-$HOME/.claude}"
CLAUDE_HOME="$(cygpath -w "$CLAUDE_HOME_BASH" 2>/dev/null || echo "$CLAUDE_HOME_BASH")"
TS=$(date +%Y%m%d-%H%M%S)

# Portable temp base directory
if [ -n "${CCCTO_TMP:-}" ]; then
    TMP_BASE="$CCCTO_TMP"
elif [ -w /c/tmp ] 2>/dev/null || { mkdir -p /c/tmp 2>/dev/null && [ -w /c/tmp ]; }; then
    TMP_BASE="/c/tmp"
else
    TMP_BASE="${TMPDIR:-/tmp}"
fi

STAGE_DIR_BASH="$TMP_BASE/claude-install-stage-$TS"
STAGE_DIR="$(cygpath -w "$STAGE_DIR_BASH" 2>/dev/null || echo "$STAGE_DIR_BASH")"
BACKUP_DIR_BASH="$TMP_BASE/claude-install-backup-$TS"
BACKUP_DIR="$(cygpath -w "$BACKUP_DIR_BASH" 2>/dev/null || echo "$BACKUP_DIR_BASH")"

# Python detection — verify it actually works (Windows has fake python3 stubs)
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
    : # Use exported PYTHON
elif ! detect_python; then
    echo "ERROR: Python 3 not found. Run setup.sh or install Python 3 first." >&2
    exit 1
fi

if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi

DRY_RUN=0
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --profile=*) PROFILE="${arg#--profile=}" ;;
    esac
done

case "$PROFILE" in
    minimal|standard|full) ;;
    *)
        echo "ERROR: unknown --profile=$PROFILE (use minimal|standard|full)" >&2
        exit 1
        ;;
esac

INSTALL_TSV_BASH="$DECISIONS_BASH/profiles/$PROFILE.tsv"
INSTALL_TSV="$(cygpath -w "$INSTALL_TSV_BASH" 2>/dev/null || echo "$INSTALL_TSV_BASH")"

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${BOLD}  CloaudeCodeCTO Installer${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

[ -f "$INSTALL_TSV_BASH" ] || { echo -e "${RED}ERROR:${NC} $INSTALL_TSV_BASH not found. Run scripts/curate_profiles.py."; exit 1; }
[ -d "$ASSETS_DIR_BASH" ] || { echo -e "${RED}ERROR:${NC} $ASSETS_DIR_BASH not found"; exit 1; }
[ -d "$CLAUDE_HOME_BASH" ] || { echo -e "${RED}ERROR:${NC} $CLAUDE_HOME_BASH does not exist"; exit 1; }

TOTAL=$(grep -v '^#' "$INSTALL_TSV_BASH" | grep -c '[^[:space:]]' || echo 0)

echo -e "  Profile:     ${BOLD}$PROFILE${NC}"
echo -e "  Components:  ${BOLD}$TOTAL${NC}"
echo -e "  Target:      $CLAUDE_HOME_BASH"
echo -e "  Stage:       $STAGE_DIR_BASH"
echo -e "  Backup:      $BACKUP_DIR_BASH"
echo -e "  Python:      $PYTHON ($($PYTHON --version 2>&1))"
[ "$DRY_RUN" -eq 1 ] && echo -e "  ${YELLOW}[DRY-RUN MODE]${NC}"
echo ""

# --- [1/9] Backup ---
echo -e "${CYAN}[1/9] Backup${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    mkdir -p "$BACKUP_DIR_BASH"
    cp -r "$CLAUDE_HOME_BASH/." "$BACKUP_DIR_BASH/" 2>/dev/null || true
    echo -e "  ${GREEN}OK${NC} $BACKUP_DIR_BASH"
fi
echo ""

# --- [2/9] Stage structure ---
echo -e "${CYAN}[2/9] Create stage structure${NC}"
mkdir -p "$STAGE_DIR_BASH"/{skills,agents,commands,hooks,rules,projects,config}
echo -e "  ${GREEN}OK${NC} $STAGE_DIR_BASH"
echo ""

# --- [3/9] Copy components from install.tsv (Python, fast) ---
echo -e "${CYAN}[3/9] Copy selected components${NC}"

DRY_INT=$DRY_RUN "$PYTHON" - << PYEOF
import os
import shutil
import sys
from pathlib import Path

ROOT = Path(r"$ROOT")
STAGE = Path(r"$STAGE_DIR")
TSV = Path(r"$INSTALL_TSV")
DRY = int(os.environ.get("DRY_INT", "0"))

if not ROOT.exists():
    print(f"  ERROR: ROOT does not exist: {ROOT}", file=sys.stderr)
    sys.exit(1)

copied = {"skill": 0, "agent": 0, "command": 0}
skipped = []

def validate_skill_dir(dst_dir: Path, item_id: str) -> bool:
    """Ensure SKILL.md exists with YAML frontmatter. Promote README.md if needed."""
    dst_skill = dst_dir / "SKILL.md"

    if not dst_skill.exists():
        dst_readme = dst_dir / "README.md"
        if dst_readme.exists():
            dst_readme.rename(dst_skill)

    if not dst_skill.exists():
        shutil.rmtree(dst_dir, ignore_errors=True)
        skipped.append((item_id, "no SKILL.md or README.md"))
        return False

    try:
        content = dst_skill.read_text(encoding="utf-8", errors="replace")
        first_line = content.lstrip().split("\n", 1)[0].strip()
    except OSError:
        first_line = ""

    if not first_line.startswith("---"):
        shutil.rmtree(dst_dir, ignore_errors=True)
        skipped.append((item_id, "SKILL.md missing YAML frontmatter"))
        return False

    return True

# Read TSV — skip comments and blank lines
with TSV.open(encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\r\n")
        if not line or line.startswith("#"):
            continue
        parts = line.split("\t")
        if len(parts) != 3:
            skipped.append(("?", f"malformed line: {line[:60]}"))
            continue
        ctype, cid, cpath = parts
        src = ROOT / cpath
        if not src.exists():
            skipped.append((cid, "source missing"))
            continue

        if ctype == "skill":
            src_dir = src.parent
            dst_dir = STAGE / "skills" / cid
            if not DRY:
                try:
                    if dst_dir.exists():
                        shutil.rmtree(dst_dir)
                    shutil.copytree(src_dir, dst_dir)
                except OSError as e:
                    skipped.append((cid, f"copy failed: {e}"))
                    continue
                if not validate_skill_dir(dst_dir, cid):
                    continue
            copied["skill"] += 1
        elif ctype == "agent":
            dst = STAGE / "agents" / f"{cid}.md"
            if not DRY:
                try:
                    shutil.copy2(src, dst)
                except OSError as e:
                    skipped.append((cid, f"copy failed: {e}"))
                    continue
            copied["agent"] += 1
        elif ctype == "command":
            dst = STAGE / "commands" / f"{cid}.md"
            if not DRY:
                try:
                    shutil.copy2(src, dst)
                except OSError as e:
                    skipped.append((cid, f"copy failed: {e}"))
                    continue
            copied["command"] += 1
        else:
            skipped.append((cid, f"unknown type: {ctype}"))

print(f"  Skills:   {copied['skill']}")
print(f"  Agents:   {copied['agent']}")
print(f"  Commands: {copied['command']}")
if skipped:
    print(f"  Skipped:  {len(skipped)}")
    for cid, reason in skipped[:3]:
        print(f"    - {cid}: {reason[:60]}")
PYEOF

echo ""

# --- [4/9] Install orchestrator (from decisions/assets/) ---
echo -e "${CYAN}[4/9] Install orchestrator${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    asset_count=0
    while IFS= read -r -d '' f; do
        rel="${f#"$ASSETS_DIR_BASH/"}"
        dst="$STAGE_DIR_BASH/$rel"
        mkdir -p "$(dirname "$dst")"
        cp "$f" "$dst"
        echo -e "  ${GREEN}+${NC} $rel"
        asset_count=$((asset_count + 1))
    done < <(find "$ASSETS_DIR_BASH" -type f -print0)
    echo "  ($asset_count asset files written)"
fi
echo ""

# --- [5/9] Install rules ---
echo -e "${CYAN}[5/9] Install rules${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    if [ -f "$DECISIONS_BASH/agent-decision-tree.md" ]; then
        cp "$DECISIONS_BASH/agent-decision-tree.md" "$STAGE_DIR_BASH/rules/agent-decision-tree.md"
        echo -e "  ${GREEN}+${NC} rules/agent-decision-tree.md"
    fi

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
fi
echo ""

# --- [6/9] Install runtime + generate settings.json ---
# Stages EEC's hook runtime (scripts/hooks/*.js + hooks.json) and merges
# the hook config into settings.json. After install, CloaudeCodeCTO hooks
# fire for ALL sessions regardless of which upstream repo the skill/agent
# came from. This is how the 6 features (token optimization, memory,
# continuous learning, verification, parallelization, orchestration) work.
echo -e "${CYAN}[6/9] Install runtime + settings.json${NC}"
RUNTIME_DIR_BASH="$ASSETS_DIR_BASH/runtime"
RUNTIME_DIR="$(cygpath -w "$RUNTIME_DIR_BASH" 2>/dev/null || echo "$RUNTIME_DIR_BASH")"
# CLAUDE_PLUGIN_ROOT must be a path Node can resolve. On Windows git-bash
# we use mixed mode (C:/Users/...) because Node doesn't understand /c/...
PLUGIN_ROOT="$(cygpath -m "$CLAUDE_HOME_BASH" 2>/dev/null || echo "$CLAUDE_HOME_BASH")"

if [ "$DRY_RUN" -eq 0 ]; then
    # Stage the hook scripts directory
    if [ -d "$RUNTIME_DIR_BASH/scripts/hooks" ]; then
        mkdir -p "$STAGE_DIR_BASH/scripts/hooks"
        cp "$RUNTIME_DIR_BASH/scripts/hooks"/*.js "$STAGE_DIR_BASH/scripts/hooks/" 2>/dev/null || true
        hook_js_count=$(find "$STAGE_DIR_BASH/scripts/hooks" -maxdepth 1 -name '*.js' 2>/dev/null | wc -l | tr -d ' ')
        echo -e "  ${GREEN}+${NC} scripts/hooks/ ($hook_js_count JS files)"
    else
        echo -e "  ${YELLOW}WARN${NC} runtime/scripts/hooks not found at $RUNTIME_DIR_BASH/scripts/hooks"
        hook_js_count=0
    fi

    # Merge hooks.json into settings.json + set CLAUDE_PLUGIN_ROOT.
    # Preserves any existing user settings (permissions, keybindings, etc.).
    TARGET_SETTINGS="$(cygpath -w "$CLAUDE_HOME_BASH/settings.json" 2>/dev/null || echo "$CLAUDE_HOME_BASH/settings.json")"
    PLUGIN_ROOT="$PLUGIN_ROOT" RUNTIME_DIR="$RUNTIME_DIR" STAGE_DIR="$STAGE_DIR" TARGET_SETTINGS="$TARGET_SETTINGS" "$PYTHON" - << 'PYRUNTIME'
import json
import os
from pathlib import Path

stage = Path(os.environ["STAGE_DIR"])
runtime_dir = Path(os.environ["RUNTIME_DIR"])
plugin_root = os.environ["PLUGIN_ROOT"]
target_settings_path = Path(os.environ["TARGET_SETTINGS"])

# Load existing user settings if present, so we don't clobber their config
existing = {}
if target_settings_path.exists():
    try:
        existing = json.loads(target_settings_path.read_text(encoding="utf-8"))
        if not isinstance(existing, dict):
            existing = {}
        else:
            print(f"  merging with existing settings.json (keys: {', '.join(sorted(existing.keys()))})")
    except (OSError, json.JSONDecodeError):
        existing = {}

# Our defaults + runtime
settings = dict(existing)
settings.setdefault("alwaysThinkingEnabled", True)

# env: merge our vars INTO existing env (keep user's vars)
env = dict(existing.get("env", {})) if isinstance(existing.get("env"), dict) else {}
env["CLAUDE_PLUGIN_ROOT"] = plugin_root
env.setdefault("ECC_HOOK_PROFILE", "standard")
settings["env"] = env

# hooks: replace ours, but stash user's non-CCCTO hooks first
hooks_json_path = runtime_dir / "hooks.json"
if hooks_json_path.exists():
    try:
        runtime = json.loads(hooks_json_path.read_text(encoding="utf-8"))
        runtime_hooks = runtime.get("hooks", {})
        if isinstance(runtime_hooks, dict):
            settings["hooks"] = runtime_hooks
            total = sum(len(v) if isinstance(v, list) else 0 for v in runtime_hooks.values())
            print(f"  + hooks.json merged ({total} entries across {len(runtime_hooks)} events)")
    except (OSError, json.JSONDecodeError) as e:
        print(f"  WARN hooks.json merge failed: {e}")
else:
    print("  WARN hooks.json not found in runtime dir")
    settings.setdefault("hooks", {})

settings["$comment"] = "Generated by CloaudeCodeCTO installer. Hooks merged from EEC runtime."

(stage / "settings.json").write_text(
    json.dumps(settings, indent=2, ensure_ascii=False),
    encoding="utf-8",
)
print("  + settings.json (with env.CLAUDE_PLUGIN_ROOT, existing keys preserved)")
PYRUNTIME
fi
echo ""

# --- [7/9] Commit to target ---
echo -e "${CYAN}[7/9] Commit stage -> $CLAUDE_HOME_BASH${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    for d in skills agents commands hooks rules projects config scripts; do
        if [ -d "$STAGE_DIR_BASH/$d" ]; then
            mkdir -p "$CLAUDE_HOME_BASH/$d"
            cp -r "$STAGE_DIR_BASH/$d/." "$CLAUDE_HOME_BASH/$d/" 2>/dev/null || true
            count=$(find "$STAGE_DIR_BASH/$d" -maxdepth 1 -mindepth 1 | wc -l | tr -d ' ')
            echo -e "  ${GREEN}+${NC} $d ($count items)"
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
VERIFY_FAILED=0
if [ "$DRY_RUN" -eq 0 ]; then
    skills_c=$(find "$CLAUDE_HOME_BASH/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    agents_c=$(find "$CLAUDE_HOME_BASH/agents" -maxdepth 1 -mindepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
    cmds_c=$(find "$CLAUDE_HOME_BASH/commands" -maxdepth 1 -mindepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
    echo "  Target has: skills=$skills_c  agents=$agents_c  commands=$cmds_c"

    # Sanity check: fail loudly if committed count is wildly off
    actual_total=$((skills_c + agents_c + cmds_c))
    min_expected=$((TOTAL * 80 / 100))
    if [ "$actual_total" -lt "$min_expected" ]; then
        echo -e "  ${RED}FAIL${NC} Only $actual_total of $TOTAL components installed (<80%)."
        echo -e "  ${RED}FAIL${NC} Something went wrong in the copy phase. Check stage dir:"
        echo -e "         $STAGE_DIR_BASH"
        VERIFY_FAILED=1
    fi
fi
echo ""

# --- [9/9] Write manifest ---
echo -e "${CYAN}[9/9] Write manifest${NC}"
if [ "$DRY_RUN" -eq 0 ]; then
    "$PYTHON" - << MFEOF
import json
from pathlib import Path
from datetime import datetime

target = Path(r"$CLAUDE_HOME")
total_selected = int("$TOTAL")

actual_skills = len([d for d in (target / "skills").iterdir() if d.is_dir()]) if (target / "skills").exists() else 0
actual_agents = len(list((target / "agents").iterdir())) if (target / "agents").exists() else 0
actual_commands = len(list((target / "commands").iterdir())) if (target / "commands").exists() else 0
actual_total = actual_skills + actual_agents + actual_commands

manifest = {
    "installed_at": datetime.now().isoformat(timespec="seconds"),
    "target": r"$CLAUDE_HOME",
    "profile": "$PROFILE",
    "backup": r"$BACKUP_DIR",
    "stage": r"$STAGE_DIR",
    "selected_total": total_selected,
    "total": actual_total,
    "installed": {
        "skills": actual_skills,
        "agents": actual_agents,
        "commands": actual_commands,
    },
    "orchestrator": {
        "lifecycle_skill": "skills/project-lifecycle/SKILL.md",
        "meta_command": "commands/start-project.md",
        "config": "config/lifecycle.json",
    },
    "rules": ["rules/agent-decision-tree.md"],
    "generated": ["CLAUDE.md", "settings.json"],
}
Path(r"$MANIFEST").write_text(json.dumps(manifest, indent=2), encoding="utf-8")
print(f"  OK install-manifest.json")
print(f"  Selected: {total_selected}  Installed: {actual_total}")
MFEOF
fi
echo ""

if [ "$VERIFY_FAILED" -eq 1 ]; then
    echo -e "${RED}==========================================${NC}"
    echo -e "${BOLD}  Install FAILED verification${NC}"
    echo -e "${RED}==========================================${NC}"
    echo -e "  Backup:   $BACKUP_DIR_BASH"
    echo -e "  Stage:    $STAGE_DIR_BASH"
    echo ""
    exit 2
fi

echo -e "${GREEN}==========================================${NC}"
echo -e "${BOLD}  Install complete${NC}"
echo -e "${GREEN}==========================================${NC}"
echo -e "  Backup:   $BACKUP_DIR_BASH"
echo -e "  Manifest: decisions/install-manifest.json"
[ "$DRY_RUN" -eq 1 ] && echo -e "  ${YELLOW}[DRY-RUN — no changes applied]${NC}"
echo ""
