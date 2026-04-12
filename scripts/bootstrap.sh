#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Bootstrap — First-time setup wrapper
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
echo -e "${CYAN}║${NC}  ${BOLD}CloaudeCodeCTO Bootstrap${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${DIM}First-time setup wrapper${NC}               ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
echo ""
info "This script prepares your clone for the main setup:"
info "  1. Check required tools (git, python, bash)"
info "  2. Initialize submodules (16 source repos, ~1 GB)"
info "  3. Verify Python dependencies"
info "  4. Launch scripts/setup.sh for the full pipeline"
echo ""

# ============================================================
# [1/4] Tool check
# ============================================================
header "1/4" "Tool Check"

missing=0
for cmd in git python bash; do
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
# [2/4] Python dependency check
# ============================================================
header "2/4" "Python Dependencies"

if python -c "import yaml" 2>/dev/null; then
    ok "PyYAML installed"
else
    warn "PyYAML is not installed"
    info "PyYAML is required for parsing SKILL.md frontmatter"
    if confirm "Install PyYAML now (pip install pyyaml)?" "Y"; then
        if python -m pip install pyyaml 2>&1 | tail -3 | sed 's/^/    /'; then
            ok "PyYAML installed"
        else
            err "Pip install failed — try manually: pip install pyyaml"
            exit 1
        fi
    else
        warn "Skipping — setup.sh will fail without PyYAML"
        exit 1
    fi
fi

# ============================================================
# [3/4] Submodule initialization
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
# [4/4] Launch main setup
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
