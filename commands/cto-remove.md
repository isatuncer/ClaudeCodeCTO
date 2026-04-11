---
description: Remove a repo from CloaudeCodeCTO. Removes the submodule, cleans git state, and updates registry.
---

# CTO Remove Repo

Remove a previously added repository from the system.

## Arguments

`$ARGUMENTS` should be the alias of the repo to remove.

Example: `/cto-remove my-skills`

## Steps

1. **Parse alias** from `$ARGUMENTS`

2. **Confirm with user** before removing:
   - Show repo URL and what it contains (skills/agents/commands count)
   - Ask "Are you sure you want to remove this repo?"

3. **If confirmed**, run:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/add-repo.sh --remove $ARGUMENTS
   ```

4. **Re-run scanner** to update conflict maps:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/scanner.sh
   ```

5. **Report** what was removed and any impacts on installed components.

## Rules

- Always confirm before removing
- Warn if removing a repo that has components currently installed in `~/.claude/`
- Update decision-log.md if any decisions referenced this repo
