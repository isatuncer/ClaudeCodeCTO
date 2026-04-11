# Chaos Engineering Game Days Framework

> **Compliance References:**
> - Based on: AWS GameDay, Gremlin Chaos Framework
> - Spec: Principles of Chaos Engineering (Netflix 2019)
> - Controls: Experiment catalog, scoring
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Game Days are structured resilience testing events where teams inject controlled failures and practice incident response. Quarterly cadence builds muscle memory.

---

## 1. Experiment Catalog

| # | Experiment | Blast Radius | Complexity |
|---|-----------|-------------|-----------|
| 1 | Network latency injection (100-500ms) | Service-to-service | Low |
| 2 | Service crash (kill process) | Single service | Low |
| 3 | Disk full (fill temp disk to 95%) | Single host | Low |
| 4 | Database failover (promote replica) | Data layer | Medium |
| 5 | DNS failure (block DNS resolution) | Cross-service | Medium |
| 6 | Certificate expiry simulation | TLS endpoints | Medium |
| 7 | Memory leak simulation (gradual OOM) | Single service | Medium |
| 8 | CPU spike (stress test to 95%) | Single host | Low |
| 9 | Dependency timeout (external API 30s delay) | Integration | Medium |
| 10 | Data corruption (invalid records) | Data layer | High |
| 11 | Region failover | Infrastructure | High |
| 12 | Cascading failure (multiple services) | Cross-service | High |

---

## 2. Maturity Levels

| Level | Name | Description |
|-------|------|------------|
| L1 | Manual | Ad-hoc experiments in dev environment |
| L2 | Scheduled | Quarterly game days in staging |
| L3 | Continuous | Automated chaos in staging CI/CD |
| L4 | Production | Controlled experiments in production with safeguards |

---

## 3. Game Day Execution Runbook

### Before (1 week prior)
- [ ] Select 3-5 experiments from catalog
- [ ] Notify all teams
- [ ] Verify rollback procedures
- [ ] Set up monitoring dashboards
- [ ] Define success criteria per experiment
- [ ] Prepare communication channels

### During (Game Day)
- [ ] Brief all participants (15 min)
- [ ] Run experiments one at a time
- [ ] For each experiment:
  - Announce injection start time
  - Inject failure
  - Start timer: detection time
  - Observe team response
  - Record: detection, diagnosis, recovery times
  - Verify rollback/recovery
  - Debrief between experiments (10 min)

### After (within 1 week)
- [ ] Score each experiment
- [ ] Write game day report
- [ ] Create action items for gaps found
- [ ] Update runbooks based on learnings
- [ ] Schedule next game day

---

## 4. Scoring Rubric

| Dimension | 1 (Poor) | 3 (Good) | 5 (Excellent) |
|-----------|----------|----------|---------------|
| **Detection** | > 15 min | 5-15 min | < 5 min |
| **Diagnosis** | > 30 min | 10-30 min | < 10 min |
| **Recovery** | > 60 min | 15-60 min | < 15 min |
| **Communication** | No updates | Periodic updates | Real-time updates |
| **Documentation** | No post-mortem | Basic notes | Full post-mortem |

**Game Day Score = Average of all dimensions across all experiments (5-25 scale)**

---

## 5. Game Day Report Template

```
Game Day Report
Date: [YYYY-MM-DD]
Participants: [list]
Environment: [staging/production]

EXPERIMENTS
| # | Experiment | Detection | Diagnosis | Recovery | Communication | Score |
|---|-----------|-----------|-----------|----------|---------------|-------|
| 1 | [name] | [time] | [time] | [time] | [1-5] | [X/25] |

OVERALL SCORE: [X/25]
PREVIOUS SCORE: [Y/25]
TREND: [Improving/Stable/Degrading]

KEY FINDINGS
- [finding 1]
- [finding 2]

ACTION ITEMS
| # | Action | Owner | Deadline |
|---|--------|-------|----------|
| 1 | [action] | [name] | [date] |
```

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| CHAOS_ENGINEERING.md | Experiment principles and safety |
| INCIDENT_RESPONSE_PLAN.md | Practice incident workflow |
| DISASTER_RECOVERY_PLAN.md | Test DR procedures |
| SRE_ERROR_BUDGET.md | Game day impact on error budget |
| DORA_METRICS.md | MTTR improvement tracking |
