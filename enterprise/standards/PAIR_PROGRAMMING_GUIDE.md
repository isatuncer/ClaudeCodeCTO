# Pair Programming & Mob Programming Guide

> **Compliance References:**
> - Based on: Kent Beck "Extreme Programming Explained" 2nd Ed.
> - Spec: XP Practices
> - Controls: Driver-Navigator, Ping-Pong TDD
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Rule: Critical modules are NEVER written by a single person.

---

## 1. When MANDATORY

| Situation | Pair Required? | Reason |
|-----------|---------------|--------|
| Authentication/Authorization code | **YES** | Security critical |
| Payment/financial processing | **YES** | Data integrity critical |
| Cryptography/encryption | **YES** | Errors are intolerable |
| Database migration (prod) | **YES** | Hard to reverse |
| Core business logic | **YES** | Business rule errors are costly |
| Infrastructure as Code | **YES** | Wrong config = downtime |
| New engineer (onboarding) | YES | Knowledge transfer |
| Bug fix (P1/P2) | Recommended | Fast and correct resolution |
| Refactoring | Recommended | Risky changes |
| Normal feature | Optional | Depends on complexity |

---

## 2. Pair Programming Formats

### Driver-Navigator
```
Driver:    At keyboard, writes code
Navigator: Watches screen, directs, catches errors, thinks big picture

SWITCH ROLES every 25 minutes (Pomodoro)
```

### Ping-Pong (TDD Pair)
```
Person A: Writes test (RED)
Person B: Writes code (GREEN)
Person A: Refactors
Person B: Writes next test
...continues
```
> This format is IDEAL for SDET + Developer.

### Mob Programming (3+ people)
```
1 Driver (writes)
1 Navigator (directs)
N Observers (watch, ask questions)

Driver rotation every 15 minutes.
```
> Use for architectural decisions, complex debugging, onboarding.

---

## 3. Remote Pair Programming

| Tool | Feature |
|------|---------|
| VS Code Live Share | Work in the same editor |
| JetBrains Code With Me | IntelliJ/WebStorm |
| Tuple | Low latency screen sharing |
| Screen share (Zoom/Meet) | Simple but effective |

### Rules
- Camera ON (facial expression matters)
- Quality microphone
- Free screen zoom (Navigator should be able to zoom)
- 2 hours MAX (then break)

---

## 4. Pair Programming in VSH

In Claude Code, pair programming is applied as follows:

### Developer + Security Reviewer
```
Me (CTO/Developer): I write the code
security-reviewer agent: Reviews code simultaneously
/santa-loop: 2 independent reviewers for final approval
```

### Developer + SDET
```
Me: Derive test cases from diagram + write tests (RED)
Me: Write the code (GREEN)
gan-evaluator: Test live application with Playwright + score
```

### Critical Module
```
/team-builder to create parallel team:
  Agent 1: Writes code
  Agent 2: Writes tests simultaneously
  Agent 3: Performs security review
Then /santa-loop with 2 reviewers for approval
```

---

## Related Documents
- `governance/standards/CODE_REVIEW_CHECKLIST.md`
- `governance/standards/SHIFT_LEFT_SECURITY.md`
- `departments/05/.../sdet_engineer.md`
