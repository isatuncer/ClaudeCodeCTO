---
description: Search GitHub for new AI coding repos with skills/agents/prompts. Evaluate quality, check language, and optionally add as submodule.
---

# CTO Search

Search GitHub for new repositories that contain AI coding skills, agents, commands, or prompts.

## Arguments

`$ARGUMENTS` is the search query. Examples:
- `/cto-search claude code skills`
- `/cto-search cursor rules collection`
- `/cto-search ai agent framework`
- `/cto-search prompt library coding`

## Steps

1. **Search GitHub** using gh CLI:
   ```bash
   gh search repos "$ARGUMENTS" --sort stars --limit 20 --json fullName,stargazersCount,description,updatedAt,language
   ```

2. **Filter results**:
   - Remove repos with < 50 stars
   - Remove repos where primary language is not English-friendly
   - Remove repos already in our registry
   - Check against `decisions/repo-registry.tsv` for duplicates

3. **Present results** as a ranked table:
   - Repo name, stars, description
   - Whether it contains skills/agents/commands (estimate from description)
   - Language check status
   - Already registered or not

4. **Ask user** which repo(s) to add.

5. **If user selects one**, run:
   ```bash
   cd c:/Users/Dell/Desktop/kisisel/CloaudeCodeCTO && bash scripts/add-repo.sh <selected-repo>
   ```

6. **After adding**, run a quick scan and report findings.

## Search Tips

Suggest these searches if user doesn't provide arguments:
- `claude code skills` — Claude Code specific
- `awesome claude code` — curated lists
- `ai coding agent` — agent frameworks
- `prompt engineering library` — prompt collections
- `mcp server` — MCP tools
- `cursor rules` — IDE rule collections
