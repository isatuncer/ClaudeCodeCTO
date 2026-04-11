---
title: "Branch Strategy Document"
document-id: "BS-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "Git Flow / GitHub Flow / Trunk-Based Development"
---

# Branch Strategy Document

## Table of Contents
1. [Document Information](#1-document-information)
2. [Strategy Overview](#2-strategy-overview)
3. [Branch Types](#3-branch-types)
4. [Branch Naming Conventions](#4-branch-naming-conventions)
5. [Workflow](#5-workflow)
6. [Merge and Review Policy](#6-merge-and-review-policy)
7. [Release Process](#7-release-process)
8. [Hotfix Process](#8-hotfix-process)
9. [Approval](#9-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| Repository | [FILL] |
| Strategy | [FILL — Git Flow / GitHub Flow / Trunk-Based / GitLab Flow] |
| Prepared By | [FILL] |
| Tech Lead | [FILL] |

## 2. Strategy Overview

[FILL — Describe the chosen branching strategy, rationale, and how it supports the team's release cadence.]

### 2.1 Branch Diagram
```
[FILL — ASCII diagram showing branch flow]
main ──────────────────────────────────────►
  └── develop ────────────────────────────►
        ├── feature/xxx ──┘
        ├── feature/yyy ──┘
        └── release/1.0 ──► main (tag v1.0)
```

## 3. Branch Types

| Branch | Purpose | Base Branch | Merges Into | Lifetime | Protection |
|--------|---------|-------------|-------------|----------|------------|
| main | Production code | - | - | Permanent | Protected |
| develop | Integration | main | main (via release) | Permanent | Protected |
| feature/* | New features | [FILL] | [FILL] | Temporary | No |
| bugfix/* | Bug fixes | [FILL] | [FILL] | Temporary | No |
| release/* | Release prep | [FILL] | main + develop | Temporary | Protected |
| hotfix/* | Production fixes | main | main + develop | Temporary | No |

## 4. Branch Naming Conventions

| Type | Pattern | Example |
|------|---------|---------|
| Feature | `feature/[TICKET]-short-description` | `feature/PROJ-123-user-auth` |
| Bugfix | `bugfix/[TICKET]-short-description` | `bugfix/PROJ-456-login-error` |
| Release | `release/[VERSION]` | `release/1.2.0` |
| Hotfix | `hotfix/[TICKET]-short-description` | `hotfix/PROJ-789-critical-fix` |

### 4.1 Rules
- Use lowercase and hyphens only
- Include ticket/issue number
- Keep descriptions under 5 words
- Delete branches after merge

## 5. Workflow

### 5.1 Feature Development
1. Create branch from `[FILL — e.g., develop]`
2. Commit frequently with conventional commit messages
3. Push branch and create Pull Request
4. Pass CI checks and code review
5. Merge via [FILL — squash / merge commit / rebase]
6. Delete feature branch

### 5.2 Commit Message Format
```
<type>(<scope>): <description>

<optional body>

<optional footer>
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `ci`

## 6. Merge and Review Policy

| Rule | Requirement |
|------|-------------|
| Minimum reviewers | [FILL — e.g., 2] |
| CI must pass | Yes |
| Merge method | [FILL — Squash / Merge commit / Rebase] |
| Branch up-to-date | Yes — rebase before merge |
| Stale PR auto-close | [FILL — e.g., After 14 days of inactivity] |

### 6.1 Review Checklist
- [ ] Code follows coding standards
- [ ] Tests added/updated
- [ ] No secrets or credentials
- [ ] Documentation updated if needed
- [ ] Breaking changes documented

## 7. Release Process

| Step | Action | Owner |
|------|--------|-------|
| 1 | Create `release/X.Y.Z` from `[FILL]` | [FILL] |
| 2 | Run full regression test suite | [FILL] |
| 3 | Fix release bugs on release branch | [FILL] |
| 4 | Merge to `main` and tag `vX.Y.Z` | [FILL] |
| 5 | Merge back to `develop` | [FILL] |
| 6 | Deploy to production | [FILL] |

### 7.1 Versioning
| Component | Format | Example |
|-----------|--------|---------|
| Release version | [FILL — e.g., SemVer] | v1.2.3 |
| Pre-release | [FILL] | v1.2.3-rc.1 |

## 8. Hotfix Process

1. Create `hotfix/[TICKET]-description` from `main`
2. Fix the issue with minimal change
3. Test thoroughly
4. Merge to `main` (tag with patch version)
5. Merge to `develop` to keep branches in sync
6. Deploy immediately

## 9. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| Tech Lead | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
