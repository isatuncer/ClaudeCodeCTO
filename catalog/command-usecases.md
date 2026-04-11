# CTO Command Use Cases

## Use Case Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     USER (Developer)                     │
└───────────┬─────────┬──────────┬──────────┬─────────────┘
            │         │          │          │
    ┌───────▼──┐ ┌────▼────┐ ┌──▼───┐ ┌───▼─────┐
    │ DISCOVER │ │ MANAGE  │ │SETUP │ │ UPDATE  │
    └───┬──────┘ └────┬────┘ └──┬───┘ └───┬─────┘
        │             │         │         │
   ┌────▼────┐   ┌────▼────┐  ┌▼──────┐ ┌▼──────────┐
   │/cto-    │   │/cto-    │  │/cto-  │ │/cto-       │
   │search   │   │list     │  │setup  │ │update      │
   └────┬────┘   └────┬────┘  └──┬───┘ └──────┬─────┘
        │             │          │             │
   ┌────▼────┐   ┌────▼────┐    │        ┌───▼──────┐
   │/cto-    │   │/cto-    │    │        │/cto-      │
   │add      │   │remove   │    │        │scan       │
   └─────────┘   └─────────┘    │        └───┬───────┘
                                │            │
                           ┌────▼────────────▼───┐
                           │   /cto-conflicts    │
                           └──────────┬──────────┘
                                      │
                           ┌──────────▼──────────┐
                           │   /cto-status       │
                           └─────────────────────┘
```

## Detailed Use Case Flows

### UC-1: Discover and Add New Source

```
Actor: Developer
Trigger: Wants to discover new AI coding repos

Flow:
  1. Developer → /cto-search "claude code skills"
  2. System → Searches GitHub API
  3. System → Filters results by stars, language, content
  4. System → Automatically excludes non-English repos
  5. Developer → Selects a repo
  6. Developer → /cto-add owner/repo
  7. System → Clones as submodule
  8. System → Runs language check (>30% non-English → REJECT)
  9. System → Scans content (skill/agent/command counts)
  10. System → Adds to registry
  11. System → Shows results

Alternative Flow (Language Rejection):
  7a. System → Detects non-English repo
  7b. System → Reverts submodule
  7c. System → "REJECTED: Not in English"

Alternative Flow (Already Exists):
  6a. System → Repo already exists
  6b. System → "Try a different alias"
```

### UC-2: Install Components

```
Actor: Developer
Trigger: Wants to install best components to Claude Code

Flow:
  1. Developer → /cto-setup --dry-run
  2. System → Shows what will be installed
  3. System → Shows conflicts
  4. Developer → /cto-setup --all --backup
  5. System → Backs up existing files
  6. System → Selects best version for each category
  7. System → Installs to ~/.claude/
  8. System → Reports skipped components (worse version)
  9. System → Shows installation summary

Alternative Flow (Conflict):
  6a. Same-named component in multiple repos
  6b. System → Checks decision-log.md
  6c. If decision exists → uses that version
  6d. If no decision → selects largest file
```

### UC-3: Resolve Conflicts

```
Actor: Developer
Trigger: Same-named components exist in different repos

Flow:
  1. Developer → /cto-conflicts
  2. System → Lists all conflicts
  3. Developer → /cto-conflicts claude-api
  4. System → Compares both versions side by side
  5. System → Analyzes size, structure, quality
  6. System → Suggests recommendation
  7. Developer → Confirms or overrides
  8. System → Writes to decision-log.md

Decision Criteria (Priority Order):
  1. Content quality
  2. Official source (anthropics/ > community)
  3. File size (larger = more comprehensive)
  4. Recency
  5. Community validation (stars)
```

### UC-4: Weekly Update

```
Actor: Developer (or cron job)
Trigger: Source repos may have been updated

Flow:
  1. Developer → /cto-update
  2. System → git submodule update --remote
  3. System → Compares old vs new commit per repo
  4. System → Detects changed files
  5. System → Runs full scan
  6. System → Lists new components
  7. System → Lists changed components
  8. System → Detects new conflicts
  9. System → Writes to changelog.md
  10. System → Suggests installation if improvements exist
```

### UC-5: System Status

```
Actor: Developer
Trigger: Wants to see overall status

Flow:
  1. Developer → /cto-status
  2. System → Reads repo count
  3. System → Extracts stats from TSV files
  4. System → Compares installed vs available
  5. System → Shows dashboard
  6. System → Lists recommended actions
```

### UC-6: Remove Repo

```
Actor: Developer
Trigger: Decided to remove a source

Flow:
  1. Developer → /cto-remove alias
  2. System → Shows repo info
  3. System → Asks for confirmation
  4. Developer → Confirms
  5. System → Removes submodule
  6. System → Cleans git state
  7. System → Updates registry
  8. System → Reports affected decisions
```

## Command Relationship Matrix

| Command | Triggers | Triggered by |
|---------|----------|------------|
| /cto-search | → cto-add | Manual |
| /cto-add | → scanner.sh | Manual, after search |
| /cto-remove | → scanner.sh | Manual |
| /cto-list | - | Manual |
| /cto-scan | → conflicts report | Manual, after add/update |
| /cto-setup | ← scanner data | Manual, after scan |
| /cto-update | → scanner.sh | Manual, weekly |
| /cto-conflicts | ← scanner data | Manual, after scan |
| /cto-status | ← all data | Manual, always |
