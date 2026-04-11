# Chaos Engineering Strategy

> **Compliance References:**
> - Based on: Principles of Chaos Engineering (Netflix 2019)
> - Spec: 5 Principles of Chaos
> - Controls: Experiment catalog, blast radius
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Principle: "Deliberately break the system. A system that stays up is truly reliable."

---

## 1. When to Apply

| Phase | Requirement |
|-------|------------|
| Staging - sprint end | Recommended |
| Pre-production (before release) | MANDATORY |
| Production (stable period) | Optional (game day) |

> **NEVER** run chaos on first deploy or on an unknown system.
> Monitoring + alerting + rollback must be READY first.

---

## 2. Chaos Experiments

### Hypothesis-Based Approach
```
1. Hypothesis: "If DB replica goes down, the system continues operating in read-only mode"
2. Experiment: Shut down DB replica
3. Measurement: Error rate, response time, user impact
4. Result: Is hypothesis correct? Is the system resilient?
```

### Experiment Catalog

| ID | Experiment | What Breaks | Expected Behavior | Severity |
|----|-----------|-------------|-------------------|----------|
| CE-001 | DB Replica Down | Read replica is shut down | Falls back to reading from primary, slows down but continues | Medium |
| CE-002 | Redis Down | Redis service is stopped | Cache miss, reads from DB, slows down but continues | Medium |
| CE-003 | App Instance Kill | 1 container is killed | LB routes traffic to other instances, NO downtime | Low |
| CE-004 | Network Latency | 500ms artificial delay | Is timeout handling working, is retry correct | Medium |
| CE-005 | Disk Full | Disk 100% full simulation | Graceful error, log writing should not error, alert should trigger | High |
| CE-006 | DNS Failure | DNS resolution fails | 3rd party services degrade, core continues | High |
| CE-007 | 3rd Party Down | Payment/email provider down | Circuit breaker open, operation queued, retry | High |
| CE-008 | Memory Leak | Continuously increasing memory | OOM handler works, recovery after restart | High |
| CE-009 | Clock Skew | System clock 5min ahead/behind | JWT validation, cron jobs, log timestamps should not be affected | Medium |
| CE-010 | Certificate Expiry | SSL certificate expired | Alert triggers, automatic renewal | High |

---

## 3. Blast Radius Control

| Environment | Max Blast Radius |
|-------------|-----------------|
| Development | Unlimited - try everything |
| Staging | 100% traffic can be affected |
| Production - Game Day | Max 5% traffic (canary segment) |
| Production - Automated | Max 1% traffic + automatic rollback |

---

## 4. Tools

| Tool | Platform | Type |
|------|----------|------|
| Litmus | Kubernetes | Open source |
| Gremlin | Any | SaaS |
| Chaos Monkey | AWS | Netflix OSS |
| Toxiproxy | Any | Network proxy (latency, timeout) |
| tc (traffic control) | Linux | Network emulation |
| `kill -9` | Any | Process kill |
| `stress-ng` | Linux | CPU/memory/disk stress |

---

## 5. Chaos Experiment Report Template

```markdown
## Chaos Experiment Report

| Field | Value |
|-------|-------|
| Experiment ID | CE-[N] |
| Date | [DATE] |
| Environment | Staging / Production |
| Hypothesis | [Expected behavior] |

### Experiment Detail
- What was done: [Description]
- Duration: [N minutes]
- Affected: [Service/users]

### Results
| Metric | Before Experiment | During Experiment | After Recovery |
|--------|------------------|-------------------|----------------|
| Error rate | 0.01% | [N]% | 0.01% |
| Response time p95 | 200ms | [N]ms | 200ms |
| Availability | 99.99% | [N]% | 99.99% |

### Hypothesis Result
- [ ] CONFIRMED - System is resilient
- [ ] FALSE - System broke, fix required

### Actions (If hypothesis is false)
| Action | Responsibility | Deadline |
|--------|---------------|----------|
| [Fix] | [Who] | [Date] |
```

---

## Related Documents
- `governance/standards/MONITORING_STRATEGY.md`
- `governance/standards/RUNBOOK_INDEX.md`
- `governance/incidents/INCIDENT_RESPONSE_PLAN.md`
- `governance/templates/POSTMORTEM_TEMPLATE.md`
