# V-Model + Agile Hybrid Development Model

> **Compliance References:**
> - Based on: V-Model XT (German Federal Gov.), Scrum Guide 2020
> - Spec: Test-design phase mapping
> - Controls: V-Model levels + Agile sprints
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Principle: Agile's flexibility + V-Model's discipline + Shift-Left Security

---

## 1. Why Hybrid?

| Approach | Pros | Cons |
|----------|------|------|
| Pure Agile | Fast, flexible, feedback | Weak documentation, security is skipped |
| Pure V-Model | Disciplined, traceable, test-focused | Slow, resistant to change |
| **Hybrid** | Best of both | Complex but ideal for enterprise |

---

## 2. V-Model Structure (Adapted for VSH)

```
Phase 0: Discovery        <->  Phase 7: Acceptance Test (UAT)
  |                                  |
Phase 1: Requirements     <->  Phase 7: System Test (E2E)
  |                                  |
Phase 2: Architecture     <->  Phase 7: Integration Test
  |                                  |
Phase 3: DB Design        <->  Phase 6: DB Integration Test
  |                                  |
Phase 4: API Design       <->  Phase 6: API Test
  |                                  |
Phase 5: Infrastructure   <->  Phase 6: Infra Test
  |                                  |
        -> Phase 6: Development <-
          (Sprint by Sprint - Agile)
          Unit tests are written here
```

### Taken from V-Model
- Every design phase has a corresponding TEST phase
- **Traceability:** Requirement -> Design -> Code -> Test chain is never broken
- **Verification:** Each phase output MUST be APPROVED before proceeding to the next phase (Gate)

### Taken from Agile
- **Sprint-based** iteration within Phase 6
- **Customer feedback** at the end of every sprint
- **Changes** are accepted (with Impact Analysis)
- **Retrospective** for continuous improvement

---

## 3. Test-Design Mapping (V-Model Correspondence)

| Design Phase | Test Phase | Test Type | Responsibility |
|-------------|----------|-----------|---------------|
| Phase 1: Requirements | Phase 7: UAT | Acceptance test | Customer + QA |
| Phase 2: Architecture | Phase 7: E2E | System test | SDET + QA |
| Phase 3: DB | Phase 6: DB test | Integration | Developer + DBA |
| Phase 4: API | Phase 6: API test | API test | Developer + SDET |
| Phase 5: Infrastructure | Phase 6: Infra test | Smoke + chaos | DevOps + SDET |
| Phase 6: Code | Phase 6: Unit test | Unit | Developer |

### RULE: For every design output there IS a corresponding test.
- If a requirement is written -> Acceptance criteria is written AT THE SAME TIME
- If an API spec is designed -> API test case is written AT THE SAME TIME
- If a DB schema is designed -> DB integration test is written AT THE SAME TIME

---

## 4. Within Sprint (Agile Layer)

```
Sprint Planning -> Daily -> Coding (TDD) -> Review -> Demo -> Retro
                                  |
                    Diagram APPROVED -> Write test (RED) -> Write code (GREEN)
```

### Sprint Ceremonies
| Ceremony | Timing | Duration |
|----------|--------|----------|
| Sprint Planning | Sprint Day 1 | 2 hours |
| Daily Standup | Every day | 15 min |
| Backlog Grooming | Mid-week | 1 hour |
| Sprint Review (Demo) | Sprint last day | 1 hour |
| Retrospective | Sprint last day | 45 min |

---

## 5. Formal Verification Points (Gates)

| Gate | V-Model Equivalent | Agile Equivalent |
|------|-------------------|-----------------|
| Gate 1 | Requirements Review | Sprint 0 approval |
| Gate 2 | Design Review | Architecture spike + approval |
| Gate 3 | Detailed Design Approval | DG approve at sprint start |
| Gate 4 | Code Review | Code review + /santa-loop |
| Gate 5 | Test Completion | Sprint end + release gate |

---

## 6. Change Management (Formal Change Management)

When a change comes mid-project:

```
1. Record change request (CHANGE_IMPACT_ANALYSIS)
2. Perform impact analysis (which diagrams, tests, code are affected)
3. Risk assessment
4. Cost/time estimate
5. Present impact report to customer
6. Approval -> Update affected diagrams -> Update tests -> Update code
7. Update RTM
```

### Change Control Board (CCB)
For major changes (major scope change):
- PO (Claude) prepares impact report
- Customer sees cost/time impact
- Decision: Accept / Defer / Reject

---

## Related Documents
- `governance/traceability/REQUIREMENTS_TRACEABILITY_MATRIX.md`
- `governance/traceability/CHANGE_IMPACT_ANALYSIS.md`
- `governance/standards/DIAGRAM_DRIVEN_TESTING.md`
- `governance/standards/DEFINITION_OF_DONE.md`
- `governance/standards/DEFINITION_OF_READY.md`
- `governance/APPROVAL_PIPELINE.md`
