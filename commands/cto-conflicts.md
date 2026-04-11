---
description: Show and resolve naming conflicts — same-named skills/agents/commands from different repos. Compare content, recommend best version, update decision log.
---

# CTO Conflicts

Analyze and resolve naming conflicts between source repos.

## Arguments

`$ARGUMENTS` (optional): specific component name to analyze, e.g. `claude-api`

## Steps

### If no arguments — show all conflicts:

1. **Read conflict data**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO
   cat decisions/skills-map.tsv | sort -t$'\t' -k1,1 | uniq -d -f0
   ```

2. **For each conflict**, read both versions and compare:
   - File size and line count
   - Content structure (sections, depth)
   - Source repo reputation
   - Last modified date

3. **Present** a table of all conflicts with recommendation.

4. **Ask user** to confirm or override each decision.

5. **Update** `decisions/decision-log.md` with final decisions.

### If specific component name provided:

1. **Find all versions** of that component across repos:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO
   grep "^$ARGUMENTS" decisions/skills-map.tsv decisions/agents-map.tsv decisions/commands-map.tsv
   ```

2. **Read and compare** the actual file contents side by side.

3. **Analyze differences**:
   - Which has more comprehensive instructions
   - Which has better examples
   - Which is more up-to-date
   - Which follows better prompt engineering practices

4. **Recommend** the better version with clear reasoning.

5. **If user confirms**, update `decisions/decision-log.md`.

## Decision Criteria (Priority Order)

1. **Content quality** — More comprehensive, better structured, better examples
2. **Official source** — anthropics/ repos take priority over community forks
3. **File size** — Larger typically means more comprehensive (but not always)
4. **Recency** — More recently updated versions preferred
5. **Community validation** — Higher-star repos get slight preference
