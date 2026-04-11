# Source Analysis — Why We Selected These Sources
> Date: 2026-04-09
> This file documents why each source was selected, contribution stats, and community strength.
> Source IDs (S01-S14) are used instead of repo names.

## Source Evaluation Table

| ID | Score | Stars | Forks | Contributors | Last Update | Selected Components | Selection Rationale |
|----|-------|-------|-------|-------------|-------------|--------------------|--------------------|
| S01 | 92/100 | 147K | 8K+ | 50+ | Active (daily) | 181 skills, 47 agents, 70+ cmds | Most comprehensive single package. Hackathon winner. Daily updates. |
| S02 | 88/100 | 112K | 2K+ | Anthropic team | Active | 17 skills | Official source. Production-ready quality. Every skill tested. |
| S03 | 82/100 | 32K | 3K+ | 30+ | Active (weekly) | 1370+ skills | Largest skill pool. Installer CLI. Multi-platform. |
| S04 | 76/100 | 10K | 1K+ | 15+ | Active | 25 agents | Business function organization. 12 coding agent support. |
| S05 | 74/100 | 17K | 1.5K+ | 20+ | Active | 140+ subagents | Categorized subagent system. 10 domains. |
| S06 | 68/100 | 1.1K | 200+ | 10+ | Active | 35 skills, 135 agents | Compact but complete toolkit. Templates included. |
| S07 | 95/100 | 134K | 10K+ | 100+ | Active (daily) | 6500+ system prompts | Internal prompts from 28+ AI tools. Continuously updated. |
| S08 | 78/100 | 166 | 30+ | 5+ | Active | AI tool prompts | Date-stamped archive. Tool definitions included. |
| S09 | 76/100 | 8.3K | 500+ | 10+ | Active (per version) | Claude Code prompts | 24 built-in tool definitions. Sub-agent prompts. |
| S10 | 84/100 | 38.5K | 5K+ | 200+ | Active | IDE rules | Largest Cursor rule collection. |
| S11 | 90/100 | 143K | 15K+ | 500+ | Active | 157+ prompts | Academic reference. Harvard/Columbia cited. |
| S12 | 80/100 | 37.5K | 3K+ | 30+ | Active | Curated directory | For discovering new sources. |
| S13 | 85/100 | 73K | 8K+ | 100+ | Active | Technical guide | CoT, few-shot, RAG techniques. Website included. |
| S14 | 72/100 | 3.7K | 400+ | 10+ | Active | Hook patterns | Context management. Ledger system. |

## Community Strength Comparison

```
Community Strength (Stars + Forks + Contributors composite score)

S01  ████████████████████████████████████████░░░░░  88%  (147K★)
S07  ██████████████████████████████████████████████  95%  (134K★)
S11  ████████████████████████████████████████████░░  92%  (143K★)
S02  ███████████████████████████████████████░░░░░░░  85%  (112K★)
S13  ██████████████████████████████████░░░░░░░░░░░░  78%  (73K★)
S10  ██████████████████████████████░░░░░░░░░░░░░░░░  72%  (38.5K★)
S12  █████████████████████████████░░░░░░░░░░░░░░░░░  70%  (37.5K★)
S03  ████████████████████████░░░░░░░░░░░░░░░░░░░░░░  58%  (32K★)
S05  ██████████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░  42%  (17K★)
S04  ████████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  28%  (10K★)
S09  ██████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  15%  (8.3K★)
S14  ███░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  8%   (3.7K★)
S06  █░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  3%   (1.1K★)
S08  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  <1%  (166★)
```

## Component Distribution (What Comes From Where)

```
Skills (1,575 unique):
  S03 ████████████████████████████████████  1370+  (largest pool)
  S01 ██████████████                        181    (highest quality)
  S04 ████████                              220+   (business-focused)
  S06 ██                                    35     (toolkit)
  S02 █                                     17     (official reference)

Agents (300+):
  S05 ████████████████████                  140+   (categorized)
  S06 ████████████████████████████████████  135    (toolkit)
  S01 ███████████                           47     (core)
  S04 ██████                                26     (business function)

Commands (70+):
  S01 ██████████████████████████████████    70+    (single source)

Prompts (6800+):
  S07 ██████████████████████████████████    6500+  (all AI tools)
  S11 ██                                    157+   (general reference)
  S09 █                                     Full   (Claude Code specific)
  S08 █                                     28+    (coding tool specific)

Rules:
  S10 ████████████████████████████████████  38.5K★ (IDE rules)
  S01 ████████████                          76 rules, 13 languages
```

## Update Frequency

| ID | Last Commit | Update Frequency | Active Contributors (last 30 days) |
|----|------------|------------------|------------------------------------|
| S01 | Last 24 hours | Daily | 5-10 |
| S02 | Last week | Weekly | Anthropic team |
| S03 | Last 3 days | Weekly | 3-5 |
| S07 | Last 24 hours | Daily | 10+ |
| S09 | Last week | Per version | 2-3 |
| S10 | Last 3 days | Weekly | 10+ |
| S11 | Last week | Weekly | 20+ |
| S13 | Last week | Weekly | 5-10 |

## Summary

When a developer downloads this repo:
1. **1,575 skills** — best versions pre-selected from conflicts
2. **263 agents** — ready and categorized
3. **6500+ system prompts** — full competitor analysis
4. **Conflicts resolved** — best version chosen for same-named components
5. **One-command install** — `bash setup.sh --all`
6. **Weekly updates** — system stays current as sources update
