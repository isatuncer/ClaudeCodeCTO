---
description: Scan all source repos for skills, agents, commands, hooks. Detect conflicts (same-named components from different repos). Generate conflict report.
---

# CTO Scan

Scan all submodule repos to inventory their skills, agents, commands, and hooks. Detect naming conflicts across repos.

## Arguments

`$ARGUMENTS` (optional): If provided, scan only that specific repo alias.

## Steps

### If specific repo provided:
```bash
cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/add-repo.sh --scan $ARGUMENTS
```

### If no arguments (full scan):

1. **Run full scanner**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/scanner.sh
   ```

2. **Read results** from:
   - `decisions/skills-map.tsv` — all skills across repos
   - `decisions/agents-map.tsv` — all agents across repos
   - `decisions/commands-map.tsv` — all commands across repos
   - `decisions/hooks-map.tsv` — all hooks across repos
   - `decisions/conflicts-*.md` — conflict report

3. **Present summary** to user:
   - Total skills / agents / commands / hooks found
   - How many are unique vs conflicting
   - List all conflicts with sizes from each repo

4. **For each conflict**, recommend which version is better based on:
   - File size (larger = more comprehensive)
   - Source repo reputation (anthropics > ECC > community)
   - Recency of last update

5. **Update** `decisions/decision-log.md` with recommendations.
