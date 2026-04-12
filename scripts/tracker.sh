#!/usr/bin/env bash
# ============================================================
# CloaudeCodeCTO Tracker — Stage 6 OPTIMIZE
#
# Parses ~/.claude/ runtime logs to extract usage metrics:
# - Which skills/agents/commands were triggered
# - Token usage patterns per component
# - Unused items (candidates for pruning)
#
# This runs continuously over time. Each run appends to
# decisions/usage-report.json history.
# ============================================================

set -uo pipefail

ROOT_BASH="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
REPORT="$ROOT_BASH/decisions/usage-report.json"

echo ""
echo "=========================================="
echo "  CloaudeCodeCTO Tracker"
echo "=========================================="
echo ""

if [ ! -d "$CLAUDE_HOME" ]; then
    echo "ERROR: $CLAUDE_HOME does not exist"
    exit 1
fi

python << PYEOF
import json
import re
from collections import Counter
from datetime import datetime
from pathlib import Path

CLAUDE_HOME = Path(r"$(cygpath -w $CLAUDE_HOME)")
REPORT = Path(r"$(cygpath -w $REPORT)")

# Installed inventory
skills = sorted(p.name for p in (CLAUDE_HOME / "skills").iterdir() if p.is_dir()) if (CLAUDE_HOME / "skills").is_dir() else []
agents = sorted(p.stem for p in (CLAUDE_HOME / "agents").iterdir() if p.suffix == ".md") if (CLAUDE_HOME / "agents").is_dir() else []
commands = sorted(p.stem for p in (CLAUDE_HOME / "commands").iterdir() if p.suffix == ".md") if (CLAUDE_HOME / "commands").is_dir() else []

print(f"Installed: {len(skills)} skills, {len(agents)} agents, {len(commands)} commands")

# Parse logs
usage = Counter()
log_files = []

for candidate in ("cost-tracker.log", "bash-commands.log", ".cto-install.log"):
    p = CLAUDE_HOME / candidate
    if p.exists():
        log_files.append(p)

total_log_lines = 0
for lf in log_files:
    try:
        content = lf.read_text(encoding="utf-8", errors="replace")
        lines = content.splitlines()
        total_log_lines += len(lines)
        # Look for skill / agent / command mentions in logs
        for s in skills:
            if f"/skills/{s}/" in content or f"skill:{s}" in content:
                usage[f"skill:{s}"] += 1
        for a in agents:
            if f"/agents/{a}" in content or f"agent:{a}" in content:
                usage[f"agent:{a}"] += 1
        for c in commands:
            if f"/{c}" in content or f"command:{c}" in content:
                usage[f"command:{c}"] += 1
    except OSError:
        continue

# Most used
top_used = usage.most_common(20)

# Unused (everything installed but not seen)
seen = {k.split(":", 1)[1] for k in usage if ":" in k}
unused_skills = [s for s in skills if s not in seen]
unused_agents = [a for a in agents if a not in seen]
unused_commands = [c for c in commands if c not in seen]

report = {
    "generated_at": datetime.now().isoformat(timespec="seconds"),
    "installed": {
        "skills": len(skills),
        "agents": len(agents),
        "commands": len(commands),
    },
    "log_stats": {
        "files_parsed": [str(f.name) for f in log_files],
        "total_log_lines": total_log_lines,
    },
    "top_20_used": [{"id": k, "count": v} for k, v in top_used],
    "unused": {
        "skills": len(unused_skills),
        "agents": len(unused_agents),
        "commands": len(unused_commands),
        "skills_sample": unused_skills[:30],
        "agents_sample": unused_agents[:30],
        "commands_sample": unused_commands[:30],
    },
    "pruning_suggestion": {
        "note": "Run tracker.sh periodically. Items unused for 30+ days become prune candidates. Currently this is the first measurement — no pruning recommended yet.",
        "threshold_days": 30,
        "max_candidates_per_run": 50,
    },
}

REPORT.write_text(json.dumps(report, indent=2, ensure_ascii=False, default=str), encoding="utf-8")

print()
print(f"Logs parsed: {len(log_files)} files, {total_log_lines} lines")
print(f"Usage events: {sum(usage.values())}")
print(f"Components seen: {len(seen)}")
print(f"Unused skills:   {len(unused_skills)}")
print(f"Unused agents:   {len(unused_agents)}")
print(f"Unused commands: {len(unused_commands)}")

if top_used:
    print()
    print("TOP 10 MOST USED")
    for k, v in top_used[:10]:
        print(f"  {v:>5}  {k}")
else:
    print()
    print("No usage events yet (fresh install - logs will build up over time).")

print()
print(f"Report: decisions/usage-report.json")
PYEOF
