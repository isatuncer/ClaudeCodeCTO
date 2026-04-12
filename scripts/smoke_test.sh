#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Smoke Test — Stage 5.5
#
# Structural + syntactic verification of the installed system.
# Does NOT test functional behavior (that requires a fresh
# Claude Code session to observe skill auto-selection).
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
REPORT_FILE="$ROOT_BASH/decisions/smoke-test-report.md"

if [ -t 1 ]; then
    GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'
    CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'
else
    GREEN='' RED='' YELLOW='' CYAN='' BOLD='' NC=''
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
echo -e "  Target: $CLAUDE_HOME"
echo ""

# --- Test 1: Directory structure ---
echo -e "${CYAN}[1/8] Directory structure${NC}"
for d in skills agents commands rules config; do
    if [ -d "$CLAUDE_HOME/$d" ]; then
        count=$(ls "$CLAUDE_HOME/$d" 2>/dev/null | wc -l)
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
    lines=$(wc -l < "$CLAUDE_HOME/rules/agent-decision-tree.md")
    pass "agent-decision-tree.md ($lines lines)"
else
    fail "agent-decision-tree.md missing"
fi
echo ""

# --- Test 5: JSON syntax ---
echo -e "${CYAN}[5/8] JSON syntax${NC}"
for f in "$CLAUDE_HOME/settings.json" "$CLAUDE_HOME/config/lifecycle.json"; do
    if [ -f "$f" ]; then
        if python -c "import json; json.load(open(r'$(cygpath -w $f)', encoding='utf-8'))" 2>/dev/null; then
            pass "$(basename $f) valid JSON"
        else
            fail "$(basename $f) invalid JSON"
        fi
    fi
done
echo ""

# --- Test 6: SKILL.md frontmatter (Python, fast) ---
echo -e "${CYAN}[6/8] Frontmatter sanity${NC}"
read total_skills missing_fm <<< $(python - << PYEOF
from pathlib import Path
skills_dir = Path(r"$(cygpath -w $CLAUDE_HOME)/skills")
total = 0
missing = 0
for d in skills_dir.iterdir():
    if not d.is_dir():
        continue
    total += 1
    sk = d / "SKILL.md"
    if sk.exists():
        try:
            first = sk.read_text(encoding="utf-8", errors="replace").split("\n", 1)[0]
            if not first.strip().startswith("---"):
                missing += 1
        except OSError:
            missing += 1
    else:
        missing += 1
print(total, missing)
PYEOF
)
if [ "${missing_fm:-0}" -eq 0 ]; then
    pass "All $total_skills skills have frontmatter"
elif [ "${missing_fm:-0}" -lt $((total_skills / 20)) ]; then
    warn "$missing_fm/$total_skills skills missing frontmatter (tolerable)"
else
    fail "$missing_fm/$total_skills skills missing frontmatter (too many)"
fi
echo ""

# --- Test 7: Manifest sanity ---
echo -e "${CYAN}[7/8] Install manifest${NC}"
MANIFEST="$ROOT_BASH/decisions/install-manifest.json"
if [ -f "$MANIFEST" ]; then
    manifest_total=$(python -c "import json; print(json.load(open(r'$(cygpath -w $MANIFEST)'))['total'])" 2>/dev/null || echo "0")
    actual_total=$(( $(ls "$CLAUDE_HOME/skills" | wc -l) + $(ls "$CLAUDE_HOME/agents" | wc -l) + $(ls "$CLAUDE_HOME/commands" | wc -l) ))
    if [ "$manifest_total" -gt 0 ] && [ "$actual_total" -ge "$manifest_total" ]; then
        pass "Manifest total ($manifest_total) matches installed ($actual_total)"
    else
        warn "Manifest says $manifest_total, actual $actual_total"
    fi
else
    fail "install-manifest.json missing"
fi
echo ""

# --- Test 8: Backup preservation ---
echo -e "${CYAN}[8/8] Backup preservation${NC}"
latest_backup=$(ls -dt /c/tmp/claude-install-backup-* 2>/dev/null | head -1)
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
5. JSON syntax
6. Frontmatter sanity
7. Install manifest consistency
8. Backup preservation

## Failures

$(if [ "${#FAILURES[@]:-0}" = "0" ]; then echo "_None_"; else for f in "${FAILURES[@]}"; do echo "- $f"; done; fi)

## Next Steps

- Start a fresh Claude Code session to verify skill loading works
- Test \`/start-project\` command interactively
- Monitor \`~/.claude/cost-tracker.log\` for token usage patterns
- Stage 6 (OPTIMIZE) will be ongoing based on real usage data
EOF

echo ""
echo -e "  Report: decisions/smoke-test-report.md"

if [ "$FAIL" -eq 0 ]; then
    exit 0
else
    exit 1
fi
