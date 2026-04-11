# Organizational Process Performance Baselines - CMMI Level 4

> **Compliance References:**
> - Based on: CMMI-DEV v2.0 Level 4, Shewhart SPC
> - Spec: Statistical Process Control
> - Controls: Control charts, UCL/LCL
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Process baselines are historical performance measurements used to detect anomalies, predict outcomes, and manage by exception. Required for CMMI Level 4+.

---

## 1. Key Metrics to Baseline

| Metric | Unit | Collection Point |
|--------|------|-----------------|
| Defect density | Defects per KLOC | Post-release |
| Sprint velocity | Story points per sprint | Sprint end |
| Cycle time | Hours (story start → done) | Per story |
| Code review time | Hours (PR open → approved) | Per PR |
| Test pass rate | % of tests passing | Per build |
| Build success rate | % of builds succeeding | Per build |
| Deployment frequency | Deploys per week | Per deploy |
| Change failure rate | % of deploys causing failure | Per deploy |
| MTTR | Minutes to recover | Per incident |
| Test coverage | % line coverage | Per build |

---

## 2. Establishing Baselines

### Minimum Data Requirements
- **6 sprints** of consistent data for reliable baselines
- **30 data points** per metric for statistical significance
- Same team composition and process

### Calculation
```
Mean (X̄) = Sum of values / Number of observations
Std Dev (σ) = √(Σ(xi - X̄)² / (n-1))
UCL = X̄ + 3σ  (Upper Control Limit)
LCL = X̄ - 3σ  (Lower Control Limit)
```

---

## 3. Control Charts

### X-bar Chart (for means)
```
UCL ─────────────────────── X̄ + 3σ
                    *
         *    *         *
Mean ─── * ── * ── * ── * ── * ── X̄
    *              *
              *              *
LCL ─────────────────────── X̄ - 3σ
     S1   S2   S3   S4   S5   S6
```

### Rules for Out-of-Control
| Rule | Condition | Action |
|------|-----------|--------|
| 1 | Single point > UCL or < LCL | Investigate immediately |
| 2 | 7 consecutive points on same side of mean | Trend detected, investigate |
| 3 | 6 consecutive increasing/decreasing | Systematic shift, investigate |
| 4 | 2 of 3 consecutive points > 2σ from mean | Warning, monitor closely |

---

## 4. Baseline Dashboard Template

```
Process Performance Baselines
Updated: [YYYY-MM-DD]
Data Period: Sprint [X] - Sprint [Y]

| Metric | Mean | Std Dev | UCL | LCL | Current | Status |
|--------|------|---------|-----|-----|---------|--------|
| Velocity | [X] sp | [Y] | [Z] | [W] | [V] | [Normal/Warning/Alert] |
| Cycle Time | [X] hrs | [Y] | [Z] | [W] | [V] | |
| Defect Density | [X]/KLOC | [Y] | [Z] | [W] | [V] | |
| Review Time | [X] hrs | [Y] | [Z] | [W] | [V] | |
| Build Success | [X]% | [Y] | [Z] | [W] | [V] | |
| Coverage | [X]% | [Y] | [Z] | [W] | [V] | |
```

---

## 5. Quarterly Recalibration

Every quarter:
1. Collect new data from past quarter
2. Recalculate mean and control limits
3. Compare with previous baseline
4. Identify systematic improvements or degradations
5. Update baseline if process has genuinely changed
6. Document reasons for baseline changes

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| DORA_METRICS.md | DF, LT, CFR, MTTR baselines |
| QUANTITATIVE_PROCESS_MGMT.md | SPC and prediction models |
| CAUSAL_ANALYSIS.md | Triggered by out-of-control signals |
| DEVEX_SURVEY.md | DevEx scores as process metric |
