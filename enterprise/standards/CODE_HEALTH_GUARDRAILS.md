# AI Code Health Guardrails

> **Compliance References:**
> - Based on: CodeScene Methodology, SonarQube SQALE
> - Spec: ISO/IEC 25010:2011 (Maintainability)
> - Controls: Cyclomatic, cognitive complexity
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Beyond linting: behavioral complexity analysis that scores code health A-F and blocks PRs that degrade overall quality.

---

## 1. Health Dimensions

| Dimension | Metric | Threshold (WARN) | Threshold (BLOCK) |
|-----------|--------|-----------------|-------------------|
| Cyclomatic Complexity | Per function | > 10 | > 20 |
| Cognitive Complexity | Per function | > 15 | > 30 |
| Coupling (Afferent) | Incoming deps | > 20 | > 40 |
| Coupling (Efferent) | Outgoing deps | > 15 | > 30 |
| Churn Rate | Commits/month | > 10 | > 25 |
| Duplication | % duplicated lines | > 5% | > 10% |
| Test Coverage | Per module | < 80% | < 60% |
| File Size | Lines of code | > 500 | > 800 |
| Function Size | Lines of code | > 50 | > 100 |
| Nesting Depth | Max depth | > 4 | > 6 |

---

## 2. Code Health Score

### Per-Module Calculation
```
Health Score = 100
  - (complexity_violations * 5)
  - (coupling_violations * 4)
  - (coverage_gap * 3)      # (80 - actual_coverage) * 3
  - (duplication_pct * 2)
  - (churn_factor * 1)

Grade:
  A: 90-100
  B: 75-89
  C: 60-74
  D: 40-59
  F: 0-39
```

### Project-Level Score
```
Project Health = Weighted average of all module scores
Weight = Module size (LOC) * Change frequency
```

---

## 3. PR Blocking Rules

| Condition | Action |
|-----------|--------|
| Any module drops to F grade | BLOCK merge |
| Project score decreases > 5 points | BLOCK merge |
| New code has coverage < 80% | BLOCK merge |
| New function complexity > 20 | BLOCK merge |
| Everything else | PASS with health report comment |

---

## 4. Hotspot Prioritization

| | Low Churn | High Churn |
|---|---|---|
| **High Health (A-B)** | Stable, good | Watch for degradation |
| **Low Health (D-F)** | Risky but stable | **CRITICAL: Fix immediately** |

---

## 5. Tool Recommendations

| Tool | Language | What It Measures |
|------|----------|-----------------|
| SonarQube | Multi | Full code health suite |
| CodeClimate | Multi | Maintainability, duplication |
| ESLint + complexity rules | JS/TS | Complexity per function |
| Radon | Python | Cyclomatic complexity |
| gocyclo | Go | Cyclomatic complexity |
| cargo-geiger | Rust | Unsafe code usage |

---

## 6. Sprint Health Tracking

| Sprint | Score | Grade | Trend | Top Issue |
|--------|-------|-------|-------|-----------|
| Sprint 1 | | | Baseline | |
| Sprint 2 | | | | |

**Target:** Health score improves 2+ points per sprint.

---

## 7. Integration with VSH

| Standard | Connection |
|----------|-----------|
| AI_TECH_DEBT_HEATMAP.md | Health scores feed heatmap |
| ARCHITECTURE_FITNESS_FUNCTIONS.md | Complexity as fitness function |
| CODE_REVIEW_CHECKLIST.md | Health check in review |
| DEFINITION_OF_DONE.md | Health score maintained for DoD |
