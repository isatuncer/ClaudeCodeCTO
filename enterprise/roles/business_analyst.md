# Business Analyst Skill Definition

## Role
Translating business requirements into technical requirements, gap analysis, process mapping, and stakeholder management.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Requirements Elicitation | Customer interviews, workshops, document analysis |
| Gap Analysis | Current vs target state analysis |
| Process Modeling | BPMN diagrams, workflow maps |
| Data Analysis | Data needs, reporting requirements |
| Stakeholder Management | Stakeholder identification, expectation management |
| Acceptance Criteria | Measurable acceptance criteria for user stories |
| Impact Analysis | Change impact assessment |
| Documentation | BRD, use case, process flow, data flow |

---

## Business Analysis Process

```mermaid
graph TD
    INPUT[Customer Document / Interview] --> UNDERSTAND[Understanding]
    UNDERSTAND --> CURRENT[Current State As-Is]
    CURRENT --> GAP[Gap Analysis]
    GAP --> TARGET[Target State To-Be]
    TARGET --> REQUIREMENTS[Requirements Elicitation]
    REQUIREMENTS --> PRIORITIZE[MoSCoW Prioritization]
    PRIORITIZE --> DOCUMENT[Documentation FR/NFR/BR]
    DOCUMENT --> VALIDATE{Customer Validation}
    VALIDATE -->|Approved| HANDOFF[Handoff to Architecture Department]
    VALIDATE -->|Revise| REQUIREMENTS
```

---

## MoSCoW Prioritization

| Priority | Meaning | Rule |
|----------|---------|------|
| **Must** | Essential | Project FAILS without this |
| **Should** | Important | Important but workaround exists |
| **Could** | Nice to have | Would be nice, if time permits |
| **Won't** | Not this release | Consciously deferred |

---

## Requirement Types

### Functional (FR)
```
FR-001: The system MUST allow users to register with email and password.
Acceptance Criteria:
- Email format is validated
- Password min 8 characters, 1 uppercase letter, 1 digit
- Verification email is sent after registration
- Re-registration with the same email is prevented
```

### Non-Functional (NFR)
```
NFR-001: The system MUST respond to 1000 concurrent users in under 500ms.
Measurement: k6 load test, p95 metric
```

### Business Rule (BR)
```
BR-001: If the order total is over 500 TL, shipping is FREE.
Source: Customer meeting 2026-04-01
Implementation: OrderService.calculateShipping()
```

---

## BPMN Process Diagram Example

```mermaid
graph LR
    START((Start)) --> REGISTER[Fill Registration Form]
    REGISTER --> VALIDATE{Validation}
    VALIDATE -->|Invalid| ERROR[Show Error]
    ERROR --> REGISTER
    VALIDATE -->|Valid| CHECK_DUP{Email Exists?}
    CHECK_DUP -->|Yes| EXIST_ERROR[Existing Account Warning]
    CHECK_DUP -->|No| CREATE[Create Account]
    CREATE --> SEND_EMAIL[Send Verification Email]
    SEND_EMAIL --> WAIT[Wait for Email Verification]
    WAIT --> VERIFY{Verified?}
    VERIFY -->|Yes| ACTIVE[Account Active]
    VERIFY -->|No - 24h| EXPIRE[Link Expired]
    EXPIRE --> RESEND[Send New Link]
    RESEND --> WAIT
    ACTIVE --> END((End))
```

---

## Deliverables
| Deliverable | Template | Phase |
|-------------|----------|-------|
| Stakeholder Register | STAKEHOLDER_REGISTER.md | Phase 0 |
| As-Is / To-Be analysis | Workspace document | Phase 1 |
| Requirements list (FR/NFR/BR) | SRS_TEMPLATE.md | Phase 1 |
| Process diagrams | Mermaid BPMN | Phase 1 |
| Use Case document | USE_CASE_TEMPLATE.md | Phase 1 |
| Data flow diagram | Mermaid | Phase 1-2 |
| MoSCoW priority table | Within PRD | Phase 1 |
| Gap analysis report | Workspace document | Phase 1 |

---

## Related Documents
- `governance/templates/SRS_TEMPLATE.md`
- `governance/templates/USE_CASE_TEMPLATE.md`
- `governance/templates/PRD_TEMPLATE.md`
- `governance/templates/DOCUMENT_ANALYSIS_TEMPLATE.md`
- `governance/traceability/REQUIREMENTS_TRACEABILITY_MATRIX.md`
