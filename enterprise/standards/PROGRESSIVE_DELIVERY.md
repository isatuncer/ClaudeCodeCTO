# Progressive Delivery Pipeline

> **Compliance References:**
> - Based on: James Governor (RedMonk 2018), LaunchDarkly
> - Spec: Canary, blue-green, feature flags
> - Controls: Automated rollback triggers
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Unified deployment strategy combining canary releases, blue-green deployments, feature flags, and automated rollback.

---

## 1. Strategies

| Strategy | Risk | Speed | Use Case |
|----------|------|-------|----------|
| **Canary** | Very Low | Slow | Production, high-risk changes |
| **Blue-Green** | Low | Fast | Zero-downtime deployments |
| **Feature Flags** | Very Low | Instant | Decouple deploy from release |
| **Shadow/Dark** | None | N/A | Testing with production traffic |

---

## 2. Canary Release Stages

| Stage | Traffic % | Duration | Promotion Criteria |
|-------|----------|----------|--------------------|
| 1 | 1% | 15 minutes | Error rate < 0.1%, p99 < 500ms |
| 2 | 5% | 30 minutes | Error rate < 0.1%, p99 < 500ms |
| 3 | 25% | 1 hour | Error rate < 0.1%, p99 < 500ms |
| 4 | 50% | 2 hours | Error rate < 0.1%, p99 < 500ms |
| 5 | 100% | - | Full rollout |

### Automatic Rollback Triggers
- Error rate > 1% for any canary stage
- p99 latency > 2x baseline
- 5xx rate > 0.5%
- Memory/CPU > 90%

---

## 3. Deployment Ring Strategy

| Ring | Audience | Purpose |
|------|----------|---------|
| Ring 0 | Internal team | Dogfooding |
| Ring 1 | Beta users (opt-in) | Early feedback |
| Ring 2 | 10% production | Canary validation |
| Ring 3 | 100% production | General availability |

---

## 4. Feature Flag Lifecycle

```
Create → Enable (Internal) → Enable (Beta) → Enable (GA) → Permanent/Remove
```

| State | Visibility | Duration |
|-------|-----------|----------|
| Created | Off for all | Until ready |
| Internal | Team only | 1-2 sprints |
| Beta | Opt-in users | 1-4 weeks |
| GA | All users | Permanent or remove |
| Stale | Flag > 90 days | Must decide: permanent or remove |

### Kill Switch
Every feature flag has a kill switch: instant disable without deployment.

---

## 5. Integration with VSH

| Standard | Connection |
|----------|-----------|
| FEATURE_FLAG_STRATEGY.md | Flag management details |
| RELEASE_MANAGEMENT.md | Release process |
| MONITORING_STRATEGY.md | Canary metrics monitoring |
| SRE_ERROR_BUDGET.md | Error budget impact |
| DORA_METRICS.md | Deployment frequency, CFR |
