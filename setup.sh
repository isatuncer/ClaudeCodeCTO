#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Setup v3.0
# Multi-OS installer for the best AI coding components
#
# Supports: macOS, Linux, Windows (Git Bash / WSL / MSYS2)
#
# Usage:
#   bash setup.sh              # Interactive mode
#   bash setup.sh --all        # Install everything
#   bash setup.sh --update     # Pull latest + re-scan + re-install
#   bash setup.sh --skills     # Skills only
#   bash setup.sh --agents     # Agents only
#   bash setup.sh --commands   # Commands only
#   bash setup.sh --hooks      # Hooks only
#   bash setup.sh --rules      # Rules only
#   bash setup.sh --prompts    # Prompt libraries only
#   bash setup.sh --dry-run    # Preview without installing
#   bash setup.sh --status     # Quick status check (from manifest)
#   bash setup.sh --backup     # Backup existing files first
#   bash setup.sh --uninstall  # Remove ALL installed components
#   bash setup.sh --uninstall skills  # Remove skills only
# ============================================================

set -uo pipefail

# ============================================================
# OS DETECTION
# ============================================================

detect_os() {
    case "$(uname -s)" in
        Darwin*)  OS="macos"   ;;
        Linux*)   OS="linux"   ;;
        CYGWIN*|MINGW*|MSYS*)  OS="windows" ;;
        *)        OS="unknown" ;;
    esac

    # WSL detection
    if [ "$OS" = "linux" ] && grep -qi microsoft /proc/version 2>/dev/null; then
        OS="wsl"
    fi
}

# ============================================================
# PATH RESOLUTION (Multi-OS)
# ============================================================

resolve_paths() {
    ROOT="$(cd "$(dirname "$0")" && pwd)"
    SOURCES="$ROOT/sources"
    DECISIONS="$ROOT/decisions"

    case "$OS" in
        windows)
            # Git Bash / MSYS2: convert to Windows-style if needed
            if [ -n "${USERPROFILE:-}" ]; then
                WIN_HOME=$(cygpath -u "$USERPROFILE" 2>/dev/null || echo "$HOME")
            else
                WIN_HOME="$HOME"
            fi
            CLAUDE_HOME="${CLAUDE_HOME:-$WIN_HOME/.claude}"
            ;;
        wsl)
            # WSL: check if Claude Code is installed in Windows side
            WIN_USER=$(cmd.exe /C "echo %USERPROFILE%" 2>/dev/null | tr -d '\r' || echo "")
            if [ -n "$WIN_USER" ] && [ -d "$(wslpath "$WIN_USER" 2>/dev/null)/.claude" ]; then
                CLAUDE_HOME="$(wslpath "$WIN_USER")/.claude"
                log_info "Detected Claude Code on Windows side: $CLAUDE_HOME"
            else
                CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
            fi
            ;;
        *)
            CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
            ;;
    esac

    SKILLS_DIR="$CLAUDE_HOME/skills"
    AGENTS_DIR="$CLAUDE_HOME/agents"
    COMMANDS_DIR="$CLAUDE_HOME/commands"
    HOOKS_DIR="$CLAUDE_HOME/hooks"
    RULES_DIR="$CLAUDE_HOME/rules"
    PROMPTS_DIR="$CLAUDE_HOME/prompts"
}

# ============================================================
# UI HELPERS
# ============================================================

# Colors (disable on dumb terminals)
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    CYAN='\033[0;36m'
    BOLD='\033[1m'
    DIM='\033[2m'
    NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' NC=''
fi

print_banner() {
    echo ""
    echo -e "${CYAN}  ╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║${NC}${BOLD}        ClaudeCodeCTO Setup v3.0            ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}  ║${NC}  Best AI coding components, one command install  ${CYAN}║${NC}"
    echo -e "${CYAN}  ╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
}

log_step()  { echo -e "\n${CYAN}━━━ $1 ━━━${NC}"; }
log_info()  { echo -e "  ${BLUE}ℹ${NC}  $1"; }
log_ok()    { echo -e "  ${GREEN}✓${NC}  $1"; }
log_warn()  { echo -e "  ${YELLOW}⚠${NC}  $1"; }
log_err()   { echo -e "  ${RED}✗${NC}  $1"; }
log_skip()  { echo -e "  ${DIM}⊘  $1 (better version exists)${NC}"; }

progress_bar() {
    local current=$1
    local total=$2
    local label=$3
    local pct=0
    [ "$total" -gt 0 ] && pct=$((current * 100 / total))
    local filled=$((pct / 5))
    local empty=$((20 - filled))
    printf "\r  ${BLUE}[${GREEN}%s${DIM}%s${BLUE}]${NC} %3d%%  %s" \
        "$(printf '█%.0s' $(seq 1 $filled 2>/dev/null) 2>/dev/null || echo "")" \
        "$(printf '░%.0s' $(seq 1 $empty 2>/dev/null) 2>/dev/null || echo "")" \
        "$pct" "$label"
}

# ============================================================
# PREREQUISITES CHECK
# ============================================================

check_prerequisites() {
    log_step "Step 1/8 — Checking prerequisites"

    # OS
    log_info "Operating system: ${BOLD}$OS${NC}"

    # Git
    if ! command -v git &>/dev/null; then
        log_err "Git is not installed. Please install git first."
        echo "  macOS:   brew install git"
        echo "  Linux:   sudo apt install git"
        echo "  Windows: https://git-scm.com/download/win"
        exit 1
    fi
    log_ok "Git $(git --version | cut -d' ' -f3)"

    # Claude Code directory
    if [ -d "$CLAUDE_HOME" ]; then
        log_ok "Claude Code directory found: $CLAUDE_HOME"
    else
        log_warn "Claude Code directory not found. Will create: $CLAUDE_HOME"
    fi

    # Disk space (rough check — need ~500MB for all sources)
    local free_mb=0
    case "$OS" in
        macos)  free_mb=$(df -m "$HOME" | tail -1 | awk '{print $4}') ;;
        linux|wsl) free_mb=$(df -m "$HOME" | tail -1 | awk '{print $4}') ;;
        windows) free_mb=$(df -m "$HOME" 2>/dev/null | tail -1 | awk '{print $4}' 2>/dev/null || echo 999999) ;;
    esac
    if [ "$free_mb" -lt 500 ] 2>/dev/null; then
        log_warn "Low disk space: ${free_mb}MB free (500MB recommended)"
    else
        log_ok "Disk space OK"
    fi
}

# ============================================================
# SUBMODULE INITIALIZATION
# ============================================================

init_submodules() {
    log_step "Step 2/8 — Initializing source repositories"

    cd "$ROOT"
    if [ ! -f ".gitmodules" ]; then
        log_err "No .gitmodules found. Clone with: git clone --recursive <repo-url>"
        exit 1
    fi

    local total=$(grep -c 'path = ' .gitmodules 2>/dev/null || echo 0)
    local current=0

    log_info "Initializing $total source repositories..."

    git submodule init 2>/dev/null || true
    git submodule update --init 2>&1 | while IFS= read -r line; do
        if echo "$line" | grep -q "Cloning into"; then
            current=$((current + 1))
            local repo_name=$(echo "$line" | sed "s/.*'//;s/'.*//" | xargs basename)
            progress_bar "$current" "$total" "$repo_name"
        fi
    done
    echo ""

    local ready=$(ls -d "$SOURCES"/*/ 2>/dev/null | wc -l)
    log_ok "$ready source repositories ready"
}

# ============================================================
# CONFLICT DETECTION
# ============================================================

should_install() {
    local component_type="$1"
    local component_name="$2"
    local source_repo="$3"
    local map_file="$DECISIONS/${component_type}-map.tsv"

    [ -f "$map_file" ] || return 0

    # Use grep with fixed string and tab delimiter; suppress errors
    local entries
    entries=$(grep -F "${component_name}	" "$map_file" 2>/dev/null | grep "^${component_name}	") || true

    # If no entries or single entry, install without conflict check
    [ -z "$entries" ] && return 0
    local entry_count
    entry_count=$(printf '%s\n' "$entries" | wc -l | tr -d '[:space:]')
    [ "$entry_count" -le 1 ] 2>/dev/null && return 0

    # Multiple entries = conflict. Pick best by file_size (column 4)
    local best_repo
    best_repo=$(printf '%s\n' "$entries" | sort -t$'\t' -k4 -nr | head -1 | cut -f2)

    [ "$best_repo" = "$source_repo" ] && return 0
    return 1
}

backup_existing() {
    local target="$1"
    if [ -e "$target" ] && [ "$BACKUP" = true ]; then
        local backup_path="${target}.bak.$(date +%Y%m%d-%H%M%S)"
        cp -r "$target" "$backup_path"
    fi
}

# ============================================================
# INSTALLATION FUNCTIONS
# ============================================================

setup_skills() {
    log_step "Step 3/8 — Installing Skills"
    log_info "Scanning 1,600+ skills from 4 sources, selecting the best version of each..."

    local SKILL_SOURCES=(
        "anthropics-skills"
        "everything-claude-code"
        "antigravity-awesome-skills"
        "rohitg00-toolkit"
    )

    # Count total first
    local total=0
    for repo in "${SKILL_SOURCES[@]}"; do
        local rp="$SOURCES/$repo"
        [ -d "$rp/skills" ] && total=$((total + $(find "$rp/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)))
    done

    local installed=0
    local skipped=0
    local current=0

    mkdir -p "$SKILLS_DIR"

    for repo in "${SKILL_SOURCES[@]}"; do
        local repo_path="$SOURCES/$repo"
        [ -d "$repo_path/skills" ] || continue

        for skill_dir in "$repo_path/skills"/*/; do
            [ -d "$skill_dir" ] || continue
            local skill_name=$(basename "$skill_dir")

            [[ "$skill_name" == "__pycache__" || "$skill_name" == "node_modules" || "$skill_name" == ".git" ]] && continue

            current=$((current + 1))
            progress_bar "$current" "$total" "$skill_name"

            if ! should_install "skills" "$skill_name" "$repo"; then
                skipped=$((skipped + 1))
                continue
            fi

            if [ "$DRY_RUN" = false ]; then
                local target="$SKILLS_DIR/$skill_name"
                backup_existing "$target"
                mkdir -p "$target"
                cp -r "$skill_dir"/* "$target/" 2>/dev/null || true
            fi
            installed=$((installed + 1))
        done
    done

    echo ""
    log_ok "Skills installed: ${GREEN}$installed${NC} | Skipped (conflict): ${DIM}$skipped${NC} | Total scanned: $current"
}

setup_agents() {
    log_step "Step 4/8 — Installing Agents"
    log_info "Scanning 348 agents from 4 sources, deduplicating to ~263 unique..."

    local AGENT_SOURCES=(
        "everything-claude-code"
        "voltagent-subagents"
        "rohitg00-toolkit"
        "alirezarezvani-claude-skills"
    )

    local installed=0
    local skipped=0
    mkdir -p "$AGENTS_DIR"

    for repo in "${AGENT_SOURCES[@]}"; do
        local repo_path="$SOURCES/$repo"

        # agents/ directory
        if [ -d "$repo_path/agents" ]; then
            find "$repo_path/agents" -name "*.md" -not -name "README.md" -type f 2>/dev/null | while IFS= read -r agent_file; do
                local agent_name=$(basename "$agent_file" .md)
                if should_install "agents" "$agent_name" "$repo"; then
                    if [ "$DRY_RUN" = false ]; then
                        backup_existing "$AGENTS_DIR/$agent_name.md"
                        cp "$agent_file" "$AGENTS_DIR/$agent_name.md" 2>/dev/null || true
                    fi
                    echo "installed" >> /tmp/cccto_agent_count 2>/dev/null
                else
                    echo "skipped" >> /tmp/cccto_agent_count 2>/dev/null
                fi
            done
        fi

        # categories/ directory (VoltAgent structure)
        if [ -d "$repo_path/categories" ]; then
            find "$repo_path/categories" -name "*.md" -not -name "README.md" -type f 2>/dev/null | while IFS= read -r agent_file; do
                local agent_name=$(basename "$agent_file" .md)
                if should_install "agents" "$agent_name" "$repo"; then
                    if [ "$DRY_RUN" = false ]; then
                        backup_existing "$AGENTS_DIR/$agent_name.md"
                        cp "$agent_file" "$AGENTS_DIR/$agent_name.md" 2>/dev/null || true
                    fi
                fi
            done
        fi
    done

    installed=$(ls "$AGENTS_DIR"/*.md 2>/dev/null | wc -l)
    rm -f /tmp/cccto_agent_count 2>/dev/null
    log_ok "Agents installed: ${GREEN}$installed${NC}"
}

setup_commands() {
    log_step "Step 5/8 — Installing Slash Commands"
    log_info "Installing slash commands + CTO management commands..."

    local CMD_SOURCES=(
        "everything-claude-code"
        "rohitg00-toolkit"
    )

    local installed=0
    mkdir -p "$COMMANDS_DIR"

    # Source repo commands
    for repo in "${CMD_SOURCES[@]}"; do
        local repo_path="$SOURCES/$repo"
        [ -d "$repo_path/commands" ] || continue

        find "$repo_path/commands" -name "*.md" -not -name "README.md" -type f 2>/dev/null | while IFS= read -r cmd_file; do
            local cmd_name=$(basename "$cmd_file" .md)
            if should_install "commands" "$cmd_name" "$repo"; then
                if [ "$DRY_RUN" = false ]; then
                    backup_existing "$COMMANDS_DIR/$cmd_name.md"
                    cp "$cmd_file" "$COMMANDS_DIR/$cmd_name.md" 2>/dev/null || true
                fi
            fi
        done
    done

    # ClaudeCodeCTO's own commands (always install — ours, no conflict)
    if [ -d "$ROOT/commands" ]; then
        local cto_cmd_count=0
        for cmd_file in "$ROOT/commands"/*.md; do
            [ -f "$cmd_file" ] || continue
            local cmd_name=$(basename "$cmd_file" .md)
            if [ "$DRY_RUN" = false ]; then
                backup_existing "$COMMANDS_DIR/$cmd_name.md"
                cp "$cmd_file" "$COMMANDS_DIR/$cmd_name.md" 2>/dev/null || true
            fi
            cto_cmd_count=$((cto_cmd_count + 1))
        done
        log_ok "CTO commands ($cto_cmd_count) installed: /startCTO, /doc-create, /cto-* etc."
    fi

    installed=$(ls "$COMMANDS_DIR"/*.md 2>/dev/null | wc -l)
    log_ok "Total commands installed: ${GREEN}$installed${NC}"
}

setup_hooks() {
    log_step "Step 6/8 — Installing Hooks"
    log_info "Installing hook scripts and configurations..."

    local HOOK_SOURCES=(
        "everything-claude-code"
        "continuous-claude-v3"
        "rohitg00-toolkit"
    )

    mkdir -p "$HOOKS_DIR"
    local installed=0

    for repo in "${HOOK_SOURCES[@]}"; do
        local repo_path="$SOURCES/$repo"
        [ -d "$repo_path/hooks" ] || continue

        if [ "$DRY_RUN" = false ]; then
            # Use cp -n (no-clobber) to avoid overwriting
            case "$OS" in
                macos) cp -Rn "$repo_path/hooks"/* "$HOOKS_DIR/" 2>/dev/null || true ;;
                *)     cp -rn "$repo_path/hooks"/* "$HOOKS_DIR/" 2>/dev/null || true ;;
            esac
        fi
        installed=$((installed + 1))
    done

    local hook_count=$(find "$HOOKS_DIR" -type f 2>/dev/null | wc -l)
    log_ok "Hooks installed: ${GREEN}$hook_count${NC} files from $installed sources"
}

setup_rules() {
    log_step "Step 7/8 — Installing Rules"
    log_info "Installing coding rules (13 languages) and IDE rules..."

    mkdir -p "$RULES_DIR"

    # Main rules from ECC
    local repo_path="$SOURCES/everything-claude-code"
    if [ -d "$repo_path/rules" ]; then
        if [ "$DRY_RUN" = false ]; then
            case "$OS" in
                macos) cp -Rn "$repo_path/rules"/* "$RULES_DIR/" 2>/dev/null || true ;;
                *)     cp -rn "$repo_path/rules"/* "$RULES_DIR/" 2>/dev/null || true ;;
            esac
        fi
        local rule_count=$(find "$RULES_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
        log_ok "Coding rules installed: ${GREEN}$rule_count${NC} files"
    fi

    # Cursor rules as reference
    local cursor_path="$SOURCES/awesome-cursorrules"
    if [ -d "$cursor_path" ]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$CLAUDE_HOME/references/cursor-rules"
            case "$OS" in
                macos) cp -Rn "$cursor_path/rules"/* "$CLAUDE_HOME/references/cursor-rules/" 2>/dev/null || true ;;
                *)     cp -rn "$cursor_path/rules"/* "$CLAUDE_HOME/references/cursor-rules/" 2>/dev/null || true ;;
            esac
        fi
        log_ok "Cursor rules installed as reference"
    fi
}

setup_prompts() {
    log_step "Step 8/8 — Installing Prompt Libraries"
    log_info "Installing 6800+ prompts from 5 sources..."

    mkdir -p "$PROMPTS_DIR"

    # 1. AI tool system prompts (S07)
    log_info "  [1/4] System prompts from 28+ AI tools..."
    local sys_prompts="$SOURCES/system-prompts-collection"
    if [ -d "$sys_prompts" ] && [ "$DRY_RUN" = false ]; then
        mkdir -p "$PROMPTS_DIR/system-prompts"
        find "$sys_prompts" -maxdepth 3 -name "*.md" -type f 2>/dev/null | head -200 | while IFS= read -r f; do
            cp "$f" "$PROMPTS_DIR/system-prompts/$(basename "$f")" 2>/dev/null || true
        done
        log_ok "System prompts installed"
    fi

    # 2. Claude Code internals (S09)
    log_info "  [2/4] Claude Code internal prompts..."
    local claude_prompts="$SOURCES/piebald-claude-prompts"
    if [ -d "$claude_prompts" ] && [ "$DRY_RUN" = false ]; then
        mkdir -p "$PROMPTS_DIR/claude-code-internals"
        cp "$claude_prompts"/*.md "$PROMPTS_DIR/claude-code-internals/" 2>/dev/null || true
        log_ok "Claude Code internals installed"
    fi

    # 3. AI coding tool prompts (S08)
    log_info "  [3/4] AI coding tool prompts..."
    local eli_prompts="$SOURCES/elifuzz-system-prompts"
    if [ -d "$eli_prompts" ] && [ "$DRY_RUN" = false ]; then
        mkdir -p "$PROMPTS_DIR/coding-tool-prompts"
        case "$OS" in
            macos) cp -Rn "$eli_prompts"/* "$PROMPTS_DIR/coding-tool-prompts/" 2>/dev/null || true ;;
            *)     cp -rn "$eli_prompts"/* "$PROMPTS_DIR/coding-tool-prompts/" 2>/dev/null || true ;;
        esac
        log_ok "Coding tool prompts installed"
    fi

    # 4. Prompt Engineering Guide (S13)
    log_info "  [4/4] Prompt Engineering Guide..."
    local pe_guide="$SOURCES/prompt-engineering-guide"
    if [ -d "$pe_guide" ] && [ "$DRY_RUN" = false ]; then
        mkdir -p "$PROMPTS_DIR/prompt-engineering-guide"
        find "$pe_guide" -maxdepth 2 -name "*.md" -type f 2>/dev/null | head -50 | while IFS= read -r f; do
            cp "$f" "$PROMPTS_DIR/prompt-engineering-guide/$(basename "$f")" 2>/dev/null || true
        done
        log_ok "Prompt Engineering Guide installed"
    fi

    local total_prompts=$(find "$PROMPTS_DIR" -type f 2>/dev/null | wc -l)
    log_ok "Total prompt files installed: ${GREEN}$total_prompts${NC}"
}

# ============================================================
# ENTERPRISE COMPONENTS
# ============================================================

setup_enterprise() {
    log_step "Step 9/10 — Installing Enterprise Components"
    log_info "Installing CTO-level project delivery system..."

    local ENT_SRC="$ROOT/enterprise"
    local ENT_DST="$CLAUDE_HOME/enterprise"

    if [ ! -d "$ENT_SRC" ]; then
        log_warn "Enterprise directory not found. Skipping."
        return
    fi

    mkdir -p "$ENT_DST"

    # 1. Templates (69 document templates)
    log_info "  [1/6] Document templates (69 types across 14 categories)..."
    if [ "$DRY_RUN" = false ]; then
        case "$OS" in
            macos) cp -Rn "$ENT_SRC/templates" "$ENT_DST/" 2>/dev/null || true ;;
            *)     cp -rn "$ENT_SRC/templates" "$ENT_DST/" 2>/dev/null || true ;;
        esac
    fi
    local tpl_count=$(find "$ENT_DST/templates" -name "*.md" -type f 2>/dev/null | wc -l)
    log_ok "Templates: $tpl_count files"

    # 2. Mermaid Diagrams (30 templates)
    log_info "  [2/6] Mermaid diagram templates (30 diagrams)..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$ENT_DST/diagrams"
        cp "$ENT_SRC/diagrams"/*.mmd "$ENT_DST/diagrams/" 2>/dev/null || true
        cp "$ENT_SRC/diagrams"/*.md "$ENT_DST/diagrams/" 2>/dev/null || true
    fi
    local diag_count=$(find "$ENT_DST/diagrams" -name "*.mmd" -type f 2>/dev/null | wc -l)
    log_ok "Diagrams: $diag_count templates"

    # 3. Enterprise Standards (72 standards)
    log_info "  [3/6] Enterprise standards (72 — ISO, IEEE, NIST, OWASP)..."
    if [ "$DRY_RUN" = false ]; then
        case "$OS" in
            macos) cp -Rn "$ENT_SRC/standards" "$ENT_DST/" 2>/dev/null || true ;;
            *)     cp -rn "$ENT_SRC/standards" "$ENT_DST/" 2>/dev/null || true ;;
        esac
    fi
    local std_count=$(find "$ENT_DST/standards" -name "*.md" -type f 2>/dev/null | wc -l)
    log_ok "Standards: $std_count files"

    # 4. Role Definitions (20 enterprise roles)
    log_info "  [4/6] Enterprise roles (20 — CTO, Architect, QA, DevSecOps...)..."
    if [ "$DRY_RUN" = false ]; then
        case "$OS" in
            macos) cp -Rn "$ENT_SRC/roles" "$ENT_DST/" 2>/dev/null || true ;;
            *)     cp -rn "$ENT_SRC/roles" "$ENT_DST/" 2>/dev/null || true ;;
        esac
    fi
    local role_count=$(find "$ENT_DST/roles" -name "*.md" -type f 2>/dev/null | wc -l)
    log_ok "Roles: $role_count definitions"

    # 5. GitHub Actions (3 workflows)
    log_info "  [5/6] GitHub Actions (CI, Deploy, Security Scan)..."
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$ENT_DST/github-actions"
        cp "$ENT_SRC/github-actions"/*.yml "$ENT_DST/github-actions/" 2>/dev/null || true
    fi
    local ga_count=$(find "$ENT_DST/github-actions" -name "*.yml" -type f 2>/dev/null | wc -l)
    log_ok "GitHub Actions: $ga_count workflows"

    # 6. CTO CLAUDE.md (operating instructions)
    log_info "  [6/6] CTO operating instructions..."
    if [ "$DRY_RUN" = false ] && [ -f "$ENT_SRC/CLAUDE.md" ]; then
        cp "$ENT_SRC/CLAUDE.md" "$ENT_DST/CTO_INSTRUCTIONS.md" 2>/dev/null || true
        log_ok "CTO instructions installed"
    fi

    # Install doc-generator skill
    if [ "$DRY_RUN" = false ] && [ -d "$ROOT/skills/doc-generator" ]; then
        mkdir -p "$SKILLS_DIR/doc-generator"
        cp -r "$ROOT/skills/doc-generator"/* "$SKILLS_DIR/doc-generator/" 2>/dev/null || true
        log_ok "Document generator skill installed"
    fi

    # Install doc-export script
    if [ "$DRY_RUN" = false ] && [ -f "$ROOT/scripts/doc-export.sh" ]; then
        mkdir -p "$CLAUDE_HOME/scripts"
        cp "$ROOT/scripts/doc-export.sh" "$CLAUDE_HOME/scripts/" 2>/dev/null || true
        log_ok "Document export script installed"
    fi
}

# ============================================================
# PROMPT SUGGESTIONS SYSTEM
# ============================================================

install_prompt_suggester() {
    log_info "Installing prompt suggestion system..."

    local SUGGESTER_DIR="$CLAUDE_HOME/skills/cto-prompt-suggester"
    mkdir -p "$SUGGESTER_DIR"

    cat > "$SUGGESTER_DIR/SKILL.md" << 'SKILLEOF'
---
description: "Suggest optimal prompts for any task based on 6800+ curated prompt patterns. Activated when user asks for help, starts a new task, or types /suggest."
---

# CTO Prompt Suggester

You have access to a curated library of 6800+ prompts from the world's best AI coding repositories. Use this knowledge to suggest optimal prompts when the user needs help.

## When to Activate

- User asks "how should I prompt this?" or "what's the best way to ask for X?"
- User starts a complex task and could benefit from a structured prompt
- User types `/suggest` or asks for prompt suggestions
- User is struggling with getting good results from a generic request

## Prompt Categories Available

### Development Workflows
- **Code Generation**: Structured prompts for writing new code with context, constraints, and examples
- **Code Review**: Multi-perspective review prompts (security, performance, maintainability)
- **Debugging**: Systematic debugging prompts with hypothesis-driven investigation
- **Refactoring**: Safe refactoring prompts with before/after validation
- **Testing**: TDD-oriented prompts with coverage targets and edge cases

### Architecture & Design
- **System Design**: Prompts for designing scalable systems with trade-off analysis
- **API Design**: REST/GraphQL API design prompts with contract-first approach
- **Database Design**: Schema design prompts with normalization and indexing consideration
- **Migration Planning**: Zero-downtime migration prompts

### AI & Prompt Engineering
- **Chain-of-Thought**: Step-by-step reasoning prompts for complex problems
- **Few-Shot**: Prompts with examples for pattern matching tasks
- **Role-Based**: Expert persona prompts for domain-specific tasks
- **Structured Output**: Prompts that guarantee JSON/structured responses

### Project Management
- **PRD Generation**: Product requirements document prompts
- **Task Breakdown**: Work decomposition prompts
- **Risk Assessment**: Prompts for identifying and mitigating risks

## How to Suggest

When suggesting a prompt, follow this format:

1. **Understand the user's intent** — What are they trying to accomplish?
2. **Match to category** — Which prompt pattern fits best?
3. **Customize** — Adapt the template to their specific context
4. **Present options** — Offer 2-3 variations (concise, detailed, expert-level)

## Example Suggestions

### When user says: "I need to add authentication to my app"

Suggest:
```
I need to implement [JWT/OAuth2/session-based] authentication for a [framework] app.

Current stack: [list technologies]
Requirements:
- [login/register/password reset/2FA]
- [role-based access control needs]
- [session duration/refresh token strategy]

Please:
1. Design the auth flow (diagram or step-by-step)
2. Implement with security best practices (OWASP Top 10)
3. Include tests for auth edge cases (expired tokens, invalid credentials, CSRF)
4. Add rate limiting on auth endpoints
```

### When user says: "Review this code"

Suggest:
```
Review this code with these lenses (report findings per lens):

1. **Security**: OWASP Top 10, injection, auth bypass, secrets exposure
2. **Performance**: N+1 queries, unnecessary allocations, missing caching
3. **Maintainability**: Naming, function length (<50 lines), coupling
4. **Edge Cases**: Null handling, empty collections, concurrent access
5. **Testing**: What's untested? What test would catch the most bugs?

Severity: CRITICAL (blocks merge) | HIGH (should fix) | MEDIUM (consider) | LOW (nice to have)
```

### When user says: "Help me debug this error"

Suggest:
```
I'm seeing this error: [paste error]

Context:
- File: [path]
- What I changed recently: [description]
- What I already tried: [list]
- This worked before when: [context]

Please:
1. Form 3 hypotheses for the root cause, ranked by likelihood
2. For the top hypothesis, suggest a diagnostic step (not a fix)
3. After confirming the cause, suggest the minimal fix
4. Explain why this happened to prevent recurrence
```

## Prompt Enhancement Tips

Always suggest the user include:
- **Context**: What exists now, what changed
- **Constraints**: Technology limits, time limits, backwards compatibility
- **Examples**: What good output looks like
- **Anti-examples**: What to avoid
- **Verification**: How to know the result is correct
SKILLEOF

    log_ok "Prompt suggester skill installed"
}

# ============================================================
# POST-INSTALL SUMMARY
# ============================================================

# ============================================================
# MANIFEST & STATUS — Track what's installed
# ============================================================

MANIFEST="${CLAUDE_HOME:-$HOME/.claude}/.cto-manifest.tsv"

# Fast status from manifest (no scanning)
show_status() {
    print_banner

    if [ ! -f "$MANIFEST" ]; then
        log_warn "No manifest found. Run 'bash setup.sh --all' to install first."
        return
    fi

    local updated=$(head -2 "$MANIFEST" | grep "Updated:" | sed 's/.*Updated: //')

    echo -e "  ${BOLD}Installed Components${NC} ${DIM}(last install: $updated)${NC}"
    echo ""

    while IFS=$'\t' read -r category count path; do
        [[ "$category" == "#"* ]] && continue
        [[ "$category" == "category" ]] && continue
        printf "  ${GREEN}%-14s${NC} ${BOLD}%s${NC}\n" "$category" "$count"
    done < "$MANIFEST"

    # Prompt breakdown (live count, fast)
    echo ""
    echo -e "  ${BOLD}Prompt Breakdown:${NC}"
    for pdir in "$PROMPTS_DIR"/*/; do
        [ -d "$pdir" ] || continue
        local pname=$(basename "$pdir")
        local pcount=$(find "$pdir" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
        printf "    ${DIM}%-30s${NC} %s files\n" "$pname" "$pcount"
    done

    echo ""
    echo -e "  ${BOLD}Source Repos:${NC} $(ls -d "$ROOT/sources"/*/ 2>/dev/null | wc -l | tr -d '[:space:]') tracked"
    echo -e "  ${BOLD}Target:${NC} $CLAUDE_HOME"
    echo ""
    echo -e "  ${DIM}Run 'bash setup.sh --update' to pull latest and re-install${NC}"
    echo ""
}

write_manifest() {
    local skills_count=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')
    local agents_count=$(find "$AGENTS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
    local commands_count=$(find "$COMMANDS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
    local hooks_count=$(find "$HOOKS_DIR" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local rules_count=$(find "$RULES_DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local prompts_count=$(find "$PROMPTS_DIR" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local templates_count=$(find "$CLAUDE_HOME/enterprise/templates" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local diagrams_count=$(find "$CLAUDE_HOME/enterprise/diagrams" -name "*.mmd" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local standards_count=$(find "$CLAUDE_HOME/enterprise/standards" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local roles_count=$(find "$CLAUDE_HOME/enterprise/roles" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local ga_count=$(find "$CLAUDE_HOME/enterprise/github-actions" -name "*.yml" -type f 2>/dev/null | wc -l | tr -d '[:space:]')

    cat > "$MANIFEST" << MEOF
# ClaudeCodeCTO Manifest — auto-generated, do not edit
# Updated: $(date +%Y-%m-%d_%H:%M:%S)
category	count	path
skills	$skills_count	$SKILLS_DIR
agents	$agents_count	$AGENTS_DIR
commands	$commands_count	$COMMANDS_DIR
hooks	$hooks_count	$HOOKS_DIR
rules	$rules_count	$RULES_DIR
prompts	$prompts_count	$PROMPTS_DIR
templates	$templates_count	$CLAUDE_HOME/enterprise/templates
diagrams	$diagrams_count	$CLAUDE_HOME/enterprise/diagrams
standards	$standards_count	$CLAUDE_HOME/enterprise/standards
roles	$roles_count	$CLAUDE_HOME/enterprise/roles
github-actions	$ga_count	$CLAUDE_HOME/enterprise/github-actions
MEOF
}

show_summary() {
    # Read counts from live filesystem
    local skills_count=$(find "$SKILLS_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d '[:space:]')
    local agents_count=$(find "$AGENTS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
    local commands_count=$(find "$COMMANDS_DIR" -name "*.md" 2>/dev/null | wc -l | tr -d '[:space:]')
    local hooks_count=$(find "$HOOKS_DIR" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local rules_count=$(find "$RULES_DIR" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local prompts_count=$(find "$PROMPTS_DIR" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local templates_count=$(find "$CLAUDE_HOME/enterprise/templates" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local diagrams_count=$(find "$CLAUDE_HOME/enterprise/diagrams" -name "*.mmd" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local standards_count=$(find "$CLAUDE_HOME/enterprise/standards" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local roles_count=$(find "$CLAUDE_HOME/enterprise/roles" -name "*.md" -type f 2>/dev/null | wc -l | tr -d '[:space:]')

    # Prompt breakdown
    local p_system=$(find "$PROMPTS_DIR/system-prompts" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local p_claude=$(find "$PROMPTS_DIR/claude-code-internals" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local p_coding=$(find "$PROMPTS_DIR/coding-tool-prompts" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
    local p_guide=$(find "$PROMPTS_DIR/prompt-engineering-guide" -type f 2>/dev/null | wc -l | tr -d '[:space:]')

    echo ""
    echo -e "${CYAN}╔════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}${BOLD}             Installation Complete!                 ${NC}${CYAN}║${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Skills${NC}      ${BOLD}$(printf '%-6s' "$skills_count")${NC}  ${DIM}coding patterns${NC}                ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Agents${NC}      ${BOLD}$(printf '%-6s' "$agents_count")${NC}  ${DIM}specialized agents${NC}             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Commands${NC}    ${BOLD}$(printf '%-6s' "$commands_count")${NC}  ${DIM}slash commands${NC}                 ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Hooks${NC}       ${BOLD}$(printf '%-6s' "$hooks_count")${NC}  ${DIM}auto-format, auto-test${NC}          ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Rules${NC}       ${BOLD}$(printf '%-6s' "$rules_count")${NC}  ${DIM}coding standards${NC}               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Prompts${NC}     ${BOLD}$(printf '%-6s' "$prompts_count")${NC}  ${DIM}system: $p_system  claude: $p_claude  tools: $p_coding  guide: $p_guide${NC}"
    echo -e "${CYAN}║${NC}                                                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${BOLD}Enterprise:${NC}                                        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Templates${NC}   ${BOLD}$(printf '%-6s' "$templates_count")${NC}  ${DIM}document templates${NC}             ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Diagrams${NC}    ${BOLD}$(printf '%-6s' "$diagrams_count")${NC}  ${DIM}Mermaid templates${NC}              ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Standards${NC}   ${BOLD}$(printf '%-6s' "$standards_count")${NC}  ${DIM}ISO, IEEE, NIST, OWASP${NC}        ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}Roles${NC}       ${BOLD}$(printf '%-6s' "$roles_count")${NC}  ${DIM}CTO to DevSecOps${NC}               ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}                                                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  Target: ${DIM}$CLAUDE_HOME${NC}"
    echo -e "${CYAN}║${NC}  OS:     ${DIM}$OS${NC}"
    echo -e "${CYAN}╠════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}/startCTO${NC}       Launch CTO mode                    ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}/doc-create${NC}     Generate enterprise documents       ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}/cto-sync${NC}       Daily sync + GitHub discovery       ${CYAN}║${NC}"
    echo -e "${CYAN}║${NC}  ${GREEN}/cto-status${NC}     System dashboard                    ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Write manifest
    write_manifest
}

# ============================================================
# SELF-UPDATE — Pull repo first, re-exec if setup.sh changed
# ============================================================

self_update_and_run() {
    local ROOT
    ROOT="$(cd "$(dirname "$0")" && pwd)"

    # Colors (minimal, just for this bootstrap phase)
    local CYAN='\033[0;36m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
    local BOLD='\033[1m' NC='\033[0m'

    echo ""
    echo -e "${CYAN}━━━ ClaudeCodeCTO Self-Update ━━━${NC}"

    cd "$ROOT"

    # Save current setup.sh hash
    local OLD_HASH
    OLD_HASH=$(git hash-object setup.sh 2>/dev/null || echo "none")

    # Pull latest
    echo -e "  Pulling latest from GitHub..."
    git pull --ff-only origin main 2>/dev/null || git pull origin main 2>/dev/null || {
        echo -e "  ${YELLOW}⚠${NC}  Could not pull. Continuing with local version."
    }

    # Check if setup.sh changed
    local NEW_HASH
    NEW_HASH=$(git hash-object setup.sh 2>/dev/null || echo "none")

    if [ "$OLD_HASH" != "$NEW_HASH" ] && [ "$OLD_HASH" != "none" ]; then
        echo -e "  ${GREEN}✓${NC}  setup.sh updated — restarting with new version..."
        echo ""
        # Re-exec the NEW setup.sh with --update-continue (skip self-update loop)
        exec bash "$ROOT/setup.sh" --update-continue
    fi

    echo -e "  ${GREEN}✓${NC}  Already on latest version"
    echo ""

    # Continue with update
    detect_os
    resolve_paths
    do_update
}

# ============================================================
# UPDATE — Pull latest sources + re-scan + re-install
# ============================================================

do_update() {
    print_banner
    log_step "Updating ClaudeCodeCTO"

    # 1. Update all submodules (pull latest from each source)
    log_info "[1/4] Updating source repositories..."
    local UPDATED=0
    local TOTAL=0
    for repo_dir in "$SOURCES"/*/; do
        [ -d "$repo_dir/.git" ] || [ -f "$repo_dir/.git" ] || continue
        TOTAL=$((TOTAL + 1))
        local repo_name
        repo_name=$(basename "$repo_dir")

        cd "$repo_dir"
        local OLD_COMMIT
        OLD_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

        git fetch origin 2>/dev/null || true
        local DEFAULT_BRANCH
        DEFAULT_BRANCH=$(git remote show origin 2>/dev/null | grep "HEAD branch" | awk '{print $NF}' 2>/dev/null || echo "main")
        git checkout "$DEFAULT_BRANCH" 2>/dev/null || true
        git pull origin "$DEFAULT_BRANCH" 2>/dev/null || true

        local NEW_COMMIT
        NEW_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

        if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
            local CHANGES
            CHANGES=$(git log --oneline "$OLD_COMMIT".."$NEW_COMMIT" 2>/dev/null | wc -l | tr -d '[:space:]')
            log_ok "$repo_name: $CHANGES new commits"
            UPDATED=$((UPDATED + 1))
        fi
        cd "$ROOT"
    done
    log_ok "Sources checked: $TOTAL | Updated: $UPDATED"

    # 2. Re-scan for new/changed components and conflicts
    log_info "[2/4] Re-scanning components and conflicts..."
    if [ -f "$ROOT/scripts/scanner.sh" ]; then
        bash "$ROOT/scripts/scanner.sh" 2>/dev/null || true
        log_ok "Scan complete"
    else
        log_warn "Scanner script not found, skipping scan"
    fi

    # 3. Re-install everything with backup
    log_info "[3/4] Re-installing all components (with backup)..."
    BACKUP=true
    INSTALL_ALL=true
    DRY_RUN=false

    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$COMMANDS_DIR" "$HOOKS_DIR" "$RULES_DIR" "$PROMPTS_DIR"

    setup_skills
    setup_agents
    setup_commands
    setup_hooks
    setup_rules
    setup_prompts
    setup_enterprise
    install_prompt_suggester

    # 4. Summary
    log_step "[4/4] Update complete!"
    echo ""
    echo -e "  ${GREEN}What happened:${NC}"
    echo -e "    1. ClaudeCodeCTO repo pulled to latest (self-update)"
    echo -e "    2. All source repos updated from GitHub"
    echo -e "    3. Components re-scanned for conflicts"
    echo -e "    4. Best versions re-installed (old files backed up with .bak)"
    echo ""
    echo -e "  ${CYAN}Run 'bash setup.sh --all' for a clean reinstall without backup.${NC}"
    echo ""

    show_summary
}

# ============================================================
# UNINSTALL
# ============================================================

uninstall() {
    local target="${1:-all}"

    detect_os
    resolve_paths

    if [ "$target" = "all" ]; then
        log_step "Uninstalling ALL ClaudeCodeCTO components"
        echo -e "  ${YELLOW}This will remove everything installed by ClaudeCodeCTO.${NC}"
    else
        log_step "Uninstalling: $target"
    fi

    echo ""
    read -p "  Continue? [y/N]: " confirm
    [[ ! "$confirm" =~ ^[Yy]$ ]] && { echo "  Cancelled."; exit 0; }
    echo ""

    local removed=0

    do_remove() {
        local category="$1" target_dir="$2" pattern="${3:-}"
        if [ -d "$target_dir" ]; then
            local count
            if [ -n "$pattern" ]; then
                count=$(find "$target_dir" -name "$pattern" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
                find "$target_dir" -name "$pattern" -type f -delete 2>/dev/null || true
            else
                count=$(find "$target_dir" -type f 2>/dev/null | wc -l | tr -d '[:space:]')
                rm -rf "$target_dir" 2>/dev/null || true
            fi
            log_ok "$category: $count files removed"
            removed=$((removed + count))
        else
            echo -e "  ${DIM}-  $category: not installed${NC}"
        fi
    }

    case "$target" in
        skills|all)
            do_remove "Skills" "$SKILLS_DIR" ;;
        agents|all)
            do_remove "Agents" "$AGENTS_DIR" "*.md" ;;
        commands|all)
            do_remove "Commands" "$COMMANDS_DIR" "*.md" ;;
        hooks|all)
            do_remove "Hooks" "$HOOKS_DIR" ;;
        rules|all)
            do_remove "Rules" "$RULES_DIR" ;;
        prompts|all)
            do_remove "Prompts" "$PROMPTS_DIR" ;;
        enterprise|all)
            do_remove "Enterprise" "$CLAUDE_HOME/enterprise" ;;
        *) log_err "Unknown category: $target"
           echo "  Valid: skills, agents, commands, hooks, rules, prompts, enterprise, all"
           exit 1 ;;
    esac

    # If uninstalling all, also clean up extras
    if [ "$target" = "all" ]; then
        rm -rf "$CLAUDE_HOME/references/cursor-rules" 2>/dev/null
        rm -f "$CLAUDE_HOME/.cto-manifest.tsv" 2>/dev/null
        rm -rf "$CLAUDE_HOME/scripts" 2>/dev/null
        log_ok "References and manifest cleaned"
    fi

    # Update manifest if partial uninstall
    if [ "$target" != "all" ] && [ -d "$CLAUDE_HOME" ]; then
        write_manifest 2>/dev/null || true
    fi

    echo ""
    log_ok "Uninstall complete. $removed files removed."
}

# ============================================================
# INTERACTIVE MENU
# ============================================================

interactive_menu() {
    print_banner

    echo -e "  ${BOLD}What would you like to install?${NC}"
    echo ""
    echo -e "  ${GREEN}1)${NC} Everything (recommended)"
    echo -e "  ${BLUE}2)${NC} Skills only"
    echo -e "  ${BLUE}3)${NC} Agents only"
    echo -e "  ${BLUE}4)${NC} Commands only"
    echo -e "  ${BLUE}5)${NC} Hooks only"
    echo -e "  ${BLUE}6)${NC} Rules only"
    echo -e "  ${BLUE}7)${NC} Prompt libraries only"
    echo -e "  ${YELLOW}8)${NC} Update (pull latest + re-scan + re-install)"
    echo -e "  ${YELLOW}9)${NC} Dry-run (preview without installing)"
    echo -e "  ${RED}10)${NC} Uninstall"
    echo -e "  ${DIM}0)${NC} Exit"
    echo ""
    read -p "  Your choice [0-10]: " choice

    case $choice in
        1) INSTALL_ALL=true ;;
        2) INSTALL_SKILLS=true ;;
        3) INSTALL_AGENTS=true ;;
        4) INSTALL_COMMANDS=true ;;
        5) INSTALL_HOOKS=true ;;
        6) INSTALL_RULES=true ;;
        7) INSTALL_PROMPTS=true ;;
        8) self_update_and_run; exit 0 ;;
        9) DRY_RUN=true; INSTALL_ALL=true ;;
        10) uninstall; exit 0 ;;
        0) exit 0 ;;
        *) log_err "Invalid choice"; exit 1 ;;
    esac

    echo ""
    read -p "  Backup existing files before installing? [y/N]: " backup_choice
    [[ "$backup_choice" =~ ^[Yy]$ ]] && BACKUP=true
}

# ============================================================
# ARGUMENT PARSING
# ============================================================

# Flags
DRY_RUN=false
BACKUP=false
INSTALL_SKILLS=false
INSTALL_AGENTS=false
INSTALL_COMMANDS=false
INSTALL_HOOKS=false
INSTALL_RULES=false
INSTALL_PROMPTS=false
INSTALL_ALL=false
INTERACTIVE=true

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all)       INSTALL_ALL=true; INTERACTIVE=false ;;
            --skills)    INSTALL_SKILLS=true; INTERACTIVE=false ;;
            --agents)    INSTALL_AGENTS=true; INTERACTIVE=false ;;
            --commands)  INSTALL_COMMANDS=true; INTERACTIVE=false ;;
            --hooks)     INSTALL_HOOKS=true; INTERACTIVE=false ;;
            --rules)     INSTALL_RULES=true; INTERACTIVE=false ;;
            --prompts)   INSTALL_PROMPTS=true; INTERACTIVE=false ;;
            --dry-run)   DRY_RUN=true ;;
            --backup)    BACKUP=true ;;
            --update)    self_update_and_run; exit 0 ;;
            --update-continue) detect_os; resolve_paths; do_update; exit 0 ;;
            --uninstall)
                shift
                uninstall "${1:-all}"; exit 0 ;;
            --status) detect_os; resolve_paths; show_status; exit 0 ;;
            --help|-h)
                echo "Usage: bash setup.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --all        Install all components"
                echo "  --update     Pull latest + re-scan + re-install (self-updating)"
                echo "  --status     Show installed component counts (fast, from manifest)"
                echo "  --skills     Install skills only"
                echo "  --agents     Install agents only"
                echo "  --commands   Install slash commands only"
                echo "  --hooks      Install hooks only"
                echo "  --rules      Install rules only"
                echo "  --prompts    Install prompt libraries only"
                echo "  --dry-run    Preview what will be installed"
                echo "  --backup     Backup existing files before overwriting"
                echo "  --uninstall [category]  Remove components (all/skills/agents/commands/"
                echo "                          hooks/rules/prompts/enterprise)"
                echo "  --help       Show this help"
                echo ""
                echo "Examples:"
                echo "  bash setup.sh --all              # Full install"
                echo "  bash setup.sh --update           # Update everything"
                echo "  bash setup.sh --status           # Quick status check"
                echo "  bash setup.sh --uninstall        # Remove everything"
                echo "  bash setup.sh --uninstall skills  # Remove skills only"
                exit 0
                ;;
            *)
                log_err "Unknown argument: $1"
                echo "Run 'bash setup.sh --help' for usage."
                exit 1
                ;;
        esac
        shift
    done
}

# ============================================================
# MAIN
# ============================================================

main() {
    detect_os
    parse_args "$@"
    resolve_paths

    if [ "$INTERACTIVE" = true ]; then
        interactive_menu
    else
        print_banner
    fi

    if [ "$DRY_RUN" = true ]; then
        echo -e "  ${YELLOW}▶ DRY RUN — Nothing will be installed${NC}"
        echo ""
    fi

    # Step 1: Prerequisites
    check_prerequisites

    # Step 2: Submodules
    init_submodules

    # Run scanner if first time
    if [ ! -f "$DECISIONS/skills-map.tsv" ]; then
        log_step "Running first-time scan for conflict detection..."
        bash "$ROOT/scripts/scanner.sh" 2>/dev/null || true
    fi

    # Create target directories
    mkdir -p "$SKILLS_DIR" "$AGENTS_DIR" "$COMMANDS_DIR" "$HOOKS_DIR" "$RULES_DIR" "$PROMPTS_DIR"

    # Steps 3-8: Install
    if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_SKILLS" = true ]; then
        setup_skills
    fi

    if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_AGENTS" = true ]; then
        setup_agents
    fi

    if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_COMMANDS" = true ]; then
        setup_commands
    fi

    if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_HOOKS" = true ]; then
        setup_hooks
    fi

    if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_RULES" = true ]; then
        setup_rules
    fi

    if [ "$INSTALL_ALL" = true ] || [ "$INSTALL_PROMPTS" = true ]; then
        setup_prompts
    fi

    # Step 9: Enterprise components (always with --all)
    if [ "$INSTALL_ALL" = true ]; then
        setup_enterprise
    fi

    # Step 10: Prompt suggester (always with --all)
    if [ "$INSTALL_ALL" = true ] && [ "$DRY_RUN" = false ]; then
        install_prompt_suggester
    fi

    # Summary
    if [ "$DRY_RUN" = true ]; then
        echo ""
        echo -e "  ${YELLOW}▶ DRY RUN complete. Run without --dry-run to install.${NC}"
        echo ""
    else
        show_summary
    fi
}

main "$@"
