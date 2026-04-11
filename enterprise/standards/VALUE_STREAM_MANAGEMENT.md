# Value Stream Management (VSM)

> **Compliance References:**
> - Based on: Flow Framework (Mik Kersten 2018), Planview
> - Spec: Forrester Wave VSM 2025
> - Controls: Flow velocity, time, efficiency, load
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

VSM measures end-to-end flow of business value from idea to production. Connects engineering metrics to business outcomes.

---

## 1. Flow Metrics

| Metric | Definition | Target |
|--------|-----------|--------|
| **Flow Velocity** | Items completed per time period | Increasing trend |
| **Flow Time** | Idea to production (calendar time) | Decreasing trend |
| **Flow Efficiency** | Active time / Total time | > 15% |
| **Flow Load** | WIP items in progress | Within WIP limits |
| **Flow Distribution** | % split across item types | Balanced |

---

## 2. Flow Item Types

| Type | Description | Target Distribution |
|------|------------|-------------------|
| **Features** | New business value | 40-60% |
| **Defects** | Bug fixes | 10-20% |
| **Risks** | Security, compliance, tech debt | 15-25% |
| **Debt** | Refactoring, upgrades | 10-20% |

**Warning signs:** Defects > 30% = quality problem. Debt > 30% = foundation crumbling.

---

## 3. Value Stream Map

```
Idea → Backlog → Design → Dev → Review → Test → Stage → Prod
       [queue]   [active] [active] [queue] [active] [queue] [active]
       2 days    3 days   5 days   1 day   2 days   0.5d    0.5d
```

### Lead Time Breakdown
```
Total Lead Time = 14 days
Active Time = 11 days
Queue Time = 3 days
Flow Efficiency = 11/14 = 78% (excellent)
```

---

## 4. WIP Limits

| Stage | WIP Limit | Rationale |
|-------|-----------|-----------|
| Backlog (ready) | 2x sprint capacity | Enough for 2 sprints |
| In Development | Team size * 1.5 | Avoid context switching |
| In Review | Team size | Don't block reviewers |
| In Testing | Team size | Don't block testers |
| Ready for Deploy | 5 | Deploy frequently |

---

## 5. Bottleneck Identification

| Signal | Indicator | Action |
|--------|----------|--------|
| Queue growing | WIP above limit at a stage | Add capacity or reduce inflow |
| Cycle time spike | One stage takes 2x+ baseline | Investigate root cause |
| Blocked items | Items stuck > 2 days | Escalate, pair program |
| Low throughput | Velocity dropping | Remove impediments |

---

## 6. Quarterly Value Stream Review

1. Map current value stream (all stages)
2. Measure flow metrics for past quarter
3. Identify top 3 bottlenecks
4. Calculate flow efficiency
5. Review flow distribution balance
6. Set improvement targets
7. Assign kaizen actions

---

## 7. Integration with VSH

| Standard | Connection |
|----------|-----------|
| DORA_METRICS.md | Flow Time ≈ Lead Time |
| PROCESS_BASELINES.md | Flow metrics as baselines |
| DEVEX_SURVEY.md | Flow state dimension |
| AI_ESTIMATION_ENGINE.md | Flow data improves estimates |
