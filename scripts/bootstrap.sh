#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Bootstrap — First-time setup wrapper
#
# For users who just cloned the repo. Handles:
#   1. Environment check (tools, Claude Code presence)
#   2. Submodule initialization (if not done)
#   3. Python dependency install prompt
#   4. Delegates to setup.sh for the main pipeline
#
# Safe to re-run. Does nothing destructive without confirmation.
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPTS="$ROOT_BASH/scripts"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"

# Colors
if [ -t 1 ]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'
    DIM='\033[2m'; NC='\033[0m'
else
    GREEN='' RED='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' NC=''
fi

ok()   { echo -e "  ${GREEN}✓${NC} $*"; }
err()  { echo -e "  ${RED}✗${NC} $*"; }
warn() { echo -e "  ${YELLOW}!${NC} $*"; }
info() { echo -e "  ${DIM}•${NC} $*"; }
step() { echo -e "  ${CYAN}→${NC} $*"; }

header() {
    echo ""
    echo -e "${BLUE}${BOLD}[$1]${NC} ${BOLD}$2${NC}"
    echo -e "${DIM}────────────────────────────────────────────${NC}"
}

confirm() {
    local question="$1"
    local default="${2:-Y}"
    local prompt="[Y/n]"
    [ "$default" = "N" ] && prompt="[y/N]"
    echo -ne "  ${YELLOW}?${NC} ${BOLD}$question${NC} $prompt "
    read -r reply
    [ -z "$reply" ] && reply="$default"
    case "$reply" in [Yy]*) return 0 ;; *) return 1 ;; esac
}

# --- Banner ---
clear 2>/dev/null || true
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}ClaudeCodeCTO Bootstrap${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${DIM}First-time setup wrapper${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
info "This script prepares your clone for the main setup:"
info "  1. Check required tools (git, bash, python3)"
info "  2. Initialize submodules (14 source repos, ~1 GB)"
info "  3. Launch scripts/setup.sh for the full pipeline"
echo ""

# ============================================================
# Python detection — verify it actually works
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
# [1/3] Tool check
# ============================================================
header "1/3" "Tool Check"

missing=0
for cmd in git bash; do
    if command -v "$cmd" >/dev/null 2>&1; then
        ver=$("$cmd" --version 2>&1 | head -1)
        ok "$cmd: $ver"
    else
        err "$cmd NOT FOUND"
        missing=$((missing + 1))
    fi
done

if [ "$missing" -gt 0 ]; then
    echo ""
    err "Install missing tools and re-run bootstrap"
    exit 1
fi

if detect_python; then
    ok "python: $("$PYTHON" --version 2>&1) ($PYTHON)"
else
    err "Python 3 NOT FOUND"
    info "Install it first:"
    info "  Linux:   sudo apt install python3  (or dnf/pacman)"
    info "  macOS:   brew install python3"
    info "  Windows: winget install -e --id Python.Python.3"
    info "Or run install.sh which auto-prompts for installation."
    exit 1
fi

if [ -d "$CLAUDE_HOME" ]; then
    ok "Claude Code home: $CLAUDE_HOME"
else
    warn "Claude Code home not found: $CLAUDE_HOME"
    warn "Install Claude Code first: https://docs.claude.com/en/docs/claude-code"
    if ! confirm "Continue anyway (you can run setup.sh later)?" "N"; then
        exit 1
    fi
fi

# ============================================================
# [2/3] Submodule initialization
# ============================================================
header "3/4" "Submodule Initialization"

cd "$ROOT_BASH" || { err "cannot cd to project root"; exit 1; }

if [ ! -f ".gitmodules" ]; then
    warn "No .gitmodules found — nothing to initialize"
else
    TOTAL_SM=$(git submodule status 2>/dev/null | wc -l | tr -d ' ')
    UNINIT=$(git submodule status 2>/dev/null | grep -c '^-' || echo 0)

    info "Submodules in .gitmodules: $TOTAL_SM"
    info "Uninitialized:             $UNINIT"

    if [ "$UNINIT" -gt 0 ] 2>/dev/null; then
        echo ""
        warn "Initializing submodules will download ~1 GB across $UNINIT repos."
        warn "This can take 5-15 minutes depending on connection speed."
        if confirm "Proceed with submodule init?" "Y"; then
            step "Running: git submodule update --init --recursive"
            echo ""
            if git submodule update --init --recursive 2>&1 | sed 's/^/    /'; then
                ok "All submodules initialized"
            else
                err "Submodule init had issues"
                info "You can retry with: git submodule update --init --recursive --force"
                exit 1
            fi
        else
            info "Skipped — you can init manually: git submodule update --init --recursive"
            exit 0
        fi
    else
        ok "All submodules already initialized"
    fi
fi

# ============================================================
# [3/3] Launch main setup
# ============================================================
header "4/4" "Launch Main Setup"

echo ""
info "Bootstrap complete. Ready to run the main pipeline."
info "This will:"
info "  - Scan and extract all source repo content"
info "  - Score 2,500+ components by quality rubric"
info "  - Curate the best ones into ~/.claude/ (with confirmation)"
info "  - Install orchestrator, agent decision tree, and settings"
info "  - Optionally commit decisions/ to this repo"
echo ""

if confirm "Launch scripts/setup.sh now?" "Y"; then
    exec bash "$SCRIPTS/setup.sh"
else
    echo ""
    info "You can run it later with:"
    echo ""
    echo -e "    ${BOLD}bash scripts/setup.sh${NC}"
    echo ""
    info "Useful flags:"
    echo -e "    ${DIM}--check      just inspect state, no changes${NC}"
    echo -e "    ${DIM}--dry-run    show what would happen${NC}"
    echo -e "    ${DIM}--no-install skip install phase${NC}"
    echo -e "    ${DIM}--no-push    skip git push${NC}"
    echo -e "    ${DIM}--auto       non-interactive (cron mode)${NC}"
    echo ""
fi
