# Deployment Runbook

## Document Information
| Field | Value |
|-------|-------|
| Project Name | [PROJECT_NAME] |
| Version | [vX.Y.Z] |
| Author | DevOps & Infra Dept. |
| Date | [DATE] |
| Target Environment | Staging / Production |

---

## 1. Prerequisites

### 1.1 Checklist
- [ ] All tests passed (unit, integration, e2e)
- [ ] Code review completed
- [ ] Security scan clean
- [ ] Performance tests acceptable
- [ ] DB migrations tested (staging)
- [ ] Rollback plan ready
- [ ] Relevant teams notified
- [ ] Monitoring dashboards ready

### 1.2 Required Access
| System | Access | Responsibility |
|--------|--------|---------------|
| CI/CD | Deploy permission | DevOps |
| Cloud Console | Admin | DevOps |
| DB | Migration permission | DBA |
| Monitoring | Read | All team |

---

## 2. Deployment Steps

### Step 1: Preparation (T-30 min)
```bash
# 1. Pull latest code
git fetch origin && git checkout main

# 2. Build and test
[build_command]
[test_command]

# 3. Create Docker image
docker build -t [project]:[version] .
docker push [registry]/[project]:[version]
```

**Verification:**
- [ ] Build successful
- [ ] All tests passed
- [ ] Image pushed to registry

### Step 2: Database (T-15 min)
```bash
# 1. Take backup
[backup_command]

# 2. Run migration
[migration_command]

# 3. Verify
[verification_query]
```

**Verification:**
- [ ] Backup taken
- [ ] Migration successful
- [ ] Schema correct

### Step 3: Deployment (T-0)
```bash
# 1. Save current state
[save_current_version]

# 2. Deploy new version
[deploy_command]

# 3. Monitor rolling update status
[status_command]
```

**Verification:**
- [ ] All pods/instances healthy
- [ ] Health check passed
- [ ] No errors in logs

### Step 4: Smoke Test (T+5 min)
| Test | Endpoint/Flow | Expected | Status |
|------|-------------|----------|--------|
| Health | GET /health | 200 OK | [ ] |
| Login | POST /auth/login | 200 + token | [ ] |
| Home page | GET / | 200 | [ ] |
| API list | GET /api/v1/[resource] | 200 + data | [ ] |
| DB write | POST /api/v1/[resource] | 201 | [ ] |

### Step 5: Monitoring (T+30 min)
| Metric | Normal Range | Alarm Threshold |
|--------|-------------|----------------|
| Error rate | < 0.1% | > 1% |
| Response time p95 | < 500ms | > 2s |
| CPU | < 50% | > 80% |
| Memory | < 60% | > 85% |
| DB connections | < 50 | > 80 |

---

## 3. Rollback Procedure

### 3.1 Rollback Trigger Conditions
| Condition | Severity | Automatic/Manual |
|-----------|----------|-----------------|
| Error rate > 5% | Critical | Automatic |
| All health checks failed | Critical | Automatic |
| Performance drop 50%+ | High | Manual |
| Data inconsistency | Critical | Manual |

### 3.2 Rollback Steps
```bash
# 1. Revert to previous version
[rollback_command]

# 2. DB rollback (if needed)
[migration_down_command]

# 3. Verification
[health_check]
```

### 3.3 After Rollback
- [ ] Services running normally
- [ ] Data consistency verified
- [ ] Incident report opened
- [ ] Root cause analysis started

---

## 4. Communication Plan

### 4.1 Pre-Deployment
| To | When | Channel | Message |
|----|------|---------|---------|
| Development team | T-1 hour | [Channel] | Deploy plan |
| QA team | T-1 hour | [Channel] | Test preparation |
| Business units | T-30 min | [Channel] | Maintenance notification |

### 4.2 Post-Deployment
| Status | To | Message |
|--------|-----|---------|
| Successful | All team | "v[X.Y.Z] deployed successfully" |
| Issues | DevOps + Dev | "Deployment issue - investigation started" |
| Rollback | All team | "Rollback performed - reason: [reason]" |

---

## 5. Event History

| Date | Version | Environment | Status | Notes |
|------|---------|------------|--------|-------|
| [DATE] | v[X.Y.Z] | Production | Successful/Rollback | [Note] |

---

## 6. Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| DevOps Lead | VSH | [DATE] | Pending |
| CTO | VSH | [DATE] | Pending |
