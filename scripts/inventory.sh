#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Inventory v2.0
# Full inventory of ALL skills, agents, commands, hooks, and
# prompts across every source repo.
#
# Output: decisions/inventory-{type}-{YYYY-MM-DD}.tsv
# Columns: #, name, repo, path, sha256_12, file_size, line_count
#
# Usage: bash scripts/inventory.sh
# ============================================================

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/sources"
DECISIONS="$ROOT/decisions"
TIMESTAMP=$(date +%Y-%m-%d)

mkdir -p "$DECISIONS"

# ── Colors ────────────────────────────────────────────────
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' CYAN='' BOLD='' DIM='' NC=''
fi

# ── Helpers ───────────────────────────────────────────────
# Convert absolute path to clean relative (from SOURCES)
to_rel() {
    local p="${1#$SOURCES/}"
    # normalize: remove trailing slashes in path components
    p=$(echo "$p" | sed 's|/\+|/|g')
    echo "$p"
}

# Fast SHA: use md5sum (faster) with 12-char prefix
file_sha() {
    if command -v md5sum &>/dev/null; then
        md5sum "$1" 2>/dev/null | cut -c1-12
    elif command -v md5 &>/dev/null; then
        md5 -q "$1" 2>/dev/null | cut -c1-12
    else
        echo "------------"
    fi
}

# Write a row: expects global $ROW_NUM and $OUT_FILE
# Usage: write_row "name" "repo" "filepath"
write_row() {
    local name="$1" repo="$2" filepath="$3"
    local fsize lcount sha rel_path

    fsize=$(wc -c < "$filepath" 2>/dev/null | tr -d '[:space:]')
    lcount=$(wc -l < "$filepath" 2>/dev/null | tr -d '[:space:]')
    sha=$(file_sha "$filepath")
    rel_path=$(to_rel "$filepath")

    printf '%d\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$ROW_NUM" "$name" "$repo" "$rel_path" "$sha" "$fsize" "$lcount" >> "$OUT_FILE"
    ROW_NUM=$((ROW_NUM + 1))
}

# Write a prompt row (extra columns: category, extension)
write_prompt_row() {
    local name="$1" repo="$2" category="$3" filepath="$4" ext="$5"
    local fsize lcount sha rel_path

    fsize=$(wc -c < "$filepath" 2>/dev/null | tr -d '[:space:]')
    lcount=$(wc -l < "$filepath" 2>/dev/null | tr -d '[:space:]')
    sha=$(file_sha "$filepath")
    rel_path=$(to_rel "$filepath")

    printf '%d\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$ROW_NUM" "$name" "$repo" "$category" "$rel_path" "$sha" "$fsize" "$lcount" "$ext" >> "$OUT_FILE"
    ROW_NUM=$((ROW_NUM + 1))
}

# ── Banner ────────────────────────────────────────────────
echo ""
echo -e "${CYAN}  ==============================================${NC}"
echo -e "${BOLD}   ClaudeCodeCTO Inventory v2.0${NC}"
echo -e "   ${DIM}$TIMESTAMP${NC}"
echo -e "${CYAN}  ==============================================${NC}"
echo ""

TOTAL_SKILLS=0 TOTAL_AGENTS=0 TOTAL_COMMANDS=0 TOTAL_HOOKS=0 TOTAL_PROMPTS=0

# ============================================================
# 1. SKILLS
# ============================================================
echo -e "${CYAN}━━━ [1/5] Skills ━━━${NC}"

OUT_FILE="$DECISIONS/inventory-skills-${TIMESTAMP}.tsv"
printf '#\tskill_name\trepo\tpath\tsha256_12\tfile_size\tline_count\n' > "$OUT_FILE"
ROW_NUM=1

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    [ -d "${repo_dir}skills" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_count=0

    for skill_dir in "${repo_dir}skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")

        # Priority: SKILL.md > README.md > first *.md
        skill_file=""
        if [ -f "${skill_dir}SKILL.md" ]; then
            skill_file="${skill_dir}SKILL.md"
        elif [ -f "${skill_dir}README.md" ]; then
            skill_file="${skill_dir}README.md"
        else
            skill_file=$(find "$skill_dir" -maxdepth 1 -name "*.md" -type f 2>/dev/null | head -1)
        fi

        if [ -n "$skill_file" ] && [ -f "$skill_file" ]; then
            write_row "$skill_name" "$repo_name" "$skill_file"
            repo_count=$((repo_count + 1))
        fi
    done

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count"
    TOTAL_SKILLS=$((TOTAL_SKILLS + repo_count))
done

UNIQUE_SKILLS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort -u | wc -l | tr -d '[:space:]')
CONFLICT_SKILLS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort | uniq -d | wc -l | tr -d '[:space:]')
echo -e "  ${BOLD}→ $TOTAL_SKILLS total, ${GREEN}$UNIQUE_SKILLS unique${NC}, ${RED}$CONFLICT_SKILLS conflicts${NC}\n"

# ============================================================
# 2. AGENTS
# ============================================================
echo -e "${CYAN}━━━ [2/5] Agents ━━━${NC}"

OUT_FILE="$DECISIONS/inventory-agents-${TIMESTAMP}.tsv"
printf '#\tagent_name\trepo\tpath\tsha256_12\tfile_size\tline_count\n' > "$OUT_FILE"
ROW_NUM=1

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_count=0

    for agent_dir in "${repo_dir}agents" "${repo_dir}categories"; do
        [ -d "$agent_dir" ] || continue

        while IFS= read -r agent_file; do
            agent_name=$(basename "$agent_file" .md)
            write_row "$agent_name" "$repo_name" "$agent_file"
            repo_count=$((repo_count + 1))
        done < <(find "$agent_dir" -name "*.md" \
            -not -name "README.md" -not -name "CLAUDE.md" \
            -not -name "CONTRIBUTING.md" -type f 2>/dev/null | sort)
    done

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count"
    TOTAL_AGENTS=$((TOTAL_AGENTS + repo_count))
done

UNIQUE_AGENTS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort -u | wc -l | tr -d '[:space:]')
CONFLICT_AGENTS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort | uniq -d | wc -l | tr -d '[:space:]')
echo -e "  ${BOLD}→ $TOTAL_AGENTS total, ${GREEN}$UNIQUE_AGENTS unique${NC}, ${RED}$CONFLICT_AGENTS conflicts${NC}\n"

# ============================================================
# 3. COMMANDS
# ============================================================
echo -e "${CYAN}━━━ [3/5] Commands ━━━${NC}"

OUT_FILE="$DECISIONS/inventory-commands-${TIMESTAMP}.tsv"
printf '#\tcommand_name\trepo\tpath\tsha256_12\tfile_size\tline_count\n' > "$OUT_FILE"
ROW_NUM=1

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_count=0

    for cmd_dir in "${repo_dir}commands" "${repo_dir}.claude/commands"; do
        [ -d "$cmd_dir" ] || continue

        while IFS= read -r cmd_file; do
            cmd_name=$(basename "$cmd_file" .md)
            write_row "$cmd_name" "$repo_name" "$cmd_file"
            repo_count=$((repo_count + 1))
        done < <(find "$cmd_dir" -name "*.md" -not -name "README.md" -type f 2>/dev/null | sort)
    done

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count"
    TOTAL_COMMANDS=$((TOTAL_COMMANDS + repo_count))
done

UNIQUE_COMMANDS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort -u | wc -l | tr -d '[:space:]')
CONFLICT_COMMANDS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort | uniq -d | wc -l | tr -d '[:space:]')
echo -e "  ${BOLD}→ $TOTAL_COMMANDS total, ${GREEN}$UNIQUE_COMMANDS unique${NC}, ${RED}$CONFLICT_COMMANDS conflicts${NC}\n"

# ============================================================
# 4. HOOKS
# ============================================================
echo -e "${CYAN}━━━ [4/5] Hooks ━━━${NC}"

OUT_FILE="$DECISIONS/inventory-hooks-${TIMESTAMP}.tsv"
printf '#\thook_name\trepo\tpath\tsha256_12\tfile_size\tline_count\n' > "$OUT_FILE"
ROW_NUM=1

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_count=0

    if [ -d "${repo_dir}hooks" ]; then
        while IFS= read -r hook_file; do
            hook_name=$(basename "$hook_file")
            write_row "$hook_name" "$repo_name" "$hook_file"
            repo_count=$((repo_count + 1))
        done < <(find "${repo_dir}hooks" -type f -not -name "README.md" 2>/dev/null | sort)
    fi

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count"
    TOTAL_HOOKS=$((TOTAL_HOOKS + repo_count))
done

echo -e "  ${BOLD}→ ${GREEN}$TOTAL_HOOKS hooks${NC}\n"

# ============================================================
# 5. PROMPTS — every individual file
# ============================================================
echo -e "${CYAN}━━━ [5/5] Prompts ━━━${NC}"

OUT_FILE="$DECISIONS/inventory-prompts-${TIMESTAMP}.tsv"
printf '#\tprompt_name\trepo\tcategory\tpath\tsha256_12\tfile_size\tline_count\textension\n' > "$OUT_FILE"
ROW_NUM=1

# repo_name:search_dir:category
PROMPT_DEFS=(
    "system-prompts-collection:.:system-prompts"
    "piebald-claude-prompts:system-prompts:claude-internals"
    "piebald-claude-prompts:tools:claude-tools"
    "elifuzz-system-prompts:docs:coding-tools"
    "elifuzz-system-prompts:leaks:leaked-prompts"
    "prompt-engineering-guide:guides:education"
    "awesome-chatgpt-prompts:.:general"
)

for entry in "${PROMPT_DEFS[@]}"; do
    IFS=':' read -r repo_name search_dir category <<< "$entry"
    repo_path="$SOURCES/$repo_name"

    if [ ! -d "$repo_path" ]; then
        echo -e "  ${DIM}-  $repo_name: not cloned${NC}"
        continue
    fi

    search_path="$repo_path"
    [ "$search_dir" != "." ] && search_path="$repo_path/$search_dir"

    if [ ! -d "$search_path" ]; then
        echo -e "  ${DIM}-  $repo_name/$search_dir: not found${NC}"
        continue
    fi

    repo_count=0

    while IFS= read -r prompt_file; do
        case "$prompt_file" in
            */.git/*|*/node_modules/*|*/assets/*|*/.github/*) continue ;;
        esac

        filename=$(basename "$prompt_file")
        extension="${filename##*.}"
        prompt_name="${filename%.*}"

        case "$filename" in
            README.md|CLAUDE.md|CONTRIBUTING.md|LICENSE.md|CHANGELOG.md|\
            CODE_OF_CONDUCT.md|GOVERNANCE.md|OWNERS.md|\
            package.json|package-lock.json|pnpm-lock.yaml) continue ;;
        esac

        write_prompt_row "$prompt_name" "$repo_name" "$category" "$prompt_file" "$extension"
        repo_count=$((repo_count + 1))
    done < <(find "$search_path" -type f \( \
        -name "*.md" -o -name "*.txt" -o -name "*.yaml" -o -name "*.yml" \
        -o -name "*.json" -o -name "*.mdx" \) 2>/dev/null | sort)

    echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC} ${DIM}($search_dir)${NC}: $repo_count"
    TOTAL_PROMPTS=$((TOTAL_PROMPTS + repo_count))
done

UNIQUE_PROMPTS=$(tail -n +2 "$OUT_FILE" | cut -f2 | sort -u | wc -l | tr -d '[:space:]')
echo -e "  ${BOLD}→ ${GREEN}$TOTAL_PROMPTS prompt files${NC}, $UNIQUE_PROMPTS unique\n"

# ============================================================
# SUMMARY
# ============================================================
GRAND=$((TOTAL_SKILLS + TOTAL_AGENTS + TOTAL_COMMANDS + TOTAL_HOOKS + TOTAL_PROMPTS))

echo -e "${CYAN}  ==============================================${NC}"
echo -e "${BOLD}   Inventory Complete${NC}"
echo -e "${CYAN}  ==============================================${NC}"
echo ""
echo -e "  Skills:   ${GREEN}${TOTAL_SKILLS}${NC} (${UNIQUE_SKILLS} unique, ${CONFLICT_SKILLS} conflicts)"
echo -e "  Agents:   ${GREEN}${TOTAL_AGENTS}${NC} (${UNIQUE_AGENTS} unique, ${CONFLICT_AGENTS} conflicts)"
echo -e "  Commands: ${GREEN}${TOTAL_COMMANDS}${NC} (${UNIQUE_COMMANDS} unique, ${CONFLICT_COMMANDS} conflicts)"
echo -e "  Hooks:    ${GREEN}${TOTAL_HOOKS}${NC}"
echo -e "  Prompts:  ${GREEN}${TOTAL_PROMPTS}${NC} (${UNIQUE_PROMPTS} unique)"
echo -e "  ${BOLD}─────────────────────────────────${NC}"
echo -e "  ${BOLD}Grand Total: ${GREEN}${GRAND}${NC}"
echo ""
echo -e "  ${DIM}Files created:${NC}"
echo -e "    inventory-skills-${TIMESTAMP}.tsv"
echo -e "    inventory-agents-${TIMESTAMP}.tsv"
echo -e "    inventory-commands-${TIMESTAMP}.tsv"
echo -e "    inventory-hooks-${TIMESTAMP}.tsv"
echo -e "    inventory-prompts-${TIMESTAMP}.tsv"
echo ""
echo -e "${CYAN}  ==============================================${NC}"
echo ""
