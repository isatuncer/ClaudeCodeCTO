# ClaudeCodeCTO

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux%20%7C%20Windows-brightgreen.svg)](#installation)
[![Skills](https://img.shields.io/badge/Skills-1%2C575-orange.svg)](#whats-included)
[![Agents](https://img.shields.io/badge/Agents-263-purple.svg)](#whats-included)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Required-black.svg)](https://claude.ai/code)

> Turn Claude Code into a full CTO that runs your software company.
> 1,575 skills, 263 agents, 69 document templates, 72 enterprise standards.
> One command. Any OS.

[English](README.md) | [Turkce](docs/i18n/README.tr.md) | [Deutsch](docs/i18n/README.de.md) | [Espanol](docs/i18n/README.es.md) | [Francais](docs/i18n/README.fr.md) | [Italiano](docs/i18n/README.it.md) | [Portugues](docs/i18n/README.pt-BR.md) | [Русский](docs/i18n/README.ru.md) | [日本語](docs/i18n/README.ja.md) | [中文](docs/i18n/README.zh-CN.md) | [한국어](docs/i18n/README.ko.md) | [हिन्दी](docs/i18n/README.hi.md) | [العربية](docs/i18n/README.ar.md)

---

## What Is This?

ClaudeCodeCTO aggregates the **best AI coding components** from 15 curated GitHub repositories, resolves naming conflicts, and installs them into Claude Code with a single command. After setup, Claude Code becomes an **enterprise-grade CTO** that can:

- Plan projects from scratch with proper documentation (SRS, HLD, ADR, Test Plans)
- Generate **69 types** of professional documents and export them to PDF/DOCX
- Write code following TDD, run security scans, create CI/CD pipelines
- Act as **20 different expert roles** (architect, QA lead, DevSecOps, business analyst...)
- Follow **72 enterprise standards** (ISO 27001, IEEE, OWASP, NIST, DORA, CMMI)
- Create **30 types** of Mermaid diagrams (C4, ER, sequence, deployment)

**You don't need to know which skill/agent/prompt to use.** Claude knows. Just describe what you want.

---

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [What's Included](#whats-included)
- [How to Use](#how-to-use)
- [Slash Commands Reference](#slash-commands-reference)
- [10-Phase Delivery Pipeline](#10-phase-delivery-pipeline)
- [Document Codes](#document-codes)
- [Source Repositories & Scoring](#source-repositories--scoring)
- [Component Scoring & Selection](#component-scoring--selection)
- [Project Structure](#project-structure)
- [Keeping Up to Date](#keeping-up-to-date)
- [Uninstall](#uninstall)
- [Contributing](#contributing)
- [License](#license)

---

## Installation

### Prerequisites

| Requirement | How to Install |
|-------------|---------------|
| **Git** | macOS: `brew install git` / Linux: `sudo apt install git` / Windows: [git-scm.com](https://git-scm.com/download/win) |
| **Claude Code** | `npm install -g @anthropic-ai/claude-code` ([docs](https://docs.anthropic.com/en/docs/claude-code)) |
| **pandoc** *(optional, for PDF/DOCX export)* | macOS: `brew install pandoc` / Linux: `sudo apt install pandoc` / Windows: `choco install pandoc` |

### Step 1: Clone

```bash
git clone --recursive https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
```

> **Note:** The `--recursive` flag is required to download all 15 source repositories as submodules. If you forgot it, run: `git submodule update --init --recursive`

### Step 2: Install

```bash
bash setup.sh --all
```

That's it. All 1,575 skills, 263 agents, 137 commands, and enterprise templates are now installed to `~/.claude/`.

### Platform Support

| Platform | Shell | Status |
|----------|-------|--------|
| **macOS** | Terminal / iTerm2 | Fully supported |
| **Linux** (Ubuntu, Debian, Fedora, Arch) | bash / zsh | Fully supported |
| **Windows** (Git Bash) | Git Bash | Fully supported |
| **Windows** (WSL) | bash / zsh | Fully supported (auto-detects Windows-side Claude) |
| **Windows** (MSYS2) | bash | Fully supported |

### Setup Options

```bash
bash setup.sh                # Interactive mode (choose what to install)
bash setup.sh --all          # Install everything
bash setup.sh --update       # Pull latest + re-scan + re-install (self-updating)
bash setup.sh --status       # Quick status check (from manifest, no scanning)
bash setup.sh --skills       # Install skills only
bash setup.sh --agents       # Install agents only
bash setup.sh --commands     # Install commands only
bash setup.sh --hooks        # Install hooks only
bash setup.sh --rules        # Install rules only
bash setup.sh --prompts      # Install prompt libraries only
bash setup.sh --dry-run      # Preview without installing
bash setup.sh --backup       # Backup existing files before install
bash setup.sh --all --backup # Install everything with backup
bash setup.sh --uninstall           # Remove ALL installed components
bash setup.sh --uninstall skills    # Remove skills only
bash setup.sh --uninstall agents    # Remove agents only
bash setup.sh --uninstall prompts   # Remove prompts only
bash setup.sh --uninstall enterprise # Remove enterprise templates/standards
```

---

## Quick Start

```bash
# Go to any project directory (new or existing)
cd ~/my-project

# Launch CTO mode
/startCTO
```

Claude scans the project, builds a plan, and starts executing. You approve each major step.

---

## What's Included

After `bash setup.sh --all`, these get installed to `~/.claude/`:

| Category | Count | Description |
|----------|------:|-------------|
| **Skills** | 1,575 | Coding patterns for every language, framework, and domain |
| **Agents** | 263 | Specialized agents (code review, security, TDD, build fix, architect) |
| **Commands** | 137 | Slash commands including `/startCTO`, `/doc-create`, `/cto-*` |
| **Hooks** | 23+ | Auto-format, auto-test, context management, session continuity |
| **Rules** | 76+ | Coding standards for 13+ programming languages |
| **Prompts** | 6,800+ | System prompts from 28+ AI tools for reference and analysis |
| **Templates** | 69 | Enterprise document templates (SRS, HLD, ADR, Test Plan, Threat Model...) |
| **Diagrams** | 30 | Mermaid diagram templates (C4, ER, sequence, deployment, infra) |
| **Standards** | 72 | Enterprise standards (ISO 27001, IEEE, NIST, OWASP, DORA, CMMI) |
| **Roles** | 20 | Expert role definitions (CTO, architect, QA lead, DevSecOps...) |
| **CTO Brain** | 1 | Operating instructions that make Claude act as an enterprise CTO |

---

## How to Use

### 1. CTO Mode (`/startCTO`)

Open Claude Code in **any** project directory and type:

```
/startCTO
```

Claude takes over:

1. **Scans the project** -- detects files, stack, tests, docs, CI/CD
2. **Classifies the state** -- EMPTY, INITIALIZED, IN_DEVELOPMENT, or MATURE
3. **Builds an action plan** -- prioritized step-by-step checklist
4. **Asks your format preference** -- Markdown only, +PDF, or +PDF+DOCX
5. **Executes step by step** -- asking approval only at major gates
6. **Tracks progress** -- shows completed and pending steps

#### Empty Project Example

```
You:    /startCTO

Claude: +---------------------------------------+
        |     CTO MODE -- Project Analysis      |
        +---------------------------------------+
        |  State:   EMPTY                       |
        |  Files:   0                           |
        +---------------------------------------+

        My plan:
          1. [ ] Define project scope
          2. [ ] Set up project structure
          3. [ ] Generate Project Charter
          4. [ ] Generate Business Requirements
          5. [ ] Design architecture
          6. [ ] Design database
          7. [ ] Design API
          8. [ ] Set up CI/CD
          9. [ ] Begin development (TDD)
          10.[ ] Testing & security

        Document format?
          a) Markdown only
          b) Markdown + PDF
          c) Markdown + PDF + DOCX

        Shall I start?

You:    b, start

Claude: What are we building? One-line description and preferred stack.

You:    E-commerce platform. Next.js, PostgreSQL, Stripe.

Claude: --- Step 1/10: Defining project scope ---
        > Project: E-commerce Platform
        > Stack: Next.js + PostgreSQL + Stripe
        > Scope documented

        --- Step 2/10: Creating project structure ---
        > Directory structure created
        > Git initialized
        > package.json created

        --- Step 3/10: Generating Project Charter ---
        > docs/v1.0/project-management/PROJECT_CHARTER_v1.0.md
        > docs/v1.0/project-management/PROJECT_CHARTER_v1.0.pdf

        Step 3 complete. Moving to Step 4: BRD.
        Proceed? [Y/n]
```

#### Existing Codebase Example

```
You:    /startCTO

Claude: +---------------------------------------+
        |     CTO MODE -- Project Analysis      |
        +---------------------------------------+
        |  State:   IN_DEVELOPMENT              |
        |  Stack:   Django + PostgreSQL          |
        |  Files:   127 source, 12 tests        |
        |  Coverage: 24% (target: 80%)          |
        |  Docs:    0 (needs everything)        |
        |  CI/CD:   none                        |
        +---------------------------------------+

        My plan:
          1. [ ] Generate architecture docs from code
          2. [ ] Generate API docs from Django routes
          3. [ ] Create test coverage (24% -> 80%)
          4. [ ] Set up CI/CD pipeline
          5. [ ] Security scan + threat model
          6. [ ] Deployment documentation
          7. [ ] Developer guide

        Document format? [a/b/c]
```

### 2. Generate Documents (`/doc-create`)

```
/doc-create SRS          # Software Requirements Specification
/doc-create HLD          # High Level Design
/doc-create ADR          # Architecture Decision Record
/doc-create TP           # Test Plan
/doc-create API          # API Specification
/doc-create TM           # Threat Model
/doc-create DB           # Database Design
/doc-create UAT          # User Acceptance Test Plan
```

### 3. Export to PDF/DOCX (`/doc-export`)

```
/doc-export docs/v1.0/requirements/SRS_v1.0.md           # PDF + DOCX
/doc-export docs/v1.0/architecture/HLD_v1.0.md --pdf      # PDF only
/doc-export docs/latest/ --all                             # Export all docs
```

Documents are versioned automatically:
```
docs/
+-- v1.0/
|   +-- requirements/
|   |   +-- SRS_v1.0.md
|   |   +-- SRS_v1.0.pdf
|   |   +-- SRS_v1.0.docx
|   +-- architecture/
|   |   +-- HLD_v1.0.md
|   |   +-- HLD_v1.0.pdf
|   +-- testing/
|       +-- TEST_PLAN_v1.0.md
+-- v1.1/
|   +-- requirements/
|       +-- SRS_v1.1.md        # updated version
+-- latest/ -> v1.1
```

### 4. Document Coverage Report (`/doc-list`)

```
/doc-list
```

Shows which documents exist, their versions, and what's missing:

```
| Category      | Document    | Version | Status   | PDF | DOCX |
|---------------|-------------|---------|----------|-----|------|
| Requirements  | SRS         | v1.2    | Approved | Y   | Y    |
| Requirements  | BRD         | v1.0    | Draft    | N   | N    |
| Architecture  | HLD         | --      | MISSING  | --  | --   |
| Testing       | Test Plan   | v1.0    | Review   | Y   | N    |

Coverage: 12/69 templates used (17%)
Missing critical: HLD, LLD, ADR, API Spec, Threat Model
```

### 5. Manage Skill Sources

```
/cto-status              # System dashboard
/cto-search "react"      # Find new repos on GitHub
/cto-add owner/repo      # Add a new source (English only)
/cto-update              # Update all 15 sources
/cto-scan                # Re-scan for conflicts
/cto-conflicts           # Resolve same-named components
```

---

## Slash Commands Reference

### CTO Command

| Command | Description |
|---------|-------------|
| `/startCTO` | Launch autonomous CTO mode -- scans project, builds plan, executes step by step |

### Document Commands

| Command | Description |
|---------|-------------|
| `/doc-create <CODE>` | Generate a document from template (see [Document Codes](#document-codes)) |
| `/doc-export <file>` | Export Markdown to PDF and/or DOCX |
| `/doc-list` | Show all documents and coverage stats |

### Source Management Commands

| Command | Description |
|---------|-------------|
| `/cto-status` | System dashboard -- installed component counts |
| `/cto-list` | List all 15 source repositories |
| `/cto-scan` | Scan repos, detect naming conflicts |
| `/cto-add owner/repo` | Add a new source repo (English-only enforced) |
| `/cto-remove alias` | Remove a source repo |
| `/cto-setup --all` | Re-install best components |
| `/cto-update` | Update all sources from GitHub |
| `/cto-sync` | Daily sync: pull + re-scan + diff maps + change report |
| `/cto-conflicts` | Analyze and resolve conflicts |
| `/cto-search query` | Search GitHub for new repos |

### Development Commands (from installed skills)

| Command | Description |
|---------|-------------|
| `/plan` | Create implementation plan before coding |
| `/tdd` | Enforce test-driven development cycle |
| `/code-review` | Review code for quality and security |
| `/verify` | Run full verification loop |
| `/e2e` | Run end-to-end tests |
| `/build-fix` | Fix build errors automatically |
| `/refactor-clean` | Remove dead code and consolidate |
| `/security-scan` | Scan for vulnerabilities |

---

## 10-Phase Delivery Pipeline

Claude follows this pipeline automatically via `/startCTO`. You can also trigger any phase manually:

| Phase | Trigger | Documents Generated |
|-------|---------|-------------------|
| **1. Discovery & Planning** | "Plan the project" | Project Charter, BRD, WBS, Risk Register, Stakeholder Analysis |
| **2. Requirements & Analysis** | "Write the requirements" | SRS, FRD, NFR, Use Cases, RTM |
| **3. Architecture & Design** | "Design the architecture" | SAD, HLD, LLD, ADR, C4 diagrams, Security Architecture |
| **4. Database Design** | "Design the database" | ER diagrams, Data Dictionary, Migration Plan |
| **5. API Design** | "Design the API" | OpenAPI spec, Auth flows, Integration spec |
| **6. Infrastructure** | "Set up infrastructure" | CI/CD pipeline, Docker, Environment configs, Monitoring |
| **7. Development** | "Start development" | TDD cycle, code reviews, sprint planning, branch strategy |
| **8. Testing & QA** | "Test everything" | Test plan, test cases, UAT, performance tests, security tests |
| **9. Security & Compliance** | "Security review" | Threat model, SBOM, DPIA, penetration test plan |
| **10. Delivery & Operations** | "Ship it" | Release notes, deployment runbook, SLO/SLA, runbooks |

---

## Document Codes

Use these codes with `/doc-create <CODE>`:

| Code | Document | Standard |
|------|----------|----------|
| `PC` | Project Charter | PMBOK |
| `BRD` | Business Requirements Document | BABOK v3 |
| `SRS` | Software Requirements Specification | IEEE 29148 |
| `FRD` | Functional Requirements Document | BABOK v3 |
| `NFR` | Non-Functional Requirements | ISO 25010 |
| `RTM` | Requirements Traceability Matrix | IEEE 29148 |
| `SAD` | Software Architecture Document | ISO 42010 |
| `HLD` | High Level Design | IEEE 1016 |
| `LLD` | Low Level Design | IEEE 1016 |
| `ADR` | Architecture Decision Record | -- |
| `RFC` | Request for Comments | -- |
| `DB` | Database Design | -- |
| `API` | API Specification | OpenAPI 3.1 |
| `TP` | Test Plan | IEEE 829 |
| `TC` | Test Cases | IEEE 29119 |
| `UAT` | User Acceptance Test Plan | IEEE 29119 |
| `TM` | Threat Model | STRIDE |
| `SA` | Security Assessment | OWASP ASVS |
| `IRP` | Incident Response Plan | NIST 800-61 |
| `DRP` | Disaster Recovery Plan | ISO 22301 |
| `PM` | Postmortem Report | SRE Book |
| `UG` | User Guide | IEC 26514 |
| `DG` | Developer Guide | IEEE 26515 |
| `SP` | Sprint Plan | Scrum Guide |
| `SR` | Status Report | PMBOK |
| `RN` | Release Notes | -- |
| `WBS` | Work Breakdown Structure | PMBOK |

---

## Source Repositories & Scoring

All 15 source repositories are scored on a **100-point scale** across 6 criteria:

| Criterion | Weight | Description |
|-----------|-------:|-------------|
| Content Quality | /30 | Structure, detail level, examples |
| Coverage | /20 | Number of components, scope breadth |
| Freshness | /15 | Last update, active development |
| Community Strength | /15 | Stars, forks, issue/PR activity |
| Contributors | /10 | Unique contributors, bus factor |
| Usability | /10 | Ease of installation, documentation |

### Source Rankings

| Rank | ID | Score | Components | Why Selected | Alternative Considered | Why Not Alternative |
|-----:|:---|------:|-----------|-------------|----------------------|-------------------|
| 1 | S07 | **95** | 6,500+ system prompts | Most comprehensive AI tool prompt collection (28+ tools). Daily updates. Competitor analysis gold mine. | LeakedPrompts (3.2K stars) | Only covers 4 models, no tool-level prompts, infrequent updates |
| 2 | S01 | **92** | 181 skills, 47 agents, 70+ cmds | Most comprehensive single package. Hackathon winner. Only source with skills + agents + commands in one repo. | awesome-claude-code-toolkit (S06) | 6x fewer skills, no commands, lower content quality |
| 3 | S11 | **90** | 157+ curated prompts | World's largest open-source prompt library (143K stars). Harvard/Columbia referenced. Multi-platform. | FlowGPT prompt library | Closed platform, no git integration, can't be submoduled |
| 4 | S02 | **88** | 17 official skills | Official Anthropic source. Every skill is production-ready and tested. Reference quality standard. | No alternative exists | Only official source for Claude Code skills |
| 5 | S13 | **85** | Prompt engineering guide | Comprehensive techniques (CoT, few-shot, RAG). Website + Jupyter notebooks. 73K stars. | LearnPrompting.org | Less code-focused, no repo to submodule, website-only |
| 6 | S10 | **84** | IDE rules collection | Largest Cursor/IDE rule collection (38.5K stars). Rules adaptable to Claude Code CLAUDE.md. | awesome-copilot-rules | 5x smaller, only Copilot-focused, less community |
| 7 | S03 | **82** | 1,370+ skills | Largest skill pool. Covers niche domains (logistics, healthcare, IoT, gaming). Installer CLI included. | Individual niche repos | No single alternative covers this breadth; would need 50+ repos |
| 8 | S12 | **80** | Curated directory | Best discovery resource for finding new Claude Code repos (37.5K stars). Ongoing reference. | awesome-ai-agents | Different scope (general AI agents, not Claude Code specific) |
| 9 | S08 | **78** | AI tool prompts | Date-stamped system prompt archive. Per-tool definitions. Version tracking. | Individual tool docs | Scattered across vendor sites, no unified archive |
| 10 | S04 | **76** | 25 agents | Business function organization (C-level, finance, marketing). 12 coding agent support. | enterprise-ai-prompts | Less structured, no agents, fewer business domains |
| 11 | S09 | **76** | Claude Code internals | 24 built-in tool definitions. Sub-agent prompts. Version-tracked per Claude Code release. | Reverse-engineering yourself | Fragile, breaks on updates, this repo is maintained |
| 12 | S05 | **74** | 140+ subagents | Categorized subagent system across 10 domains. Clean structure. | Building agents manually | Would take weeks; these are community-tested and categorized |
| 13 | S14 | **72** | Hook patterns | Context management via hooks. Ledger + handoff system for long sessions. | Custom hook scripts | Unproven patterns; S14 is battle-tested in production |
| 14 | S06 | **68** | 35 skills, 135 agents | Compact toolkit with hooks, contexts, and templates. Good quick-start kit. | Starting from scratch | Saves 20+ hours of initial setup; includes working hook examples |

### Component Distribution

```
Skills (1,575 unique after conflict resolution):
  S03 ########################################  1,376   (largest pool)
  S01 ##############                            181     (highest quality)
  S06 ##                                        35      (toolkit)
  S02 #                                         17      (official reference)

Agents (263 unique after deduplication):
  S05 ####################                      140     (categorized subagents)
  S06 ####################################      136     (toolkit agents)
  S01 ###########                               47      (core development)
  S04 ######                                    25      (business function)

Commands (80+):
  S01 ##################################        70+     (primary source)
  S06 ####                                      10+     (toolkit)

Prompts (6,800+):
  S07 ##################################        6,500+  (all AI tools)
  S11 ##                                        157+    (general reference)
  S09 #                                         full    (Claude Code specific)
  S08 #                                         28+     (coding tool specific)
```

---

## Component Scoring & Selection

When the same component name exists in multiple sources, ClaudeCodeCTO picks the **best version** using this priority:

1. **Content quality** -- more comprehensive, better structured
2. **Official source** -- `anthropics/` > community forks
3. **File size** -- larger = more comprehensive (for same-quality content)
4. **Recency** -- more recently updated
5. **Community validation** -- higher stars/forks

### Skill Conflict Resolution Examples

| Skill | Selected | Score | Alternative | Score | Reason |
|-------|----------|------:|-------------|------:|--------|
| `algorithmic-art` | S02 (Official) | 88 | S03 (Community) | 82 | Nearly identical content (404 vs 410 lines). **Official source wins** when content is equivalent. |
| `brand-guidelines` | S03 (Community) | 82 | S02 (Official) | 65 | Community version is **2.5x more comprehensive** (176 vs 73 lines). Quality overrides official status. |
| `canvas-design` | S02 (Official) | 88 | S03 (Community) | 80 | Same size. **Official source priority** for ties. Community version is likely a fork. |
| `claude-api` | S02 (Official) | 92 | S03 (Community) | 70 | Official is **53% more comprehensive** (310 vs 252 lines). For Claude API, official is most accurate. |

### Conflict Summary

| Category | Total | Unique | Conflicts | Auto-Install |
|----------|------:|-------:|----------:|-------------:|
| Skills | 2,635 | 1,568 | 1,039 | 1,564 |
| Agents | 115 | 115 | 1 | 114 |
| Commands | 144 | 136 | 7 | 129 |
| Hooks | 24 | 24 | 0 | 24 |

Full conflict resolution data: [`decisions/decision-log.md`](decisions/decision-log.md)
Full component maps: [`decisions/skills-map.tsv`](decisions/skills-map.tsv), [`decisions/agents-map.tsv`](decisions/agents-map.tsv)

---

## Project Structure

```
ClaudeCodeCTO/
+-- setup.sh                          # ONE COMMAND INSTALLER
+-- README.md                         # This file
|
+-- enterprise/                       # ENTERPRISE SYSTEM
|   +-- CLAUDE.md                     # CTO operating instructions
|   +-- templates/                    # 69 document templates
|   |   +-- project-management/  (12) # Charter, WBS, Sprint, Status...
|   |   +-- requirements/        (8)  # BRD, SRS, FRD, NFR, RTM...
|   |   +-- architecture/        (7)  # SAD, HLD, LLD, ADR, RFC...
|   |   +-- testing/             (6)  # Test Plan, UAT, Perf, Security...
|   |   +-- security/            (5)  # Threat Model, SBOM, Incident...
|   |   +-- compliance/          (5)  # GDPR, DPIA, Privacy, ToS...
|   |   +-- operations/          (5)  # Postmortem, DRP, Retro...
|   |   +-- development/         (6)  # Coding Standards, Branch...
|   |   +-- api/                 (2)  # API Spec, Integration...
|   |   +-- database/            (2)  # DB Design, Migration...
|   |   +-- infrastructure/      (2)  # Deploy Runbook, Env Config
|   |   +-- devops-sre/          (2)  # SLO/SLA, CI/CD Pipeline
|   |   +-- user-docs/           (2)  # User Guide, Dev Guide
|   |   +-- ux-design/           (3)  # Persona, Design System, Brand
|   |   +-- data/                (2)  # Data Dictionary, Migration
|   +-- diagrams/                     # 30 Mermaid diagram templates
|   +-- standards/                    # 72 enterprise standards
|   +-- roles/                        # 20 expert role definitions
|   +-- github-actions/               # 3 CI/CD workflow templates
|
+-- skills/                           # CUSTOM SKILLS
|   +-- doc-generator/                # Document generation engine
|
+-- commands/                         # 13 SLASH COMMANDS
|   +-- startCTO.md                   # Autonomous CTO mode
|   +-- doc-create.md                 # Generate documents
|   +-- doc-export.md                 # Export to PDF/DOCX
|   +-- doc-list.md                   # Document coverage
|   +-- cto-*.md             (9)      # Source management
|
+-- scripts/                          # AUTOMATION
|   +-- setup.sh -> ../setup.sh       # (symlink)
|   +-- scanner.sh                    # Scan + conflict detection
|   +-- weekly-scan.sh                # Weekly source updates
|   +-- add-repo.sh                   # Add/remove source repos
|   +-- doc-export.sh                 # MD to PDF/DOCX converter
|
+-- catalog/                          # RESEARCH DATA
|   +-- scored-rankings.md            # 100-point source scoring
|   +-- source-analysis.md            # Why each source was chosen
|   +-- prompt-libraries.md           # 24 prompt library catalog
|   +-- prompt-libraries-map.tsv      # Prompt component mapping
|   +-- github-repos-catalog.md       # 100+ repos scanned
|   +-- command-usecases.md           # Use case diagrams
|   +-- software-documents-reference.md # 197 document type reference
|
+-- decisions/                        # CONFLICT RESOLUTION
|   +-- decision-log.md               # Selection decisions with reasoning
|   +-- skills-map.tsv                # 2,553 skills mapped
|   +-- agents-map.tsv                # 408 agents mapped
|   +-- commands-map.tsv              # 145 commands mapped
|   +-- hooks-map.tsv                 # 24 hooks mapped
|   +-- repo-registry.tsv             # 15 repo definitions
|
+-- sources/                          # 15 GIT SUBMODULES
|   +-- anthropics-skills/            # S02: Official Anthropic (17 skills)
|   +-- everything-claude-code/       # S01: 181 skills, 47 agents, 70+ cmds
|   +-- antigravity-awesome-skills/   # S03: 1,370+ skills
|   +-- alirezarezvani-claude-skills/ # S04: 25 agents
|   +-- voltagent-subagents/          # S05: 140+ subagents
|   +-- rohitg00-toolkit/             # S06: 35 skills, 135 agents
|   +-- system-prompts-collection/    # S07: 6,500+ system prompts
|   +-- elifuzz-system-prompts/       # S08: AI coding tool prompts
|   +-- piebald-claude-prompts/       # S09: Claude Code internals
|   +-- awesome-cursorrules/          # S10: IDE rules collection
|   +-- awesome-chatgpt-prompts/      # S11: General prompt library
|   +-- awesome-claude-code/          # S12: Curated directory
|   +-- prompt-engineering-guide/     # S13: Prompt engineering guide
|   +-- continuous-claude-v3/         # S14: Hook patterns
|   +-- enterprise-software-house/    # Enterprise delivery framework
|
+-- docs/
    +-- i18n/                         # README translations (12 languages)
```

---

## Keeping Up to Date

### One Command Update

```bash
cd ClaudeCodeCTO
bash setup.sh --update
```

This single command does everything:

1. **Pulls the latest ClaudeCodeCTO** -- new templates, standards, commands, bugfixes
2. **Updates all 15 source repos** -- fetches latest skills, agents, prompts from GitHub
3. **Re-scans for conflicts** -- detects new or changed components
4. **Re-installs with backup** -- old files get `.bak` extension before overwriting

Your existing Claude Code configuration is preserved. Only ClaudeCodeCTO components are updated.

### Manual Update (step by step)

If you prefer manual control:

```bash
cd ClaudeCodeCTO

# Step 1: Pull latest ClaudeCodeCTO changes
git pull origin main

# Step 2: Update all 15 source repos
git submodule update --remote

# Step 3: Re-scan for new components and conflicts
bash scripts/scanner.sh

# Step 4: Re-install (with backup)
bash setup.sh --all --backup
```

### Daily Sync (recommended)

Track changes across all sources with a single command:

```bash
bash scripts/daily-sync.sh
```

This does everything:
1. Pulls latest from all 15 source repos
2. Re-scans all skills, agents, commands, hooks
3. Compares with previous maps -- detects new and removed components
4. Updates `repo-registry.tsv` with real counts per repo
5. Generates a change report at `decisions/reports/sync-{timestamp}.md`

Options:
```bash
bash scripts/daily-sync.sh --scan-only   # Skip git pull, just re-scan
bash scripts/daily-sync.sh --dry-run     # Preview without changing anything
```

Or use the slash command inside Claude Code:
```
/cto-sync
```

### Scheduling Daily Sync

**Linux/macOS** (crontab):
```bash
0 6 * * * cd /path/to/ClaudeCodeCTO && bash scripts/daily-sync.sh >> /tmp/cto-sync.log 2>&1
```

**Windows** (Task Scheduler):
- Program: `bash`
- Arguments: `C:\path\to\ClaudeCodeCTO\scripts\daily-sync.sh`
- Trigger: Daily at 06:00

---

## Uninstall

```bash
bash setup.sh --uninstall
```

This removes all components installed to `~/.claude/` by ClaudeCodeCTO. Your Claude Code installation itself is not affected.

---

## Example Workflows

### "Build an e-commerce platform from scratch"

```
You:    "E-commerce platform. Next.js, PostgreSQL, Stripe. Start from scratch."

Claude: -> Creates project structure + git init
        -> Generates Project Charter, BRD, WBS
        -> Designs architecture (C4 diagrams, HLD, ADR)
        -> Creates database schema (ER diagrams, Data Dictionary)
        -> Generates OpenAPI spec + auth flows
        -> Sets up CI/CD (GitHub Actions)
        -> Begins TDD development cycle
        -> Runs security scan + threat model
        -> Generates release notes + deployment runbook
```

### "This project has code but no docs"

```
You:    "Analyze this codebase and create all missing documentation."

Claude: -> Scans codebase structure and patterns
        -> Generates SRS from existing code behavior
        -> Creates HLD from actual module structure
        -> Generates API docs from route definitions
        -> Creates test plan based on existing tests
        -> Reports: "Created 8 documents. 14 more recommended."
```

### "Set up CI/CD and deploy"

```
You:    "GitHub Actions CI/CD. Staging auto-deploy, production on tag."

Claude: -> Creates CI workflow (lint + test + build + coverage)
        -> Creates deploy workflow (staging + production + rollback)
        -> Creates security scan workflow (CodeQL + dependency audit)
        -> Generates CI/CD Pipeline document + Deployment Runbook
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on:
- Adding new source repositories
- Adding new document templates
- Reporting issues
- Submitting pull requests

---

## License

MIT License. See [LICENSE](LICENSE) for details.

This repo is an aggregator/curator. Each submodule in `sources/` is distributed under its own license. Check individual submodule repositories for their specific license terms.

---

## Credits

Built on the shoulders of 15 open-source repositories and their contributors. See [Source Repositories & Scoring](#source-repositories--scoring) for the full list with attribution.
