# Security Policy

## Supported Versions

ClaudeCodeCTO follows [Semantic Versioning](https://semver.org/). Only the latest minor release receives security fixes.

| Version | Supported |
|---|---|
| 1.x (latest) | ✅ |
| < 1.0 | ❌ |

---

## Reporting a Vulnerability

If you discover a security issue, **please do not open a public GitHub issue**. Instead, use one of the private channels below.

### Preferred: GitHub Private Security Advisory

1. Go to https://github.com/isatuncer/ClaudeCodeCTO/security/advisories/new
2. Fill in the advisory form — include reproduction steps, impact assessment, and any proof-of-concept
3. Submit — maintainers will be notified privately

### Alternative: Direct Contact

If the advisory form is unavailable, contact [@isatuncer](https://github.com/isatuncer) directly via a non-public channel.

---

## What to Include

A good report contains:

- **Description** — one-paragraph summary of the issue
- **Affected files** — specific script(s) or config(s) where the bug lives
- **Reproduction steps** — exact commands, input data, environment details
- **Impact** — what could an attacker do? (data exfiltration, RCE, privilege escalation, etc.)
- **Affected versions** — tags or commits where the issue is present
- **Suggested fix** — if you have one

---

## Response Timeline

| Stage | SLA |
|---|---|
| Acknowledgment | 48 hours |
| Initial triage | 5 business days |
| Fix or mitigation | 30 days (critical), 90 days (non-critical) |
| Public disclosure | After fix is released, coordinated with reporter |

---

## Scope

### In Scope

- `install.sh`, `scripts/setup.sh`, `scripts/installer.sh`, `scripts/bootstrap.sh`, `scripts/smoke_test.sh`, `scripts/tracker.sh`
- `decisions/selected.json` integrity (unauthorized modifications, malicious component injection)
- `decisions/install-assets.json` payload integrity
- Any script that writes to `~/.claude/` or `/c/tmp/`
- Credentials handling (preservation of `.credentials.json`)
- Backup / restore flow

### Out of Scope

- **Upstream submodule vulnerabilities** — report those to the respective repo owner (see [`.gitmodules`](.gitmodules))
- **Claude Code itself** — report to [Anthropic](https://www.anthropic.com/contact)
- **Third-party dependencies** (Python packages, etc.) — report to the upstream project
- Vulnerabilities that require local admin access or compromised developer machines
- Social engineering, phishing, or physical attacks

---

## Known Risks and Mitigations

ClaudeCodeCTO has several built-in safety properties:

- **No destructive git operations** — scripts never force-push, amend published commits, or bypass hooks
- **Atomic install with backup** — automatic backup to `/c/tmp/claude-install-backup-<timestamp>/` before any `~/.claude/` changes
- **Explicit approval required** — install, commit, and push each require separate confirmation (unless `--auto`)
- **Credentials preserved** — the installer never touches `~/.claude/.credentials.json`
- **Dry-run mode** — `bash scripts/setup.sh --dry-run` previews changes without applying them
- **Content verified** — `scripts/smoke_test.sh` runs 8 structural checks post-install

---

## Threat Model

The installer assumes:

1. The user runs it voluntarily (not coerced)
2. The submodule contents in `sources/` are trusted (pinned commits in `.gitmodules`)
3. `decisions/selected.json` has not been tampered with since the last maintainer push
4. The user's Claude Code `.credentials.json` is already protected by OS file permissions

**If any of these assumptions fail, additional verification is the user's responsibility.**

For higher-assurance deployments, consider:
- Running `install.sh` inside a disposable VM or container
- Verifying the git commit signature before running `setup.sh`
- Reviewing `decisions/selected.json` diffs before each update
- Running with `--dry-run` first to preview all actions

---

## Disclosure Policy

We practice **coordinated disclosure**:

1. Reporter privately submits the issue
2. Maintainers acknowledge, triage, and develop a fix
3. Fix is released in a patch version
4. A security advisory is published on GitHub crediting the reporter (unless anonymity is requested)
5. Reporter may publish their own writeup **after** the public advisory

---

## Recognition

We maintain a `SECURITY_ACKNOWLEDGMENTS.md` file listing researchers who have contributed security fixes. If you'd like credit, mention it in your advisory.

Thank you for helping keep ClaudeCodeCTO and its users safe.
