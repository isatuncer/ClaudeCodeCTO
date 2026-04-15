#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Updater
#
# Safe, user-friendly update path for existing installs.
#
# What it does:
#   1. Reads old manifest at ~/.claude/install-manifest.json (if any)
#   2. Pulls latest ClaudeCodeCTO repo + updates submodules
#   3. Shows a diff: old components/profile vs new
#   4. Confirms with user (unless --yes)
#   5. Re-runs the installer — which merges settings.json, preserves
#      user's permissions/credentials/projects, updates hooks runtime
#   6. Reports before/after counts
#
# Safe by design:
#   - Full backup taken by installer (/c/tmp/claude-install-backup-*)
#   - settings.json merged (user keys preserved)
#   - .credentials.json never touched
#   - projects/ never touched
#
# Env vars:
#   CLAUDE_HOME     Target (default: ~/.claude)
#   CCCTO_PROFILE   Override profile: minimal|standard|full
#                   (default: use profile from old manifest, fallback standard)
#
# Flags:
#   --yes           Skip confirmation prompt
#   --profile=<n>   Override profile
#   --no-git-pull   Don't pull latest from remote
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
DECISIONS="$ROOT_BASH/decisions"
SCRIPTS="$ROOT_BASH/scripts"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
else
    RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; DIM=''; NC=''
fi

ASSUME_YES=0
NO_GIT_PULL=0
PROFILE_OVERRIDE=""
for arg in "$@"; do
    case "$arg" in
        --yes|-y) ASSUME_YES=1 ;;
        --no-git-pull) NO_GIT_PULL=1 ;;
        --profile=*) PROFILE_OVERRIDE="${arg#--profile=}" ;;
        --help|-h)
            grep -E "^#" "$0" | head -35
            exit 0
            ;;
    esac
done

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${BOLD}  ClaudeCodeCTO Update${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# -------- Detect Python (same helper as install.sh) --------
detect_python() {
    local c
    for c in python3 python; do
        if command -v "$c" >/dev/null 2>&1 && "$c" --version 2>&1 | grep -q "^Python 3"; then
            PYTHON="$c"
            return 0
        fi
    done
    return 1
}
detect_python || { echo -e "${RED}ERROR:${NC} Python 3 not found. Run install.sh first."; exit 1; }

# -------- [1/5] Read old manifest --------
echo -e "${CYAN}[1/5] Read existing install${NC}"
OLD_MANIFEST="$CLAUDE_HOME/install-manifest.json"
OLD_PROFILE=""
OLD_TOTAL="?"
OLD_SKILLS="?"
OLD_AGENTS="?"
OLD_COMMANDS="?"
OLD_INSTALLED_AT="unknown"

# Manifest also lives in decisions/ when run from the repo, but target is
# the per-user one at $CLAUDE_HOME/install-manifest.json which we wrote
# during the last install. Fall back to decisions/install-manifest.json.
for candidate in "$CLAUDE_HOME/install-manifest.json" "$DECISIONS/install-manifest.json"; do
    if [ -f "$candidate" ]; then
        mread=$("$PYTHON" - << PYEOF
import json, sys
try:
    with open(r"$candidate", encoding="utf-8") as f:
        d = json.load(f)
    profile = d.get("profile", "")
    total = d.get("total") or d.get("selected_total") or 0
    inst = d.get("installed", {})
    print(f"{profile}|{total}|{inst.get('skills',0)}|{inst.get('agents',0)}|{inst.get('commands',0)}|{d.get('installed_at','unknown')}")
except Exception:
    sys.exit(1)
PYEOF
) && {
            IFS='|' read -r OLD_PROFILE OLD_TOTAL OLD_SKILLS OLD_AGENTS OLD_COMMANDS OLD_INSTALLED_AT <<< "$mread"
            echo -e "  ${GREEN}OK${NC} manifest: $candidate"
            break
        }
    fi
done

# Fallback: count actual files on disk if no manifest
if [ -z "${OLD_PROFILE:-}" ] || [ "$OLD_TOTAL" = "?" ]; then
    if [ -d "$CLAUDE_HOME/skills" ]; then
        OLD_SKILLS=$(find "$CLAUDE_HOME/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
        OLD_AGENTS=$(find "$CLAUDE_HOME/agents" -maxdepth 1 -mindepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
        OLD_COMMANDS=$(find "$CLAUDE_HOME/commands" -maxdepth 1 -mindepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
        OLD_TOTAL=$((OLD_SKILLS + OLD_AGENTS + OLD_COMMANDS))
        echo -e "  ${YELLOW}no manifest${NC} — counted on-disk (no profile info)"
    else
        echo -e "  ${YELLOW}no existing install${NC} at $CLAUDE_HOME"
    fi
fi

echo -e "  Current:  ${BOLD}$OLD_TOTAL${NC} components (skills=$OLD_SKILLS agents=$OLD_AGENTS commands=$OLD_COMMANDS)"
[ -n "${OLD_PROFILE:-}" ] && echo -e "  Profile:  ${BOLD}$OLD_PROFILE${NC}"
[ "$OLD_INSTALLED_AT" != "unknown" ] && echo -e "  Since:    ${DIM}$OLD_INSTALLED_AT${NC}"
echo ""

# -------- [2/5] Git pull + submodule update --------
echo -e "${CYAN}[2/5] Pull latest ClaudeCodeCTO${NC}"
if [ "$NO_GIT_PULL" -eq 1 ]; then
    echo -e "  ${YELLOW}SKIP${NC} (--no-git-pull)"
elif [ -d "$ROOT_BASH/.git" ]; then
    cd "$ROOT_BASH" || { echo -e "  ${RED}ERROR${NC}: cannot cd to $ROOT_BASH"; exit 1; }
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
    echo -e "  branch: $branch"
    if git pull origin "$branch" 2>&1 | sed 's/^/    /' | tail -5; then
        echo -e "  ${GREEN}OK${NC} git pull"
    else
        echo -e "  ${YELLOW}WARN${NC} git pull had warnings"
    fi
    if git submodule update --init --recursive 2>&1 | sed 's/^/    /' | tail -5; then
        echo -e "  ${GREEN}OK${NC} submodules synced"
    fi
    cd - > /dev/null || true
else
    echo -e "  ${YELLOW}WARN${NC} not a git repo — skipping pull"
fi
echo ""

# -------- [3/5] Determine new profile + counts --------
echo -e "${CYAN}[3/5] Compute new install${NC}"
NEW_PROFILE="${PROFILE_OVERRIDE:-${CCCTO_PROFILE:-${OLD_PROFILE:-standard}}}"
case "$NEW_PROFILE" in
    minimal|standard|full) ;;
    "")  NEW_PROFILE="standard" ;;
    *)
        echo -e "  ${RED}ERROR${NC}: unknown profile '$NEW_PROFILE' (minimal|standard|full)"
        exit 1
        ;;
esac

NEW_TSV="$DECISIONS/profiles/$NEW_PROFILE.tsv"
if [ ! -f "$NEW_TSV" ]; then
    echo -e "  ${RED}ERROR${NC}: $NEW_TSV not found. Run: python scripts/curate_profiles.py"
    exit 1
fi
TSV_TOTAL=$(grep -v '^#' "$NEW_TSV" | grep -c '[^[:space:]]')
TSV_SKILLS=$(grep -v '^#' "$NEW_TSV" | awk -F'\t' '$1=="skill"' | wc -l | tr -d ' ')
TSV_AGENTS=$(grep -v '^#' "$NEW_TSV" | awk -F'\t' '$1=="agent"' | wc -l | tr -d ' ')
TSV_CMDS=$(grep -v '^#' "$NEW_TSV" | awk -F'\t' '$1=="command"' | wc -l | tr -d ' ')
# Orchestrator assets (project-lifecycle skill + start-project command) are
# always installed on top of the profile. Match the counts the installer
# will actually produce in the target.
NEW_TOTAL=$((TSV_TOTAL + 2))
NEW_SKILLS=$((TSV_SKILLS + 1))
NEW_AGENTS=$TSV_AGENTS
NEW_CMDS=$((TSV_CMDS + 1))
echo -e "  Profile:  ${BOLD}$NEW_PROFILE${NC}"
echo -e "  New:      ${BOLD}$NEW_TOTAL${NC} components (skills=$NEW_SKILLS agents=$NEW_AGENTS commands=$NEW_CMDS)"
echo ""

# -------- [4/5] Show diff + confirm --------
echo -e "${CYAN}[4/5] Summary${NC}"
echo ""
if [ "$OLD_TOTAL" = "?" ]; then
    diff_total="n/a"
    diff_skills="n/a"
    diff_agents="n/a"
    diff_cmds="n/a"
else
    diff_total=$(printf "%+d" $((NEW_TOTAL - OLD_TOTAL)))
    diff_skills=$(printf "%+d" $((NEW_SKILLS - OLD_SKILLS)))
    diff_agents=$(printf "%+d" $((NEW_AGENTS - OLD_AGENTS)))
    diff_cmds=$(printf "%+d" $((NEW_CMDS - OLD_COMMANDS)))
fi
printf "  %-12s %12s %12s %12s\n" ""         "Current" "After update" "Change"
printf "  %-12s %12s %12s %12s\n" "Total"    "$OLD_TOTAL"    "$NEW_TOTAL"    "$diff_total"
printf "  %-12s %12s %12s %12s\n" "Skills"   "$OLD_SKILLS"   "$NEW_SKILLS"   "$diff_skills"
printf "  %-12s %12s %12s %12s\n" "Agents"   "$OLD_AGENTS"   "$NEW_AGENTS"   "$diff_agents"
printf "  %-12s %12s %12s %12s\n" "Commands" "$OLD_COMMANDS" "$NEW_CMDS"     "$diff_cmds"
echo ""
echo -e "  ${DIM}Preserved: .credentials.json, projects/, custom settings.json keys, user-added files${NC}"
echo -e "  ${DIM}Backup: /c/tmp/claude-install-backup-<timestamp>/${NC}"
echo ""

if [ "$ASSUME_YES" -eq 0 ]; then
    printf "Proceed with update? [Y/n] "
    read -r reply
    case "$reply" in
        n|N|no|NO) echo "Aborted."; exit 0 ;;
    esac
    echo ""
fi

# -------- [5/5] Run installer --------
echo -e "${CYAN}[5/5] Run installer (profile=$NEW_PROFILE)${NC}"
INSTALL_LOG="${CCCTO_TMP:-/c/tmp}/ccct-update-$(date +%Y%m%d-%H%M%S).log"
mkdir -p "$(dirname "$INSTALL_LOG")" 2>/dev/null || INSTALL_LOG="/tmp/ccct-update-$(date +%Y%m%d-%H%M%S).log"

export CCCTO_PROFILE="$NEW_PROFILE"
bash "$SCRIPTS/installer.sh" --profile="$NEW_PROFILE" > "$INSTALL_LOG" 2>&1
rc=$?
tail -20 "$INSTALL_LOG" | sed 's/^/    /'

echo ""
if [ "$rc" -eq 0 ]; then
    echo -e "${GREEN}==========================================${NC}"
    echo -e "${BOLD}  Update complete${NC}"
    echo -e "${GREEN}==========================================${NC}"
    echo -e "  ${DIM}Log: $INSTALL_LOG${NC}"
    echo ""
    echo -e "  ${YELLOW}Restart Claude Code${NC} to pick up new skills, hooks, and settings."
    echo ""
else
    echo -e "${RED}==========================================${NC}"
    echo -e "${BOLD}  Update FAILED (exit $rc)${NC}"
    echo -e "${RED}==========================================${NC}"
    echo -e "  Full log:  $INSTALL_LOG"
    echo -e "  Backup:    /c/tmp/claude-install-backup-*"
    exit "$rc"
fi
