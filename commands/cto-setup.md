---
description: Install the best components from all source repos into Claude Code (~/.claude/). Handles conflicts by choosing the best version. Supports dry-run, backup, and category selection.
---

# CTO Setup

Install the best skills, agents, commands, hooks, rules, and prompts from all source repos into your Claude Code installation.

## Arguments

`$ARGUMENTS` can be:
- (empty) — interactive menu
- `--all` — install everything
- `--skills` — only skills
- `--agents` — only agents
- `--commands` — only commands
- `--hooks` — only hooks
- `--rules` — only rules
- `--prompts` — only prompt libraries
- `--dry-run` — show what would be installed without installing
- `--backup` — backup existing files before overwriting

Combine flags: `--all --backup --dry-run`

## Steps

1. **Parse flags** from `$ARGUMENTS`

2. **Run setup**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash setup.sh $ARGUMENTS
   ```

3. **Report results**:
   - How many components installed per category
   - Any conflicts resolved (which version was chosen and why)
   - Any components skipped (and why)

4. **Suggest next steps**:
   - Run `/cto-scan` to verify
   - Run `/cto-update` weekly to stay current

## Conflict Resolution

When two repos have the same component name:
- The **larger file** (more comprehensive) is preferred
- **anthropics/skills** takes priority as official source
- Decisions are logged in `decisions/decision-log.md`
- Previously resolved conflicts use the cached decision

## IMPORTANT

- Never overwrite a better version with a worse one
- Always check `decisions/decision-log.md` for existing decisions before installing
- If `--backup` is used, existing files are saved as `.bak.YYYYMMDD-HHMMSS`
