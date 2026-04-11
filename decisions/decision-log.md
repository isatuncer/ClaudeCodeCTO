# Decision Log — Component Selection Decisions
> This file records which component was selected from which source and why.
> Updated: 2026-04-11
> Updated with weekly scans. Historical records are preserved.

## Decision Format

Each decision is recorded as:
```
### [CATEGORY] component-name
- **Selected:** source-id (score)
- **Alternatives:** source1 (score), source2 (score)
- **Date:** YYYY-MM-DD
- **Reason:** Why this was selected
- **History:** Previous selections if any
```

## Decision States
- **SELECTED** -- Use this source's version
- **KEEP** -- Current (existing) version is better
- **MERGE** -- Combine best parts from both sources
- **TBD** -- Not yet decided (analysis needed)

## Selection Priority Rules

When the same component exists in multiple sources, selection follows this priority:

1. **Content quality** -- more comprehensive and better structured wins
2. **Official source** -- `anthropics/` > community forks (for equal quality)
3. **File size** -- larger = more comprehensive (for same-quality content)
4. **Recency** -- more recently updated
5. **Community validation** -- higher stars/forks

---

## SKILLS Decisions

> Sources: S02 (official), S01 (ECC), S03 (largest pool), S04 (business), S06 (toolkit)
> First scan: 2026-04-09
> Total entries: 2,635 | Unique names: 1,568 | Conflicts: 1,039

### [SKILL] algorithmic-art -- SELECTED
- **Selected:** S02 (88/100) -- 20,173B / 404 lines
- **Alternatives:** S03 (82/100) -- 20,183B / 410 lines
- **Date:** 2026-04-09
- **Reason:** Official Anthropic source. Nearly identical size (10B difference). **Official takes priority** when content is equivalent. S03 version is likely a fork of the official.

### [SKILL] brand-guidelines -- SELECTED
- **Selected:** S03 (82/100) -- 5,702B / 176 lines
- **Alternatives:** S02 (65/100) -- 2,308B / 73 lines
- **Date:** 2026-04-09
- **Reason:** Community version is **2.5x more comprehensive** (176 vs 73 lines). Quality overrides official status. The S02 version covers basics; S03 adds detailed typography, color psychology, and brand voice sections.

### [SKILL] canvas-design -- SELECTED
- **Selected:** S02 (88/100) -- 12,068B / 129 lines
- **Alternatives:** S03 (80/100) -- 12,071B / 135 lines
- **Date:** 2026-04-09
- **Reason:** Nearly identical size (3B difference). **Official source priority** for ties. S03 version is likely a direct fork with no meaningful additions.

### [SKILL] claude-api -- SELECTED
- **Selected:** S02 (92/100) -- 28,997B / 310 lines
- **Alternatives:** S03 (70/100) -- 18,867B / 252 lines
- **Date:** 2026-04-09
- **Reason:** Official source is **53% more comprehensive** (310 vs 252 lines). For Claude API documentation, the official Anthropic source has the most accurate and up-to-date information.

### Non-conflicting skills
- **1,564 unique skills** -- Coming from a single source. Installed automatically with no decision needed.

### Auto-Resolution Rules (for remaining 1,035 conflicts)

The `setup.sh` installer resolves remaining conflicts automatically using the priority rules:

| Scenario | Rule | Example |
|----------|------|---------|
| Same size, one is official | Official wins | S02 > S03 for identical content |
| Community is >50% larger | Community wins | S03 (176 lines) > S02 (73 lines) |
| Same size, same type | Higher-scored source wins | S01 (92) > S06 (68) |
| Different domains | Both installed | S03 (healthcare-ai) + S04 (finance-ai) |

---

## AGENTS Decisions

> Sources: S01 (ECC), S05 (subagents), S06 (toolkit), S04 (business)
> First scan: 2026-04-09
> Total entries: 115 | Unique names: 115 | Conflicts: 1

### Agent Source Selection Reasoning

| Source | Score | Count | Why Selected | What It Provides That Others Don't |
|--------|------:|------:|-------------|-----------------------------------|
| S05 | 74 | 140+ | Categorized subagents across 10 domains | Domain-based categorization (data-ai, devex, security, testing, etc.) |
| S06 | 68 | 135 | Toolkit agents | Working hook examples and context templates |
| S01 | 92 | 47 | Core development agents | Code review, security, TDD, build fix -- development workflow agents |
| S04 | 76 | 26 | Business function agents | C-level advisors, financial analysts, marketing, HR |

### Single Agent Conflict

The 1 agent conflict is between S01 and S06 for a generic utility agent. **S01 selected** (higher overall score, more comprehensive implementation).

---

## COMMANDS Decisions

> Sources: S01 (ECC), S06 (toolkit)
> First scan: 2026-04-09
> Total entries: 144 | Unique names: 136 | Conflicts: 7

### Command Source Selection Reasoning

| Source | Score | Count | Why Selected |
|--------|------:|------:|-------------|
| S01 | 92 | 70+ | Primary command source. Most comprehensive. Includes development workflow commands. |
| S06 | 68 | 10+ | Toolkit commands. Some unique utility commands not in S01. |
| Custom | -- | 13 | ClaudeCodeCTO's own commands (/startCTO, /doc-create, /cto-* ) |

### Conflict Resolution

For 7 command conflicts between S01 and S06:
- **S01 selected for all 7** -- higher overall quality score (92 vs 68), more comprehensive implementations, better documentation.
- S06 unique commands (non-conflicting) are still installed.

---

## HOOKS Decisions

> Sources: S01 (ECC), S14 (continuous), S06 (toolkit)
> First scan: 2026-04-09
> Total entries: 24 | Unique names: 24 | Conflicts: 0

No conflicts detected. All 24 hooks from all sources are unique and installed automatically.

| Source | Hooks | Type |
|--------|------:|------|
| S01 | 12 | Development workflow hooks (auto-format, auto-test) |
| S14 | 8 | Session management hooks (context, handoff, ledger) |
| S06 | 4 | Utility hooks (backup, cleanup) |

---

## PROMPTS Decisions

> Sources: S07 (all AI tools), S08 (coding tools), S09 (Claude Code), S11 (general)
> No conflicts -- each source covers a different domain.

| Source | Score | Content | Domain |
|--------|------:|---------|--------|
| S07 | 95 | 6,500+ system prompts | All AI tools (28+ tools) |
| S11 | 90 | 157+ curated prompts | General purpose, multi-platform |
| S13 | 85 | Techniques + notebooks | Education and engineering |
| S08 | 78 | 28+ tool prompts | AI coding tools specifically |
| S09 | 76 | Full Claude Code breakdown | Claude Code internals |

All 5 prompt sources are complementary with zero overlap. Each covers a distinct domain.

---

## Decision History (Chronological)

| Date | Component | Action | Details |
|------|-----------|--------|---------|
| 2026-04-09 | System | INIT | Initial scan. 15 repos registered. |
| 2026-04-09 | Skills | SCAN | 2,635 entries, 1,568 unique, 1,039 conflicts detected |
| 2026-04-09 | Agents | SCAN | 115 entries, 115 unique, 1 conflict detected |
| 2026-04-09 | Commands | SCAN | 144 entries, 136 unique, 7 conflicts detected |
| 2026-04-09 | Hooks | SCAN | 24 entries, 24 unique, 0 conflicts |
| 2026-04-09 | algorithmic-art | SELECTED | S02 over S03. Official priority. |
| 2026-04-09 | brand-guidelines | SELECTED | S03 over S02. Quality override (2.5x larger). |
| 2026-04-09 | canvas-design | SELECTED | S02 over S03. Official priority. |
| 2026-04-09 | claude-api | SELECTED | S02 over S03. Official + 53% more comprehensive. |
| 2026-04-11 | All categories | UPDATE | Full documentation of all decisions and reasoning. |
