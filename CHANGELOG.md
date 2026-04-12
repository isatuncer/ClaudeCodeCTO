# Changelog

All notable changes to CloaudeCodeCTO will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- **Installer temp dir is now platform-aware** — previously hardcoded `/c/tmp/` (Windows-only), now falls back to `$TMPDIR` on macOS/Linux. Override with `CCCTO_TMP` env var. Fixes CI failures on Ubuntu and macOS runners.
- **smoke_test.sh:107** — quoted Python subshell invocation to silence shellcheck SC2046

### Removed
- `sources/enterprise-software-house` submodule — contributed 0 components to curation; reduced source repo count from 15 to 14

## [1.0.0] — 2026-04-12

### Added
- **One-command installer** — `curl | bash` compatible installer with `/dev/tty` fallback for interactive prompts in curl-pipe mode
- **9-stage curation pipeline** (maintainer-only) — discover → extract → score → self-score → curate → orchestrate → budget → validate → install
- **2,388 curated components** from 15 public Claude Code repositories
  - 1,845 skills
  - 307 specialized agents
  - 236 slash commands
- **8-phase project lifecycle** with `/start-project` meta-command — Discovery → Planning → Design → Build → Test → Document → Ship → Maintain
- **Atomic installer** (`scripts/installer.sh`) with automatic backup to `/c/tmp/claude-install-backup-<timestamp>/`
- **Post-install smoke test** (`scripts/smoke_test.sh`) with 8 structural checks
- **Setup orchestrator** (`scripts/setup.sh`) with 6 phases and interactive confirmation at every destructive step
- **Bootstrap script** (`scripts/bootstrap.sh`) for first-time clone setup
- **Tracker script** (`scripts/tracker.sh`) for optional usage-based pruning
- **Install assets embedded in `decisions/install-assets.json`** — lifecycle config, start-project command, and project-lifecycle skill as a single source of truth
- **100-point scoring rubric** — structural (30) + content (30) + cross-repo (20) + domain fit (20)
- **Zero-cost semantic self-scoring** via Claude Code subagents for borderline components
- **Agent overlap detection** — 22 overlapping pairs identified, disambiguation tree generated at `decisions/agent-decision-tree.md`
- **Token budget profile** at `decisions/budget-profile.json` — ~105K tokens at session startup
- **Multi-language README** — English, Turkish, German, Spanish, French, Japanese, Korean, Chinese, Russian, Arabic (RTL)
- **Factory-reset aware** — preserves `.credentials.json` during install
- **Cross-platform** — Windows (git-bash), macOS, Linux with automatic `cygpath` handling

### Design Principles
- Zero external cost — no Anthropic API charges, no paid services
- Single source of truth — only `decisions/` is authoritative
- Interactive by default — confirms every destructive action
- Resumable — pipeline stages write to `decisions/`, can restart from any checkpoint
- Idempotent — re-running `setup.sh` does the right thing
- Regenerable outputs — generated artifacts are gitignored

### Repository Structure
- End-user install flow ships to GitHub (install.sh + scripts/ + decisions/ + sources/)
- Analysis pipeline scripts stay local on the maintainer's machine
- 15 git submodules under `sources/` for the actual skill/agent content

[Unreleased]: https://github.com/isatuncer/ClaudeCodeCTO/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/isatuncer/ClaudeCodeCTO/releases/tag/v1.0.0
