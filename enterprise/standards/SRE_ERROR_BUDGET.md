# SRE Error Budget & SLO/SLI Framework

> **Compliance References:**
> - Based on: Google SRE Book (2016)
> - Spec: SLO/SLI Framework
> - Controls: Error budget policy, burn rate alerts
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Service Level Objectives (SLOs) bridge development and operations with data-driven reliability decisions. When the error budget depletes, feature development pauses for reliability work.

---

## 1. Key Concepts

| Term | Definition | Example |
|------|-----------|---------|
| **SLI** (Indicator) | Measurable metric of service health | 99.2% requests < 200ms |
| **SLO** (Objective) | Target for an SLI | 99.5% requests < 200ms |
| **SLA** (Agreement) | Business contract with consequences | 99.9% uptime or credit |
| **Error Budget** | Allowed unreliability = 1 - SLO | 0.5% = ~3.6 hours/month |

---

## 2. SLI Definitions by Service Type

### API Services
| SLI | Measurement | Good Event |
|-----|------------|-----------|
| Availability | HTTP status codes | 2xx or 3xx response |
| Latency | Response time | p99 < 500ms |
| Error Rate | 5xx responses | < 0.1% of requests |
| Throughput | Requests/second | Within capacity plan |

### Web Frontend
| SLI | Measurement | Good Event |
|-----|------------|-----------|
| LCP | Largest Contentful Paint | < 2.5s |
| FID | First Input Delay | < 100ms |
| CLS | Cumulative Layout Shift | < 0.1 |
| TTFB | Time to First Byte | < 800ms |

### Database
| SLI | Measurement | Good Event |
|-----|------------|-----------|
| Query Latency | p95 query time | < 50ms |
| Connection Pool | Available connections | > 20% free |
| Replication Lag | Replica delay | < 1 second |

---

## 3. SLO Targets

| Service | SLI | SLO | Error Budget (30d) |
|---------|-----|-----|-------------------|
| API Gateway | Availability | 99.9% | 43.2 minutes |
| API Gateway | Latency p99 | < 500ms for 99% | 432 minutes of slow |
| Web App | Availability | 99.5% | 3.6 hours |
| Database | Query p95 | < 50ms for 99.9% | 4.3 minutes |
| Auth Service | Availability | 99.99% | 4.3 minutes |

### Error Budget Calculation
```
Error Budget = (1 - SLO) * Time Period

Example: 99.9% SLO over 30 days
Budget = 0.001 * 30 * 24 * 60 = 43.2 minutes of downtime allowed
```

---

## 4. Error Budget Policy

### Budget Status Actions

| Budget Remaining | Status | Action |
|-----------------|--------|--------|
| > 50% | GREEN | Normal development, ship features |
| 25-50% | YELLOW | Caution, prioritize reliability tasks |
| 10-25% | ORANGE | Feature freeze for non-critical, reliability sprint |
| < 10% | RED | Full feature freeze, all hands on reliability |
| 0% (depleted) | BLACK | No deployments until budget recovers |

### Burn Rate Alerts

| Alert | Burn Rate | Time to Exhaustion | Action |
|-------|-----------|-------------------|--------|
| Page (P1) | 14.4x | 2 hours | Immediate response |
| Page (P2) | 6x | 5 hours | Urgent response |
| Ticket | 3x | 10 hours | Next business day |
| Log | 1x | 30 days | Monitor trend |

---

## 5. SLO Dashboard Template

```
Service: [SERVICE_NAME]
Period: [MONTH YEAR]

SLO Status:
  Availability: [99.X%] / 99.9% target  [██████████░] budget: [X min] remaining
  Latency p99:  [XXXms] / 500ms target   [████████░░░] budget: [X min] remaining
  Error Rate:   [0.X%]  / 0.1% target    [███████████] budget: [X min] remaining

Incidents This Period: [X]
Budget Consumed: [X%]
Trend: [Improving/Stable/Degrading]
```

---

## 6. Toil Measurement

Toil = manual, repetitive, automatable, reactive, no lasting value work.

| Category | Examples | Measurement |
|----------|---------|-------------|
| Deployment toil | Manual deploys, config changes | Hours/sprint |
| Incident toil | Repeated alerts, manual recovery | Hours/sprint |
| Capacity toil | Manual scaling, disk cleanup | Hours/sprint |
| Monitoring toil | Alert noise, false positives | Alerts/week |

**Target:** Toil < 50% of on-call time. Reduce 10% per quarter.

---

## 7. Quarterly SLO Review

### Agenda
1. Review SLO performance vs target
2. Error budget consumption analysis
3. Incident impact on budget
4. Toil measurement review
5. SLO adjustment proposals (tighten or relax)
6. Reliability work prioritization

---

## 8. Integration with VSH

| Standard | Connection |
|----------|-----------|
| DORA_METRICS.md | MTTR correlates with error budget |
| MONITORING_STRATEGY.md | SLI data collection |
| OBSERVABILITY_STRATEGY.md | Distributed tracing for SLI |
| INCIDENT_RESPONSE_PLAN.md | Budget impact per incident |
| AI_POSTMORTEM_GENERATOR.md | Budget consumption in post-mortems |
| PERFORMANCE_BUDGET.md | Performance SLIs |
