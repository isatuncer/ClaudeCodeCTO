# Project Onboarding Guide

## Project: [PROJECT_NAME]
## Updated: [DATE]

---

## 1. Quick Start (5 minutes)

### Step 1: Clone the code
```bash
git clone [REPO_URL]
cd [PROJECT_NAME]
```

### Step 2: Set up the environment
```bash
bash automation/scripts/setup_dev.sh
```

### Step 3: Start the application
```bash
cd src && [START_COMMAND]
```

### Step 4: Open in browser
```
http://localhost:3000
```

---

## 2. Project Overview

### What are we building?
[2-3 sentence summary of the project]

### Technology Stack
| Layer | Technology |
|-------|-----------|
| Frontend | [React/Vue/Angular + version] |
| Backend | [Node/Python/Go + framework] |
| Database | [PostgreSQL/MySQL/MongoDB] |
| Cache | [Redis] |
| CI/CD | [GitHub Actions/GitLab CI] |
| Hosting | [AWS/GCP/Azure] |

### Architecture
> Details: ADRs under `governance/decisions/`

```
[Simple architecture diagram or reference]
```

---

## 3. Folder Structure

```
src/
├── [module-1]/          # [Description]
├── [module-2]/          # [Description]
├── common/             # Shared components
├── config/             # Configurations
└── database/           # Migrations and seeds
```

**Important files:**
- `CLAUDE.md` - Project instructions (read it!)
- `governance/project_status.md` - Live project status
- `governance/standards/` - Code standards
- `CHANGELOG.md` - Change history

---

## 4. Development Rules

### Git Branch Strategy
```
main        <- Production (protected)
develop     <- Staging (integration)
feature/*   <- New feature
fix/*       <- Bug fix
hotfix/*    <- Urgent production fix
```

### Commit Format
```
<type>: <description>

Types: feat, fix, refactor, docs, test, chore, perf, ci
```

### When Writing Code
1. `/search-first` - Search for existing solutions first
2. `/tdd` - Write tests first, then implement
3. `/code-review` - On every change
4. `/prp-commit` - Smart commit

### PR Rules
- PR description mandatory (what, why)
- At least 1 reviewer approval
- All tests must pass
- No lint errors

---

## 5. Test Accounts

| Role | Email | Password | Permission |
|------|-------|----------|-----------|
| Admin | admin@test.com | [dev env password] | Full |
| User | user@test.com | [dev env password] | Standard |
| Viewer | viewer@test.com | [dev env password] | Read-only |

> **WARNING:** These accounts are for the development environment ONLY!

---

## 6. Frequently Used Commands

| Command | Description |
|---------|------------|
| `bash automation/scripts/run_tests.sh` | Run tests |
| `bash automation/scripts/lint_check.sh` | Lint check |
| `bash automation/scripts/lint_check.sh --fix` | Auto-fix lint |
| `bash automation/scripts/health_check.sh` | Health check |

---

## 7. Communication

| Topic | Channel |
|-------|---------|
| General questions | [Slack/Teams channel] |
| Bug reporting | [Issue tracker URL] |
| Emergency | [Oncall phone/Slack] |
| Documentation | This repo - `governance/` folder |

---

## 8. Helpful Links
- [ ] Project board: [URL]
- [ ] CI/CD pipeline: [URL]
- [ ] Staging: [URL]
- [ ] Monitoring: [URL]
- [ ] API documentation: [URL]
