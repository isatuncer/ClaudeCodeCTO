---
description: Add a new GitHub repo to CloaudeCodeCTO for scanning and installation. Validates language (English only), clones as submodule, scans content, detects conflicts.
---

# CTO Add Repo

Add a new GitHub repository as a source for skills, agents, commands, hooks, or prompts.

## Arguments

`$ARGUMENTS` should be a GitHub repo in `owner/repo` format or full URL. Optionally followed by an alias.

Examples:
- `/cto-add user/awesome-skills`
- `/cto-add https://github.com/user/repo my-alias`

## Steps

1. **Parse arguments** from `$ARGUMENTS`:
   - First arg: GitHub URL or `owner/repo`
   - Second arg (optional): alias name

2. **Run the add-repo script**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/add-repo.sh $ARGUMENTS
   ```

3. **If the script succeeds**, run a quick scan to show what was added:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/scanner.sh
   ```

4. **Report results** to the user:
   - How many skills, agents, commands were found
   - Any conflicts with existing components
   - Suggest running `/cto-setup` to install

5. **If the script fails** (non-English repo, invalid URL, already exists):
   - Show the error clearly
   - Suggest alternatives

## Rules

- ONLY English repos are accepted. Non-English repos are automatically rejected.
- The repo is added as a git submodule under `sources/`
- Conflicts are detected but NOT resolved automatically — use `/cto-conflicts` for that
- Registry is updated at `decisions/repo-registry.tsv`
