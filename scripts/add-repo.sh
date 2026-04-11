#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO — Repo Management Tool
#
# Usage:
#   bash scripts/add-repo.sh <github-url-or-owner/repo> [alias]
#
# Examples:
#   bash scripts/add-repo.sh https://github.com/user/repo
#   bash scripts/add-repo.sh user/repo
#   bash scripts/add-repo.sh user/repo my-custom-name
#   bash scripts/add-repo.sh --list          # List existing repos
#   bash scripts/add-repo.sh --remove <alias> # Remove a repo
#   bash scripts/add-repo.sh --scan <alias>  # Scan a single repo
# ============================================================

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/sources"
REGISTRY="$ROOT/decisions/repo-registry.tsv"
CATALOG="$ROOT/catalog/02-github-repos-catalog.md"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Create registry file if it doesn't exist
init_registry() {
    if [ ! -f "$REGISTRY" ]; then
        echo -e "alias\tgithub_url\tadded_date\tstatus\tskills\tagents\tcommands\tnotes" > "$REGISTRY"
        # Add existing submodules
        for dir in "$SOURCES"/*/; do
            [ -d "$dir" ] || continue
            local alias=$(basename "$dir")
            local url=$(cd "$dir" && git remote get-url origin 2>/dev/null || echo "unknown")
            echo -e "${alias}\t${url}\t2026-04-09\tactive\t-\t-\t-\tinitial" >> "$REGISTRY"
        done
        echo -e "${GREEN}Registry created: $REGISTRY${NC}"
    fi
}

# List existing repos
list_repos() {
    init_registry
    echo -e "${CYAN}=== Registered Repos ===${NC}"
    echo ""
    printf "%-35s %-50s %-12s %-8s\n" "ALIAS" "URL" "ADDED" "STATUS"
    printf "%-35s %-50s %-12s %-8s\n" "-----" "---" "-----" "------"
    tail -n +2 "$REGISTRY" | while IFS=$'\t' read -r alias url date status skills agents commands notes; do
        printf "%-35s %-50s %-12s %-8s\n" "$alias" "$url" "$date" "$status"
    done
    echo ""
    echo -e "Total: $(tail -n +2 "$REGISTRY" | wc -l) repos"
}

# Normalize GitHub URL
normalize_url() {
    local input="$1"
    # owner/repo format
    if [[ "$input" =~ ^[a-zA-Z0-9_-]+/[a-zA-Z0-9_.-]+$ ]]; then
        echo "https://github.com/$input.git"
    # https://github.com/owner/repo or https://github.com/owner/repo.git
    elif [[ "$input" =~ ^https://github.com/ ]]; then
        if [[ "$input" == *.git ]]; then
            echo "$input"
        else
            echo "${input%.git}.git"
        fi
    else
        echo ""
    fi
}

# Extract repo name from URL
extract_name() {
    local url="$1"
    basename "$url" .git
}

# Extract owner/repo from URL
extract_owner_repo() {
    local url="$1"
    echo "$url" | sed 's|https://github.com/||;s|\.git$||'
}

# Language check — reject non-English repos
check_language() {
    local repo_path="$1"
    local readme="$repo_path/README.md"

    if [ ! -f "$readme" ]; then
        return 0  # Skip if no README
    fi

    # Check for CJK characters, Arabic, Cyrillic, etc. (first 100 lines)
    local non_english_lines=$(head -100 "$readme" | grep -cP '[\p{Han}\p{Hangul}\p{Hiragana}\p{Katakana}\p{Cyrillic}\p{Arabic}]' 2>/dev/null || echo 0)
    local total_lines=$(head -100 "$readme" | wc -l)

    if [ "$total_lines" -gt 0 ]; then
        local ratio=$((non_english_lines * 100 / total_lines))
        if [ "$ratio" -gt 30 ]; then
            return 1  # More than 30% non-English lines
        fi
    fi

    return 0
}

# Quick scan of repo content
quick_scan() {
    local repo_path="$1"
    local skills=0 agents=0 commands=0

    [ -d "$repo_path/skills" ] && skills=$(find "$repo_path/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
    [ -d "$repo_path/agents" ] && agents=$(find "$repo_path/agents" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l)
    [ -d "$repo_path/commands" ] && commands=$(find "$repo_path/commands" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l)

    # categories/ structure (VoltAgent style)
    if [ -d "$repo_path/categories" ]; then
        local cat_agents=$(find "$repo_path/categories" -name "*.md" -not -name "README.md" 2>/dev/null | wc -l)
        agents=$((agents + cat_agents))
    fi

    echo "$skills $agents $commands"
}

# Add a new repo
add_repo() {
    local input="$1"
    local alias="${2:-}"

    # Normalize URL
    local url=$(normalize_url "$input")
    if [ -z "$url" ]; then
        echo -e "${RED}Invalid URL or owner/repo format: $input${NC}"
        echo "Usage: bash scripts/add-repo.sh owner/repo [alias]"
        exit 1
    fi

    # Determine alias
    if [ -z "$alias" ]; then
        alias=$(extract_name "$url")
    fi

    local repo_path="$SOURCES/$alias"

    # Check if it already exists
    if [ -d "$repo_path" ]; then
        echo -e "${YELLOW}This repo already exists: $alias${NC}"
        echo "Try with a different alias: bash scripts/add-repo.sh $input my-alias"
        exit 1
    fi

    echo -e "${BLUE}=== Adding Repo ===${NC}"
    echo -e "URL:   $url"
    echo -e "Alias: $alias"
    echo ""

    # Add as submodule
    echo -e "${BLUE}[1/4] Cloning...${NC}"
    cd "$ROOT"
    if ! git submodule add "$url" "sources/$alias" 2>&1; then
        echo -e "${RED}Cloning failed. Check the URL.${NC}"
        exit 1
    fi

    # Language check
    echo -e "${BLUE}[2/4] Language check...${NC}"
    if ! check_language "$repo_path"; then
        echo -e "${RED}REJECTED: This repo is not primarily in English.${NC}"
        echo -e "${YELLOW}Only English repos are accepted.${NC}"
        # Revert the submodule
        git submodule deinit -f "sources/$alias" 2>/dev/null || true
        git rm -f "sources/$alias" 2>/dev/null || true
        rm -rf ".git/modules/sources/$alias" 2>/dev/null || true
        exit 1
    fi
    echo -e "${GREEN}OK — English content verified${NC}"

    # Content scan
    echo -e "${BLUE}[3/4] Scanning content...${NC}"
    read -r skills agents commands <<< $(quick_scan "$repo_path")
    echo -e "  Skills: $skills | Agents: $agents | Commands: $commands"

    if [ "$skills" -eq 0 ] && [ "$agents" -eq 0 ] && [ "$commands" -eq 0 ]; then
        echo -e "${YELLOW}WARNING: No skills, agents, or commands found in this repo.${NC}"
        echo -e "${YELLOW}Repo was still added — it may contain prompts or rules.${NC}"
    fi

    # Add to registry
    echo -e "${BLUE}[4/4] Updating registry...${NC}"
    init_registry
    local owner_repo=$(extract_owner_repo "$url")
    local today=$(date +%Y-%m-%d)
    echo -e "${alias}\t${url}\t${today}\tactive\t${skills}\t${agents}\t${commands}\tuser-added" >> "$REGISTRY"

    # Add to catalog
    echo "" >> "$CATALOG"
    echo "| NEW | $owner_repo | - | User-added ($today) |" >> "$CATALOG"

    echo ""
    echo -e "${GREEN}=== Repo added successfully ===${NC}"
    echo -e "Alias: ${CYAN}$alias${NC}"
    echo -e "Skills: $skills | Agents: $agents | Commands: $commands"
    echo ""
    echo -e "To scan: ${CYAN}bash scripts/scanner.sh${NC}"
    echo -e "To install: ${CYAN}bash setup.sh --all${NC}"
}

# Remove a repo
remove_repo() {
    local alias="$1"
    local repo_path="$SOURCES/$alias"

    if [ ! -d "$repo_path" ]; then
        echo -e "${RED}Repo not found: $alias${NC}"
        echo "To see existing repos: bash scripts/add-repo.sh --list"
        exit 1
    fi

    echo -e "${YELLOW}Removing: $alias${NC}"

    cd "$ROOT"
    git submodule deinit -f "sources/$alias" 2>/dev/null || true
    git rm -f "sources/$alias" 2>/dev/null || true
    rm -rf ".git/modules/sources/$alias" 2>/dev/null || true

    # Update registry (set status to inactive)
    if [ -f "$REGISTRY" ]; then
        sed -i "s/^${alias}\t\(.*\)\tactive/\0\tremoved/" "$REGISTRY" 2>/dev/null || true
    fi

    echo -e "${GREEN}Repo removed: $alias${NC}"
}

# Scan a single repo
scan_single() {
    local alias="$1"
    local repo_path="$SOURCES/$alias"

    if [ ! -d "$repo_path" ]; then
        echo -e "${RED}Repo not found: $alias${NC}"
        exit 1
    fi

    echo -e "${BLUE}=== Scanning: $alias ===${NC}"
    read -r skills agents commands <<< $(quick_scan "$repo_path")
    echo -e "Skills: $skills | Agents: $agents | Commands: $commands"

    if [ "$skills" -gt 0 ]; then
        echo -e "\n${CYAN}Skills:${NC}"
        find "$repo_path/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while read -r d; do
            echo "  - $(basename "$d")"
        done
    fi

    if [ "$agents" -gt 0 ]; then
        echo -e "\n${CYAN}Agents:${NC}"
        find "$repo_path/agents" "$repo_path/categories" -name "*.md" -not -name "README.md" 2>/dev/null | while read -r f; do
            echo "  - $(basename "$f" .md)"
        done
    fi

    if [ "$commands" -gt 0 ]; then
        echo -e "\n${CYAN}Commands:${NC}"
        find "$repo_path/commands" -name "*.md" -not -name "README.md" 2>/dev/null | while read -r f; do
            echo "  - $(basename "$f" .md)"
        done
    fi
}

# ============================================================
# MAIN FLOW
# ============================================================

if [ $# -eq 0 ]; then
    echo "Usage:"
    echo "  bash scripts/add-repo.sh <owner/repo>       — Add a new repo"
    echo "  bash scripts/add-repo.sh <owner/repo> alias  — Add with alias"
    echo "  bash scripts/add-repo.sh --list              — List repos"
    echo "  bash scripts/add-repo.sh --remove <alias>    — Remove a repo"
    echo "  bash scripts/add-repo.sh --scan <alias>      — Scan a single repo"
    exit 0
fi

case "$1" in
    --list|-l)
        list_repos
        ;;
    --remove|-r)
        [ $# -lt 2 ] && { echo "Usage: --remove <alias>"; exit 1; }
        remove_repo "$2"
        ;;
    --scan|-s)
        [ $# -lt 2 ] && { echo "Usage: --scan <alias>"; exit 1; }
        scan_single "$2"
        ;;
    --help|-h)
        echo "ClaudeCodeCTO — Repo Management Tool"
        echo ""
        echo "Usage:"
        echo "  bash scripts/add-repo.sh <owner/repo>        Add a new repo"
        echo "  bash scripts/add-repo.sh <github-url> alias   Add with alias"
        echo "  bash scripts/add-repo.sh --list               List existing repos"
        echo "  bash scripts/add-repo.sh --remove <alias>     Remove a repo"
        echo "  bash scripts/add-repo.sh --scan <alias>       Scan a single repo"
        echo ""
        echo "Rules:"
        echo "  - Only English repos are accepted"
        echo "  - Repos are added as submodules (updated via git submodule update)"
        echo "  - Conflicts are detected automatically (scanner.sh)"
        ;;
    *)
        init_registry
        add_repo "$1" "${2:-}"
        ;;
esac
