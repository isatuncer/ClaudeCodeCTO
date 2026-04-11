# /cto-sync — Daily Source Sync & Map Update

Run the daily sync process: pull latest from all 15 source repos, re-scan all components, detect new/removed skills/agents/commands, update maps, and generate a change report.

## What It Does

1. **Saves current maps** for comparison
2. **Pulls latest** from all 15 source repos (git fetch + pull)
3. **Re-scans** all skills, agents, commands, hooks
4. **Diffs** previous vs current maps — reports new and removed components
5. **Searches GitHub** for new repos (6 queries: skills, agents, prompts, commands, mcp, awesome)
6. **Updates registry** with real counts per repo
7. **Generates report** at `decisions/reports/sync-{timestamp}.md`

GitHub discovery filters:
- Skips repos already tracked as submodules
- Skips repos with < 100 stars
- Groups by search query for context
- Outputs candidate list at `decisions/reports/discoveries-{date}.md`

## Usage

```
/cto-sync              # Full sync (pull + scan + diff + report)
/cto-sync --scan-only  # Skip git pull, just re-scan and diff
/cto-sync --dry-run    # Preview without changing anything
```

## Execution

Run the daily sync script:

```bash
cd $CTO_ROOT
bash scripts/daily-sync.sh $ARGUMENTS
```

Where `$CTO_ROOT` is the ClaudeCodeCTO installation directory (where setup.sh lives).

After the script completes:

1. Show the user the change summary (new/removed components)
2. If repos were updated, suggest: `bash setup.sh --update` to re-install
3. If new conflicts were found, suggest: `/cto-conflicts` to resolve them

## Output

The sync generates:
- Updated `decisions/skills-map.tsv` — all skills with source, size, line count
- Updated `decisions/agents-map.tsv` — all agents mapped
- Updated `decisions/commands-map.tsv` — all commands mapped
- Updated `decisions/hooks-map.tsv` — all hooks mapped
- Updated `decisions/repo-registry.tsv` — real counts per repo
- New `decisions/reports/sync-{timestamp}.md` — change report with diffs

## Scheduling

For automatic daily sync, add to crontab (Linux/macOS):
```bash
# Run daily at 6 AM
0 6 * * * cd /path/to/ClaudeCodeCTO && bash scripts/daily-sync.sh >> /tmp/cto-sync.log 2>&1
```

Or Windows Task Scheduler:
```
Program: bash
Arguments: /path/to/ClaudeCodeCTO/scripts/daily-sync.sh
Trigger: Daily at 06:00
```
