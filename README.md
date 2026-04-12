# CloaudeCodeCTO

> Curate the best skills, agents, and commands from 16 public Claude Code repositories into a single, high-quality installation. Orchestrates a full 9-stage pipeline from discovery to installation with zero external cost.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-8A2BE2)](https://docs.claude.com/en/docs/claude-code)

## What It Does

CloaudeCodeCTO scans 16 submoduled GitHub repositories for Claude Code skills, agents, and commands, then runs a 9-stage pipeline to extract, score, curate, and install the best components into your `~/.claude/` directory.

The end result is a Claude Code installation that can guide you **baştan sona** (start to finish) through a real project — from discovery, through planning, design, build, test, documentation, shipping, and maintenance — using purpose-built agents at each phase.

**Zero external cost.** No Anthropic API charges, no third-party services. Uses your existing Claude Code session for optional semantic self-scoring.

## Quick Start — One-Liner

The fastest way — clones the repo, initializes all submodules, and runs the setup pipeline with a single command:

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Or with `wget`:

```bash
wget -qO- https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Target directory defaults to `$HOME/CloaudeCodeCTO`. Override with:

```bash
CCCTO_DIR=/custom/path bash <(curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
```

### Manual Quick Start

```bash
# 1. Clone the repo
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO

# 2. Run the bootstrap (inits submodules + launches setup)
bash scripts/bootstrap.sh

# Or skip bootstrap and go directly
git submodule update --init --recursive
bash scripts/setup.sh
```

The setup script walks you through all 12 phases, asking for confirmation at each critical step (submodule pull, install, git commit, git push).

### Install Script Options (env vars)

The one-liner install script supports env var customization:

```bash
# Non-interactive mode (for CI/automation)
CCCTO_AUTO=1 bash <(curl -fsSL ...install.sh)

# Skip ~/.claude/ install (only clone + pipeline)
CCCTO_NO_INSTALL=1 bash <(curl -fsSL ...install.sh)

# Clone but don't run setup.sh yet
CCCTO_NO_SETUP=1 bash <(curl -fsSL ...install.sh)

# Use a specific branch
CCCTO_BRANCH=develop bash <(curl -fsSL ...install.sh)

# Custom target directory
CCCTO_DIR=~/tools/ccc bash <(curl -fsSL ...install.sh)
```

## What Gets Installed

After a successful run, your `~/.claude/` will contain:

```
~/.claude/
├── .credentials.json              (preserved)
├── CLAUDE.md                      (global instructions)
├── settings.json                  (harness config)
├── skills/                        ~1,800+ skills
│   └── project-lifecycle/         meta-orchestrator
├── agents/                        ~300 specialized agents
├── commands/                      ~230 slash commands
│   └── start-project.md           /start-project lifecycle entry
├── rules/
│   └── agent-decision-tree.md     which agent for which task
└── config/
    └── lifecycle.json             8-phase project map
```

## 9-Stage Pipeline

```
┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────────┐
│ DISCOVER │─▶│ EXTRACT  │─▶│  SCORE   │─▶│  CURATE  │─▶│ORCHESTRATE │
│   (1)    │  │   (2)    │  │   (3)    │  │   (4)    │  │   (4.5)    │
└──────────┘  └──────────┘  └──────────┘  └──────────┘  └─────┬──────┘
                                                               │
              ┌──────────┐  ┌──────────┐  ┌──────────────┐  ┌──┴──────┐
              │ OPTIMIZE │◀─│ VALIDATE │◀─│   INSTALL    │◀─│ BUDGET  │
              │   (6)    │  │  (5.5)   │  │     (5)      │  │  (4.6)  │
              └──────────┘  └──────────┘  └──────────────┘  └─────────┘
```

| # | Stage | Script | Purpose |
|---|-------|--------|---------|
| 1 | **Discover** | `scanner.sh` | TSV inventory of all source repos |
| 2 | **Extract** | `extractor.py` | Parse frontmatter + metadata → `catalog.json` |
| 3 | **Score** | `scorer_rubric.py` + self-scoring | 100-point rubric + optional LLM scoring |
| 4 | **Curate** | `curator.py` | Domain grouping, dedup → `selected.json` |
| 4.5 | **Orchestrate** | `orchestrator.py` | Map lifecycle phases to components |
| 4.6 | **Budget** | `budget.py` | Token cost profile (measurement, no cap) |
| 4.7 | **Validate** | `validate_agents.py` | Agent overlap + decision tree |
| 5 | **Install** | `installer.sh` | Safe staged install with backup |
| 5.5 | **Smoke Test** | `smoke_test.sh` | Structural + syntactic verification |
| 6 | **Optimize** | `tracker.sh` | Usage tracking + pruning suggestions |

See [`docs/PLAN.md`](docs/PLAN.md) for the full architecture and [`docs/diagrams/`](docs/diagrams/) for Mermaid diagrams.

## The 8-Phase Project Lifecycle

Once installed, `/start-project` guides you through:

```
1. Discovery  → business-analyst, market-researcher, ux-researcher
2. Planning   → planner, architect, product-manager
3. Design     → ui-designer, api-designer, database-architect
4. Build      → fullstack/frontend/backend-developer, tdd-guide
5. Test       → test-automator, qa-expert, e2e-runner
6. Document   → technical-writer, api-documenter
7. Ship       → deployment-engineer, devops-engineer, sre-engineer
8. Maintain   → performance-engineer, security-engineer, refactor-cleaner
```

Each phase has preferred agents and skills. Progress is tracked in `decisions/project-state.json` so sessions are resumable.

## Source Repositories (Submodules)

| Repository | Stars | Components |
|------------|-------|------------|
| `anthropics/skills` | official | 19 skills |
| `everything-claude-code` | large | 183 skills, 47 agents, 82 commands |
| `continuous-claude-v3` | medium | 156 skills, 32 agents |
| `antigravity-awesome-skills` | huge | 1,404 skills |
| `rohitg00-toolkit` | medium | 35 skills, 138 agents, 243 commands |
| `alirezarezvani-claude-skills` | medium | 303 components |
| `voltagent-subagents` | medium | 140 agents |
| +8 prompt/rule repos | | varies |

Full list in [`.gitmodules`](.gitmodules).

## Updating

```bash
# Check for submodule updates without pulling
bash scripts/setup.sh --check

# Pull updates + re-run pipeline + install (interactive)
bash scripts/setup.sh

# Non-interactive (for cron)
bash scripts/setup.sh --auto
```

## Project Structure

```
CloaudeCodeCTO/
├── README.md                   ← you are here
├── LICENSE                     MIT
├── .gitmodules                 16 source repos
├── .gitignore                  excludes generated artifacts
├── sources/                    SUBMODULES (init with --recursive)
├── scripts/                    pipeline implementation
│   ├── setup.sh                ★ main entry point
│   ├── bootstrap.sh            first-time clone wrapper
│   ├── extractor.py            Stage 2
│   ├── scorer_rubric.py        Stage 3a
│   ├── prepare_self_scoring.py Stage 3b (manual)
│   ├── merge_self_scoring.py   Stage 3b merge
│   ├── curator.py              Stage 4
│   ├── orchestrator.py         Stage 4.5
│   ├── budget.py               Stage 4.6
│   ├── validate_agents.py      Stage 4.7
│   ├── installer.sh            Stage 5
│   ├── smoke_test.sh           Stage 5.5
│   └── tracker.sh              Stage 6
├── decisions/                  pipeline outputs (most are .gitignored)
│   ├── selected.json           curated component list
│   ├── install-manifest.json   last install checkpoint
│   ├── budget-profile.json     token cost profile
│   ├── agent-decision-tree.md  agent disambiguation tree
│   └── smoke-test-report.md    latest smoke test
├── templates/                  installable configs
│   ├── lifecycle.json          8-phase project map
│   ├── start-project.md        /start-project command
│   └── project-lifecycle/      orchestrator skill
└── docs/
    ├── PLAN.md                 master plan
    └── diagrams/               5 Mermaid diagrams
```

## Requirements

- **Claude Code** installed (with credentials at `~/.claude/.credentials.json`)
- **Python 3.8+** with `PyYAML` (`pip install pyyaml`)
- **Bash** (git-bash on Windows)
- **Git** with submodule support
- **~1 GB free disk** for submodules + generated artifacts

## Design Principles

1. **Zero external cost** — no API keys, no paid services
2. **Factory-reset aware** — works from a clean `~/.claude/`
3. **Interactive by default** — confirms every destructive action
4. **Resumable** — each stage writes to `decisions/`, pipeline can restart
5. **Idempotent** — re-running `setup.sh` does the right thing
6. **Measurement over enforcement** — budget is measured, not capped
7. **Regenerable outputs** — generated artifacts are gitignored

## Safety Notes

- **Backup before install:** the installer creates `/c/tmp/claude-install-backup-*` before touching `~/.claude/`
- **No destructive git:** the script never force-pushes, never amends published commits
- **Explicit approval:** install, commit, and push each require separate confirmation
- **Rollback:** if install fails, restore from the backup directory

## Troubleshooting

### Setup fails at "Environment Check"
Install missing tools:
```bash
pip install pyyaml
# or
python -m pip install pyyaml
```

### Submodule pull fails
```bash
git submodule sync
git submodule update --init --recursive --force
```

### Install fails partway
Backup is at `/c/tmp/claude-install-backup-<timestamp>/`. Restore with:
```bash
rm -rf ~/.claude/skills ~/.claude/agents ~/.claude/commands
cp -r /c/tmp/claude-install-backup-<timestamp>/. ~/.claude/
```

### Claude Code doesn't see new skills
Start a **fresh Claude Code session**. The current session's system prompt is frozen at startup.

## License

MIT — see [LICENSE](LICENSE).

## Acknowledgments

This project curates content from 16 open-source repositories. See [`.gitmodules`](.gitmodules) for the full list and respective licenses. All submodule licenses are preserved inside their respective `sources/<repo>/` directories.
