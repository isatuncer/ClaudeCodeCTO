#!/usr/bin/env bash
# ClaudeCodeCTO Weekly Scanner
# Updates submodules weekly, detects new/changed components
# Updates conflict report and writes to decision log

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SOURCES="$ROOT/sources"
DECISIONS="$ROOT/decisions"
TIMESTAMP=$(date +%Y-%m-%d)
CHANGELOG="$DECISIONS/changelog.md"

echo "=== ClaudeCodeCTO Weekly Scan ==="
echo "Date: $TIMESTAMP"
echo ""

# ============================================================
# 1. SUBMODULE UPDATE
# ============================================================
echo "[1/4] Updating submodules..."

cd "$ROOT"

# Check for updates in each submodule
UPDATE_LOG=""
for repo_dir in "$SOURCES"/*/; do
    [ -d "$repo_dir" ] || continue
    repo_name=$(basename "$repo_dir")

    cd "$repo_dir"

    # Save current commit
    OLD_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

    # Update
    git fetch origin 2>/dev/null || true
    git checkout main 2>/dev/null || git checkout master 2>/dev/null || true
    git pull origin $(git branch --show-current 2>/dev/null || echo "main") 2>/dev/null || true

    # Check for new commits
    NEW_COMMIT=$(git rev-parse HEAD 2>/dev/null || echo "unknown")

    if [ "$OLD_COMMIT" != "$NEW_COMMIT" ]; then
        CHANGES=$(git log --oneline "$OLD_COMMIT".."$NEW_COMMIT" 2>/dev/null | wc -l)
        echo "  ✓ $repo_name: $CHANGES new commits"
        UPDATE_LOG="$UPDATE_LOG\n| $repo_name | $OLD_COMMIT | $NEW_COMMIT | $CHANGES commit |"

        # Detect changed files
        CHANGED_FILES=$(git diff --name-only "$OLD_COMMIT".."$NEW_COMMIT" 2>/dev/null || echo "")
        CHANGED_SKILLS=$(echo "$CHANGED_FILES" | grep -c "skills/" 2>/dev/null || echo 0)
        CHANGED_AGENTS=$(echo "$CHANGED_FILES" | grep -c "agents/" 2>/dev/null || echo 0)
        CHANGED_COMMANDS=$(echo "$CHANGED_FILES" | grep -c "commands/" 2>/dev/null || echo 0)

        if [ "$CHANGED_SKILLS" -gt 0 ] || [ "$CHANGED_AGENTS" -gt 0 ] || [ "$CHANGED_COMMANDS" -gt 0 ]; then
            echo "    Skills: $CHANGED_SKILLS, Agents: $CHANGED_AGENTS, Commands: $CHANGED_COMMANDS changes"
        fi
    else
        echo "  - $repo_name: Up to date"
    fi

    cd "$ROOT"
done

# ============================================================
# 2. FULL SCAN
# ============================================================
echo ""
echo "[2/4] Running full scan..."
bash "$ROOT/scripts/scanner.sh"

# ============================================================
# 3. CHANGELOG UPDATE
# ============================================================
echo ""
echo "[3/4] Updating changelog..."

if [ ! -f "$CHANGELOG" ]; then
    echo "# ClaudeCodeCTO Changelog" > "$CHANGELOG"
    echo "" >> "$CHANGELOG"
fi

# Add new entry
{
    echo ""
    echo "## $TIMESTAMP"
    echo ""
    if [ -n "$UPDATE_LOG" ]; then
        echo "### Updated Repos"
        echo "| Repo | Old Commit | New Commit | Changes |"
        echo "|------|------------|------------|---------|"
        echo -e "$UPDATE_LOG"
    else
        echo "All repos are up to date, no changes."
    fi
    echo ""
} >> "$CHANGELOG"

# ============================================================
# 4. SUMMARY
# ============================================================
echo ""
echo "[4/4] Weekly scan complete."
echo "Results:"
echo "  - Conflict report: $DECISIONS/conflicts-${TIMESTAMP}.md"
echo "  - Changelog: $CHANGELOG"
echo ""
echo "Next step: Analyze TBD decisions in the conflict report with Claude."
