#!/usr/bin/env bash
# ClaudeCodeCTO Scanner
# Scans all submodule repos for skill/agent/command/hook/prompt files
# Detects conflicts (components with the same name)
# Writes results to the decisions/ directory

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/sources"
DECISIONS="$ROOT/decisions"
TIMESTAMP=$(date +%Y-%m-%d)
# For stripping absolute paths to relative
ROOT_PREFIX="$ROOT/"

mkdir -p "$DECISIONS"

# Convert absolute path to relative (from project root)
to_rel() {
    echo "${1#$ROOT_PREFIX}"
}
export ROOT_PREFIX
export -f to_rel 2>/dev/null || true

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== ClaudeCodeCTO Scanner ===${NC}"
echo -e "${BLUE}Date: $TIMESTAMP${NC}"
echo ""

# ============================================================
# 1. SKILLS SCAN
# ============================================================
echo -e "${GREEN}[1/5] Scanning skills...${NC}"

SKILLS_MAP="$DECISIONS/skills-map.tsv"
echo -e "skill_name\tsource_repo\tfile_path\tfile_size\tline_count" > "$SKILLS_MAP"

# Scan the skills directory in each repo
scan_skills() {
    local repo_name="$1"
    local repo_path="$SOURCES/$repo_name"

    # Find skills directory
    if [ -d "$repo_path/skills" ]; then
        for skill_dir in "$repo_path/skills"/*/; do
            [ -d "$skill_dir" ] || continue
            local skill_name=$(basename "$skill_dir")
            local skill_file=""

            # Find SKILL.md or main md file
            if [ -f "$skill_dir/SKILL.md" ]; then
                skill_file="$skill_dir/SKILL.md"
            elif [ -f "$skill_dir/README.md" ]; then
                skill_file="$skill_dir/README.md"
            else
                # Get first md file
                skill_file=$(find "$skill_dir" -maxdepth 1 -name "*.md" -type f 2>/dev/null | head -1)
            fi

            if [ -n "$skill_file" ] && [ -f "$skill_file" ]; then
                local fsize=$(wc -c < "$skill_file" 2>/dev/null || echo 0)
                local lcount=$(wc -l < "$skill_file" 2>/dev/null || echo 0)
                echo -e "${skill_name}\t${repo_name}\t$(to_rel "$skill_file")\t${fsize}\t${lcount}" >> "$SKILLS_MAP"
            fi
        done
    fi
}

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    scan_skills "$repo_name"
done

TOTAL_SKILLS=$(tail -n +2 "$SKILLS_MAP" | wc -l)
UNIQUE_SKILLS=$(tail -n +2 "$SKILLS_MAP" | cut -f1 | sort -u | wc -l)
CONFLICT_SKILLS=$(tail -n +2 "$SKILLS_MAP" | cut -f1 | sort | uniq -d | wc -l)

echo -e "  Total skill entries: ${TOTAL_SKILLS}"
echo -e "  Unique skill names: ${UNIQUE_SKILLS}"
echo -e "  ${RED}Conflicting skills (same name, different repo): ${CONFLICT_SKILLS}${NC}"

# ============================================================
# 2. AGENTS SCAN
# ============================================================
echo -e "${GREEN}[2/5] Scanning agents...${NC}"

AGENTS_MAP="$DECISIONS/agents-map.tsv"
echo -e "agent_name\tsource_repo\tfile_path\tfile_size\tline_count" > "$AGENTS_MAP"

scan_agents() {
    local repo_name="$1"
    local repo_path="$SOURCES/$repo_name"

    if [ -d "$repo_path/agents" ]; then
        # Direct md files
        find "$repo_path/agents" -name "*.md" -not -name "README.md" -type f 2>/dev/null | while read -r agent_file; do
            local agent_name=$(basename "$agent_file" .md)
            local fsize=$(wc -c < "$agent_file" 2>/dev/null || echo 0)
            local lcount=$(wc -l < "$agent_file" 2>/dev/null || echo 0)
            echo -e "${agent_name}\t${repo_name}\t$(to_rel "$agent_file")\t${fsize}\t${lcount}" >> "$AGENTS_MAP"
        done
    fi

    # VoltAgent categorized structure
    if [ -d "$repo_path/categories" ]; then
        find "$repo_path/categories" -name "*.md" -not -name "README.md" -type f 2>/dev/null | while read -r agent_file; do
            local agent_name=$(basename "$agent_file" .md)
            local fsize=$(wc -c < "$agent_file" 2>/dev/null || echo 0)
            local lcount=$(wc -l < "$agent_file" 2>/dev/null || echo 0)
            echo -e "${agent_name}\t${repo_name}\t$(to_rel "$agent_file")\t${fsize}\t${lcount}" >> "$AGENTS_MAP"
        done
    fi
}

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    scan_agents "$repo_name"
done

TOTAL_AGENTS=$(tail -n +2 "$AGENTS_MAP" | wc -l)
UNIQUE_AGENTS=$(tail -n +2 "$AGENTS_MAP" | cut -f1 | sort -u | wc -l)
CONFLICT_AGENTS=$(tail -n +2 "$AGENTS_MAP" | cut -f1 | sort | uniq -d | wc -l)

echo -e "  Total agent entries: ${TOTAL_AGENTS}"
echo -e "  Unique agent names: ${UNIQUE_AGENTS}"
echo -e "  ${RED}Conflicting agents (same name, different repo): ${CONFLICT_AGENTS}${NC}"

# ============================================================
# 3. COMMANDS SCAN
# ============================================================
echo -e "${GREEN}[3/5] Scanning commands...${NC}"

COMMANDS_MAP="$DECISIONS/commands-map.tsv"
echo -e "command_name\tsource_repo\tfile_path\tfile_size\tline_count" > "$COMMANDS_MAP"

scan_commands() {
    local repo_name="$1"
    local repo_path="$SOURCES/$repo_name"

    if [ -d "$repo_path/commands" ]; then
        find "$repo_path/commands" -name "*.md" -not -name "README.md" -type f 2>/dev/null | while read -r cmd_file; do
            local cmd_name=$(basename "$cmd_file" .md)
            local fsize=$(wc -c < "$cmd_file" 2>/dev/null || echo 0)
            local lcount=$(wc -l < "$cmd_file" 2>/dev/null || echo 0)
            echo -e "${cmd_name}\t${repo_name}\t$(to_rel "$cmd_file")\t${fsize}\t${lcount}" >> "$COMMANDS_MAP"
        done
    fi
}

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    scan_commands "$repo_name"
done

TOTAL_COMMANDS=$(tail -n +2 "$COMMANDS_MAP" | wc -l)
UNIQUE_COMMANDS=$(tail -n +2 "$COMMANDS_MAP" | cut -f1 | sort -u | wc -l)
CONFLICT_COMMANDS=$(tail -n +2 "$COMMANDS_MAP" | cut -f1 | sort | uniq -d | wc -l)

echo -e "  Total command entries: ${TOTAL_COMMANDS}"
echo -e "  Unique command names: ${UNIQUE_COMMANDS}"
echo -e "  ${RED}Conflicting commands (same name, different repo): ${CONFLICT_COMMANDS}${NC}"

# ============================================================
# 4. HOOKS SCAN
# ============================================================
echo -e "${GREEN}[4/5] Scanning hooks...${NC}"

HOOKS_MAP="$DECISIONS/hooks-map.tsv"
echo -e "hook_name\tsource_repo\tfile_path\tfile_size" > "$HOOKS_MAP"

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_path="$repo_dir"

    if [ -d "${repo_path}hooks" ]; then
        find "${repo_path}hooks" -type f 2>/dev/null | while read -r hook_file; do
            hook_name=$(basename "$hook_file")
            fsize=$(wc -c < "$hook_file" 2>/dev/null || echo 0)
            echo -e "${hook_name}\t${repo_name}\t$(to_rel "$hook_file")\t${fsize}" >> "$HOOKS_MAP"
        done
    fi
done

TOTAL_HOOKS=$(tail -n +2 "$HOOKS_MAP" | wc -l)
echo -e "  Total hook entries: ${TOTAL_HOOKS}"

# ============================================================
# 5. CONFLICT REPORT
# ============================================================
# Fix absolute paths in TSV files — convert to relative
for tsv_file in "$SKILLS_MAP" "$AGENTS_MAP" "$COMMANDS_MAP" "$HOOKS_MAP"; do
    if [ -f "$tsv_file" ]; then
        sed -i "s|${ROOT}/||g" "$tsv_file" 2>/dev/null || \
        sed -i '' "s|${ROOT}/||g" "$tsv_file" 2>/dev/null || true
    fi
done

echo -e "${GREEN}[5/5] Generating conflict report...${NC}"

CONFLICT_REPORT="$DECISIONS/conflicts-${TIMESTAMP}.md"
cat > "$CONFLICT_REPORT" << HEADER
# Conflict Report
> Date: $TIMESTAMP
> Scanned: $(ls -d "$SOURCES"/*/ 2>/dev/null | wc -l) repos

## Summary
| Category | Total | Unique | Conflicting |
|----------|-------|--------|-------------|
| Skills | $TOTAL_SKILLS | $UNIQUE_SKILLS | $CONFLICT_SKILLS |
| Agents | $TOTAL_AGENTS | $UNIQUE_AGENTS | $CONFLICT_AGENTS |
| Commands | $TOTAL_COMMANDS | $UNIQUE_COMMANDS | $CONFLICT_COMMANDS |
| Hooks | $TOTAL_HOOKS | - | - |

## Conflicting Skills (Same Name, Different Repo)

| Skill | Repo 1 | Size 1 | Repo 2 | Size 2 | Decision |
|-------|--------|--------|--------|--------|----------|
HEADER

# List skill conflicts
tail -n +2 "$SKILLS_MAP" | cut -f1 | sort | uniq -d | while read -r conflict_name; do
    entries=$(grep "^${conflict_name}	" "$SKILLS_MAP" | head -5)
    first_repo=$(echo "$entries" | head -1 | cut -f2)
    first_size=$(echo "$entries" | head -1 | cut -f4)
    second_repo=$(echo "$entries" | sed -n '2p' | cut -f2)
    second_size=$(echo "$entries" | sed -n '2p' | cut -f4)
    echo "| $conflict_name | $first_repo | ${first_size}B | $second_repo | ${second_size}B | **TBD** |" >> "$CONFLICT_REPORT"
done

cat >> "$CONFLICT_REPORT" << AGENTS_HEADER

## Conflicting Agents (Same Name, Different Repo)

| Agent | Repo 1 | Size 1 | Repo 2 | Size 2 | Decision |
|-------|--------|--------|--------|--------|----------|
AGENTS_HEADER

# List agent conflicts
tail -n +2 "$AGENTS_MAP" | cut -f1 | sort | uniq -d | while read -r conflict_name; do
    entries=$(grep "^${conflict_name}	" "$AGENTS_MAP" | head -5)
    first_repo=$(echo "$entries" | head -1 | cut -f2)
    first_size=$(echo "$entries" | head -1 | cut -f4)
    second_repo=$(echo "$entries" | sed -n '2p' | cut -f2)
    second_size=$(echo "$entries" | sed -n '2p' | cut -f4)
    echo "| $conflict_name | $first_repo | ${first_size}B | $second_repo | ${second_size}B | **TBD** |" >> "$CONFLICT_REPORT"
done

cat >> "$CONFLICT_REPORT" << CMDS_HEADER

## Conflicting Commands (Same Name, Different Repo)

| Command | Repo 1 | Size 1 | Repo 2 | Size 2 | Decision |
|---------|--------|--------|--------|--------|----------|
CMDS_HEADER

# List command conflicts
tail -n +2 "$COMMANDS_MAP" | cut -f1 | sort | uniq -d | while read -r conflict_name; do
    entries=$(grep "^${conflict_name}	" "$COMMANDS_MAP" | head -5)
    first_repo=$(echo "$entries" | head -1 | cut -f2)
    first_size=$(echo "$entries" | head -1 | cut -f4)
    second_repo=$(echo "$entries" | sed -n '2p' | cut -f2)
    second_size=$(echo "$entries" | sed -n '2p' | cut -f4)
    echo "| $conflict_name | $first_repo | ${first_size}B | $second_repo | ${second_size}B | **TBD** |" >> "$CONFLICT_REPORT"
done

echo ""
echo -e "${BLUE}=== Scan Complete ===${NC}"
echo -e "Results: $DECISIONS/"
echo -e "  - skills-map.tsv  ($TOTAL_SKILLS entries)"
echo -e "  - agents-map.tsv  ($TOTAL_AGENTS entries)"
echo -e "  - commands-map.tsv ($TOTAL_COMMANDS entries)"
echo -e "  - hooks-map.tsv   ($TOTAL_HOOKS entries)"
echo -e "  - conflicts-${TIMESTAMP}.md (conflict report)"
