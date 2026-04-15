<!--
Thanks for contributing to ClaudeCodeCTO!

Please fill in the sections below. Keep it concise and focused on the "why".
-->

## Summary

<!-- One or two sentences: what does this PR do? -->

## Motivation

<!-- Why is this change needed? Link the related issue if applicable. -->

Closes #

## Type of Change

<!-- Check all that apply -->

- [ ] 🐛 Bug fix (non-breaking change that fixes an issue)
- [ ] ✨ New feature (non-breaking change that adds functionality)
- [ ] 💥 Breaking change (fix or feature that changes existing behavior)
- [ ] 📚 Documentation only
- [ ] 🌐 i18n / translation
- [ ] ♻️ Refactor (no functional change)
- [ ] 🎨 Style / formatting
- [ ] ⚙️ CI / tooling
- [ ] 🔒 Security fix

## Affected Components

<!-- Which files/scripts does this touch? -->

- [ ] `install.sh`
- [ ] `scripts/setup.sh`
- [ ] `scripts/installer.sh`
- [ ] `scripts/smoke_test.sh`
- [ ] `scripts/bootstrap.sh`
- [ ] `scripts/tracker.sh`
- [ ] `decisions/install-assets.json`
- [ ] `decisions/selected.json` (maintainer only — do NOT edit directly in PR)
- [ ] `README.md` / `README.tr.md` / `docs/i18n/`
- [ ] `.github/workflows/`
- [ ] Other (specify):

## Testing

<!-- How did you verify your change? -->

- [ ] `bash scripts/setup.sh --dry-run` — passes without error
- [ ] `bash scripts/setup.sh --check` — passes without error
- [ ] `bash scripts/installer.sh --dry-run` — passes (if installer touched)
- [ ] `bash scripts/smoke_test.sh` — passes (if post-install touched)
- [ ] Manual test on fresh `~/.claude/` (optional but recommended)
- [ ] CI checks pass

## Checklist

- [ ] My commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)
- [ ] I have updated `CHANGELOG.md` under `[Unreleased]` if user-visible
- [ ] I have updated documentation where relevant (README, CONTRIBUTING, etc.)
- [ ] I have not committed `.credentials.json`, secrets, or user-specific paths
- [ ] I have not modified `decisions/selected.json` directly (maintainer-only file)
- [ ] My changes are focused and atomic (one concern per PR)

## Screenshots / Logs (if applicable)

<!-- Paste relevant terminal output, screenshots, or links here -->

## Additional Notes

<!-- Anything the reviewer should know? Breaking changes, migration steps, follow-ups? -->
