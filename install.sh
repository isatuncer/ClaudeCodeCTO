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

# Detect existing CloaudeCodeCTO install by looking for our manifest
# in the user's ~/.claude/. If present, this is an UPDATE, not a fresh
# install — show a banner so the user knows what's about to happen.
EXISTING_MANIFEST="$HOME/.claude/install-manifest.json"
if [ -f "$EXISTING_MANIFEST" ]; then
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${YELLOW}  UPDATE MODE — existing install detected${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    # Try to show a compact summary without requiring python yet
    if command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
        py="python3"; command -v "$py" >/dev/null 2>&1 || py="python"
        "$py" - "$EXISTING_MANIFEST" << 'PYMAN' 2>/dev/null || true
import json, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
    inst = d.get("installed", {}) or {}
    profile = d.get("profile", "unknown")
    total = d.get("total", "?")
    print(f"  Current profile: {profile}")
    print(f"  Current total:   {total} (skills={inst.get('skills','?')} agents={inst.get('agents','?')} commands={inst.get('commands','?')})")
    print(f"  Installed at:    {d.get('installed_at', 'unknown')}")
except Exception:
    pass
PYMAN
    fi
    echo ""
    info "Your settings.json, .credentials.json, projects/, and custom files will be preserved."
    info "A backup will be written to /c/tmp/claude-install-backup-<timestamp>/"
    echo ""
fi

# ============================================================
# Python detection + optional auto-install
# ============================================================
# Verifies python3 actually works (Windows has fake Store stubs that
# exist as files but fail when executed).
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

# Attempts to auto-install Python 3 with user confirmation.
# Platform-aware: apt/dnf/pacman/apk on Linux, brew on macOS, winget on Windows.
ensure_python() {
    if detect_python; then
        ok "Python: $("$PYTHON" --version 2>&1)"
        export PYTHON
        return 0
    fi

    warn "Python 3 not found"

    local install_cmd=""
    local needs_sudo=0
    local platform_hint=""

    case "$(uname -s)" in
        Linux*)
            if command -v apt-get >/dev/null 2>&1; then
                install_cmd="apt-get install -y python3"
                needs_sudo=1
                platform_hint="Debian/Ubuntu"
            elif command -v dnf >/dev/null 2>&1; then
                install_cmd="dnf install -y python3"
                needs_sudo=1
                platform_hint="Fedora/RHEL"
            elif command -v pacman >/dev/null 2>&1; then
                install_cmd="pacman -S --noconfirm python"
                needs_sudo=1
                platform_hint="Arch/Manjaro"
            elif command -v apk >/dev/null 2>&1; then
                install_cmd="apk add python3"
                needs_sudo=1
                platform_hint="Alpine"
            fi
            ;;
        Darwin*)
            if command -v brew >/dev/null 2>&1; then
                install_cmd="brew install python3"
                platform_hint="macOS (Homebrew)"
            else
                err "Homebrew not found"
                info "Install brew first: https://brew.sh"
                info "Or install Python directly: https://www.python.org/downloads/"
                return 1
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            if command -v winget >/dev/null 2>&1; then
                install_cmd="winget install -e --id Python.Python.3 --scope user --accept-source-agreements --accept-package-agreements"
                platform_hint="Windows (winget, user scope)"
            else
                err "winget not found"
                info "Install Python manually: https://www.python.org/downloads/"
                return 1
            fi
            ;;
    esac

    if [ -z "$install_cmd" ]; then
        err "No supported package manager detected"
        info "Install Python 3 manually: https://www.python.org/downloads/"
        return 1
    fi

    echo ""
    info "Platform: $platform_hint"
    if [ "$needs_sudo" -eq 1 ]; then
        echo -e "  Command:  ${BOLD}sudo $install_cmd${NC}"
        warn "This will prompt for your sudo password"
    else
        echo -e "  Command:  ${BOLD}$install_cmd${NC}"
    fi
    echo ""

    if ! confirm "Install Python 3 now?" "Y"; then
        err "Python 3 required — installation cancelled"
        return 1
    fi

    step "Installing Python 3..."
    if [ "$needs_sudo" -eq 1 ]; then
        # shellcheck disable=SC2086
        if ! sudo $install_cmd; then
            err "Python install failed"
            return 1
        fi
    else
        # shellcheck disable=SC2086
        if ! $install_cmd; then
            err "Python install failed"
            return 1
        fi
    fi

    # Verify
    if detect_python; then
        ok "Python installed: $("$PYTHON" --version 2>&1)"
        export PYTHON
        return 0
    else
        err "Python install completed but python3 still not found"
        info "PATH may need reloading — try opening a new terminal"
        return 1
    fi
}

# ============================================================
# Node.js detection + optional auto-install
# ============================================================
detect_node() {
    if command -v node >/dev/null 2>&1; then
        if node --version 2>&1 | grep -qE "^v(1[8-9]|[2-9][0-9])\."; then
            NODE_CMD=node
            return 0
        fi
    fi
    return 1
}

ensure_node() {
    if detect_node; then
        ok "Node.js: $(node --version 2>&1) ($(command -v node))"
        return 0
    fi

    warn "Node.js 18+ not found (required for Claude Code)"

    local install_cmd=""
    local needs_sudo=0
    local platform_hint=""

    case "$(uname -s)" in
        Linux*)
            if command -v apt-get >/dev/null 2>&1; then
                install_cmd="apt-get install -y nodejs npm"
                needs_sudo=1
                platform_hint="Debian/Ubuntu"
            elif command -v dnf >/dev/null 2>&1; then
                install_cmd="dnf install -y nodejs npm"
                needs_sudo=1
                platform_hint="Fedora/RHEL"
            elif command -v pacman >/dev/null 2>&1; then
                install_cmd="pacman -S --noconfirm nodejs npm"
                needs_sudo=1
                platform_hint="Arch/Manjaro"
            elif command -v apk >/dev/null 2>&1; then
                install_cmd="apk add nodejs npm"
                needs_sudo=1
                platform_hint="Alpine"
            fi
            ;;
        Darwin*)
            if command -v brew >/dev/null 2>&1; then
                install_cmd="brew install node"
                platform_hint="macOS (Homebrew)"
            else
                err "Homebrew not found"
                info "Install brew first: https://brew.sh"
                info "Or install Node.js directly: https://nodejs.org/"
                return 1
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            if command -v winget >/dev/null 2>&1; then
                install_cmd="winget install -e --id OpenJS.NodeJS --scope user --accept-source-agreements --accept-package-agreements"
                platform_hint="Windows (winget, user scope)"
            else
                err "winget not found"
                info "Install Node.js manually: https://nodejs.org/"
                return 1
            fi
            ;;
    esac

    if [ -z "$install_cmd" ]; then
        err "No supported package manager detected for Node.js"
        info "Install manually: https://nodejs.org/"
        return 1
    fi

    echo ""
    info "Platform: $platform_hint"
    if [ "$needs_sudo" -eq 1 ]; then
        echo -e "  Command:  ${BOLD}sudo $install_cmd${NC}"
        warn "This will prompt for your sudo password"
    else
        echo -e "  Command:  ${BOLD}$install_cmd${NC}"
    fi
    echo ""

    if ! confirm "Install Node.js now?" "Y"; then
        err "Node.js required — installation cancelled"
        return 1
    fi

    step "Installing Node.js..."
    if [ "$needs_sudo" -eq 1 ]; then
        # shellcheck disable=SC2086
        if ! sudo $install_cmd; then
            err "Node.js install failed"
            return 1
        fi
    else
        # shellcheck disable=SC2086
        if ! $install_cmd; then
            err "Node.js install failed"
            return 1
        fi
    fi

    if detect_node; then
        ok "Node.js installed: $(node --version 2>&1)"
        return 0
    else
        err "Node.js install completed but node not on PATH"
        info "Open a new terminal and re-run install.sh"
        return 1
    fi
}

# ============================================================
# Claude Code detection + optional auto-install
# ============================================================
detect_claude_code() {
    # Claude Code installed if `claude` command exists AND ~/.claude/ has credentials
    if command -v claude >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

ensure_claude_code() {
    if detect_claude_code; then
        ok "Claude Code: $(claude --version 2>&1 | head -1) ($(command -v claude))"
    else
        warn "Claude Code not installed"
        echo ""
        info "Claude Code will be installed via npm (requires Node.js)"
        info "Package: @anthropic-ai/claude-code"
        echo ""

        if ! confirm "Install Claude Code now?" "Y"; then
            err "Claude Code required — installation cancelled"
            return 1
        fi

        # Ensure Node.js first
        if ! ensure_node; then
            err "Node.js is required for Claude Code"
            return 1
        fi

        # Install Claude Code via npm
        local npm_cmd="npm install -g @anthropic-ai/claude-code"
        local npm_needs_sudo=0

        # Check if global npm install needs sudo (typical on Linux)
        case "$(uname -s)" in
            Linux*)
                # Check if user can write to npm global prefix
                local npm_prefix
                npm_prefix=$(npm config get prefix 2>/dev/null || echo "/usr")
                if [ ! -w "$npm_prefix/lib/node_modules" ] 2>/dev/null; then
                    npm_needs_sudo=1
                fi
                ;;
        esac

        echo ""
        if [ "$npm_needs_sudo" -eq 1 ]; then
            echo -e "  Command:  ${BOLD}sudo $npm_cmd${NC}"
            warn "Global npm install needs sudo on this system"
        else
            echo -e "  Command:  ${BOLD}$npm_cmd${NC}"
        fi
        echo ""

        step "Installing Claude Code..."
        if [ "$npm_needs_sudo" -eq 1 ]; then
            # shellcheck disable=SC2086
            if ! sudo $npm_cmd; then
                err "Claude Code install failed"
                info "Try manually: sudo npm install -g @anthropic-ai/claude-code"
                return 1
            fi
        else
            # shellcheck disable=SC2086
            if ! $npm_cmd; then
                err "Claude Code install failed"
                info "Try manually: npm install -g @anthropic-ai/claude-code"
                return 1
            fi
        fi

        if detect_claude_code; then
            ok "Claude Code installed: $(claude --version 2>&1 | head -1)"
        else
            err "Claude Code install completed but 'claude' command not on PATH"
            info "Open a new terminal and re-run install.sh"
            return 1
        fi
    fi

    # Now check for login (credentials)
    if [ -f "$HOME/.claude/.credentials.json" ]; then
        ok "Claude Code credentials present"
        return 0
    else
        warn "Claude Code not logged in"
        info ""
        info "Run this command in a separate terminal:"
        echo -e "    ${BOLD}claude${NC}    ${DIM}# will prompt for login${NC}"
        info ""
        info "After logging in, re-run install.sh to continue."
        if confirm "Continue without login (setup.sh will fail at install step)?" "N"; then
            return 0
        fi
        return 1
    fi
}

# ============================================================
# [1/6] Prerequisite Check
# ============================================================
header "1/6" "Prerequisite Check"

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
    err "Install missing tools and re-run:"
    echo "    git: https://git-scm.com/downloads"
    abort "missing required tools"
fi

# Python 3 — auto-install if missing
if ! ensure_python; then
    abort "Python 3 is required"
fi

# Claude Code — auto-install if missing (pulls in Node.js as needed)
if ! ensure_claude_code; then
    abort "Claude Code is required"
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
# [4/6] Python stdlib check
# ============================================================
header "4/6" "Python stdlib check"

# Installer only uses Python stdlib (json, shutil, pathlib) — no third-party deps.
if "$PYTHON" -c "import json, shutil, pathlib" 2>/dev/null; then
    ok "Python stdlib modules available"
else
    err "Python stdlib broken — reinstall Python"
    abort "Python stdlib missing"
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
    [ -n "${CCCTO_PROFILE:-}" ]   && SETUP_FLAGS="$SETUP_FLAGS --profile=$CCCTO_PROFILE"

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
