# Quantitative Process Management - CMMI Level 4-5

> **Compliance References:**
> - Based on: CMMI-DEV v2.0 Level 4-5
> - Spec: QPM, CAR Practice Areas
> - Controls: SPC, Cpk, prediction models
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Statistical process control (SPC) for software delivery. Uses control charts, capability baselines, and prediction models.

---

## 1. Key Sub-Practices

| Practice | CMMI Level | Purpose |
|----------|-----------|---------|
| Establish process performance objectives | L4 | Define quantitative targets |
| Select measures and analytic techniques | L4 | Choose what to measure |
| Manage using statistical methods | L4 | Control charts, baselines |
| Organizational performance models | L5 | Predict outcomes |
| Causal analysis and resolution | L5 | Root cause elimination |

---

## 2. Process Capability

### Process Capability Index (Cpk)
```
Cpk = min((USL - μ) / 3σ, (μ - LSL) / 3σ)

Where:
  USL = Upper Specification Limit
  LSL = Lower Specification Limit
  μ = Process mean
  σ = Process standard deviation
```

| Cpk Value | Capability | Action |
|-----------|-----------|--------|
| > 2.0 | World-class | Maintain |
| 1.33-2.0 | Capable | Monitor |
| 1.0-1.33 | Barely capable | Improve |
| < 1.0 | Not capable | Urgent action |

---

## 3. Prediction Models

### Schedule Prediction
```
Predicted Completion = Current Date + (Remaining SP / Avg Velocity) * Sprint Length
Confidence: ±1σ for 68%, ±2σ for 95%
```

### Quality Prediction
```
Expected Defects = (KLOC * Historical Defect Density) * (1 - Test Effectiveness)
```

### Cost Prediction
```
Predicted Cost = (Remaining Features * Avg Cost/Feature) + (Risk Buffer * 15%)
```

---

## 4. Control Charts for Software

| Chart Type | Measures | Use Case |
|-----------|---------|----------|
| X-bar | Sprint velocity mean | Velocity stability |
| R-chart | Velocity range | Variation in velocity |
| p-chart | Defect percentage | Quality trend |
| c-chart | Defect count per release | Release quality |
| u-chart | Defects per KLOC | Code quality |

---

## 5. Data Collection Repository

| Metric | Frequency | Source | Retention |
|--------|-----------|--------|-----------|
| Sprint velocity | Per sprint | Sprint retrospective | Permanent |
| Defect density | Per release | Bug tracker + LOC | Permanent |
| Cycle time | Per story | Project management tool | Permanent |
| Build success rate | Per build | CI/CD | 1 year |
| Test pass rate | Per build | CI/CD | 1 year |
| Code coverage | Per build | CI/CD | 1 year |
| DORA metrics | Per sprint | Deployment pipeline | Permanent |
| Estimation accuracy | Per sprint | MMRE calculation | Permanent |

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| PROCESS_BASELINES.md | Baseline data for SPC |
| DORA_METRICS.md | Key process metrics |
| CAUSAL_ANALYSIS.md | Triggered by SPC violations |
| AI_ESTIMATION_ENGINE.md | Prediction model data |
| VALUE_STREAM_MANAGEMENT.md | Flow metrics as process data |
