#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Setup — Full Automation
#
# Orchestrates the complete pipeline with user interaction:
#   1. Environment check
#   2. State inspection
#   3. Submodule update detection
#   4. Pull updates (with confirm)
#   5. Re-run pipeline: extract -> score -> curate
#   6. Compare with previous selection
#   7. Install to ~/.claude/ (with confirm)
#   8. Smoke test
#   9. Commit + push decisions/ (with confirm)
#  10. Final summary
#
# Modes:
#   (default)   interactive - confirms every critical action
#   --auto      non-interactive - runs everything without prompts
#   --dry-run   show what would happen, no changes
#   --check     only check status, no pulls or changes
#   --no-install skip install step
#   --no-push    skip git push step
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
DECISIONS="$ROOT_BASH/decisions"
SCRIPTS="$ROOT_BASH/scripts"
SOURCES="$ROOT_BASH/sources"
SETUP_LOG="$DECISIONS/setup.log"
START_TS=$(date +%s)

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

# Modes
AUTO=0
DRY_RUN=0
CHECK_ONLY=0
NO_INSTALL=0
NO_PUSH=0

for arg in "$@"; do
    case "$arg" in
        --auto) AUTO=1 ;;
        --dry-run) DRY_RUN=1 ;;
        --check) CHECK_ONLY=1 ;;
        --no-install) NO_INSTALL=1 ;;
        --no-push) NO_PUSH=1 ;;
        --help|-h)
            grep -E "^#" "$0" | head -40
            exit 0
            ;;
    esac
done

# Colors
if [ -t 1 ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
    BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' MAGENTA='' BOLD='' DIM='' NC=''
fi

# Helpers
mkdir -p "$DECISIONS"
: > "$SETUP_LOG"

log() {
    local msg="$*"
    echo "[$(date +'%H:%M:%S')] $msg" >> "$SETUP_LOG"
}

header() {
    local phase="$1"
    local title="$2"
    echo ""
    echo -e "${BLUE}${BOLD}[$phase]${NC} ${BOLD}$title${NC}"
    echo -e "${DIM}────────────────────────────────────────────${NC}"
    log "PHASE $phase: $title"
}

info() { echo -e "  ${DIM}•${NC} $*"; log "INFO: $*"; }
ok()   { echo -e "  ${GREEN}✓${NC} $*"; log "OK: $*"; }
warn() { echo -e "  ${YELLOW}!${NC} $*"; log "WARN: $*"; }
err()  { echo -e "  ${RED}✗${NC} $*"; log "ERR: $*"; }
step() { echo -e "  ${CYAN}→${NC} $*"; log "STEP: $*"; }

confirm() {
    local question="$1"
    local default="${2:-Y}"
    if [ "$AUTO" -eq 1 ]; then
        info "AUTO mode: assuming yes for \"$question\""
        return 0
    fi
    local prompt="[Y/n]"
    [ "$default" = "N" ] && prompt="[y/N]"
    echo -ne "  ${MAGENTA}?${NC} ${BOLD}$question${NC} $prompt "
    read -r reply
    if [ -z "$reply" ]; then
        reply="$default"
    fi
    case "$reply" in
        [Yy]*) return 0 ;;
        *) return 1 ;;
    esac
}

abort() {
    local msg="$*"
    err "Aborted: $msg"
    echo ""
    echo -e "${RED}══════════════════════════════════════════${NC}"
    echo -e "${RED}${BOLD}  Setup aborted${NC}"
    echo -e "${RED}══════════════════════════════════════════${NC}"
    exit 1
}

# --- Banner ---
clear 2>/dev/null || true
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}CloaudeCodeCTO Setup${NC}                    ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${DIM}Automated pipeline + install${NC}           ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
[ "$AUTO" -eq 1 ]        && echo -e "  ${YELLOW}[AUTO MODE]${NC} non-interactive"
[ "$DRY_RUN" -eq 1 ]     && echo -e "  ${YELLOW}[DRY-RUN]${NC} no changes will be applied"
[ "$CHECK_ONLY" -eq 1 ]  && echo -e "  ${YELLOW}[CHECK-ONLY]${NC} just inspecting state"
[ "$NO_INSTALL" -eq 1 ]  && echo -e "  ${YELLOW}[NO-INSTALL]${NC} install step will be skipped"
[ "$NO_PUSH" -eq 1 ]     && echo -e "  ${YELLOW}[NO-PUSH]${NC} git push step will be skipped"
echo -e "  ${DIM}Log: $SETUP_LOG${NC}"
echo ""

# ============================================================
# [1/12] Environment Check
# ============================================================
header "1/12" "Environment Check"

for cmd in python git bash; do
    if command -v "$cmd" >/dev/null 2>&1; then
        ver=$("$cmd" --version 2>&1 | head -1)
        ok "$cmd: $ver"
    else
        err "$cmd NOT FOUND"
        abort "missing required tool: $cmd"
    fi
done

if python -c "import yaml" 2>/dev/null; then
    ok "Python PyYAML module"
else
    err "PyYAML missing — install with: pip install pyyaml"
    abort "missing Python dependency"
fi

if [ -d "$CLAUDE_HOME" ]; then
    ok "Claude home: $CLAUDE_HOME"
else
    err "Claude home not found: $CLAUDE_HOME"
    abort "Claude Code is not installed"
fi

if [ -f "$CLAUDE_HOME/.credentials.json" ]; then
    ok "Credentials present"
else
    warn "No credentials — you may need to re-login after install"
fi

# ============================================================
# [2/12] Current State
# ============================================================
header "2/12" "Current State Inspection"

CURR_SKILLS=$(ls "$CLAUDE_HOME/skills" 2>/dev/null | wc -l | tr -d ' ')
CURR_AGENTS=$(ls "$CLAUDE_HOME/agents" 2>/dev/null | wc -l | tr -d ' ')
CURR_COMMANDS=$(ls "$CLAUDE_HOME/commands" 2>/dev/null | wc -l | tr -d ' ')

info "Currently installed in $CLAUDE_HOME:"
info "  skills:   $CURR_SKILLS"
info "  agents:   $CURR_AGENTS"
info "  commands: $CURR_COMMANDS"

MANIFEST="$DECISIONS/install-manifest.json"
if [ -f "$MANIFEST" ]; then
    LAST_INSTALL=$(python -c "import json; d=json.load(open(r'$(cygpath -w $MANIFEST)')); print(d.get('installed_at','unknown'))" 2>/dev/null || echo "unknown")
    info "Last install manifest: $LAST_INSTALL"
else
    info "No install manifest yet (fresh system)"
fi

if [ -f "$DECISIONS/selected.json" ]; then
    SELECTED_COUNT=$(python -c "import json; print(json.load(open(r'$(cygpath -w $DECISIONS/selected.json)'))['total'])" 2>/dev/null || echo "0")
    info "Previous selection: $SELECTED_COUNT components"
fi

# ============================================================
# [3/12] Submodule Update Check
# ============================================================
header "3/12" "Submodule Update Check"

cd "$ROOT_BASH" || abort "cannot cd to project root"

if [ ! -f ".gitmodules" ]; then
    warn "No .gitmodules found — no submodules to check"
    SUBMODULE_COUNT=0
    UPDATES_NEEDED=0
else
    SUBMODULE_COUNT=$(git submodule status 2>/dev/null | wc -l | tr -d ' ')
    info "Total submodules: $SUBMODULE_COUNT"

    step "Fetching remote state for each submodule..."
    UPDATES_NEEDED=0
    UPDATE_LIST=""

    while IFS= read -r sm_line; do
        sm_path=$(echo "$sm_line" | awk '{print $2}')
        [ -z "$sm_path" ] && continue
        sm_name=$(basename "$sm_path")

        if [ -d "$sm_path/.git" ] || [ -f "$sm_path/.git" ]; then
            (
                cd "$sm_path" 2>/dev/null || exit 1
                git fetch --quiet 2>/dev/null || true
                LOCAL=$(git rev-parse HEAD 2>/dev/null || echo "")
                REMOTE=$(git rev-parse '@{u}' 2>/dev/null || git rev-parse HEAD 2>/dev/null || echo "")
                BEHIND=$(git rev-list --count HEAD..'@{u}' 2>/dev/null || echo 0)
                if [ "$BEHIND" -gt 0 ] 2>/dev/null; then
                    echo "BEHIND:$BEHIND"
                else
                    echo "UP-TO-DATE"
                fi
            ) > /tmp/sm_check_$$.txt 2>/dev/null

            result=$(cat /tmp/sm_check_$$.txt 2>/dev/null || echo "UNKNOWN")
            rm -f /tmp/sm_check_$$.txt

            if echo "$result" | grep -q "^BEHIND:"; then
                behind=$(echo "$result" | cut -d: -f2)
                warn "$sm_name — $behind commits behind"
                UPDATES_NEEDED=$((UPDATES_NEEDED + 1))
                UPDATE_LIST="$UPDATE_LIST $sm_name"
            elif [ "$result" = "UP-TO-DATE" ]; then
                ok "$sm_name — up-to-date"
            else
                warn "$sm_name — status unknown"
            fi
        else
            warn "$sm_name — not initialized"
        fi
    done < <(git submodule status 2>/dev/null)

    echo ""
    if [ "$UPDATES_NEEDED" -eq 0 ]; then
        ok "All submodules up-to-date"
    else
        warn "$UPDATES_NEEDED submodule(s) have updates:$UPDATE_LIST"
    fi
fi

if [ "$CHECK_ONLY" -eq 1 ]; then
    echo ""
    info "CHECK-ONLY mode: exiting"
    exit 0
fi

# ============================================================
# [4/12] Update Decision
# ============================================================
header "4/12" "Update Decision"

if [ "$UPDATES_NEEDED" -eq 0 ]; then
    if [ -f "$DECISIONS/selected.json" ]; then
        info "No submodule updates and selection exists."
        if ! confirm "Force re-run pipeline anyway?" "N"; then
            info "Skipping pipeline re-run"
            SKIP_PIPELINE=1
        else
            SKIP_PIPELINE=0
        fi
    else
        info "No previous selection found — will run pipeline fresh"
        SKIP_PIPELINE=0
    fi
else
    if ! confirm "Pull $UPDATES_NEEDED submodule update(s)?" "Y"; then
        abort "user declined submodule update"
    fi
    SKIP_PIPELINE=0
fi

# ============================================================
# [5/12] Pull Submodules
# ============================================================
header "5/12" "Pull Submodules"

if [ "$UPDATES_NEEDED" -eq 0 ]; then
    info "Nothing to pull"
elif [ "$DRY_RUN" -eq 1 ]; then
    info "DRY-RUN: would pull $UPDATES_NEEDED submodule(s)"
else
    step "Running: git submodule update --remote --merge"
    if git submodule update --remote --merge 2>&1 | tee -a "$SETUP_LOG"; then
        ok "Submodules updated"
    else
        warn "Submodule update had issues — check $SETUP_LOG"
        if ! confirm "Continue anyway?" "N"; then
            abort "user declined to continue after submodule errors"
        fi
    fi
fi

# ============================================================
# [6/12] Re-extract Metadata
# ============================================================
header "6/12" "Extract Metadata (Stage 2)"

if [ "$SKIP_PIPELINE" -eq 1 ]; then
    info "Skipping (no changes)"
else
    PREV_COMPONENT_COUNT=0
    if [ -f "$DECISIONS/catalog.json" ]; then
        PREV_COMPONENT_COUNT=$(python -c "import json; d=json.load(open(r'$(cygpath -w $DECISIONS/catalog.json)')); print(d['summary']['total']['skills']+d['summary']['total']['agents']+d['summary']['total']['commands'])" 2>/dev/null || echo "0")
    fi

    step "Running extractor.py..."
    if [ "$DRY_RUN" -eq 0 ]; then
        if PYTHONIOENCODING=utf-8 python "$SCRIPTS/extractor.py" 2>&1 | tail -15 | sed 's/^/    /'; then
            NEW_COMPONENT_COUNT=$(python -c "import json; d=json.load(open(r'$(cygpath -w $DECISIONS/catalog.json)')); print(d['summary']['total']['skills']+d['summary']['total']['agents']+d['summary']['total']['commands'])" 2>/dev/null || echo "0")
            DIFF=$((NEW_COMPONENT_COUNT - PREV_COMPONENT_COUNT))
            if [ "$DIFF" -gt 0 ]; then
                ok "Extracted $NEW_COMPONENT_COUNT components (+$DIFF)"
            elif [ "$DIFF" -lt 0 ]; then
                warn "Extracted $NEW_COMPONENT_COUNT components ($DIFF)"
            else
                ok "Extracted $NEW_COMPONENT_COUNT components (no change)"
            fi
        else
            abort "extractor.py failed"
        fi
    else
        info "DRY-RUN: would extract"
    fi
fi

# ============================================================
# [7/12] Re-score (Rubric)
# ============================================================
header "7/12" "Score Components (Stage 3)"

if [ "$SKIP_PIPELINE" -eq 1 ]; then
    info "Skipping (no changes)"
else
    step "Running scorer_rubric.py..."
    if [ "$DRY_RUN" -eq 0 ]; then
        if PYTHONIOENCODING=utf-8 python "$SCRIPTS/scorer_rubric.py" 2>&1 | tail -20 | sed 's/^/    /'; then
            ok "Scoring complete"
        else
            abort "scorer_rubric.py failed"
        fi
    else
        info "DRY-RUN: would score"
    fi

    info "Self-scoring (Stage 3b) is interactive — use Claude Code manually if desired"
    info "Current run uses rubric scores only"

    # Re-merge previous self-scoring results if they exist
    if [ -d "$DECISIONS/self-scoring/results" ] && [ -n "$(ls -A $DECISIONS/self-scoring/results 2>/dev/null)" ]; then
        step "Merging existing self-scoring results..."
        if [ "$DRY_RUN" -eq 0 ]; then
            PYTHONIOENCODING=utf-8 python "$SCRIPTS/merge_self_scoring.py" 2>&1 | tail -10 | sed 's/^/    /'
            ok "Previous self-scoring merged"
        fi
    fi
fi

# ============================================================
# [8/12] Re-curate
# ============================================================
header "8/12" "Curate Selection (Stage 4)"

if [ "$SKIP_PIPELINE" -eq 1 ]; then
    info "Skipping (no changes)"
else
    PREV_SELECTED=0
    if [ -f "$DECISIONS/selected.json" ]; then
        PREV_SELECTED=$(python -c "import json; print(json.load(open(r'$(cygpath -w $DECISIONS/selected.json)'))['total'])" 2>/dev/null || echo "0")
    fi

    step "Running curator.py..."
    if [ "$DRY_RUN" -eq 0 ]; then
        if PYTHONIOENCODING=utf-8 python "$SCRIPTS/curator.py" 2>&1 | tail -15 | sed 's/^/    /'; then
            NEW_SELECTED=$(python -c "import json; print(json.load(open(r'$(cygpath -w $DECISIONS/selected.json)'))['total'])" 2>/dev/null || echo "0")
            DIFF=$((NEW_SELECTED - PREV_SELECTED))
            if [ "$DIFF" -gt 0 ]; then
                ok "Selected $NEW_SELECTED (+$DIFF from previous)"
            elif [ "$DIFF" -lt 0 ]; then
                warn "Selected $NEW_SELECTED ($DIFF from previous)"
            else
                ok "Selected $NEW_SELECTED (no change)"
            fi
        else
            abort "curator.py failed"
        fi
    else
        info "DRY-RUN: would curate"
    fi
fi

# ============================================================
# [9/12] Orchestrate + Budget + Validate
# ============================================================
header "9/12" "Orchestrate + Budget + Validate (Stages 4.5–4.7)"

if [ "$SKIP_PIPELINE" -eq 1 ]; then
    info "Skipping (no changes)"
else
    for stage in orchestrator budget validate_agents; do
        step "Running $stage.py..."
        if [ "$DRY_RUN" -eq 0 ]; then
            if PYTHONIOENCODING=utf-8 python "$SCRIPTS/$stage.py" 2>&1 | tail -8 | sed 's/^/    /'; then
                ok "$stage done"
            else
                warn "$stage.py had issues (non-fatal)"
            fi
        else
            info "DRY-RUN: would run $stage"
        fi
    done
fi

# ============================================================
# [10/12] Install Decision + Execute
# ============================================================
header "10/12" "Install to ~/.claude/"

if [ "$NO_INSTALL" -eq 1 ]; then
    info "--no-install: skipping install phase"
elif [ ! -f "$DECISIONS/selected.json" ]; then
    warn "No selected.json — nothing to install"
else
    INSTALL_COUNT=$(python -c "import json; print(json.load(open(r'$(cygpath -w $DECISIONS/selected.json)'))['total'])" 2>/dev/null || echo "0")
    info "Ready to install $INSTALL_COUNT components to $CLAUDE_HOME"
    info "Current state: skills=$CURR_SKILLS, agents=$CURR_AGENTS, commands=$CURR_COMMANDS"

    if confirm "Proceed with install?" "Y"; then
        step "Running installer.sh..."
        if [ "$DRY_RUN" -eq 1 ]; then
            bash "$SCRIPTS/installer.sh" --dry-run 2>&1 | tail -20 | sed 's/^/    /'
        else
            if bash "$SCRIPTS/installer.sh" 2>&1 | tail -20 | sed 's/^/    /'; then
                ok "Install complete"
            else
                err "Installer reported errors"
                info "Backup available at /c/tmp/claude-install-backup-*"
            fi
        fi
    else
        info "Install skipped by user"
    fi
fi

# ============================================================
# [11/12] Smoke Test
# ============================================================
header "11/12" "Smoke Test (Stage 5.5)"

if [ "$NO_INSTALL" -eq 1 ] || [ "$DRY_RUN" -eq 1 ]; then
    info "Skipping smoke test (install was skipped)"
else
    step "Running smoke_test.sh..."
    if bash "$SCRIPTS/smoke_test.sh" 2>&1 | tail -15 | sed 's/^/    /'; then
        ok "Smoke test passed"
    else
        warn "Smoke test reported issues — see $DECISIONS/smoke-test-report.md"
    fi
fi

# ============================================================
# [12/12] Git: Commit + Push decisions/
# ============================================================
header "12/12" "Self-repo Update (decisions/ git state)"

cd "$ROOT_BASH" || abort "cannot cd to project root"

CHANGED=$(git status --porcelain decisions/ templates/ 2>/dev/null | wc -l | tr -d ' ')
if [ "$CHANGED" -eq 0 ]; then
    info "No changes to commit in decisions/ or templates/"
elif [ "$DRY_RUN" -eq 1 ]; then
    info "DRY-RUN: would commit $CHANGED file(s)"
    git status --porcelain decisions/ templates/ 2>/dev/null | head -20 | sed 's/^/    /'
else
    info "$CHANGED file(s) changed in decisions/ or templates/"
    git status --porcelain decisions/ templates/ 2>/dev/null | head -20 | sed 's/^/    /'
    echo ""

    if confirm "Commit these changes?" "Y"; then
        git add decisions/ templates/ 2>/dev/null

        COMMIT_MSG="chore: auto-update decisions and templates

Ran setup.sh pipeline:
- Submodules: $UPDATES_NEEDED updated
- Components: $(python -c "import json; print(json.load(open(r'$(cygpath -w $DECISIONS/selected.json)'))['total'])" 2>/dev/null || echo "?") selected
- Install: $([ "$NO_INSTALL" -eq 0 ] && echo "yes" || echo "no")

Generated by scripts/setup.sh"

        if git commit -m "$COMMIT_MSG" 2>&1 | tail -5 | sed 's/^/    /'; then
            ok "Committed"

            if [ "$NO_PUSH" -eq 0 ]; then
                REMOTE_OK=$(git config --get remote.origin.url 2>/dev/null)
                if [ -z "$REMOTE_OK" ]; then
                    info "No remote configured — skipping push"
                elif confirm "Push to remote ($REMOTE_OK)?" "N"; then
                    if git push 2>&1 | tail -5 | sed 's/^/    /'; then
                        ok "Pushed"
                    else
                        warn "Push failed"
                    fi
                else
                    info "Push skipped by user"
                fi
            else
                info "--no-push: skipping git push"
            fi
        else
            warn "Commit failed"
        fi
    else
        info "Commit skipped by user"
    fi
fi

# ============================================================
# Final Summary
# ============================================================
END_TS=$(date +%s)
DURATION=$((END_TS - START_TS))
MINS=$((DURATION / 60))
SECS=$((DURATION % 60))

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}Setup Complete${NC}                          ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Duration:${NC}       ${MINS}m ${SECS}s"
echo -e "  ${BOLD}Log:${NC}            $SETUP_LOG"
echo -e "  ${BOLD}Submodules:${NC}     $UPDATES_NEEDED updated (of $SUBMODULE_COUNT)"

if [ -f "$DECISIONS/selected.json" ]; then
    FINAL_SEL=$(python -c "import json; print(json.load(open(r'$(cygpath -w $DECISIONS/selected.json)'))['total'])" 2>/dev/null || echo "?")
    echo -e "  ${BOLD}Selected:${NC}       $FINAL_SEL components"
fi

FINAL_SKILLS=$(ls "$CLAUDE_HOME/skills" 2>/dev/null | wc -l | tr -d ' ')
FINAL_AGENTS=$(ls "$CLAUDE_HOME/agents" 2>/dev/null | wc -l | tr -d ' ')
FINAL_CMDS=$(ls "$CLAUDE_HOME/commands" 2>/dev/null | wc -l | tr -d ' ')
echo -e "  ${BOLD}Installed:${NC}      $FINAL_SKILLS skills, $FINAL_AGENTS agents, $FINAL_CMDS commands"

if [ "$DRY_RUN" -eq 1 ]; then
    echo ""
    echo -e "  ${YELLOW}[DRY-RUN — no changes applied]${NC}"
fi

echo ""
echo -e "  ${DIM}Next: start a fresh Claude Code session to use the new install${NC}"
echo -e "  ${DIM}Run periodically: bash scripts/setup.sh${NC}"
echo ""

log "SETUP COMPLETE in ${DURATION}s"
exit 0
