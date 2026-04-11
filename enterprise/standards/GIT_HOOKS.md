# Git Hook Definitions

> **Compliance References:**
> - Based on: Git SCM "Customizing Git - Git Hooks"
> - Spec: Pre-commit framework
> - Controls: Pre-commit, pre-push, commit-msg
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Automatic quality control before commits. Catch errors before PR/CI.

---

## 1. Pre-commit Hook

### Execution Order
```
git commit -> pre-commit hook -> [PASS: commit proceeds / FAIL: commit blocked]
```

### Checks
| Order | Check | Tool | Description |
|-------|-------|------|-------------|
| 1 | Secret scanning | git-secrets / gitleaks | Search for API keys, passwords, tokens |
| 2 | Lint | ESLint / Ruff / golint | Code quality check |
| 3 | Format | Prettier / Black / gofmt | Code formatting |
| 4 | Type checking | TypeScript / mypy | Type errors |
| 5 | Test (fast) | Jest --bail / pytest -x | Only tests for changed files |

### Example: Node.js (package.json + lint-staged)
```json
{
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md}": [
      "prettier --write"
    ]
  }
}
```

### Example: Python (pre-commit-config.yaml)
```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.4.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
  - repo: https://github.com/pre-commit/pre-commit-hooks
    hooks:
      - id: check-added-large-files
      - id: detect-private-key
      - id: check-merge-conflict
```

---

## 2. Commit-msg Hook

### Conventional Commit Check
```
<type>: <description>

Types: feat, fix, refactor, docs, test, chore, perf, ci
```

### Example (commitlint)
```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'refactor', 'docs', 'test', 'chore', 'perf', 'ci'
    ]],
    'subject-max-length': [2, 'always', 100]
  }
};
```

---

## 3. Pre-push Hook

### Checks (before push)
| Check | Description |
|-------|-------------|
| All tests | `run_tests.sh all` |
| Build | Is build successful |
| Branch protection | Block direct push to `main`/`master` |

### Example: Branch Protection
```bash
#!/bin/bash
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')
if [ "$branch" = "main" ] || [ "$branch" = "master" ]; then
  echo "ERROR: Direct push to main/master is not allowed!"
  echo "Create a feature branch and open a PR."
  exit 1
fi
```

---

## 4. Secret Scanning Details

### Scanned Patterns
| Pattern | Example |
|---------|---------|
| AWS Key | `AKIA[0-9A-Z]{16}` |
| Private Key | `-----BEGIN.*PRIVATE KEY-----` |
| Generic Secret | `password\s*=\s*['"][^'"]+['"]` |
| API Key | `api[_-]?key\s*=\s*['"][^'"]+['"]` |
| JWT | `eyJ[A-Za-z0-9-_]+\.eyJ[A-Za-z0-9-_]+` |
| Connection String | `(postgres|mysql|mongodb)://[^@]+@` |

### False Positive Management
False positives can be skipped by adding them to the `.gitleaksignore` file.

---

## 5. Installation

### Node.js (Husky + lint-staged)
```bash
npx husky init
npm install --save-dev lint-staged
```

### Python (pre-commit)
```bash
pip install pre-commit
pre-commit install
```

### Go
```bash
# Write bash script inside .git/hooks/pre-commit
go vet ./...
staticcheck ./...
```

---

## 6. Hook Bypass

> **WARNING:** Hook bypass should ONLY be used in exceptional cases.
> EXPLAIN the bypass reason in the commit message.

```bash
git commit --no-verify -m "chore: urgent hotfix - hook temporarily bypassed"
```

This usage is recorded in logs and reviewed during code review.
