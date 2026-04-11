# Release Management Process

> **Compliance References:**
> - Based on: ITIL 4 Release Management, SemVer 2.0.0
> - Spec: Release cadence
> - Controls: Go/No-Go matrix, rollback criteria
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Standards for release planning, coordination, and deployment process.

---

## 1. Release Schedule

| Type | Period | Day | Time |
|------|--------|-----|------|
| Minor release | End of sprint (2 weeks) | Friday | 10:00 (low traffic) |
| Patch/bugfix | As needed | Any | 10:00 |
| Hotfix | URGENT | IMMEDIATELY | Immediately |

> **Rule:** Deploy is PROHIBITED after Friday 15:00 (weekend support risk)

---

## 2. Release Process

### Week 2, Wednesday: Code Freeze
- [ ] New feature merge to develop branch STOPS
- [ ] Only bug fixes can be merged
- [ ] `release/vX.Y.Z` branch is created from develop

### Week 2, Thursday: QA + Release Preparation
- [ ] Full QA cycle on staging
- [ ] Update CHANGELOG.md
- [ ] Prepare release notes
- [ ] Version bump (package.json / pyproject.toml / etc.)
- [ ] Test migration on staging

### Week 2, Friday: Release
- [ ] Go/No-Go meeting (15 min)
- [ ] Go -> merge release branch to main
- [ ] Create git tag (vX.Y.Z)
- [ ] Production deploy
- [ ] Smoke test
- [ ] Release announcement
- [ ] Delete release branch

---

## 3. Go/No-Go Matrix

| Criteria | Go | No-Go |
|----------|-----|-------|
| Unit test | 100% pass | Any fail |
| E2E test | Critical flows pass | Critical flow fail |
| Security scan | 0 critical | Critical finding |
| Coverage | >= 80% | < 70% |
| Staging QA | Approved | P1/P2 open bug |
| Migration | Successful on staging | Migration error |
| Rollback plan | Ready | Not ready |

---

## 4. Rollback Criteria

AUTOMATIC rollback after deploy in these situations:
- Error rate > 5% (within 5 min)
- Health check fails 3 times
- Response time p95 > 5s (within 5 min)

Manual rollback decision:
- Data inconsistency detected
- Security vulnerability detected
- Critical business flow broken

> Command: `bash automation/scripts/rollback.sh production`

---

## 5. Related Documents
- `governance/standards/BRANCHING_STRATEGY.md`
- `governance/versioning/VERSIONING_STRATEGY.md`
- `governance/templates/RELEASE_NOTES_TEMPLATE.md`
- `governance/templates/DEPLOYMENT_RUNBOOK_TEMPLATE.md`
- `CHANGELOG.md`
