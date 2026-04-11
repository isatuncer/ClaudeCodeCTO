# Architecture Fitness Functions

> **Compliance References:**
> - Based on: "Building Evolutionary Architectures" (Neal Ford 2017)
> - Spec: Automated fitness functions
> - Controls: Dependency, complexity, performance rules
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Fitness functions are automated tests that validate architectural characteristics. They run in CI and fail the build if architecture degrades. From Neal Ford's "Building Evolutionary Architectures."

---

## 1. Categories

| Category | What It Guards | Example |
|----------|---------------|---------|
| **Performance** | Speed, throughput | API response < 500ms |
| **Security** | Attack surface | No hardcoded secrets |
| **Dependency** | Coupling rules | No circular dependencies |
| **Complexity** | Code health | Cyclomatic complexity < 10 |
| **Reliability** | Fault tolerance | Circuit breakers on external calls |
| **Compliance** | Regulatory | Audit columns on all tables |

---

## 2. Fitness Function Catalog

### 2.1 Dependency Rules
| Rule | Check | Severity |
|------|-------|----------|
| No circular dependencies | dependency-cruiser, madge | BLOCK |
| Controllers cannot import repositories directly | Layer check | BLOCK |
| No direct DB access from route handlers | Import analysis | BLOCK |
| Max dependency depth: 4 levels | Tree analysis | WARN |
| No importing from `internal/` outside module | Boundary check | BLOCK |

### 2.2 Complexity Rules
| Rule | Check | Severity |
|------|-------|----------|
| Cyclomatic complexity < 10 per function | ESLint, SonarQube | WARN (>10), BLOCK (>20) |
| Cognitive complexity < 15 per function | SonarQube | WARN |
| File size < 500 lines | Line count | WARN |
| Function size < 50 lines | Line count | WARN |
| Nesting depth < 4 levels | AST analysis | WARN |

### 2.3 Performance Rules
| Rule | Check | Severity |
|------|-------|----------|
| API response p95 < 500ms | Load test | BLOCK |
| Bundle size < 250KB (gzipped) | Webpack analysis | WARN |
| No N+1 queries | Query analysis | BLOCK |
| Database query < 100ms | Explain analyze | WARN |

### 2.4 Security Rules
| Rule | Check | Severity |
|------|-------|----------|
| No hardcoded secrets | TruffleHog, regex | BLOCK |
| Security headers present | Response check | BLOCK |
| HTTPS enforced | Config check | BLOCK |
| Parameterized queries only | AST/regex scan | BLOCK |
| Input validation on all endpoints | Schema check | WARN |

### 2.5 Compliance Rules
| Rule | Check | Severity |
|------|-------|----------|
| Audit columns on all entities | Schema check | BLOCK |
| Soft delete pattern used | Schema check | WARN |
| PII fields marked for masking | Annotation check | BLOCK |
| Rate limiting on all public endpoints | Config check | BLOCK |

---

## 3. CI Integration

```yaml
# GitHub Actions fitness function step
- name: Architecture Fitness Functions
  run: |
    # Dependency checks
    npx dependency-cruiser --validate .dependency-cruiser.cjs src/
    
    # Complexity checks
    npx eslint src/ --rule 'complexity: [error, 10]'
    
    # File size checks
    find src/ -name '*.ts' -size +500l -exec echo "WARN: Large file: {}" \;
    
    # Security checks
    npx trufflehog filesystem src/ --only-verified
    
    echo "All fitness functions passed"
```

---

## 4. Scoring & Trending

### Architecture Health Score

| Grade | Score | Meaning |
|-------|-------|---------|
| A | 90-100 | Excellent, all fitness functions pass |
| B | 75-89 | Good, minor warnings only |
| C | 60-74 | Needs attention, multiple warnings |
| D | 40-59 | Poor, some blocking violations |
| F | 0-39 | Critical, major architectural degradation |

### Score Formula
```
Score = 100 - (BLOCK_violations * 10) - (WARN_violations * 3)
```

### Sprint Tracking
| Sprint | Score | Blocks | Warns | Trend |
|--------|-------|--------|-------|-------|
| Sprint 1 | | | | Baseline |
| Sprint 2 | | | | |

---

## 5. Adding New Fitness Functions

1. Identify architectural characteristic to protect
2. Define measurable threshold
3. Choose detection tool/method
4. Set severity (BLOCK or WARN)
5. Add to CI pipeline
6. Document in this file
7. Monitor for false positives (first 2 sprints)

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| CODE_HEALTH_GUARDRAILS.md | Complexity and coupling metrics |
| DEFINITION_OF_DONE.md | Fitness functions must pass for DoD |
| CODE_REVIEW_CHECKLIST.md | Architecture review items |
| PERFORMANCE_BUDGET.md | Performance thresholds |
