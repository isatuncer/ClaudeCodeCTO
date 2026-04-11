# Test Case Document

## Document Information
| Field | Value |
|-------|-------|
| Project Name | [PROJECT_NAME] |
| Module | [Module Name] |
| Author | QA & Security Dept. |
| Date | [DATE] |
| Related Test Plan | TEST_PLAN-[NUMBER] |
| Related SRS | FR-XXX, NFR-XXX |

---

## Test Case List

### TC-001: [Test Name]

| Field | Value |
|-------|-------|
| ID | TC-001 |
| Type | Unit / Integration / E2E |
| Priority | P1 / P2 / P3 / P4 |
| Related Requirement | FR-001 |
| Source Diagram | DG-XXX |
| Diagram Element | [table/relationship/sequence step/state transition] |
| Precondition | [System/data preconditions] |
| Test Data | [Required test data] |

**Test Steps:**
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | [Action] | [Expected] |
| 2 | [Action] | [Expected] |
| 3 | [Action] | [Expected] |

**Postcondition:** [Expected system state after test]

**Test Code Reference:**
```
tests/[module]/[test_file].test.[ext]
```

---

### TC-002: [Test Name - Negative Scenario]

| Field | Value |
|-------|-------|
| ID | TC-002 |
| Type | Unit / Integration |
| Priority | P1 |
| Related Requirement | FR-001 |
| Precondition | [Precondition] |

**Test Steps:**
| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | Send invalid data | Validation error returned |
| 2 | Empty required field | 400 Bad Request |
| 3 | Unauthorized access | 401/403 error |

---

### TC-003: [Test Name - Boundary Value]

| Field | Value |
|-------|-------|
| ID | TC-003 |
| Type | Unit |
| Priority | P2 |

**Boundary Value Table:**
| Input | Min | Min-1 | Min+1 | Max-1 | Max | Max+1 |
|-------|-----|-------|-------|-------|-----|-------|
| [field] | [value] | Error | Valid | Valid | Valid | Error |

---

## Traceability Matrix

| Test Case | Requirement | Module | Automation | Last Run | Result |
|-----------|-----------|--------|-----------|----------|--------|
| TC-001 | FR-001 | [Module] | Yes | [DATE] | Pass/Fail |
| TC-002 | FR-001 | [Module] | Yes | [DATE] | Pass/Fail |
| TC-003 | FR-001 | [Module] | Yes | [DATE] | Pass/Fail |

---

## Test Results Summary

| Metric | Value |
|--------|-------|
| Total test cases | [N] |
| Passed | [N] |
| Failed | [N] |
| Skipped | [N] |
| Pass rate | %[N] |
| Coverage | %[N] |
