---
description: Update all source repos (git submodule update), re-scan for changes, detect new/modified components, and report what changed since last scan.
---

# CTO Update

Pull latest changes from all source repos and re-scan for new or modified components.

## Steps

1. **Update all submodules**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && git submodule update --remote --merge 2>&1
   ```

2. **Run full scanner**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/scanner.sh
   ```

3. **Compare with previous scan** — read previous and current TSV files:
   - New skills/agents/commands added
   - Existing components modified (size changed)
   - Removed components
   - New conflicts introduced

4. **Update changelog**:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/weekly-scan.sh
   ```

5. **Report to user**:
   - Which repos had updates
   - How many new components found
   - Any new conflicts that need resolution
   - Suggest `/cto-setup --all --backup` if there are improvements to install

6. **Update decision-log.md** if any previously resolved conflicts have new versions that might be better.

## When to Run

- Weekly recommended
- After adding a new repo with `/cto-add`
- When you suspect upstream repos have been updated
