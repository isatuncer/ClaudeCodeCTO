# Developer Experience (DevEx) Survey & Metrics

> **Compliance References:**
> - Based on: DX Core 4 Framework (Storey et al. 2023)
> - Spec: Developer experience measurement
> - Controls: Flow, cognitive load, feedback loops
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Developer Experience (DevEx) measures how productive, satisfied, and efficient developers feel. Research shows strong correlation between DevEx scores and delivery performance (DORA metrics). This standard defines how to measure and improve DevEx.

---

## 1. Three Dimensions of DevEx

| Dimension | What It Measures | Impact |
|-----------|-----------------|--------|
| **Flow State** | Ability to focus, uninterrupted deep work | Productivity, quality |
| **Cognitive Load** | Complexity of tools, processes, codebase | Speed, onboarding |
| **Feedback Loops** | Speed of CI/CD, code review, deployment | Iteration speed |

---

## 2. Quarterly Survey (15 Questions)

Rate each statement from 1 (Strongly Disagree) to 5 (Strongly Agree):

### Flow State (5 questions)
1. I can focus on coding for 2+ hours without interruption
2. I have clear priorities and know what to work on next
3. Meetings don't disrupt my productive coding time
4. I feel "in the zone" regularly during my work week
5. Context switching between tasks is minimal

### Cognitive Load (5 questions)
6. The codebase is easy to understand and navigate
7. Development environment setup is straightforward
8. Documentation is sufficient to do my work
9. I don't need to understand too many systems to make a change
10. Error messages and logs help me debug quickly

### Feedback Loops (5 questions)
11. CI/CD pipeline gives me results in < 10 minutes
12. Code reviews are completed within 4 hours
13. I can deploy my changes to a test environment easily
14. Automated tests give me confidence my changes work
15. I get clear feedback when something breaks

---

## 3. Scoring Methodology

### Individual Score
```
Dimension Score = Average of 5 questions in that dimension (1.0 - 5.0)
Overall DevEx Score = Average of all 3 dimensions (1.0 - 5.0)
```

### Team Score
```
Team DevEx = Average of all individual DevEx scores
```

### Classification

| Score | Rating | Action |
|-------|--------|--------|
| 4.5 - 5.0 | Excellent | Maintain, share best practices |
| 3.5 - 4.4 | Good | Minor improvements |
| 2.5 - 3.4 | Needs Improvement | Targeted action plan |
| 1.0 - 2.4 | Critical | Immediate intervention |

---

## 4. Benchmark Targets

| Metric | Minimum | Target | Elite |
|--------|---------|--------|-------|
| Overall DevEx | 3.0 | 4.0 | 4.5+ |
| Flow State | 3.0 | 4.0 | 4.5+ |
| Cognitive Load | 3.0 | 3.5 | 4.0+ |
| Feedback Loops | 3.5 | 4.0 | 4.5+ |
| Survey Response Rate | 60% | 80% | 95%+ |

---

## 5. Action Plans by Dimension

### Low Flow State (< 3.0)
- [ ] Implement "Focus Fridays" (no meetings)
- [ ] Reduce WIP limits (max 1 active task per developer)
- [ ] Create maker schedule (4-hour coding blocks)
- [ ] Reduce Slack/notification interruptions

### Low Cognitive Load (< 3.0)
- [ ] Improve onboarding documentation
- [ ] Simplify development environment setup (1-command)
- [ ] Reduce codebase complexity (refactoring sprints)
- [ ] Create architecture decision records (ADRs) for context
- [ ] Improve error messages and logging

### Low Feedback Loops (< 3.0)
- [ ] Optimize CI/CD pipeline (target < 10 min)
- [ ] Set code review SLA (4-hour turnaround)
- [ ] Add preview environments per PR
- [ ] Improve test reliability (fix flaky tests)
- [ ] Add deployment status notifications

---

## 6. Correlation with DORA Metrics

| DevEx Dimension | DORA Correlation |
|----------------|-----------------|
| Flow State ↑ | Lead Time ↓, Deployment Frequency ↑ |
| Cognitive Load ↓ | Change Failure Rate ↓ |
| Feedback Loops ↑ | Lead Time ↓, MTTR ↓ |

**Track both together** - DevEx improvement should lead to DORA improvement within 1-2 quarters.

---

## 7. Team Health Radar Template

```
           Flow State
              5
              |
              4
              |
    Feedback  3---+---3  Cognitive
    Loops     |   |   |  Load
              2   |   2
              |   |   |
              1   1   1
```

Plot team averages per dimension. Ideal shape: large, balanced triangle.

---

## 8. Survey Schedule

| Activity | Frequency | Owner |
|----------|-----------|-------|
| Full DevEx Survey | Quarterly | Scrum Master |
| Pulse Check (3 questions) | Monthly | Tech Lead |
| Action Plan Review | Monthly | Engineering Manager |
| DevEx Retrospective | Quarterly | Team |

---

## 9. Integration with VSH

- DevEx Survey runs at every sprint retrospective (abbreviated)
- Full survey at end of each phase transition
- Results inform sprint capacity planning
- Low DevEx scores trigger process improvement tasks in backlog
