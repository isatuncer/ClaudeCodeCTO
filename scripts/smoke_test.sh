#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Smoke Test (pure bash, no Python)
#
# Structural + syntactic verification of the installed system.
# Does NOT test functional behavior (that requires a fresh
# Claude Code session to observe skill auto-selection).
# ============================================================

set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
REPORT_FILE="$ROOT/decisions/smoke-test-report.md"

# Temp base dir (for backup check) — same logic as installer.sh
if [ -n "${CCCTO_TMP:-}" ]; then
    TMP_BASE="$CCCTO_TMP"
elif [ -d /c/tmp ]; then
    TMP_BASE="/c/tmp"
else
    TMP_BASE="${TMPDIR:-/tmp}"
fi

if [ -t 1 ]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
    GREEN=''; RED=''; YELLOW=''; CYAN=''; BOLD=''; NC=''
fi

PASS=0
FAIL=0
WARN=0
FAILURES=()

pass() { PASS=$((PASS + 1)); echo -e "  ${GREEN}PASS${NC} $1"; }
fail() { FAIL=$((FAIL + 1)); FAILURES+=("$1"); echo -e "  ${RED}FAIL${NC} $1"; }
warn() { WARN=$((WARN + 1)); echo -e "  ${YELLOW}WARN${NC} $1"; }

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${BOLD}  CloaudeCodeCTO Smoke Test${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""
echo "  Target: $CLAUDE_HOME"
echo ""

# --- Test 1: Directory structure ---
echo -e "${CYAN}[1/8] Directory structure${NC}"
for d in skills agents commands rules config; do
    if [ -d "$CLAUDE_HOME/$d" ]; then
        count=$(find "$CLAUDE_HOME/$d" -maxdepth 1 -mindepth 1 2>/dev/null | wc -l | tr -d ' ')
        pass "$d/ exists ($count items)"
    else
        fail "$d/ missing"
    fi
done
echo ""

# --- Test 2: Core files ---
echo -e "${CYAN}[2/8] Core files${NC}"
for f in settings.json CLAUDE.md .credentials.json; do
    if [ -f "$CLAUDE_HOME/$f" ]; then
        pass "$f present"
    else
        fail "$f missing"
    fi
done
echo ""

# --- Test 3: Orchestrator ---
echo -e "${CYAN}[3/8] Orchestrator${NC}"
if [ -f "$CLAUDE_HOME/skills/project-lifecycle/SKILL.md" ]; then
    pass "project-lifecycle skill installed"
else
    fail "project-lifecycle skill missing"
fi
if [ -f "$CLAUDE_HOME/commands/start-project.md" ]; then
    pass "/start-project command installed"
else
    fail "/start-project command missing"
fi
if [ -f "$CLAUDE_HOME/config/lifecycle.json" ]; then
    pass "config/lifecycle.json present"
else
    fail "lifecycle.json missing"
fi
echo ""

# --- Test 4: Rules ---
echo -e "${CYAN}[4/8] Rules${NC}"
if [ -f "$CLAUDE_HOME/rules/agent-decision-tree.md" ]; then
    lines=$(wc -l < "$CLAUDE_HOME/rules/agent-decision-tree.md" | tr -d ' ')
    pass "agent-decision-tree.md ($lines lines)"
else
    fail "agent-decision-tree.md missing"
fi
echo ""

# --- Test 5: JSON sanity (basic check — file exists, non-empty, balanced braces) ---
echo -e "${CYAN}[5/8] JSON sanity${NC}"
check_json_basic() {
    local f="$1"
    local name
    name=$(basename "$f")
    if [ ! -f "$f" ]; then
        fail "$name missing"
        return
    fi
    if [ ! -s "$f" ]; then
        fail "$name empty"
        return
    fi
    # First non-whitespace char must be { or [
    local first
    first=$(head -c 10 "$f" | tr -d '[:space:]' | head -c 1)
    if [ "$first" != "{" ] && [ "$first" != "[" ]; then
        fail "$name not valid JSON (starts with '$first')"
        return
    fi
    # Rough brace balance check
    local open_braces close_braces
    open_braces=$(tr -cd '{' < "$f" | wc -c | tr -d ' ')
    close_braces=$(tr -cd '}' < "$f" | wc -c | tr -d ' ')
    if [ "$open_braces" != "$close_braces" ]; then
        fail "$name unbalanced braces ($open_braces open, $close_braces close)"
        return
    fi
    pass "$name structurally valid"
}
check_json_basic "$CLAUDE_HOME/settings.json"
check_json_basic "$CLAUDE_HOME/config/lifecycle.json"
echo ""

# --- Test 6: SKILL.md frontmatter (pure bash) ---
echo -e "${CYAN}[6/8] Frontmatter sanity${NC}"
total_skills=0
missing_fm=0
for d in "$CLAUDE_HOME"/skills/*/; do
    [ -d "$d" ] || continue
    total_skills=$((total_skills + 1))
    sk="$d/SKILL.md"
    if [ -f "$sk" ]; then
        # Get first non-empty line
        first=$(head -5 "$sk" 2>/dev/null | grep -v '^$' | head -1 || echo "")
        case "$first" in
            ---*) ;;  # ok
            *) missing_fm=$((missing_fm + 1)) ;;
        esac
    else
        missing_fm=$((missing_fm + 1))
    fi
done

if [ "$missing_fm" -eq 0 ]; then
    pass "All $total_skills skills have frontmatter"
elif [ "$missing_fm" -lt $((total_skills / 20)) ]; then
    warn "$missing_fm/$total_skills skills missing frontmatter (tolerable)"
else
    fail "$missing_fm/$total_skills skills missing frontmatter (too many)"
fi
echo ""

# --- Test 7: Manifest sanity ---
echo -e "${CYAN}[7/8] Install manifest${NC}"
MANIFEST="$ROOT/decisions/install-manifest.json"
if [ -f "$MANIFEST" ]; then
    # Extract "total" field with grep/sed (manifest format is fixed)
    manifest_total=$(grep '"total":' "$MANIFEST" | head -1 | sed 's/.*"total":[[:space:]]*\([0-9][0-9]*\).*/\1/')
    actual_skills=$(find "$CLAUDE_HOME/skills" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    actual_agents=$(find "$CLAUDE_HOME/agents" -maxdepth 1 -mindepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
    actual_commands=$(find "$CLAUDE_HOME/commands" -maxdepth 1 -mindepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
    actual_total=$((actual_skills + actual_agents + actual_commands))

    if [ -n "$manifest_total" ] && [ "$manifest_total" = "$actual_total" ]; then
        pass "Installed $actual_total matches manifest"
    elif [ -n "$manifest_total" ] && [ "$manifest_total" -gt 0 ] 2>/dev/null; then
        warn "Manifest says $manifest_total, actual $actual_total (diff: $((actual_total - manifest_total)))"
    else
        warn "Could not read manifest total"
    fi
else
    fail "install-manifest.json missing"
fi
echo ""

# --- Test 8: Backup preservation ---
echo -e "${CYAN}[8/8] Backup preservation${NC}"
latest_backup=$(find "$TMP_BASE" -maxdepth 1 -name "claude-install-backup-*" -type d 2>/dev/null | sort -r | head -1)
if [ -n "$latest_backup" ] && [ -d "$latest_backup" ]; then
    pass "Backup exists at $latest_backup"
else
    warn "No install backup found (not critical if first install)"
fi
echo ""

# --- Final ---
echo -e "${CYAN}==========================================${NC}"
echo -e "${BOLD}  Result: $PASS pass, $FAIL fail, $WARN warn${NC}"
echo -e "${CYAN}==========================================${NC}"

# Write report
cat > "$REPORT_FILE" << EOF
# Smoke Test Report

**Generated:** $(date +'%Y-%m-%d %H:%M:%S')
**Target:** $CLAUDE_HOME

## Summary

| Result | Count |
|--------|-------|
| PASS | $PASS |
| FAIL | $FAIL |
| WARN | $WARN |

## Test Categories

1. Directory structure
2. Core files (settings, CLAUDE.md, credentials)
3. Orchestrator (project-lifecycle skill + /start-project command + lifecycle.json)
4. Rules (agent-decision-tree)
5. JSON sanity
6. Frontmatter sanity
7. Install manifest consistency
8. Backup preservation

## Failures

$(if [ "$FAIL" = "0" ]; then echo "_None_"; else for f in "${FAILURES[@]}"; do echo "- $f"; done; fi)

## Next Steps

- Start a fresh Claude Code session to verify skill loading works
- Test \`/start-project\` command interactively
EOF

echo ""
echo "  Report: decisions/smoke-test-report.md"

if [ "$FAIL" -eq 0 ]; then
    exit 0
else
    exit 1
fi
