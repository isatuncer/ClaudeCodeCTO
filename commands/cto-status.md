---
description: Show overall CloaudeCodeCTO system status — repo count, component totals, conflicts, last scan date, installed vs available.
---

# CTO Status

Show a comprehensive dashboard of the CloaudeCodeCTO system.

## Steps

1. **Count repos**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && ls -d sources/*/ | wc -l
   ```

2. **Read scan data** from `decisions/` TSV files:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO
   echo "Skills:" && wc -l decisions/skills-map.tsv
   echo "Agents:" && wc -l decisions/agents-map.tsv
   echo "Commands:" && wc -l decisions/commands-map.tsv
   echo "Hooks:" && wc -l decisions/hooks-map.tsv
   ```

3. **Count conflicts**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO
   tail -n +2 decisions/skills-map.tsv | cut -f1 | sort | uniq -d | wc -l
   ```

4. **Check installed** — compare what's in `~/.claude/skills/`, `~/.claude/agents/`, etc. with what's available in sources.

5. **Check last scan date**:
   ```bash
   ls -la decisions/conflicts-*.md 2>/dev/null | tail -1
   ```

6. **Present dashboard**:

   ```
   === CloaudeCodeCTO Status ===

   Repos:      14 active
   Skills:     X available (Y installed, Z conflicts)
   Agents:     X available (Y installed, Z conflicts)
   Commands:   X available (Y installed)
   Hooks:      X available
   Last Scan:  YYYY-MM-DD
   Decisions:  X resolved, Y pending

   Recent Changes:
   - [date] repo-name: N new components
   ```

7. **Suggest actions** based on status:
   - If never scanned: suggest `/cto-scan`
   - If conflicts pending: suggest `/cto-conflicts`
   - If updates available: suggest `/cto-update`
   - If not installed: suggest `/cto-setup`
