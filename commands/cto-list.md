---
description: List all registered repos in CloaudeCodeCTO with their status, content counts, and last update.
---

# CTO List Repos

Show all registered source repositories and their status.

## Steps

1. **Run list command**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/add-repo.sh --list
   ```

2. **Also show summary stats** by reading the registry:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && cat decisions/repo-registry.tsv
   ```

3. **Present** a clean table to the user showing:
   - Alias
   - GitHub URL
   - Date added
   - Status (active/removed)
   - Skills / Agents / Commands count
   - Notes

4. **Show total counts** across all repos.
