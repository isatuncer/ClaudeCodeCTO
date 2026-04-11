# Contributing to ClaudeCodeCTO

Thanks for your interest in contributing! This project aggregates the best AI coding components from across GitHub into a single installer for Claude Code.

## Ways to Contribute

### 1. Add a New Source Repository

Found a great GitHub repo with Claude Code skills, agents, or prompts?

```bash
# Option A: Use the script
bash scripts/add-repo.sh owner/repo-name

# Option B: Use the slash command (inside Claude Code)
/cto-add owner/repo-name
```

**Requirements for new source repos:**
- Repository must be in **English** (non-English repos are automatically rejected)
- Must contain skills, agents, commands, or prompts for AI coding tools
- Must be publicly accessible on GitHub
- Must have an open-source license

### 2. Add a New Document Template

1. Create the template in `enterprise/templates/{category}/`
2. Follow the existing format:
   - YAML frontmatter with metadata
   - Structured sections with headers
   - Approval table at the bottom
3. Reference the relevant standard (ISO, IEEE, OWASP, etc.)
4. Add the template to `catalog/software-documents-reference.md`
5. Submit a PR

### 3. Add a New Enterprise Standard

1. Create the standard in `enterprise/standards/`
2. Follow the existing naming convention: `STANDARD_NAME.md` (uppercase, underscores)
3. Include scope, requirements, checklist, and references
4. Submit a PR

### 4. Improve Conflict Resolution

The `decisions/decision-log.md` file tracks component selection decisions. If you think a different source has a better version of a component:

1. Compare the two versions
2. Document your reasoning (content quality, comprehensiveness, accuracy)
3. Submit a PR updating the decision log

### 5. Add Translations

README translations live in `docs/i18n/`. Currently supported:
Arabic, Chinese, French, German, Hindi, Italian, Japanese, Korean, Portuguese (BR), Russian, Spanish, Turkish

To add a new language:
1. Create `docs/i18n/README.{lang-code}.md`
2. Translate the full README
3. Add the language link to the main README header
4. Submit a PR

---

## Reporting Issues

Use [GitHub Issues](../../issues) and include:
- Your OS (macOS, Linux, Windows + shell)
- Claude Code version (`claude --version`)
- Full error output
- Steps to reproduce

Use the provided issue templates:
- **Bug Report** — for bugs and errors
- **Feature Request** — for new features and improvements

---

## Pull Request Process

1. Fork the repo
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Make your changes
4. Run `bash scripts/scanner.sh` to verify no new conflicts
5. Test with `bash setup.sh --dry-run` if you changed installation logic
6. Submit a PR with a clear description

### PR Checklist

- [ ] Changes are tested (scanner passes, dry-run works)
- [ ] Documentation is updated if needed
- [ ] No secrets or credentials in committed files
- [ ] Commit messages follow conventional format (`feat:`, `fix:`, `docs:`, etc.)

---

## Code of Conduct

Be respectful. Be constructive. Help others succeed.

- Critique code, not people
- Assume good intent
- Welcome newcomers
- Give credit where due

---

## Development Setup

```bash
# Clone with submodules
git clone --recursive https://github.com/isatuncer/ClaudeCodeCTO.git
cd ClaudeCodeCTO

# Verify submodules are initialized
git submodule status

# Run a scan to verify everything works
bash scripts/scanner.sh

# Test installation (dry-run)
bash setup.sh --dry-run
```

---

## Questions?

Open an issue or start a discussion. We're happy to help.
