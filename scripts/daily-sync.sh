#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO Daily Sync
# Pulls latest from all sources, re-scans, diffs against
# previous maps, updates registry with real counts, and
# generates a change report.
#
# Usage:
#   bash scripts/daily-sync.sh            # Full sync
#   bash scripts/daily-sync.sh --dry-run   # Preview only
#   bash scripts/daily-sync.sh --scan-only # Skip git pull, just re-scan
# ============================================================

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/sources"
DECISIONS="$ROOT/decisions"
TIMESTAMP=$(date +%Y-%m-%d)
TIME_FULL=$(date +%Y-%m-%d_%H-%M-%S)
REPORTS="$DECISIONS/reports"
DRY_RUN=false
SCAN_ONLY=false

# Parse args
for arg in "$@"; do
    case "$arg" in
        --dry-run)   DRY_RUN=true ;;
        --scan-only) SCAN_ONLY=true ;;
    esac
done

mkdir -p "$DECISIONS" "$REPORTS"

# Colors
if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ]; then
    RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
    BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'
    DIM='\033[2m'; NC='\033[0m'
else
    RED='' GREEN='' YELLOW='' BLUE='' CYAN='' BOLD='' DIM='' NC=''
fi

log_step()  { echo -e "\n${CYAN}━━━ $1 ━━━${NC}"; }
log_info()  { echo -e "  ${BLUE}ℹ${NC}  $1"; }
log_ok()    { echo -e "  ${GREEN}✓${NC}  $1"; }
log_warn()  { echo -e "  ${YELLOW}⚠${NC}  $1"; }
log_new()   { echo -e "  ${GREEN}+${NC}  $1"; }
log_del()   { echo -e "  ${RED}-${NC}  $1"; }

echo ""
echo -e "${CYAN}  ==============================================${NC}"
echo -e "${BOLD}   ClaudeCodeCTO Daily Sync${NC}"
echo -e "   ${DIM}$TIMESTAMP${NC}"
echo -e "${CYAN}  ==============================================${NC}"

# ============================================================
# 1. SAVE PREVIOUS MAPS (for diff later)
# ============================================================
log_step "Step 1/6 — Saving previous state"

PREV_DIR="$REPORTS/prev"
mkdir -p "$PREV_DIR"

for f in skills-map.tsv agents-map.tsv commands-map.tsv hooks-map.tsv repo-registry.tsv; do
    [ -f "$DECISIONS/$f" ] && cp "$DECISIONS/$f" "$PREV_DIR/$f" 2>/dev/null
done
log_ok "Previous maps saved for comparison"

# ============================================================
# 2. PULL LATEST FROM ALL SOURCES
# ============================================================
log_step "Step 2/6 — Updating source repositories"

UPDATED_REPOS=()
TOTAL_REPOS=0
UPDATED_COUNT=0

if [ "$SCAN_ONLY" = true ]; then
    log_info "Skipping git pull (--scan-only mode)"
else
    # Pull ClaudeCodeCTO itself first
    cd "$ROOT"
    OLD_SELF=$(git rev-parse HEAD 2>/dev/null || echo "none")
    if [ "$DRY_RUN" = false ]; then
        git pull --ff-only origin main >/dev/null 2>&1 || true
    fi
    NEW_SELF=$(git rev-parse HEAD 2>/dev/null || echo "none")
    if [ "$OLD_SELF" != "$NEW_SELF" ]; then
        log_ok "ClaudeCodeCTO itself updated"
    fi

    # Pull each submodule
    for repo_dir in "$SOURCES"/*/; do
        [ -d "$repo_dir/.git" ] || [ -f "$repo_dir/.git" ] || continue
        TOTAL_REPOS=$((TOTAL_REPOS + 1))
        repo_name=$(basename "$repo_dir")

        cd "$repo_dir"
        OLD_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

        if [ "$DRY_RUN" = false ]; then
            git fetch origin >/dev/null 2>&1 || true
            DEFAULT_BRANCH=$(git remote show origin 2>/dev/null | grep "HEAD branch" | awk '{print $NF}' 2>/dev/null || echo "main")
            git checkout "$DEFAULT_BRANCH" >/dev/null 2>&1 || true
            git pull origin "$DEFAULT_BRANCH" >/dev/null 2>&1 || true
        fi

        NEW_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

        if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
            CHANGES=$(git log --oneline "$OLD_COMMIT".."$NEW_COMMIT" 2>/dev/null | wc -l | tr -d '[:space:]')
            log_ok "$repo_name: ${GREEN}$CHANGES new commits${NC}"
            UPDATED_REPOS+=("$repo_name:$CHANGES")
            UPDATED_COUNT=$((UPDATED_COUNT + 1))
        else
            echo -e "  ${DIM}-  $repo_name: up to date${NC}"
        fi
        cd "$ROOT"
    done

    log_ok "Repos checked: $TOTAL_REPOS | Updated: $UPDATED_COUNT"
fi

# ============================================================
# 3. FULL RE-SCAN (regenerate all maps)
# ============================================================
log_step "Step 3/6 — Re-scanning all components"

if [ "$DRY_RUN" = true ]; then
    log_info "DRY RUN — skipping scan"
else
    bash "$ROOT/scripts/scanner.sh" 2>/dev/null || {
        log_warn "Scanner had warnings, continuing..."
    }
    log_ok "Scan complete"
fi

# ============================================================
# 4. DIFF PREVIOUS vs CURRENT MAPS
# ============================================================
log_step "Step 4/6 — Detecting changes"

REPORT_FILE="$REPORTS/sync-${TIME_FULL}.md"

cat > "$REPORT_FILE" << HEADER
# Daily Sync Report
> Date: $TIMESTAMP
> Time: $TIME_FULL
> Mode: $([ "$DRY_RUN" = true ] && echo "DRY RUN" || echo "FULL SYNC")

HEADER

# Function: diff two TSV maps and report new/removed
diff_maps() {
    local category="$1"
    local prev_file="$PREV_DIR/${category}-map.tsv"
    local curr_file="$DECISIONS/${category}-map.tsv"
    local name_col=1  # column with component name

    if [ ! -f "$prev_file" ] || [ ! -f "$curr_file" ]; then
        echo "## $category" >> "$REPORT_FILE"
        echo "No previous scan to compare." >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        return
    fi

    local prev_names curr_names
    prev_names=$(tail -n +2 "$prev_file" | cut -f$name_col | sort -u)
    curr_names=$(tail -n +2 "$curr_file" | cut -f$name_col | sort -u)

    local new_items removed_items
    new_items=$(comm -13 <(echo "$prev_names") <(echo "$curr_names"))
    removed_items=$(comm -23 <(echo "$prev_names") <(echo "$curr_names"))

    local prev_count curr_count new_count removed_count
    prev_count=$(echo "$prev_names" | grep -c . 2>/dev/null || echo 0)
    curr_count=$(echo "$curr_names" | grep -c . 2>/dev/null || echo 0)
    new_count=$(echo "$new_items" | grep -c . 2>/dev/null || echo 0)
    removed_count=$(echo "$removed_items" | grep -c . 2>/dev/null || echo 0)

    # Handle empty results
    [ -z "$new_items" ] && new_count=0
    [ -z "$removed_items" ] && removed_count=0

    echo "## ${category^}" >> "$REPORT_FILE"
    echo "| Metric | Count |" >> "$REPORT_FILE"
    echo "|--------|------:|" >> "$REPORT_FILE"
    echo "| Previous | $prev_count |" >> "$REPORT_FILE"
    echo "| Current | $curr_count |" >> "$REPORT_FILE"
    echo "| **New** | **$new_count** |" >> "$REPORT_FILE"
    echo "| **Removed** | **$removed_count** |" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"

    if [ "$new_count" -gt 0 ] 2>/dev/null; then
        echo "### New ${category}" >> "$REPORT_FILE"
        echo "$new_items" | while read -r item; do
            [ -z "$item" ] && continue
            # Find which repo it came from
            local source_repo
            source_repo=$(grep "^${item}	" "$curr_file" | head -1 | cut -f2)
            echo "- \`$item\` (from $source_repo)" >> "$REPORT_FILE"
            log_new "NEW $category: $item (from $source_repo)"
        done
        echo "" >> "$REPORT_FILE"
    fi

    if [ "$removed_count" -gt 0 ] 2>/dev/null; then
        echo "### Removed ${category}" >> "$REPORT_FILE"
        echo "$removed_items" | while read -r item; do
            [ -z "$item" ] && continue
            local source_repo
            source_repo=$(grep "^${item}	" "$prev_file" | head -1 | cut -f2)
            echo "- \`$item\` (was in $source_repo)" >> "$REPORT_FILE"
            log_del "REMOVED $category: $item (was in $source_repo)"
        done
        echo "" >> "$REPORT_FILE"
    fi

    if [ "$new_count" = "0" ] && [ "$removed_count" = "0" ]; then
        log_ok "${category}: no changes"
    fi
}

diff_maps "skills"
diff_maps "agents"
diff_maps "commands"
diff_maps "hooks"

# ============================================================
# 5. GITHUB DISCOVERY — Search for new repos
# ============================================================
log_step "Step 5/7 — Searching GitHub for new repos"

DISCOVERIES="$REPORTS/discoveries-${TIMESTAMP}.md"
KNOWN_REPOS_FILE="$PREV_DIR/known_repos.txt"

# Build list of repos we already track
git config --file "$ROOT/.gitmodules" --get-regexp 'submodule\..*\.url' 2>/dev/null | awk '{print $2}' | sed 's|.*/||;s|\.git$||' | sort -u > "$KNOWN_REPOS_FILE" 2>/dev/null || true

if ! command -v gh &>/dev/null; then
    log_warn "GitHub CLI (gh) not installed — skipping discovery"
    echo "## GitHub Discovery" >> "$REPORT_FILE"
    echo "Skipped: gh CLI not available." >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
else
    SEARCH_QUERIES=(
        "claude code skills"
        "claude code agents"
        "claude-code prompts"
        "claude code slash commands"
        "awesome claude code"
        "claude code mcp"
    )

    CANDIDATE_COUNT=0

    cat > "$DISCOVERIES" << DISC_HEADER
# GitHub Discovery Report
> Date: $TIMESTAMP
> Searched: ${#SEARCH_QUERIES[@]} queries

## New Repo Candidates

| Repo | Stars | Description | Why Consider |
|------|------:|-------------|-------------|
DISC_HEADER

    declare -A SEEN_REPOS 2>/dev/null || true

    for query in "${SEARCH_QUERIES[@]}"; do
        # Search GitHub, get top results sorted by stars, JSON output
        results=$(gh search repos "$query" --sort stars --order desc --limit 15 --json fullName,stargazersCount,description,updatedAt 2>/dev/null || echo "[]")

        # Skip if no results
        [ "$results" = "[]" ] && continue

        # Parse each result
        echo "$results" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    for r in data:
        name = r.get('fullName','')
        stars = r.get('stargazersCount',0)
        desc = r.get('description','') or ''
        updated = r.get('updatedAt','')[:10]
        # Clean description for TSV
        desc = desc.replace('|',' ').replace('\n',' ')[:100]
        print(f'{name}\t{stars}\t{desc}\t{updated}')
except:
    pass
" 2>/dev/null | while IFS=$'\t' read -r full_name stars desc updated; do
            # Extract repo name
            repo_short=$(echo "$full_name" | sed 's|.*/||')

            # Skip if already tracked
            if grep -qx "$repo_short" "$KNOWN_REPOS_FILE" 2>/dev/null; then
                continue
            fi

            # Skip if already seen in this run
            if [ -n "${SEEN_REPOS[$full_name]+x}" ] 2>/dev/null; then
                continue
            fi
            SEEN_REPOS["$full_name"]=1

            # Skip low-star repos
            if [ "$stars" -lt 100 ] 2>/dev/null; then
                continue
            fi

            echo "| [$full_name](https://github.com/$full_name) | $stars | $desc | query: \"$query\" |" >> "$DISCOVERIES"
            log_new "CANDIDATE: $full_name ($stars stars)"
            CANDIDATE_COUNT=$((CANDIDATE_COUNT + 1))
        done
    done

    # If python3 not available, try without parsing
    if ! command -v python3 &>/dev/null; then
        log_warn "python3 not available — using basic search"
        for query in "${SEARCH_QUERIES[@]}"; do
            gh search repos "$query" --sort stars --order desc --limit 10 2>/dev/null | while read -r line; do
                repo_name=$(echo "$line" | awk '{print $1}')
                repo_short=$(echo "$repo_name" | sed 's|.*/||')
                if ! grep -qx "$repo_short" "$KNOWN_REPOS_FILE" 2>/dev/null; then
                    echo "| $repo_name | - | - | query: \"$query\" |" >> "$DISCOVERIES"
                    CANDIDATE_COUNT=$((CANDIDATE_COUNT + 1))
                fi
            done
        done
    fi

    if [ "$CANDIDATE_COUNT" -gt 0 ] 2>/dev/null; then
        log_ok "Found $CANDIDATE_COUNT new repo candidates"

        cat >> "$DISCOVERIES" << DISC_FOOTER

---

## How to Add

Review the candidates above, then add promising ones:

\`\`\`bash
bash scripts/add-repo.sh owner/repo-name
\`\`\`

Or use the slash command:
\`\`\`
/cto-add owner/repo-name
\`\`\`

Requirements:
- Must be in English
- Must contain skills, agents, commands, or prompts
- Will be validated automatically by add-repo.sh
DISC_FOOTER

        # Add to main report
        echo "## GitHub Discovery" >> "$REPORT_FILE"
        echo "Found **$CANDIDATE_COUNT** new repo candidates." >> "$REPORT_FILE"
        echo "Full list: \`$DISCOVERIES\`" >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        echo "Top candidates:" >> "$REPORT_FILE"
        tail -n +8 "$DISCOVERIES" | head -10 >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
    else
        log_ok "No new repos found (we already track the best ones)"
        echo "## GitHub Discovery" >> "$REPORT_FILE"
        echo "No new candidates found." >> "$REPORT_FILE"
        echo "" >> "$REPORT_FILE"
        rm -f "$DISCOVERIES"
    fi
fi

# ============================================================
# 6. UPDATE REPO REGISTRY WITH REAL COUNTS
# ============================================================
log_step "Step 6/7 — Updating repo registry"

REGISTRY="$DECISIONS/repo-registry.tsv"
REGISTRY_NEW="$DECISIONS/repo-registry.tsv.new"

echo -e "alias\tgithub_url\tadded_date\tstatus\tskills\tagents\tcommands\tnotes" > "$REGISTRY_NEW"

for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir/.git" ] || [ -f "$repo_dir/.git" ] || continue
    repo_name=$(basename "$repo_dir")

    # Get URL from .gitmodules
    local_url=$(git config --file "$ROOT/.gitmodules" --get "submodule.sources/$repo_name.url" 2>/dev/null || echo "unknown")

    # Get added date from existing registry
    added_date=$(grep "^${repo_name}	" "$REGISTRY" 2>/dev/null | cut -f3 || echo "$TIMESTAMP")
    [ -z "$added_date" ] && added_date="$TIMESTAMP"

    # Count ACTUAL components from this repo in current maps
    skill_count=$(grep "	${repo_name}	" "$DECISIONS/skills-map.tsv" 2>/dev/null | wc -l | tr -d '[:space:]')
    agent_count=$(grep "	${repo_name}	" "$DECISIONS/agents-map.tsv" 2>/dev/null | wc -l | tr -d '[:space:]')
    cmd_count=$(grep "	${repo_name}	" "$DECISIONS/commands-map.tsv" 2>/dev/null | wc -l | tr -d '[:space:]')

    # Check if repo was updated today
    note="ok"
    for entry in "${UPDATED_REPOS[@]+"${UPDATED_REPOS[@]}"}"; do
        if [[ "$entry" == "$repo_name:"* ]]; then
            commits="${entry#*:}"
            note="updated:${commits}commits"
        fi
    done

    echo -e "${repo_name}\t${local_url}\t${added_date}\tactive\t${skill_count}\t${agent_count}\t${cmd_count}\t${note}" >> "$REGISTRY_NEW"
done

if [ "$DRY_RUN" = false ]; then
    mv "$REGISTRY_NEW" "$REGISTRY"
    log_ok "Registry updated with real counts"
else
    log_info "DRY RUN — registry not updated"
    rm -f "$REGISTRY_NEW"
fi

# ============================================================
# 6. SUMMARY
# ============================================================
log_step "Step 7/7 — Summary"

# Read current counts
CURR_SKILLS=$(tail -n +2 "$DECISIONS/skills-map.tsv" 2>/dev/null | cut -f1 | sort -u | wc -l | tr -d '[:space:]')
CURR_AGENTS=$(tail -n +2 "$DECISIONS/agents-map.tsv" 2>/dev/null | cut -f1 | sort -u | wc -l | tr -d '[:space:]')
CURR_COMMANDS=$(tail -n +2 "$DECISIONS/commands-map.tsv" 2>/dev/null | cut -f1 | sort -u | wc -l | tr -d '[:space:]')
CURR_HOOKS=$(tail -n +2 "$DECISIONS/hooks-map.tsv" 2>/dev/null | wc -l | tr -d '[:space:]')

# Conflicts
SKILL_CONFLICTS=$(tail -n +2 "$DECISIONS/skills-map.tsv" 2>/dev/null | cut -f1 | sort | uniq -d | wc -l | tr -d '[:space:]')
AGENT_CONFLICTS=$(tail -n +2 "$DECISIONS/agents-map.tsv" 2>/dev/null | cut -f1 | sort | uniq -d | wc -l | tr -d '[:space:]')

# Write summary to report
cat >> "$REPORT_FILE" << SUMMARY
---

## Current Totals

| Category | Unique | Conflicts |
|----------|-------:|----------:|
| Skills | $CURR_SKILLS | $SKILL_CONFLICTS |
| Agents | $CURR_AGENTS | $AGENT_CONFLICTS |
| Commands | $CURR_COMMANDS | - |
| Hooks | $CURR_HOOKS | - |

## Repos Updated
SUMMARY

if [ ${#UPDATED_REPOS[@]+"${#UPDATED_REPOS[@]}"} -gt 0 ] 2>/dev/null; then
    for entry in "${UPDATED_REPOS[@]}"; do
        repo="${entry%%:*}"
        commits="${entry#*:}"
        echo "- **$repo**: $commits new commits" >> "$REPORT_FILE"
    done
else
    echo "No repos updated (all up to date)." >> "$REPORT_FILE"
fi

echo "" >> "$REPORT_FILE"
echo "---" >> "$REPORT_FILE"
echo "*Report generated by \`scripts/daily-sync.sh\` at $TIME_FULL*" >> "$REPORT_FILE"

# Console summary
echo ""
echo -e "  ${BOLD}Current state:${NC}"
echo -e "    Skills:   ${GREEN}$CURR_SKILLS${NC} unique ($SKILL_CONFLICTS conflicts)"
echo -e "    Agents:   ${GREEN}$CURR_AGENTS${NC} unique ($AGENT_CONFLICTS conflicts)"
echo -e "    Commands: ${GREEN}$CURR_COMMANDS${NC} unique"
echo -e "    Hooks:    ${GREEN}$CURR_HOOKS${NC}"
echo ""
echo -e "  ${BOLD}Report:${NC} $REPORT_FILE"
echo ""

if [ "$UPDATED_COUNT" -gt 0 ] 2>/dev/null; then
    echo -e "  ${YELLOW}$UPDATED_COUNT repos updated. Run 'bash setup.sh --update' to re-install.${NC}"
else
    echo -e "  ${GREEN}All repos up to date. No re-install needed.${NC}"
fi
echo ""

# Cleanup old prev dir
rm -rf "$PREV_DIR"
