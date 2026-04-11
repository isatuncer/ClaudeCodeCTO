# Git Branching Strategy

> **Compliance References:**
> - Based on: Git Flow (Vincent Driessen 2010)
> - Spec: GitHub Flow, Trunk-based development
> - Controls: Branch protection rules
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Model: GitHub Flow + Release Branch

---

## 1. Branch Structure

```
main            <- Production (protected, direct push FORBIDDEN)
├── develop     <- Integration (deploys to staging)
├── feature/*   <- New feature (branched from develop)
├── fix/*       <- Bug fix (branched from develop)
├── hotfix/*    <- Urgent production fix (branched from main)
└── release/*   <- Release preparation (branched from develop)
```

---

## 2. Branch Rules

| Branch | Opens From | Merges Into | Protection | CI/CD |
|--------|-----------|------------|------------|-------|
| `main` | - | release/*, hotfix/* | Push protected, PR required | -> Production |
| `develop` | - | feature/*, fix/* | PR required | -> Staging |
| `feature/*` | develop | develop via PR | - | -> PR check |
| `fix/*` | develop | develop via PR | - | -> PR check |
| `hotfix/*` | main | main + develop | - | -> PR check |
| `release/*` | develop | main + develop | - | -> Staging test |

---

## 3. Naming

```
feature/[ticket-id]-short-description
fix/[ticket-id]-short-description
hotfix/[ticket-id]-short-description
release/v[X.Y.Z]
```

Examples:
```
feature/FR-042-user-profile-page
fix/BUG-108-login-redirect-error
hotfix/SEC-003-close-xss-vulnerability
release/v1.3.0
```

---

## 4. Feature Flow

```mermaid
gitgraph
    commit id: "v1.0.0"
    branch develop
    commit id: "sprint start"
    branch feature/FR-001
    commit id: "feat: add login page"
    commit id: "test: login tests"
    checkout develop
    merge feature/FR-001 id: "PR #1 merged"
    branch release/v1.1.0
    commit id: "chore: bump version"
    checkout main
    merge release/v1.1.0 id: "v1.1.0" tag: "v1.1.0"
    checkout develop
    merge release/v1.1.0 id: "sync develop"
```

---

## 5. Hotfix Flow

```mermaid
gitgraph
    commit id: "v1.1.0" tag: "v1.1.0"
    branch hotfix/SEC-003
    commit id: "fix: close XSS vulnerability"
    checkout main
    merge hotfix/SEC-003 id: "v1.1.1" tag: "v1.1.1"
    branch develop
    commit id: "sync hotfix"
```

**Hotfix rules:**
- ONLY branched from main
- Minimum changes (fix only)
- Merge into both main and develop
- Deploy within max 2 hours

---

## 6. PR (Pull Request) Rules

- [ ] PR description is filled (what, why)
- [ ] At least 1 reviewer approved
- [ ] CI pipeline passed (lint, test, build)
- [ ] No merge conflicts
- [ ] Branch is up to date with develop/main (rebase/merge)
- [ ] If security-sensitive code -> security-reviewer
- [ ] If critical module -> `/santa-loop` (2 reviewers)

### Merge Strategy
| Case | Strategy |
|------|----------|
| feature -> develop | **Squash merge** (clean history) |
| release -> main | **Merge commit** (release point visible) |
| hotfix -> main | **Merge commit** |
| develop sync | **Merge commit** |

---

## 7. Branch Cleanup

- Feature/fix branches are **AUTOMATICALLY DELETED** after merge
- Stale branches (30+ days no activity) -> warning -> deleted
- Release branches are deleted after tagging
