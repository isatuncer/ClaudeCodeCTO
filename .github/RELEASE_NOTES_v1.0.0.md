# CloaudeCodeCTO v1.0.0

> Turn Claude Code into a full-lifecycle CTO with **one command**.

## 🎯 What's in this release

CloaudeCodeCTO curates the best skills, agents, and commands from 14 public Claude Code repositories into a single, high-quality installation — **zero external cost**, **fully automated**, and **resumable**.

### Headline Numbers

- 📦 **2,388 components** curated
  - 1,845 skills
  - 307 specialized agents
  - 236 slash commands
- 🏛️ **14 source repositories** (pinned git submodules)
- 🔁 **8-phase project lifecycle** via `/start-project`
- 💰 **$0 external cost** — no Anthropic API charges, no paid services

### The 8-Phase Lifecycle

```
Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
```

Each phase has preferred agents and skills. Progress is tracked in `decisions/project-state.json` so sessions are resumable.

## 🚀 Quick Start

```bash
curl -fsSL https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh | bash
```

Or manual:

```bash
git clone https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO
git submodule update --init --recursive
bash scripts/setup.sh
```

## ✨ Features

- **One-command installer** — `curl | bash` compatible with `/dev/tty` fallback for prompts
- **Atomic install with backup** — everything staged in `/c/tmp/` first, automatic backup to `/c/tmp/claude-install-backup-<timestamp>/`
- **Interactive by default** — confirms every destructive action; `--auto` for CI
- **Post-install smoke test** — 8 structural checks catch broken YAML and missing files
- **Factory-reset aware** — works on a clean `~/.claude/`, preserves `.credentials.json`
- **Cross-platform** — Windows (git-bash), macOS, Linux
- **Multi-language** — README in 10 languages (EN, TR, DE, ES, FR, JA, KO, ZH, RU, AR)
- **Single source of truth** — only `decisions/` is authoritative
- **Resumable** — pipeline stages write to `decisions/`, can restart from any checkpoint

## 🏗️ How It's Built

A 9-stage curation pipeline runs on the maintainer's machine before release:

1. **Discover** — scan 14 submodules for components
2. **Extract** — parse YAML frontmatter into `catalog.json`
3. **Score** — 100-point deterministic rubric (structural + content + cross-repo + domain)
4. **Self-score** — optional semantic re-scoring via Claude Code subagents (zero cost)
5. **Curate** — dedupe overlapping agents, group by domain → `selected.json`
6. **Orchestrate** — map to 8-phase lifecycle
7. **Budget** — profile token cost (~105K at startup)
8. **Validate** — detect 22 overlap pairs, generate agent decision tree
9. **Install** — atomic staged install with backup + smoke test

End users never see the pipeline — they just consume `decisions/selected.json` via `setup.sh`.

## 📊 Component Breakdown by Domain

| Domain | Count | Examples |
|---|---:|---|
| devops | 541 | docker, kubernetes, terraform, CI/CD |
| project-mgmt | 349 | planning, OKRs, sprint workflows |
| frontend | 333 | React, Vue, Next.js, design systems |
| coding | 287 | language-specific builders and reviewers |
| backend | 183 | APIs, databases, microservices |
| security | 143 | auditing, pen-testing, compliance |
| testing | 140 | unit, integration, E2E, mutation |
| data-ai | 132 | ML pipelines, LLM integration, RAG |
| docs | 120 | technical writing, API reference |
| architecture | 81 | C4 diagrams, ADRs, system design |
| other | 79 | miscellaneous |

## 🛡️ Safety

- Automatic backup before any `~/.claude/` changes
- No destructive git operations (no force-push, no amend, no hook bypass)
- Explicit approval required for install, commit, push (unless `--auto`)
- `.credentials.json` is never touched by the installer
- Dry-run mode: `bash scripts/setup.sh --dry-run`

## 📚 Documentation

- Full README: [README.md](https://github.com/isatuncer/ClaudeCodeCTO/blob/v1.0.0/README.md)
- 10 languages: [docs/i18n/](https://github.com/isatuncer/ClaudeCodeCTO/tree/v1.0.0/docs/i18n)
- Contributing guide: [CONTRIBUTING.md](https://github.com/isatuncer/ClaudeCodeCTO/blob/v1.0.0/CONTRIBUTING.md)
- Security policy: [SECURITY.md](https://github.com/isatuncer/ClaudeCodeCTO/blob/v1.0.0/SECURITY.md)
- Changelog: [CHANGELOG.md](https://github.com/isatuncer/ClaudeCodeCTO/blob/v1.0.0/CHANGELOG.md)

## 🙏 Acknowledgments

This release curates content from 14 open-source repositories. See [`.gitmodules`](https://github.com/isatuncer/ClaudeCodeCTO/blob/v1.0.0/.gitmodules) for the full list with respective licenses. All submodule licenses are preserved inside their `sources/<repo>/` directories.

Huge thanks to all upstream maintainers who make their skills, agents, and commands available under open licenses. This project would not exist without their work.

## 🔗 Links

- [Install one-liner](https://raw.githubusercontent.com/isatuncer/ClaudeCodeCTO/main/install.sh)
- [Issues](https://github.com/isatuncer/ClaudeCodeCTO/issues)
- [Discussions](https://github.com/isatuncer/ClaudeCodeCTO/discussions)
- [Claude Code docs](https://docs.claude.com/en/docs/claude-code)

---

**Built with care by [@isatuncer](https://github.com/isatuncer). Star ⭐ if this saves you time!**
