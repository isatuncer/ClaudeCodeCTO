#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO One-Command Installer
#
# Clones the repo, initializes all submodules, installs Python
# dependencies, and launches the setup pipeline — all in one
# command.
#
# Usage:
#
#   # One-liner from remote (works with curl-pipe):
#   curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
#
#   # Or with wget:
#   wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
#
#   # Local (after clone):
#   bash install.sh
#
# Environment variables (all optional):
#
#   CCCTO_DIR         Target directory (default: $HOME/CloaudeCodeCTO)
#   CCCTO_BRANCH      Branch to clone (default: main)
#   CCCTO_REPO_URL    Git URL (default: https://github.com/isatuncer/ClaudeCodeCTO.git)
#   CCCTO_AUTO        "1" for non-interactive mode (no prompts)
#   CCCTO_NO_INSTALL  "1" to skip the ~/.claude/ install step
#   CCCTO_NO_SETUP    "1" to skip running setup.sh at all
#
# ============================================================

set -uo pipefail

# --- Defaults ---
CCCTO_DIR="${CCCTO_DIR:-$HOME/CloaudeCodeCTO}"
CCCTO_BRANCH="${CCCTO_BRANCH:-main}"
CCCTO_REPO_URL="${CCCTO_REPO_URL:-https://github.com/isatuncer/ClaudeCodeCTO.git}"
CCCTO_AUTO="${CCCTO_AUTO:-0}"
CCCTO_NO_INSTALL="${CCCTO_NO_INSTALL:-0}"
CCCTO_NO_SETUP="${CCCTO_NO_SETUP:-0}"

# --- Colors ---
if [ -t 1 ]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; CYAN='\033[0;36m'; MAGENTA='\033[0;35m'
    BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
else
    GREEN='' RED='' YELLOW='' BLUE='' CYAN='' MAGENTA='' BOLD='' DIM='' NC=''
fi

# --- Output helpers ---
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

abort() {
    local msg="$*"
    err "Aborted: $msg"
    echo ""
    echo -e "${RED}══════════════════════════════════════════${NC}"
    echo -e "${RED}${BOLD}  Installation aborted${NC}"
    echo -e "${RED}══════════════════════════════════════════${NC}"
    exit 1
}

# --- Interactive helper (works even when piped via curl) ---
confirm() {
    local question="$1"
    local default="${2:-Y}"

    if [ "$CCCTO_AUTO" = "1" ]; then
        info "AUTO mode: assuming yes for \"$question\""
        return 0
    fi

    local prompt="[Y/n]"
    [ "$default" = "N" ] && prompt="[y/N]"

    local reply=""
    if [ -t 0 ]; then
        # stdin is a terminal — normal read
        echo -ne "  ${MAGENTA}?${NC} ${BOLD}$question${NC} $prompt "
        read -r reply
    elif [ -r /dev/tty ]; then
        # Piped stdin but /dev/tty is available (curl-pipe case)
        echo -ne "  ${MAGENTA}?${NC} ${BOLD}$question${NC} $prompt "
        read -r reply < /dev/tty
    else
        # No tty at all (CI / headless) — use default
        info "No TTY available — using default for \"$question\""
        [ "$default" = "Y" ] && return 0 || return 1
    fi

    [ -z "$reply" ] && reply="$default"
    case "$reply" in [Yy]*) return 0 ;; *) return 1 ;; esac
}

# --- Banner ---
clear 2>/dev/null || true
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  ${BOLD}CloaudeCodeCTO One-Command Installer${NC}       ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${DIM}Clone + submodules + pipeline + install${NC}    ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════╝${NC}"
echo ""
info "Target directory: $CCCTO_DIR"
info "Branch:           $CCCTO_BRANCH"
info "Repo URL:         $CCCTO_REPO_URL"
[ "$CCCTO_AUTO" = "1" ]        && echo -e "  ${YELLOW}[AUTO MODE]${NC} non-interactive"
[ "$CCCTO_NO_INSTALL" = "1" ]  && echo -e "  ${YELLOW}[NO-INSTALL]${NC} ~/.claude/ install will be skipped"
[ "$CCCTO_NO_SETUP" = "1" ]    && echo -e "  ${YELLOW}[NO-SETUP]${NC} setup.sh will not be launched"

# ============================================================
# [1/6] Prerequisite Check
# ============================================================
header "1/6" "Prerequisite Check"

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
    err "Install missing tools and re-run:"
    [ "$missing" -gt 0 ] && echo "    git:    https://git-scm.com/downloads"
    [ "$missing" -gt 0 ] && echo "    python: https://www.python.org/downloads/"
    abort "missing required tools"
fi

# Claude Code check (warning only — can proceed without it)
if [ -d "$HOME/.claude" ] && [ -f "$HOME/.claude/.credentials.json" ]; then
    ok "Claude Code installed with credentials"
else
    warn "Claude Code not found or not logged in"
    info "Install from: https://docs.claude.com/en/docs/claude-code"
    if ! confirm "Continue anyway (setup.sh will fail at install step)?" "N"; then
        abort "Claude Code required"
    fi
fi

# ============================================================
# [2/6] Clone or Update Repository
# ============================================================
header "2/6" "Clone / Update Repository"

if [ -d "$CCCTO_DIR/.git" ]; then
    info "Target directory already contains a git repo"
    (
        cd "$CCCTO_DIR" || exit 1
        current_url=$(git config --get remote.origin.url 2>/dev/null || echo "")
        if [ "$current_url" = "$CCCTO_REPO_URL" ]; then
            ok "Remote matches — pulling latest"
            step "git pull origin $CCCTO_BRANCH"
            if git pull origin "$CCCTO_BRANCH" 2>&1 | sed 's/^/    /'; then
                ok "Up to date"
            else
                warn "Pull had issues — check manually"
            fi
        else
            warn "Remote URL differs: $current_url"
            warn "Leaving existing directory untouched"
        fi
    )
elif [ -e "$CCCTO_DIR" ]; then
    err "Target exists but is not a git repo: $CCCTO_DIR"
    if confirm "Remove and re-clone?" "N"; then
        rm -rf "$CCCTO_DIR"
    else
        abort "target directory is not empty"
    fi
fi

if [ ! -d "$CCCTO_DIR/.git" ]; then
    step "git clone --branch $CCCTO_BRANCH $CCCTO_REPO_URL $CCCTO_DIR"
    if git clone --branch "$CCCTO_BRANCH" "$CCCTO_REPO_URL" "$CCCTO_DIR" 2>&1 | sed 's/^/    /'; then
        ok "Cloned successfully"
    else
        abort "git clone failed"
    fi
fi

cd "$CCCTO_DIR" || abort "cannot cd into $CCCTO_DIR"

# ============================================================
# [3/6] Initialize Submodules
# ============================================================
header "3/6" "Initialize Submodules"

if [ ! -f ".gitmodules" ]; then
    warn "No .gitmodules — nothing to initialize"
else
    TOTAL_SM=$(git submodule status 2>/dev/null | wc -l | tr -d ' ')
    UNINIT=$(git submodule status 2>/dev/null | grep -c '^-' || echo 0)

    info "Submodules in .gitmodules: $TOTAL_SM"
    info "Uninitialized:             $UNINIT"

    if [ "$UNINIT" -gt 0 ] 2>/dev/null; then
        echo ""
        warn "About to download ~1 GB of submodule content across $UNINIT repos."
        warn "This can take 5-15 minutes depending on connection speed."

        if confirm "Proceed with submodule init?" "Y"; then
            step "git submodule update --init --recursive"
            echo ""
            if git submodule update --init --recursive 2>&1 | sed 's/^/    /'; then
                ok "All submodules initialized"
            else
                warn "Submodule init had issues"
                info "Retry manually: git submodule update --init --recursive --force"
                if ! confirm "Continue anyway?" "N"; then
                    abort "submodule init failed"
                fi
            fi
        else
            info "Skipped submodule init"
            info "Pipeline cannot run without submodules — you'll need to init them manually"
            CCCTO_NO_SETUP=1
        fi
    else
        ok "All submodules already initialized"
    fi
fi

# ============================================================
# [4/6] Python Dependencies
# ============================================================
header "4/6" "Python Dependencies"

if python -c "import yaml" 2>/dev/null; then
    ok "PyYAML installed"
else
    warn "PyYAML is required for parsing SKILL.md frontmatter"
    if confirm "Install PyYAML now (python -m pip install pyyaml)?" "Y"; then
        if python -m pip install pyyaml 2>&1 | tail -3 | sed 's/^/    /'; then
            ok "PyYAML installed"
        else
            warn "Pip install failed — install manually: pip install pyyaml"
            if ! confirm "Continue without PyYAML (setup.sh will fail)?" "N"; then
                abort "Python dependency missing"
            fi
        fi
    fi
fi

# ============================================================
# [5/6] Permissions
# ============================================================
header "5/6" "Script Permissions"

script_count=0
for sh in scripts/*.sh install.sh; do
    if [ -f "$sh" ]; then
        chmod +x "$sh" 2>/dev/null
        script_count=$((script_count + 1))
    fi
done
ok "Made $script_count shell scripts executable"

# ============================================================
# [6/6] Launch Main Setup
# ============================================================
header "6/6" "Launch Main Setup"

if [ "$CCCTO_NO_SETUP" = "1" ]; then
    info "NO-SETUP flag set — skipping setup.sh"
    info "Run it later with: cd $CCCTO_DIR && bash scripts/setup.sh"
    LAUNCHED=0
else
    echo ""
    info "Ready to run the main pipeline. This will:"
    info "  - Extract metadata from all source repos (~1 min)"
    info "  - Score ~2,500 components with the rubric (~30 sec)"
    info "  - Curate the best ones into decisions/selected.json"
    info "  - Generate orchestrator + budget + decision tree"
    if [ "$CCCTO_NO_INSTALL" = "1" ]; then
        info "  - (install to ~/.claude/ will be SKIPPED)"
    else
        info "  - Install to ~/.claude/ (asks for confirmation first)"
    fi
    echo ""

    SETUP_FLAGS=""
    [ "$CCCTO_AUTO" = "1" ]       && SETUP_FLAGS="$SETUP_FLAGS --auto"
    [ "$CCCTO_NO_INSTALL" = "1" ] && SETUP_FLAGS="$SETUP_FLAGS --no-install"

    if confirm "Launch scripts/setup.sh now?" "Y"; then
        step "bash scripts/setup.sh$SETUP_FLAGS"
        echo ""
        # Use exec to replace this process with setup.sh
        exec bash "$CCCTO_DIR/scripts/setup.sh" $SETUP_FLAGS
    else
        info "Setup skipped. Run it later:"
        echo ""
        echo -e "    ${BOLD}cd $CCCTO_DIR${NC}"
        echo -e "    ${BOLD}bash scripts/setup.sh${NC}"
        LAUNCHED=0
    fi
fi

# ============================================================
# Final Summary (only reached if setup.sh NOT exec'd)
# ============================================================
echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║${NC}  ${BOLD}Installation prepared${NC}                       ${GREEN}║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Location:${NC}   $CCCTO_DIR"
echo -e "  ${BOLD}Branch:${NC}     $CCCTO_BRANCH"
echo ""
echo -e "  ${DIM}Next steps:${NC}"
echo -e "    cd $CCCTO_DIR"
echo -e "    bash scripts/setup.sh    ${DIM}# Run the pipeline interactively${NC}"
echo -e "    bash scripts/setup.sh --check   ${DIM}# Just check state${NC}"
echo -e "    bash scripts/setup.sh --help    ${DIM}# See all options${NC}"
echo ""
