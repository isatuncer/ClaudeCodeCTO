# Estimation Guide

> **Compliance References:**
> - Based on: COCOMO II (Boehm 2000), IFPUG Function Points 4.3.1
> - Spec: Parametric estimation
> - Controls: Story points, T-shirt sizing
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Standard for consistent work size estimation in sprint planning.

---

## 1. Story Point Scale (Fibonacci)

| SP | Size | Example | Estimated Duration |
|----|------|---------|-------------------|
| **1** | Trivial | Text change, config update | < 1 hour |
| **2** | Small | Simple CRUD endpoint, minor UI fix | 1-3 hours |
| **3** | Medium-small | Form + validation + API connection | 3-6 hours |
| **5** | Medium | New page + API + DB + test | 1-2 days |
| **8** | Large | New module (auth, payment, etc.) | 2-4 days |
| **13** | Very large | Complex integration, new service | 4-7 days |
| **21** | Epic | Must be split - doesn't fit in a single sprint | 1-2 weeks |

> **Rule:** Items with 13+ SP MUST BE SPLIT. Max 8 SP per single task.

---

## 2. T-Shirt Sizing (Quick Estimation)

| Size | SP Equivalent | Usage |
|------|--------------|-------|
| XS | 1 | Config, text, typo fix |
| S | 2-3 | Simple feature, minor bug fix |
| M | 5 | Standard feature |
| L | 8 | Complex feature |
| XL | 13+ | MUST BE SPLIT |

---

## 3. Estimation Meeting Protocol

### Planning Poker
1. Product Owner explains the task
2. Everyone (each agent/department) estimates independently
3. Highest and lowest explain their reasoning
4. New round after discussion
5. Consensus (or median is taken)

### Estimation Issues
| Issue | Solution |
|-------|----------|
| High uncertainty | Create a spike task (research), then estimate |
| Everyone estimates differently | The highest estimator explains the risk |
| Always underestimating | Add x1.5 buffer (Hofstadter's law) |
| No comparison point | Set a reference story (this was 5 SP, how does the new one compare?) |

---

## 4. Velocity Tracking

### Sprint Velocity
```
Velocity = Total completed SP / Number of sprints
```

### Capacity Calculation
```
Sprint capacity = Average velocity x 85% (buffer)
```

| Sprint | Planned SP | Completed SP | Velocity |
|--------|-----------|--------------|----------|
| Sprint 1 | 30 | 25 | 25 |
| Sprint 2 | 28 | 28 | 28 |
| Sprint 3 | 30 | 22 | 22 |
| **Average** | - | - | **25** |
| **Capacity** | - | - | **~21** |

---

## 5. Task Types and Multipliers

| Task Type | SP Multiplier | Description |
|-----------|--------------|-------------|
| New feature | x1.0 | Normal estimate |
| Bug fix | x0.7 | Generally faster |
| Refactoring | x1.2 | Risk + test effort |
| Technical debt | x1.3 | More unknowns |
| Integration | x1.5 | External dependency risk |
| Security | x1.3 | Extra test + review |
| Migration | x1.5 | Rollback plan included |

---

## 6. Required Overhead

To be included in every task (not estimated separately):
- [ ] Unit test writing (20-30% additional effort)
- [ ] Code review process (10%)
- [ ] Documentation (5-10%)
- [ ] CI/CD + deployment (5%)

> **Total:** Add x1.4-1.5 multiplier to pure coding time
