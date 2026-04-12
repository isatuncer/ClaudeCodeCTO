#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Setup — Install-only flow
#
# This script installs the pre-curated component set into
# ~/.claude/. The curation (analysis pipeline) happened on the
# maintainer's machine BEFORE this repo was pushed; end users
# simply consume the pre-built decisions/selected.json.
#
# Phases:
#   1. Environment check
#   2. Current state inspection
#   3. Submodule sanity check
#   4. Install (installer.sh)
#   5. Smoke test (smoke_test.sh)
#   6. (Optional) Tracker baseline
#
# Modes:
#   (default)    interactive — confirms the install
#   --auto       non-interactive
#   --dry-run    show what would happen, no changes
#   --check      only inspect state, no install
#   --no-install skip install (diagnostic mode)
#   --no-smoke   skip smoke test
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
DECISIONS="$ROOT_BASH/decisions"
SCRIPTS="$ROOT_BASH/scripts"
SETUP_LOG="$DECISIONS/setup.log"
START_TS=$(date +%s)

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

# Modes
AUTO=0
DRY_RUN=0
CHECK_ONLY=0
NO_INSTALL=0
NO_SMOKE=0

for arg in "$@"; do
    case "$arg" in
        --auto) AUTO=1 ;;
        --dry-run) DRY_RUN=1 ;;
        --check) CHECK_ONLY=1 ;;
        --no-install) NO_INSTALL=1 ;;
        --no-smoke) NO_SMOKE=1 ;;
        --help|-h)
            grep -E "^#" "$0" | head -30
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

mkdir -p "$DECISIONS"
: > "$SETUP_LOG"

log()    { echo "[$(date +'%H:%M:%S')] $*" >> "$SETUP_LOG"; }
header() {
    echo ""
    echo -e "${BLUE}${BOLD}[$1]${NC} ${BOLD}$2${NC}"
    echo -e "${DIM}────────────────────────────────────────────${NC}"
    log "PHASE $1: $2"
}
info()   { echo -e "  ${DIM}•${NC} $*"; log "INFO: $*"; }
ok()     { echo -e "  ${GREEN}✓${NC} $*"; log "OK: $*"; }
warn()   { echo -e "  ${YELLOW}!${NC} $*"; log "WARN: $*"; }
err()    { echo -e "  ${RED}✗${NC} $*"; log "ERR: $*"; }
step()   { echo -e "  ${CYAN}→${NC} $*"; log "STEP: $*"; }

confirm() {
    local question="$1"
    local default="${2:-Y}"
    if [ "$AUTO" -eq 1 ]; then
        info "AUTO mode: yes for \"$question\""
        return 0
    fi
    local prompt="[Y/n]"
    [ "$default" = "N" ] && prompt="[y/N]"
    local reply=""
    if [ -t 0 ]; then
        echo -ne "  ${MAGENTA}?${NC} ${BOLD}$question${NC} $prompt "
        read -r reply
    elif [ -r /dev/tty ]; then
        echo -ne "  ${MAGENTA}?${NC} ${BOLD}$question${NC} $prompt "
        read -r reply < /dev/tty
    else
        [ "$default" = "Y" ] && return 0 || return 1
    fi
    [ -z "$reply" ] && reply="$default"
    case "$reply" in [Yy]*) return 0 ;; *) return 1 ;; esac
}

abort() {
    err "Aborted: $*"
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
echo -e "${CYAN}║${NC}  ${DIM}Install pre-curated Claude Code toolkit${NC}   ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
[ "$AUTO" -eq 1 ]        && echo -e "  ${YELLOW}[AUTO]${NC} non-interactive"
[ "$DRY_RUN" -eq 1 ]     && echo -e "  ${YELLOW}[DRY-RUN]${NC} no changes"
[ "$CHECK_ONLY" -eq 1 ]  && echo -e "  ${YELLOW}[CHECK-ONLY]${NC} just inspecting"
[ "$NO_INSTALL" -eq 1 ]  && echo -e "  ${YELLOW}[NO-INSTALL]${NC} install skipped"
[ "$NO_SMOKE" -eq 1 ]    && echo -e "  ${YELLOW}[NO-SMOKE]${NC} smoke test skipped"
echo -e "  ${DIM}Log: $SETUP_LOG${NC}"
echo ""

# ============================================================
# Python detection — verify it actually works (Windows has fake stubs)
# ============================================================
detect_python() {
    local candidate
    for candidate in python3 python; do
        if command -v "$candidate" >/dev/null 2>&1; then
            if "$candidate" --version 2>&1 | grep -q "^Python 3"; then
                PYTHON="$candidate"
                export PYTHON
                return 0
            fi
        fi
    done
    return 1
}

# ============================================================
# [1/6] Environment Check
# ============================================================
header "1/6" "Environment Check"

for cmd in bash git; do
    if command -v "$cmd" >/dev/null 2>&1; then
        ver=$("$cmd" --version 2>&1 | head -1)
        ok "$cmd: $ver"
    else
        err "$cmd NOT FOUND"
        abort "missing required tool: $cmd"
    fi
done

if detect_python; then
    ok "python: $("$PYTHON" --version 2>&1) ($PYTHON)"
else
    err "Python 3 NOT FOUND"
    info "Run install.sh from scratch for auto-install, or install manually:"
    info "  Linux:   sudo apt install python3  (or dnf/pacman)"
    info "  macOS:   brew install python3"
    info "  Windows: winget install -e --id Python.Python.3"
    abort "Python 3 is required"
fi

if [ -d "$CLAUDE_HOME" ]; then
    ok "Claude home: $CLAUDE_HOME"
else
    err "Claude home not found: $CLAUDE_HOME"
    abort "Claude Code not installed"
fi

if [ -f "$CLAUDE_HOME/.credentials.json" ]; then
    ok "Credentials present"
else
    warn "No credentials — login to Claude Code first"
    if ! confirm "Continue anyway?" "N"; then
        abort "credentials missing"
    fi
fi

# ============================================================
# [2/6] Current State
# ============================================================
header "2/6" "Current State"

CURR_SKILLS=$(ls "$CLAUDE_HOME/skills" 2>/dev/null | wc -l | tr -d ' ')
CURR_AGENTS=$(ls "$CLAUDE_HOME/agents" 2>/dev/null | wc -l | tr -d ' ')
CURR_COMMANDS=$(ls "$CLAUDE_HOME/commands" 2>/dev/null | wc -l | tr -d ' ')

info "Currently in $CLAUDE_HOME:"
info "  skills=$CURR_SKILLS  agents=$CURR_AGENTS  commands=$CURR_COMMANDS"

MANIFEST="$DECISIONS/install-manifest.json"
if [ -f "$MANIFEST" ]; then
    ok "Pre-built manifest exists"
fi

INSTALL_TSV="$DECISIONS/install.tsv"
ASSETS_DIR="$DECISIONS/assets"
if [ -f "$INSTALL_TSV" ] && [ -d "$ASSETS_DIR" ]; then
    TOTAL=$(grep -v '^#' "$INSTALL_TSV" | grep -c '[^[:space:]]' || echo 0)
    ok "Pre-built selection: $TOTAL components"
else
    err "decisions/install.tsv or decisions/assets/ missing — cannot install"
    abort "pre-built selection not found"
fi

# ============================================================
# [3/6] Submodule Sanity Check
# ============================================================
header "3/6" "Submodule Sanity Check"

cd "$ROOT_BASH" || abort "cannot cd to project root"

if [ ! -f ".gitmodules" ]; then
    warn "No .gitmodules — submodules won't be checked"
else
    TOTAL_SM=$(git submodule status 2>/dev/null | wc -l | tr -d ' ')
    UNINIT=$(git submodule status 2>/dev/null | grep -c '^-' || echo 0)

    info "Submodules: $TOTAL_SM  uninitialized: $UNINIT"

    if [ "$UNINIT" -gt 0 ] 2>/dev/null; then
        warn "$UNINIT submodules not initialized"
        warn "Run: git submodule update --init --recursive"
        if ! confirm "Initialize now?" "Y"; then
            abort "submodules required for install"
        fi
        step "git submodule update --init --recursive"
        git submodule update --init --recursive 2>&1 | tee -a "$SETUP_LOG" | tail -3 | sed 's/^/    /'
    else
        ok "All submodules initialized"
    fi
fi

if [ "$CHECK_ONLY" -eq 1 ]; then
    echo ""
    info "CHECK-ONLY mode: exiting"
    exit 0
fi

# ============================================================
# [4/6] Install
# ============================================================
header "4/6" "Install to ~/.claude/"

if [ "$NO_INSTALL" -eq 1 ]; then
    info "--no-install: skipped"
elif [ "$DRY_RUN" -eq 1 ]; then
    step "DRY-RUN: bash scripts/installer.sh --dry-run"
    bash "$SCRIPTS/installer.sh" --dry-run 2>&1 | tail -20 | sed 's/^/    /'
else
    info "Ready to install $TOTAL components to $CLAUDE_HOME"
    info "A backup of the current ~/.claude/ will be created first."
    echo ""
    if confirm "Proceed with install?" "Y"; then
        step "bash scripts/installer.sh"
        if bash "$SCRIPTS/installer.sh" 2>&1 | tail -25 | sed 's/^/    /'; then
            ok "Install complete"
        else
            err "Installer reported errors"
            info "Backup available at /c/tmp/claude-install-backup-*"
        fi
    else
        info "Install skipped by user"
        NO_INSTALL=1
    fi
fi

# ============================================================
# [5/6] Smoke Test
# ============================================================
header "5/6" "Smoke Test"

if [ "$NO_SMOKE" -eq 1 ] || [ "$NO_INSTALL" -eq 1 ] || [ "$DRY_RUN" -eq 1 ]; then
    info "Skipping"
else
    step "bash scripts/smoke_test.sh"
    if bash "$SCRIPTS/smoke_test.sh" 2>&1 | tail -20 | sed 's/^/    /'; then
        ok "Smoke test passed"
    else
        warn "Smoke test reported issues — see $DECISIONS/smoke-test-report.md"
    fi
fi

# ============================================================
# [6/6] Summary
# ============================================================
END_TS=$(date +%s)
DURATION=$((END_TS - START_TS))
MINS=$((DURATION / 60))
SECS=$((DURATION % 60))

FINAL_SKILLS=$(ls "$CLAUDE_HOME/skills" 2>/dev/null | wc -l | tr -d ' ')
FINAL_AGENTS=$(ls "$CLAUDE_HOME/agents" 2>/dev/null | wc -l | tr -d ' ')
FINAL_CMDS=$(ls "$CLAUDE_HOME/commands" 2>/dev/null | wc -l | tr -d ' ')

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}Setup Complete${NC}                          ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Duration:${NC}  ${MINS}m ${SECS}s"
echo -e "  ${BOLD}Installed:${NC} $FINAL_SKILLS skills, $FINAL_AGENTS agents, $FINAL_CMDS commands"
echo -e "  ${BOLD}Log:${NC}       $SETUP_LOG"
[ "$DRY_RUN" -eq 1 ] && echo -e "  ${YELLOW}[DRY-RUN — no changes applied]${NC}"
echo ""
echo -e "  ${DIM}Next: start a fresh Claude Code session to use the installation${NC}"
echo ""

log "SETUP COMPLETE in ${DURATION}s"
exit 0
