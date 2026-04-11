# Scoring & Selection Decisions
> Date: 2026-04-09 (updated 2026-04-11)
> Scoring: Out of 100
> Criteria: Content Quality (30) + Coverage (20) + Freshness (15) + Community Strength (15) + Contributors (10) + Usability (10)

## Scoring Criteria

| Criterion | Weight | Description |
|-----------|-------:|-------------|
| Content Quality | /30 | Prompt/skill/agent structure, detail level, examples |
| Coverage | /20 | Number of components, scope breadth |
| Freshness | /15 | Last update, active development |
| Community Strength | /15 | Stars, forks, issue/PR activity |
| Contributors | /10 | Unique contributors, bus factor |
| Usability | /10 | Ease of installation, documentation |

---

## Category 1: Skills & Agent Sources

### S01 — Everything Claude Code (Score: 92/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 28/30 | Well-structured SKILL.md files with frontmatter. Clear descriptions and examples. |
| Coverage | 20/20 | 181 skills + 47 agents + 70+ commands. Only source with all three component types. |
| Freshness | 14/15 | Daily updates. Most active community repo. |
| Community | 12/15 | 147K stars, 8K+ forks. Hackathon winner. |
| Contributors | 8/10 | 50+ contributors. Active PR review process. |
| Usability | 10/10 | Drop-in compatible with Claude Code. No modification needed. |

**Why Selected:** Most comprehensive single package. The only source that provides skills, agents, AND commands together. Daily updates ensure freshness.

**Alternative Considered:** S06 (rohitg00-toolkit, 68/100)
**Why Not:** 6x fewer skills (35 vs 181), no commands at all, lower content quality. S06 is still included for its unique agent collection.

---

### S02 — Anthropic Official Skills (Score: 88/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 30/30 | Perfect quality. Official Anthropic team. Production-ready. |
| Coverage | 12/20 | Only 17 skills. Limited scope. |
| Freshness | 14/15 | Active development by Anthropic team. |
| Community | 15/15 | 112K stars. Official repository. |
| Contributors | 10/10 | Anthropic engineering team. Highest trust. |
| Usability | 7/10 | Standard structure but no agents or commands. |

**Why Selected:** Reference quality standard. Every skill is tested and production-ready. Official source takes priority in conflicts.

**Alternative Considered:** No alternative exists for official Anthropic skills.
**Why Not:** N/A — only official source.

---

### S03 — Antigravity Awesome Skills (Score: 82/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 22/30 | Variable quality. Some excellent, some thin. |
| Coverage | 20/20 | 1,370+ skills. Largest pool by far. Covers niche domains (logistics, healthcare, IoT, gaming, fintech). |
| Freshness | 12/15 | Weekly updates. Active community. |
| Community | 12/15 | 32K stars, 3K+ forks. |
| Contributors | 6/10 | 30+ contributors but quality varies. |
| Usability | 10/10 | Includes installer CLI. Multi-platform support. |

**Why Selected:** Largest skill pool. Only source covering niche domains like healthcare, logistics, IoT. Installer CLI included.

**Alternative Considered:** Individual niche repos (e.g., separate healthcare, logistics, gaming repos)
**Why Not:** No single alternative covers this breadth. Would require 50+ repos to match coverage. Installer CLI is a bonus.

---

### S04 — Alirezarezvani Claude Skills (Score: 76/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 24/30 | Good business focus. Well-organized by function. |
| Coverage | 16/20 | 25 agents. 12 coding agent support. |
| Freshness | 12/15 | Active updates. |
| Community | 10/15 | 10K stars, 1K+ forks. |
| Contributors | 6/10 | 15+ contributors. |
| Usability | 8/10 | Organized by business function (C-level, finance, marketing). |

**Why Selected:** Business function organization not found elsewhere. C-level, finance, marketing, HR skills. 12 coding agent support.

**Alternative Considered:** enterprise-ai-prompts
**Why Not:** Less structured. No agents included. Fewer business domains covered. Lower community adoption.

---

### S05 — VoltAgent Subagents (Score: 74/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 20/30 | Clean structure but formulaic format. |
| Coverage | 18/20 | 140+ subagents across 10 domains. |
| Freshness | 12/15 | Active development. |
| Community | 12/15 | 17K stars, 1.5K+ forks. |
| Contributors | 6/10 | 20+ contributors. |
| Usability | 6/10 | Requires adaptation for some use cases. |

**Why Selected:** Categorized subagent system. 10 distinct domains. Clean category structure.

**Alternative Considered:** Building agents manually from scratch.
**Why Not:** Would take weeks to create and test. S05 agents are community-tested and categorized.

---

### S06 — Rohitg00 Toolkit (Score: 68/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 18/30 | Adequate quality. Some entries thin. |
| Coverage | 16/20 | 135 agents + 35 skills. Hooks, contexts, templates. |
| Freshness | 10/15 | Active but less frequent updates. |
| Community | 8/15 | 1.1K stars. Smaller community. |
| Contributors | 8/10 | 10+ contributors. |
| Usability | 8/10 | Compact. Good quick-start kit. |

**Why Selected:** Compact but complete toolkit. Includes working hook examples and context templates not found elsewhere.

**Alternative Considered:** Starting from scratch.
**Why Not:** Saves 20+ hours of initial setup. Includes working hook examples and context templates.

---

## Category 2: Prompt Libraries

### S07 — AI Tool System Prompts Collection (Score: 95/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 28/30 | Real system prompts extracted from production AI tools. |
| Coverage | 20/20 | 6,500+ prompts from 28+ tools (Cursor, Devin, Kiro, Lovable, Manus, Perplexity, Replit, Windsurf, v0, Xcode, etc.) |
| Freshness | 15/15 | Daily updates. New tools added regularly. |
| Community | 15/15 | 134K stars, 10K+ forks. Massive community. |
| Contributors | 10/10 | 100+ contributors. Crowd-sourced verification. |
| Usability | 7/10 | Raw prompts need context. No installer. |

**Why Selected:** Most comprehensive AI tool prompt collection. Competitor analysis gold mine. Daily updates capture the latest from 28+ tools.

**Alternative Considered:** leaked-system-prompts (3.2K stars)
**Why Not:** Only covers 4 models (GPT, Claude, Gemini, Grok). No tool-level prompts. Infrequent updates. Missing coding tool coverage entirely.

---

### S11 — Awesome ChatGPT Prompts (Score: 90/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 30/30 | Academic-grade. Harvard/Columbia referenced. |
| Coverage | 14/20 | 157+ curated prompts. Multi-platform. |
| Freshness | 13/15 | Weekly updates. Active community. |
| Community | 15/15 | 143K stars, 15K+ forks. Largest prompt repo. |
| Contributors | 10/10 | 500+ contributors. |
| Usability | 8/10 | Well-organized. Multi-language support. |

**Why Selected:** World's largest open-source prompt library. Academic reference quality. Multi-platform (ChatGPT, Claude, Gemini, Llama, Mistral).

**Alternative Considered:** FlowGPT platform
**Why Not:** Closed platform. No git integration. Cannot be submoduled. Content quality unverified.

---

### S13 — Prompt Engineering Guide (Score: 85/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 28/30 | Comprehensive techniques with examples and notebooks. |
| Coverage | 16/20 | CoT, few-shot, RAG, context engineering, agents. |
| Freshness | 14/15 | Active. promptingguide.ai website maintained. |
| Community | 12/15 | 73K stars, 8K+ forks. |
| Contributors | 8/10 | 100+ contributors. |
| Usability | 7/10 | Website + Jupyter notebooks. Educational format. |

**Why Selected:** Comprehensive prompt engineering techniques. Jupyter notebooks for hands-on learning. Techniques directly applicable to skill writing.

**Alternative Considered:** LearnPrompting.org
**Why Not:** Less code-focused. No git repo to submodule. Website-only content cannot be included.

---

### S08 — AI Coding Tool Prompts (Score: 78/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 26/30 | Date-stamped. Tool definitions included. |
| Coverage | 14/20 | 28+ coding tool prompts. |
| Freshness | 12/15 | Active with version tracking. |
| Community | 10/15 | 166 stars. Small but focused. |
| Contributors | 8/10 | 5+ dedicated contributors. |
| Usability | 8/10 | Well-organized per-tool structure. |

**Why Selected:** Date-stamped system prompt archive. Version tracking enables evolution analysis. Per-tool definitions not available elsewhere.

**Alternative Considered:** Individual vendor documentation
**Why Not:** Scattered across vendor sites. No unified archive. No version comparison possible. No single source of truth.

---

### S09 — Claude Code System Prompts (Score: 76/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 24/30 | Accurate breakdown of Claude Code internals. |
| Coverage | 12/20 | Claude Code specific only. |
| Freshness | 13/15 | Updated per Claude Code version. |
| Community | 10/15 | 8.3K stars, 500+ forks. |
| Contributors | 8/10 | 10+ contributors. |
| Usability | 9/10 | Well-structured. Version-tracked. |

**Why Selected:** Complete Claude Code system prompt breakdown. 24 built-in tool definitions. Sub-agent prompts. Essential for understanding and extending Claude Code.

**Alternative Considered:** Reverse-engineering Claude Code yourself
**Why Not:** Fragile approach. Breaks on updates. S09 is maintained and version-tracked by the community.

---

## Category 3: IDE Rules & Config

### S10 — Awesome CursorRules (Score: 84/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 24/30 | High-quality IDE rules. Many community-tested. |
| Coverage | 18/20 | Largest collection. Multi-framework. |
| Freshness | 13/15 | Weekly updates. |
| Community | 14/15 | 38.5K stars, 5K+ forks. |
| Contributors | 8/10 | 200+ contributors. |
| Usability | 7/10 | Cursor format needs adaptation for Claude Code. |

**Why Selected:** Largest IDE rule collection. Rules adaptable to Claude Code CLAUDE.md format. Multi-framework coverage.

**Alternative Considered:** awesome-copilot-rules
**Why Not:** 5x smaller collection. Only Copilot-focused. Less community validation. Narrower framework coverage.

---

## Category 4: Hooks & Observability

### S14 — Continuous Claude v3 (Score: 72/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 22/30 | Good hook patterns. Ledger system innovative. |
| Coverage | 14/20 | Context management focused. |
| Freshness | 12/15 | Active development. |
| Community | 10/15 | 3.7K stars, 400+ forks. |
| Contributors | 6/10 | 10+ contributors. |
| Usability | 8/10 | Well-documented hook examples. |

**Why Selected:** Context management via hooks. Ledger + handoff system for long sessions. Battle-tested patterns.

**Alternative Considered:** Custom hook scripts
**Why Not:** Unproven patterns. S14 is battle-tested in production. Ledger system is innovative and hard to replicate.

---

## Category 5: Curated Directories

### S12 — Awesome Claude Code (Score: 80/100)

| Criterion | Score | Reasoning |
|-----------|------:|-----------|
| Content Quality | 22/30 | Well-organized directory. Good categorization. |
| Coverage | 18/20 | Comprehensive Claude Code ecosystem directory. |
| Freshness | 13/15 | Actively maintained. |
| Community | 14/15 | 37.5K stars, 3K+ forks. |
| Contributors | 6/10 | 30+ contributors. |
| Usability | 7/10 | Discovery resource, not components. |

**Why Selected:** Best discovery resource for finding new Claude Code repos. Ongoing reference for weekly scans.

**Alternative Considered:** awesome-ai-agents
**Why Not:** Different scope (general AI agents, not Claude Code specific). Would need heavy filtering. Less actionable.

---

## Overall Ranking — Top 14 Sources

| Rank | ID | Score | Primary Value | Selected Components |
|-----:|:---|------:|--------------|-------------------|
| 1 | S07 | **95** | Competitor analysis (28+ AI tools) | 6,500+ system prompts |
| 2 | S01 | **92** | Most comprehensive package | 181 skills, 47 agents, 70+ commands |
| 3 | S11 | **90** | Academic reference library | 157+ curated prompts |
| 4 | S02 | **88** | Official quality standard | 17 official skills |
| 5 | S13 | **85** | Prompt engineering education | Techniques + notebooks |
| 6 | S10 | **84** | IDE rule adaptation | IDE rules collection |
| 7 | S03 | **82** | Largest skill pool | 1,370+ skills |
| 8 | S12 | **80** | Discovery directory | Curated links |
| 9 | S08 | **78** | Version-tracked tool prompts | AI coding tool prompts |
| 10 | S04 | **76** | Business function skills | 25 agents |
| 11 | S09 | **76** | Claude Code internals | System prompt + 24 tools |
| 12 | S05 | **74** | Categorized subagents | 140+ subagents |
| 13 | S14 | **72** | Hook patterns | Context management |
| 14 | S06 | **68** | Quick-start toolkit | 35 skills, 135 agents |

---

## Prompt Libraries — Selected vs Rejected

### Selected (5 sources — included as submodules)

| ID | Score | Items | Why Selected |
|:---|------:|------:|-------------|
| S07 | 95 | 6,500+ | All AI tool system prompts. Competitor analysis. Daily updates. |
| S11 | 90 | 157+ | Academic reference. 143K stars. Multi-platform. |
| S13 | 85 | full | Prompt engineering techniques. Jupyter notebooks. |
| S08 | 78 | 28+ | Date-stamped tool prompts. Version evolution tracking. |
| S09 | 76 | full | Claude Code internals. 24 tool definitions. |

### Evaluated but NOT Selected (14 libraries)

| Library | Score | Why Rejected |
|---------|------:|-------------|
| Anthropic Prompt Tutorial | 80 | Accessible via Anthropic docs website. Not a component source. |
| AI Coding Prompts (500+) | 60 | Framework-specific. S03 skills cover all these with more depth. |
| GPT Store Prompts | 60 | GPT-specific. Not directly usable in Claude. Patterns covered by S07. |
| Prompt Master Skill | 65 | Single skill. S01 already includes prompt-related skills. |
| ChatGPT System Prompts | 55 | Security/injection focused. Narrow scope. S07 already covers. |
| Templated Prompts | 55 | Low adoption (1.6K stars). Experimental. Template format adds complexity. |
| Leaked Model Prompts | 55 | Only 4 models. S07 tracks these plus 24+ more. Ethically questionable. |
| Big Prompt Library | 50 | Mixed quality. Security perspective already covered by included sources. |
| Top GPT Store | 50 | Academic/research angle but GPT-specific. |
| Bulk Prompts (100K+) | 45 | Quantity over quality. No curation. Would add noise. |
| GPT Super Prompting | 40 | Offensive security content. Defensive value covered by S07. |
| Awesome LLM Prompts | 35 | Meta-index only. Used during research, no components. |
| Awesome GPT Prompt Eng | 35 | Resource list only. S13 covers education better. |
| Curated AI System Prompts | 65 | Smaller subset of S07 (11 tools vs 28+). Not enough unique value. |

Full prompt library map: [`catalog/prompt-libraries-map.tsv`](prompt-libraries-map.tsv)

---

## Conflict Decisions

### Skills Conflicts (First Scan: 1,039 conflicts)

| Skill | Selected | Score | Alternative | Alt Score | Reason |
|-------|----------|------:|-------------|----------:|--------|
| `algorithmic-art` | S02 (Official) | 88 | S03 (Community) | 82 | Same size (404 vs 410 lines). **Official takes priority** for equivalent content. |
| `brand-guidelines` | S03 (Community) | 82 | S02 (Official) | 65 | Community is **2.5x more comprehensive** (176 vs 73 lines). Quality wins over official status. |
| `canvas-design` | S02 (Official) | 88 | S03 (Community) | 80 | Same size. **Official priority** for ties. Community version is likely a fork. |
| `claude-api` | S02 (Official) | 92 | S03 (Community) | 70 | Official is **53% more comprehensive** (310 vs 252 lines). For Claude API, official is most accurate. |

> Remaining 1,035 skill conflicts are resolved automatically by the setup script using the priority rules above.

### Summary

| Category | Total | Unique | Conflicts | Auto-Install |
|----------|------:|-------:|----------:|-------------:|
| Skills | 2,635 | 1,568 | 1,039 | 1,564 |
| Agents | 115 | 115 | 1 | 114 |
| Commands | 144 | 136 | 7 | 129 |
| Hooks | 24 | 24 | 0 | 24 |
