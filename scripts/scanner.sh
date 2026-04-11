#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Scanner v2.0
# Scans all submodule repos for skill/agent/command/hook files.
# Shows live progress per repo, compares with previous maps,
# detects new/removed components, and generates conflict report.
# ============================================================

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/sources"
DECISIONS="$ROOT/decisions"
TIMESTAMP=$(date +%Y-%m-%d)
ROOT_PREFIX="$ROOT/"

mkdir -p "$DECISIONS"

to_rel() { echo "${1#$ROOT_PREFIX}"; }

# Colors
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'
    DIM='\033[2m'; NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' NC=''
fi

# ============================================================
# SAVE PREVIOUS MAPS (for diff)
# ============================================================
PREV_SKILLS="" PREV_AGENTS="" PREV_COMMANDS="" PREV_HOOKS=""

if [ -f "$DECISIONS/skills-map.tsv" ]; then
    PREV_SKILLS=$(tail -n +2 "$DECISIONS/skills-map.tsv" | cut -f1 | sort -u)
fi
if [ -f "$DECISIONS/agents-map.tsv" ]; then
    PREV_AGENTS=$(tail -n +2 "$DECISIONS/agents-map.tsv" | cut -f1 | sort -u)
fi
if [ -f "$DECISIONS/commands-map.tsv" ]; then
    PREV_COMMANDS=$(tail -n +2 "$DECISIONS/commands-map.tsv" | cut -f1 | sort -u)
fi
if [ -f "$DECISIONS/hooks-map.tsv" ]; then
    PREV_HOOKS=$(tail -n +2 "$DECISIONS/hooks-map.tsv" | cut -f1 | sort -u)
fi

PREV_SKILL_COUNT=0 PREV_AGENT_COUNT=0 PREV_CMD_COUNT=0 PREV_HOOK_COUNT=0
[ -n "$PREV_SKILLS" ] && PREV_SKILL_COUNT=$(echo "$PREV_SKILLS" | wc -l | tr -d '[:space:]')
[ -n "$PREV_AGENTS" ] && PREV_AGENT_COUNT=$(echo "$PREV_AGENTS" | wc -l | tr -d '[:space:]')
[ -n "$PREV_COMMANDS" ] && PREV_CMD_COUNT=$(echo "$PREV_COMMANDS" | wc -l | tr -d '[:space:]')
[ -n "$PREV_HOOKS" ] && PREV_HOOK_COUNT=$(echo "$PREV_HOOKS" | wc -l | tr -d '[:space:]')

echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}${BOLD}       ClaudeCodeCTO Scanner v2.0            ${NC}${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  ${DIM}$TIMESTAMP${NC}                                   ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════╝${NC}"
echo ""

if [ "$PREV_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
    echo -e "  ${DIM}Previous scan: ${PREV_SKILL_COUNT} skills, ${PREV_AGENT_COUNT} agents, ${PREV_CMD_COUNT} commands, ${PREV_HOOK_COUNT} hooks${NC}"
    echo ""
fi

# ============================================================
# 1. SKILLS SCAN
# ============================================================
echo -e "${CYAN}━━━ [1/5] Scanning skills ━━━${NC}"

SKILLS_MAP="$DECISIONS/skills-map.tsv"
echo -e "skill_name\tsource_repo\tfile_path\tfile_size\tline_count" > "$SKILLS_MAP"

SKILL_REPOS=("anthropics-skills" "everything-claude-code" "antigravity-awesome-skills" "rohitg00-toolkit")

for repo_name in "${SKILL_REPOS[@]}"; do
    repo_path="$SOURCES/$repo_name"
    [ -d "$repo_path/skills" ] || continue

    repo_count=0
    for skill_dir in "$repo_path/skills"/*/; do
        [ -d "$skill_dir" ] || continue
        skill_name=$(basename "$skill_dir")
        skill_file=""

        if [ -f "$skill_dir/SKILL.md" ]; then
            skill_file="$skill_dir/SKILL.md"
        elif [ -f "$skill_dir/README.md" ]; then
            skill_file="$skill_dir/README.md"
        else
            skill_file=$(find "$skill_dir" -maxdepth 1 -name "*.md" -type f 2>/dev/null | head -1)
        fi

        if [ -n "$skill_file" ] && [ -f "$skill_file" ]; then
            fsize=$(wc -c < "$skill_file" 2>/dev/null | tr -d '[:space:]')
            lcount=$(wc -l < "$skill_file" 2>/dev/null | tr -d '[:space:]')
            echo -e "${skill_name}\t${repo_name}\t$(to_rel "$skill_file")\t${fsize}\t${lcount}" >> "$SKILLS_MAP"
            repo_count=$((repo_count + 1))
        fi
    done
    echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count skills"
done

TOTAL_SKILLS=$(tail -n +2 "$SKILLS_MAP" | wc -l | tr -d '[:space:]')
UNIQUE_SKILLS=$(tail -n +2 "$SKILLS_MAP" | cut -f1 | sort -u | wc -l | tr -d '[:space:]')
CONFLICT_SKILLS=$(tail -n +2 "$SKILLS_MAP" | cut -f1 | sort | uniq -d | wc -l | tr -d '[:space:]')

# Diff with previous
NEW_SKILLS="" REMOVED_SKILLS=""
if [ -n "$PREV_SKILLS" ]; then
    CURR_SKILL_NAMES=$(tail -n +2 "$SKILLS_MAP" | cut -f1 | sort -u)
    NEW_SKILLS=$(comm -13 <(echo "$PREV_SKILLS") <(echo "$CURR_SKILL_NAMES") 2>/dev/null || true)
    REMOVED_SKILLS=$(comm -23 <(echo "$PREV_SKILLS") <(echo "$CURR_SKILL_NAMES") 2>/dev/null || true)
fi

NEW_SKILL_COUNT=0 REMOVED_SKILL_COUNT=0
[ -n "$NEW_SKILLS" ] && NEW_SKILL_COUNT=$(echo "$NEW_SKILLS" | grep -c . 2>/dev/null || echo 0)
[ -n "$REMOVED_SKILLS" ] && REMOVED_SKILL_COUNT=$(echo "$REMOVED_SKILLS" | grep -c . 2>/dev/null || echo 0)

echo ""
echo -e "  ${BOLD}Total:${NC} $TOTAL_SKILLS entries → ${GREEN}$UNIQUE_SKILLS unique${NC} (${RED}$CONFLICT_SKILLS conflicts${NC})"
if [ "$NEW_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
    echo -e "  ${GREEN}+ $NEW_SKILL_COUNT new skills${NC}"
    echo "$NEW_SKILLS" | head -5 | while read -r s; do
        [ -z "$s" ] && continue
        src=$(grep "^${s}	" "$SKILLS_MAP" | head -1 | cut -f2)
        echo -e "    ${GREEN}+${NC} $s ${DIM}($src)${NC}"
    done
    [ "$NEW_SKILL_COUNT" -gt 5 ] && echo -e "    ${DIM}... and $((NEW_SKILL_COUNT - 5)) more${NC}"
fi
if [ "$REMOVED_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
    echo -e "  ${RED}- $REMOVED_SKILL_COUNT removed skills${NC}"
fi
if [ "$PREV_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
    DIFF=$((UNIQUE_SKILLS - PREV_SKILL_COUNT))
    if [ "$DIFF" -gt 0 ]; then
        echo -e "  ${DIM}Change: $PREV_SKILL_COUNT → $UNIQUE_SKILLS (+$DIFF)${NC}"
    elif [ "$DIFF" -lt 0 ]; then
        echo -e "  ${DIM}Change: $PREV_SKILL_COUNT → $UNIQUE_SKILLS ($DIFF)${NC}"
    else
        echo -e "  ${DIM}No change from previous scan${NC}"
    fi
fi
echo ""

# ============================================================
# 2. AGENTS SCAN
# ============================================================
echo -e "${CYAN}━━━ [2/5] Scanning agents ━━━${NC}"

AGENTS_MAP="$DECISIONS/agents-map.tsv"
echo -e "agent_name\tsource_repo\tfile_path\tfile_size\tline_count" > "$AGENTS_MAP"

AGENT_REPOS=("everything-claude-code" "voltagent-subagents" "rohitg00-toolkit" "alirezarezvani-claude-skills")

for repo_name in "${AGENT_REPOS[@]}"; do
    repo_path="$SOURCES/$repo_name"
    repo_count=0

    # agents/ directory (recursive)
    if [ -d "$repo_path/agents" ]; then
        while IFS= read -r agent_file; do
            agent_name=$(basename "$agent_file" .md)
            fsize=$(wc -c < "$agent_file" 2>/dev/null | tr -d '[:space:]')
            lcount=$(wc -l < "$agent_file" 2>/dev/null | tr -d '[:space:]')
            echo -e "${agent_name}\t${repo_name}\t$(to_rel "$agent_file")\t${fsize}\t${lcount}" >> "$AGENTS_MAP"
            repo_count=$((repo_count + 1))
        done < <(find "$repo_path/agents" -name "*.md" -not -name "README.md" -not -name "CLAUDE.md" -type f 2>/dev/null)
    fi

    # categories/ directory (VoltAgent)
    if [ -d "$repo_path/categories" ]; then
        while IFS= read -r agent_file; do
            agent_name=$(basename "$agent_file" .md)
            fsize=$(wc -c < "$agent_file" 2>/dev/null | tr -d '[:space:]')
            lcount=$(wc -l < "$agent_file" 2>/dev/null | tr -d '[:space:]')
            echo -e "${agent_name}\t${repo_name}\t$(to_rel "$agent_file")\t${fsize}\t${lcount}" >> "$AGENTS_MAP"
            repo_count=$((repo_count + 1))
        done < <(find "$repo_path/categories" -name "*.md" -not -name "README.md" -type f 2>/dev/null)
    fi

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count agents"
done

TOTAL_AGENTS=$(tail -n +2 "$AGENTS_MAP" | wc -l | tr -d '[:space:]')
UNIQUE_AGENTS=$(tail -n +2 "$AGENTS_MAP" | cut -f1 | sort -u | wc -l | tr -d '[:space:]')
CONFLICT_AGENTS=$(tail -n +2 "$AGENTS_MAP" | cut -f1 | sort | uniq -d | wc -l | tr -d '[:space:]')

NEW_AGENTS="" REMOVED_AGENTS=""
if [ -n "$PREV_AGENTS" ]; then
    CURR_AGENT_NAMES=$(tail -n +2 "$AGENTS_MAP" | cut -f1 | sort -u)
    NEW_AGENTS=$(comm -13 <(echo "$PREV_AGENTS") <(echo "$CURR_AGENT_NAMES") 2>/dev/null || true)
    REMOVED_AGENTS=$(comm -23 <(echo "$PREV_AGENTS") <(echo "$CURR_AGENT_NAMES") 2>/dev/null || true)
fi

NEW_AGENT_COUNT=0 REMOVED_AGENT_COUNT=0
[ -n "$NEW_AGENTS" ] && NEW_AGENT_COUNT=$(echo "$NEW_AGENTS" | grep -c . 2>/dev/null || echo 0)
[ -n "$REMOVED_AGENTS" ] && REMOVED_AGENT_COUNT=$(echo "$REMOVED_AGENTS" | grep -c . 2>/dev/null || echo 0)

echo ""
echo -e "  ${BOLD}Total:${NC} $TOTAL_AGENTS entries → ${GREEN}$UNIQUE_AGENTS unique${NC} (${RED}$CONFLICT_AGENTS conflicts${NC})"
if [ "$NEW_AGENT_COUNT" -gt 0 ] 2>/dev/null; then
    echo -e "  ${GREEN}+ $NEW_AGENT_COUNT new agents${NC}"
    echo "$NEW_AGENTS" | head -5 | while read -r a; do
        [ -z "$a" ] && continue
        src=$(grep "^${a}	" "$AGENTS_MAP" | head -1 | cut -f2)
        echo -e "    ${GREEN}+${NC} $a ${DIM}($src)${NC}"
    done
fi
if [ "$REMOVED_AGENT_COUNT" -gt 0 ] 2>/dev/null; then
    echo -e "  ${RED}- $REMOVED_AGENT_COUNT removed agents${NC}"
fi
if [ "$PREV_AGENT_COUNT" -gt 0 ] 2>/dev/null; then
    DIFF=$((UNIQUE_AGENTS - PREV_AGENT_COUNT))
    if [ "$DIFF" -ne 0 ]; then
        echo -e "  ${DIM}Change: $PREV_AGENT_COUNT → $UNIQUE_AGENTS ($([ "$DIFF" -gt 0 ] && echo "+")$DIFF)${NC}"
    else
        echo -e "  ${DIM}No change from previous scan${NC}"
    fi
fi
echo ""

# ============================================================
# 3. COMMANDS SCAN
# ============================================================
echo -e "${CYAN}━━━ [3/5] Scanning commands ━━━${NC}"

COMMANDS_MAP="$DECISIONS/commands-map.tsv"
echo -e "command_name\tsource_repo\tfile_path\tfile_size\tline_count" > "$COMMANDS_MAP"

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_path="$repo_dir"
    repo_count=0

    # .claude/commands/ (some repos store commands here)
    for cmd_dir in "$repo_path/commands" "$repo_path/.claude/commands"; do
        [ -d "$cmd_dir" ] || continue
        while IFS= read -r cmd_file; do
            cmd_name=$(basename "$cmd_file" .md)
            fsize=$(wc -c < "$cmd_file" 2>/dev/null | tr -d '[:space:]')
            lcount=$(wc -l < "$cmd_file" 2>/dev/null | tr -d '[:space:]')
            echo -e "${cmd_name}\t${repo_name}\t$(to_rel "$cmd_file")\t${fsize}\t${lcount}" >> "$COMMANDS_MAP"
            repo_count=$((repo_count + 1))
        done < <(find "$cmd_dir" -name "*.md" -not -name "README.md" -type f 2>/dev/null)
    done

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count commands"
done

TOTAL_COMMANDS=$(tail -n +2 "$COMMANDS_MAP" | wc -l | tr -d '[:space:]')
UNIQUE_COMMANDS=$(tail -n +2 "$COMMANDS_MAP" | cut -f1 | sort -u | wc -l | tr -d '[:space:]')
CONFLICT_COMMANDS=$(tail -n +2 "$COMMANDS_MAP" | cut -f1 | sort | uniq -d | wc -l | tr -d '[:space:]')

NEW_CMDS="" REMOVED_CMDS=""
if [ -n "$PREV_COMMANDS" ]; then
    CURR_CMD_NAMES=$(tail -n +2 "$COMMANDS_MAP" | cut -f1 | sort -u)
    NEW_CMDS=$(comm -13 <(echo "$PREV_COMMANDS") <(echo "$CURR_CMD_NAMES") 2>/dev/null || true)
    REMOVED_CMDS=$(comm -23 <(echo "$PREV_COMMANDS") <(echo "$CURR_CMD_NAMES") 2>/dev/null || true)
fi

NEW_CMD_COUNT=0 REMOVED_CMD_COUNT=0
[ -n "$NEW_CMDS" ] && NEW_CMD_COUNT=$(echo "$NEW_CMDS" | grep -c . 2>/dev/null || echo 0)
[ -n "$REMOVED_CMDS" ] && REMOVED_CMD_COUNT=$(echo "$REMOVED_CMDS" | grep -c . 2>/dev/null || echo 0)

echo ""
echo -e "  ${BOLD}Total:${NC} $TOTAL_COMMANDS entries → ${GREEN}$UNIQUE_COMMANDS unique${NC} (${RED}$CONFLICT_COMMANDS conflicts${NC})"
if [ "$NEW_CMD_COUNT" -gt 0 ] 2>/dev/null; then echo -e "  ${GREEN}+ $NEW_CMD_COUNT new commands${NC}"; fi
if [ "$REMOVED_CMD_COUNT" -gt 0 ] 2>/dev/null; then echo -e "  ${RED}- $REMOVED_CMD_COUNT removed commands${NC}"; fi
echo ""

# ============================================================
# 4. HOOKS SCAN
# ============================================================
echo -e "${CYAN}━━━ [4/5] Scanning hooks ━━━${NC}"

HOOKS_MAP="$DECISIONS/hooks-map.tsv"
echo -e "hook_name\tsource_repo\tfile_path\tfile_size" > "$HOOKS_MAP"

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")
    repo_count=0

    if [ -d "${repo_dir}hooks" ]; then
        while IFS= read -r hook_file; do
            hook_name=$(basename "$hook_file")
            fsize=$(wc -c < "$hook_file" 2>/dev/null | tr -d '[:space:]')
            echo -e "${hook_name}\t${repo_name}\t$(to_rel "$hook_file")\t${fsize}" >> "$HOOKS_MAP"
            repo_count=$((repo_count + 1))
        done < <(find "${repo_dir}hooks" -type f 2>/dev/null)
    fi

    [ "$repo_count" -gt 0 ] && echo -e "  ${GREEN}✓${NC}  ${BOLD}$repo_name${NC}: $repo_count hooks"
done

TOTAL_HOOKS=$(tail -n +2 "$HOOKS_MAP" | wc -l | tr -d '[:space:]')
echo -e "\n  ${BOLD}Total:${NC} ${GREEN}$TOTAL_HOOKS hooks${NC}"
echo ""

# ============================================================
# 5. FIX PATHS + GENERATE CONFLICT REPORT
# ============================================================
echo -e "${CYAN}━━━ [5/5] Generating conflict report ━━━${NC}"

# Fix absolute paths
for tsv_file in "$SKILLS_MAP" "$AGENTS_MAP" "$COMMANDS_MAP" "$HOOKS_MAP"; do
    if [ -f "$tsv_file" ]; then
        sed -i "s|${ROOT}/||g" "$tsv_file" 2>/dev/null || \
        sed -i '' "s|${ROOT}/||g" "$tsv_file" 2>/dev/null || true
    fi
done

CONFLICT_REPORT="$DECISIONS/conflicts-${TIMESTAMP}.md"
cat > "$CONFLICT_REPORT" << HEADER
# Conflict Report — $TIMESTAMP
> Scanned: $(ls -d "$SOURCES"/*/ 2>/dev/null | wc -l | tr -d '[:space:]') repos

## Summary
| Category | Total | Unique | Conflicts | vs Previous |
|----------|------:|-------:|----------:|-------------|
| Skills | $TOTAL_SKILLS | $UNIQUE_SKILLS | $CONFLICT_SKILLS | $([ "$PREV_SKILL_COUNT" -gt 0 ] 2>/dev/null && echo "${PREV_SKILL_COUNT} → ${UNIQUE_SKILLS}" || echo "first scan") |
| Agents | $TOTAL_AGENTS | $UNIQUE_AGENTS | $CONFLICT_AGENTS | $([ "$PREV_AGENT_COUNT" -gt 0 ] 2>/dev/null && echo "${PREV_AGENT_COUNT} → ${UNIQUE_AGENTS}" || echo "first scan") |
| Commands | $TOTAL_COMMANDS | $UNIQUE_COMMANDS | $CONFLICT_COMMANDS | $([ "$PREV_CMD_COUNT" -gt 0 ] 2>/dev/null && echo "${PREV_CMD_COUNT} → ${UNIQUE_COMMANDS}" || echo "first scan") |
| Hooks | $TOTAL_HOOKS | - | - | $([ "$PREV_HOOK_COUNT" -gt 0 ] 2>/dev/null && echo "${PREV_HOOK_COUNT} → ${TOTAL_HOOKS}" || echo "first scan") |

HEADER

# New components section
if [ "$NEW_SKILL_COUNT" -gt 0 ] || [ "$NEW_AGENT_COUNT" -gt 0 ] || [ "$NEW_CMD_COUNT" -gt 0 ] 2>/dev/null; then
    echo "## New Components (since last scan)" >> "$CONFLICT_REPORT"
    echo "" >> "$CONFLICT_REPORT"
    if [ "$NEW_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
        echo "### New Skills ($NEW_SKILL_COUNT)" >> "$CONFLICT_REPORT"
        echo "$NEW_SKILLS" | while read -r s; do
            [ -z "$s" ] && continue
            src=$(grep "^${s}	" "$SKILLS_MAP" | head -1 | cut -f2)
            echo "- \`$s\` ($src)" >> "$CONFLICT_REPORT"
        done
        echo "" >> "$CONFLICT_REPORT"
    fi
    if [ "$NEW_AGENT_COUNT" -gt 0 ] 2>/dev/null; then
        echo "### New Agents ($NEW_AGENT_COUNT)" >> "$CONFLICT_REPORT"
        echo "$NEW_AGENTS" | while read -r a; do
            [ -z "$a" ] && continue
            src=$(grep "^${a}	" "$AGENTS_MAP" | head -1 | cut -f2)
            echo "- \`$a\` ($src)" >> "$CONFLICT_REPORT"
        done
        echo "" >> "$CONFLICT_REPORT"
    fi
fi

# Removed components section
if [ "$REMOVED_SKILL_COUNT" -gt 0 ] || [ "$REMOVED_AGENT_COUNT" -gt 0 ] 2>/dev/null; then
    echo "## Removed Components (since last scan)" >> "$CONFLICT_REPORT"
    echo "" >> "$CONFLICT_REPORT"
    if [ "$REMOVED_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
        echo "### Removed Skills ($REMOVED_SKILL_COUNT)" >> "$CONFLICT_REPORT"
        echo "$REMOVED_SKILLS" | while read -r s; do [ -z "$s" ] && continue; echo "- \`$s\`" >> "$CONFLICT_REPORT"; done
        echo "" >> "$CONFLICT_REPORT"
    fi
fi

# Conflict details
cat >> "$CONFLICT_REPORT" << 'CONFLICT_HDR'
## Skill Conflicts

| Skill | Repo 1 | Size 1 | Repo 2 | Size 2 | Winner |
|-------|--------|--------|--------|--------|--------|
CONFLICT_HDR

tail -n +2 "$SKILLS_MAP" | cut -f1 | sort | uniq -d | while read -r conflict_name; do
    entries=$(grep "^${conflict_name}	" "$SKILLS_MAP" | head -5)
    r1=$(echo "$entries" | head -1 | cut -f2); s1=$(echo "$entries" | head -1 | cut -f4)
    r2=$(echo "$entries" | sed -n '2p' | cut -f2); s2=$(echo "$entries" | sed -n '2p' | cut -f4)
    # Auto-decide: official wins ties, otherwise bigger wins
    winner="TBD"
    if [ "$r1" = "anthropics-skills" ]; then winner="$r1"
    elif [ "$r2" = "anthropics-skills" ]; then winner="$r2"
    elif [ "${s1:-0}" -ge "${s2:-0}" ] 2>/dev/null; then winner="$r1"
    else winner="$r2"
    fi
    echo "| $conflict_name | $r1 | ${s1}B | $r2 | ${s2}B | **$winner** |" >> "$CONFLICT_REPORT"
done

cat >> "$CONFLICT_REPORT" << 'AGENT_HDR'

## Agent Conflicts

| Agent | Repo 1 | Size 1 | Repo 2 | Size 2 | Winner |
|-------|--------|--------|--------|--------|--------|
AGENT_HDR

tail -n +2 "$AGENTS_MAP" | cut -f1 | sort | uniq -d | while read -r conflict_name; do
    entries=$(grep "^${conflict_name}	" "$AGENTS_MAP" | head -5)
    r1=$(echo "$entries" | head -1 | cut -f2); s1=$(echo "$entries" | head -1 | cut -f4)
    r2=$(echo "$entries" | sed -n '2p' | cut -f2); s2=$(echo "$entries" | sed -n '2p' | cut -f4)
    echo "| $conflict_name | $r1 | ${s1}B | $r2 | ${s2}B | TBD |" >> "$CONFLICT_REPORT"
done

echo -e "  ${GREEN}✓${NC}  Conflict report: ${DIM}decisions/conflicts-${TIMESTAMP}.md${NC}"

# ============================================================
# FINAL SUMMARY
# ============================================================
echo ""
echo -e "${CYAN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}${BOLD}            Scan Complete                    ${NC}${CYAN}║${NC}"
echo -e "${CYAN}╠═══════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC}                                               ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Skills:   ${GREEN}${UNIQUE_SKILLS}${NC} unique (${TOTAL_SKILLS} raw, ${CONFLICT_SKILLS} conflicts) ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Agents:   ${GREEN}${UNIQUE_AGENTS}${NC} unique (${TOTAL_AGENTS} raw, ${CONFLICT_AGENTS} conflicts) ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Commands: ${GREEN}${UNIQUE_COMMANDS}${NC} unique (${TOTAL_COMMANDS} raw, ${CONFLICT_COMMANDS} conflicts) ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}  Hooks:    ${GREEN}${TOTAL_HOOKS}${NC}                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                               ${CYAN}║${NC}"

if [ "$PREV_SKILL_COUNT" -gt 0 ] 2>/dev/null; then
    TOTAL_NEW=$((NEW_SKILL_COUNT + NEW_AGENT_COUNT + NEW_CMD_COUNT))
    TOTAL_REMOVED=$((REMOVED_SKILL_COUNT + REMOVED_AGENT_COUNT + REMOVED_CMD_COUNT))
    if [ "$TOTAL_NEW" -gt 0 ] || [ "$TOTAL_REMOVED" -gt 0 ]; then
        echo -e "${CYAN}║${NC}  Changes: ${GREEN}+${TOTAL_NEW} new${NC}, ${RED}-${TOTAL_REMOVED} removed${NC}              ${CYAN}║${NC}"
    else
        echo -e "${CYAN}║${NC}  ${DIM}No changes since last scan${NC}                   ${CYAN}║${NC}"
    fi
else
    echo -e "${CYAN}║${NC}  ${DIM}First scan — no previous data to compare${NC}   ${CYAN}║${NC}"
fi

echo -e "${CYAN}║${NC}                                               ${CYAN}║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════╝${NC}"
echo ""
