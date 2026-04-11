# Diagram-Driven Test Generation Guide

> **Compliance References:**
> - Based on: ISO/IEC/IEEE 29119-4:2015 (Model-Based Testing)
> - Spec: Test generation from models
> - Controls: ER→DB tests, Sequence→API tests
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## RULE
**Once a diagram is APPROVED, tests are written FIRST, then code.**
```
DG-XXX APPROVED -> Tests written (RED) -> Code written (GREEN) -> Tests must pass -> Refactor
```

---

## 1. Test Generation by Diagram Type

### ER Diagram (DG-301) -> Database Integration Test

From each ER diagram:

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Each table | Create, read, update, soft-delete | Integration |
| Each relationship (1:N, N:N) | Related record creation, cascade, orphan handling | Integration |
| Each UNIQUE constraint | Duplicate record rejection test | Integration |
| Each NOT NULL column | Null value rejection test | Unit |
| Each DEFAULT value | Default value verification | Unit |
| Audit columns | Are created_at/by, updated_at/by auto-populated? | Integration |
| Soft delete | Is deleted_at set, hidden from queries? | Integration |
| Indexes | Is query performance acceptable? | Performance |

**Example:** If `users ||--o{ orders` appears in DG-301:
```
TC-DB-001: Should be able to create a user (INSERT users)
TC-DB-002: Deleting a user should not affect their orders (soft delete)
TC-DB-003: Should not allow creating a second user with the same email (UNIQUE)
TC-DB-004: Email should not be left empty (NOT NULL)
TC-DB-005: created_at should be auto-populated
TC-DB-006: Should be able to list a user's orders (JOIN)
TC-DB-007: Should not allow creating an order without user_id (FK constraint)
```

---

### Sequence Diagram (DG-401-406) -> API / E2E Test

From each sequence diagram:

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Each arrow (request) | Request format and response validation | API |
| Happy path (full flow) | End-to-end successful scenario | E2E |
| Each error branch | Error state returned correctly? | API |
| Each validation step | Is validation working? | Unit + API |
| Each authorization check | Is unauthorized access rejected? | API |
| Each DB operation | Is data saved correctly? | Integration |

**Example:** For the auth login sequence in DG-401:
```
TC-AUTH-001: Successful login -> 200 + token (happy path E2E)
TC-AUTH-002: Wrong password -> 401 (error branch)
TC-AUTH-003: Empty email -> 400 validation error
TC-AUTH-004: Locked account -> 423 (business rule)
TC-AUTH-005: Token refresh -> should return new token
TC-AUTH-006: Invalid refresh token -> 401
TC-AUTH-007: Social login (Google) -> create/link account
TC-AUTH-008: Successful login should be written to log (audit)
TC-AUTH-009: Failed login should be written to log (security)
TC-AUTH-010: 5 failed attempts -> account should be locked (rate limit)
```

---

### State Diagram (DG-602) -> State Transition Test

From each state diagram:

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Each valid transition (A -> B) | Transition should succeed | Unit |
| Each invalid transition (A -X-> C) | Transition should be rejected | Unit |
| Initial state | Is it in the correct initial state? | Unit |
| Final state | Does it reach the correct final state? | Integration |
| All paths | Every possible path should be tested | E2E |

**Example:** For the order state machine in DG-602:
```
TC-STATE-001: New order should start in "pending_payment" state
TC-STATE-002: pending_payment -> confirmed (payment successful)
TC-STATE-003: pending_payment -> cancelled (user cancelled)
TC-STATE-004: confirmed -> shipped (handed to carrier)
TC-STATE-005: confirmed -X-> pending (invalid transition, should be rejected)
TC-STATE-006: shipped -> delivered (delivered)
TC-STATE-007: delivered -> return_requested (within 7 days)
TC-STATE-008: delivered -X-> return_requested (after 7 days, should be rejected)
TC-STATE-009: Full path: pending -> confirmed -> shipped -> delivered -> completed
```

---

### Class Diagram (DG-603) -> Unit Test

From each class diagram:

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Each public method | Does the method work correctly? | Unit |
| Each dependency (arrow) | Dependency test with mock | Unit |
| Each error case | Is the error thrown correctly? | Unit |
| Each validation | Is invalid input rejected? | Unit |

---

### Component Tree (DG-604) -> Frontend Test

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Each page | Render test | Component |
| Each form | Validation + submit test | Component |
| Each interactive element | Click/type/select test | Component |
| Page transitions | Routing test | E2E |
| Loading/error/empty state | Correct display in each state | Component |

---

### Deployment Diagram (DG-204) -> Infra Test

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Health endpoint | Is each service alive? | Smoke |
| Load balancer | Is traffic distributed correctly? | Load |
| DB replication | Is replica in sync? | Integration |
| Cache | Are cache hit/miss correct? | Integration |
| CDN | Are static files being served? | Smoke |

---

### CI/CD Pipeline Diagram (DG-502) -> Pipeline Test

| Diagram Element | Test to Generate | Test Type |
|-----------------|-----------------|-----------|
| Each pipeline step | Does the step run successfully? | CI |
| Gate criteria | Does the gate reject? (coverage < 80%) | CI |
| Rollback | Does rollback work? | Integration |

---

## 2. Test Priority Order

After a diagram is approved, tests are written in this order:

```
1. Unit Test      <- From class diagram + validation rules
2. Integration    <- From ER diagram + sequence diagrams
3. API Test       <- From sequence diagrams
4. E2E Test       <- From full flow sequence + state diagrams
5. Performance    <- From deployment + data flow diagrams
6. Security       <- From security architecture diagram
```

---

## 3. Test Coverage Check

For each APPROVED diagram:

```
Diagram elements: N
Test case count:  >= N (at least 1 test per element)
Coverage:         Must cover 100% of diagram elements
```

**Coverage report example:**
```
DG-301 ER Diagram Coverage:
  users table:          6 tests (CRUD + constraint + audit) ✓
  orders table:         5 tests ✓
  users-orders relation: 3 tests ✓
  payments table:       4 tests ✓
  audit_log:            2 tests ✓
  TOTAL: 20 tests / 20 elements = 100% coverage ✓
```

---

## 4. Traceability

Required fields for each test case:
```
| Related Diagram | DG-301 |
| Diagram Element | users table, email UNIQUE constraint |
| Related Requirement | FR-001 |
```

This information is also added to the `governance/traceability/DIAGRAM_TEST_MAPPING.md` table.

---

## Related Documents
- `governance/diagrams/DIAGRAM_CATALOG.md` - Diagram catalog
- `governance/templates/TEST_PLAN_TEMPLATE.md` - Test plan
- `governance/templates/TEST_CASE_TEMPLATE.md` - Test case
- `governance/traceability/DIAGRAM_TEST_MAPPING.md` - Diagram-test mapping
- `governance/standards/DEFINITION_OF_DONE.md` - DoD
