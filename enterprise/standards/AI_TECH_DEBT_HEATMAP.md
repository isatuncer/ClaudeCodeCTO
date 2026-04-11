# AI-Powered Technical Debt Heatmap

> **Compliance References:**
> - Based on: CodeScene Methodology (Adam Tornhill 2015)
> - Spec: Behavioral code analysis
> - Controls: Hotspot detection, code health scoring
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Traditional debt tracking is manual and reactive. AI-powered heatmaps detect hotspots (high churn + high complexity) and prioritize by business impact.

---

## 1. Hotspot Detection

A **hotspot** is a file/module that changes frequently AND is complex. These are the highest-risk areas.

```
Risk Score = Change Frequency * Complexity Score * (1 / Test Coverage)
```

### Data Sources
| Metric | Source | Tool |
|--------|--------|------|
| Change Frequency | Git log (commits per file) | `git log --format=format: --name-only \| sort \| uniq -c \| sort -rn` |
| Complexity | Cyclomatic + Cognitive | SonarQube, ESLint |
| Test Coverage | Coverage report | Jest, pytest, go test |
| Coupling | Import analysis | dependency-cruiser |
| Age | Last modified date | Git log |

---

## 2. Code Health Score

| Grade | Score | Definition | Action |
|-------|-------|-----------|--------|
| A | 90-100 | Clean, well-tested, low complexity | Maintain |
| B | 70-89 | Good, minor improvements possible | Monitor |
| C | 50-69 | Technical debt accumulating | Schedule refactoring |
| D | 30-49 | Significant debt, high risk | Priority refactoring |
| F | 0-29 | Critical, rewrite candidate | Immediate action |

---

## 3. Debt Categories

| Category | Examples | Detection |
|----------|---------|-----------|
| **Design Debt** | God classes, missing abstractions, tight coupling | Coupling analysis, class size |
| **Code Debt** | Duplications, complex functions, magic numbers | SonarQube, ESLint |
| **Test Debt** | Low coverage, missing edge cases, flaky tests | Coverage reports |
| **Documentation Debt** | Missing docs, outdated README, no ADRs | Doc coverage check |
| **Infrastructure Debt** | Manual deployments, no monitoring, old dependencies | Config audit |

---

## 4. Prioritization Matrix

| | Low Business Impact | High Business Impact |
|---|---|---|
| **High Change Frequency** | Medium priority | **Critical priority** |
| **Low Change Frequency** | Low priority | Medium priority |

### Priority Formula
```
Priority = Business_Impact(1-5) * Change_Frequency(1-5) * Complexity(1-5) / Test_Coverage(0.1-1.0)
```

---

## 5. Sprint Allocation

| Sprint Phase | Debt Allocation | Focus |
|-------------|----------------|-------|
| Normal sprint | 15-20% capacity | Top 3 hotspots |
| Debt sprint (quarterly) | 100% capacity | Deep refactoring |
| Pre-release | 0% | Feature freeze |

---

## 6. Heatmap Report Template

```
Technical Debt Heatmap - Sprint [X]
Date: [YYYY-MM-DD]

TOP 10 HOTSPOTS
| Rank | File/Module | Churn | Complexity | Coverage | Health | Score |
|------|------------|-------|-----------|----------|--------|-------|
| 1 | src/auth/service.ts | 47 commits | 23 CC | 45% | D | 89 |
| 2 | src/api/routes.ts | 38 commits | 18 CC | 52% | D | 72 |
| ... | | | | | | |

DEBT SUMMARY
  Total debt items: [X]
  Critical (F grade): [X] modules
  High (D grade): [X] modules
  Estimated effort: [X] story points

TREND
  Previous sprint score: [X]
  Current sprint score: [Y]
  Direction: [Improving/Stable/Degrading]

ACTIONS THIS SPRINT
  - [ ] Refactor [module]: reduce complexity from [X] to [Y]
  - [ ] Add tests for [module]: increase coverage from [X]% to [Y]%
```

---

## 7. Integration with VSH

| Standard | Connection |
|----------|-----------|
| TECH_DEBT_REGISTER.md | Manual debt tracking enhanced by heatmap |
| CODE_HEALTH_GUARDRAILS.md | Health scoring methodology |
| ARCHITECTURE_FITNESS_FUNCTIONS.md | Automated detection |
| DORA_METRICS.md | Debt impacts lead time and failure rate |
