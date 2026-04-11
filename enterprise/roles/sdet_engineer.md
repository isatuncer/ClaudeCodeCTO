# SDET (Software Development Engineer in Test) Skill Definition

## Role
An engineer who DEVELOPS test software. Unlike manual QA: builds test INFRASTRUCTURE, writes test frameworks, integrates into CI/CD.

---

## QA vs SDET Difference

| Area | Manual QA | QA Automation | **SDET** |
|------|-----------|--------------|----------|
| Test writing | Manual scenarios | Test scripts | Test FRAMEWORK |
| Coding | No | Intermediate | Advanced (production-level) |
| CI/CD | Uses | Integrates | **Designs and builds** |
| Tool development | No | No | **Writes custom test tools** |
| Performance test | No | Basic | **Builds load test infrastructure** |
| Code review | No | Test code | **Reviews production code too** |

---

## Responsibilities

| Area | Detail |
|------|--------|
| Test Framework | Design and build test infrastructure (POM, fixtures, helpers) |
| Test Pipeline | Design test pipeline in CI/CD (parallel, retry, artifact) |
| Custom Tooling | Write project-specific test tools (data generator, mock server, test reporter) |
| Contract Testing | API contract testing (Pact/Prism) |
| Chaos Test | Chaos engineering experiment infrastructure |
| Performance Infra | k6/Artillery test suite, dashboard, threshold |
| Visual Test Infra | Playwright screenshot baseline, diff pipeline |
| Testability | Improve testability of production code (DI, interface, mock point) |
| Flaky Eradication | Systematically fix flaky tests |
| Coverage Strategy | Which module gets which test type, coverage targets |

---

## SDET Deliverables

| Deliverable | Description |
|-------------|-------------|
| `tests/framework/` | Common test utilities, base classes |
| `tests/fixtures/` | Test data factory, seed, mock |
| `tests/helpers/` | API client, auth helper, DB helper |
| `.github/workflows/test.yml` | Test CI pipeline |
| `k6/` or `artillery/` | Performance test suite |
| `tests/contract/` | API contract tests |
| Test dashboard config | Grafana/Allure test report dashboard |

---

## Defensive Programming Checks

SDET tests the following (things developers overlook):

| Category | Test Examples |
|----------|--------------|
| Boundary | Max int, min int, 0, -1, empty string, null, undefined |
| Injection | SQL, XSS, command injection payloads |
| Concurrency | Race condition, deadlock, double submit |
| Timeout | Network timeout, DB timeout, 3rd party timeout |
| Resource | Memory limit, disk full, connection pool exhaustion |
| Data integrity | Duplicate key, foreign key violation, orphan record |
| Auth bypass | Token manipulation, role escalation, IDOR |
| Error handling | Is every error code correct, is there stack trace leakage |

---

## Pair Programming Integration

SDET + Developer pair programming:
```
Developer: Writes code
SDET: Writes tests simultaneously (real TDD pair)

Result:
- Code is designed to be testable
- Tests stay in sync with production code
- Edge cases are caught immediately
```

---

## Related Documents
- `departments/05/.../qa_automation_engineer.md`
- `governance/standards/DIAGRAM_DRIVEN_TESTING.md`
- `governance/standards/CHAOS_ENGINEERING.md`
- `governance/standards/UI_UX_TESTING_STRATEGY.md`
