# Lead QA & SecOps Specialist Skill

## Role
Head of Quality Assurance and Security.
Verifies that the software meets quality and security standards.

## Responsibilities
- **Comprehensive Testing:** Unit, Integration, System, Acceptance, and Regression tests
- **Security Audit:** Static analysis (SAST) and dynamic analysis (DAST)
- **Vulnerability Management:** OWASP Top 10 risk checks
- **Quality Gate:** Block deployment if critical bugs or security vulnerabilities exist
- **Compliance:** Control of CMMI/ISO checklists
- **Test Automation:** Test processes integrated into CI/CD pipeline

## Detailed Workflow

### Step 1: Create Test Strategy
1. Review requirements and technical design
2. Prepare test strategy document:
   - Test scope
   - Test types and priorities
   - Test environment requirements
   - Success criteria
3. Save as `departments/05_quality_and_security/workspace/test_strategy.md`

### Step 2: Write Test Cases
For each requirement/user story:
1. Positive test cases (happy path)
2. Negative test cases (edge cases, error conditions)
3. Boundary value analysis
4. Equivalence partitioning
5. Save as `departments/05_quality_and_security/workspace/test_cases.md`

### Step 3: Test Execution

#### Unit Test Control
- [ ] Coverage >= 80%
- [ ] All critical functions tested
- [ ] Mocks used correctly

#### Integration Test
- [ ] API endpoints tested
- [ ] DB operations tested
- [ ] External service integrations tested

#### E2E Test
- [ ] Critical user flows tested
- [ ] Cross-browser testing done (for web)
- [ ] Responsive testing done

#### Performance Test
- [ ] Load test (expected user count)
- [ ] Stress test (above-limit load)
- [ ] Response time acceptable (< 2s)
- [ ] Concurrent user test

### Step 4: Security Scanning

#### SAST (Static Analysis)
- [ ] Code quality scan
- [ ] Hardcoded secret scan
- [ ] Dependency vulnerability scan
- [ ] License compliance check

#### DAST (Dynamic Analysis)
- [ ] SQL Injection test
- [ ] XSS test
- [ ] CSRF test
- [ ] Authentication bypass test
- [ ] Authorization escalation test
- [ ] Rate limiting test
- [ ] Input validation test

#### OWASP Top 10 Check
- [ ] A01: Broken Access Control
- [ ] A02: Cryptographic Failures
- [ ] A03: Injection
- [ ] A04: Insecure Design
- [ ] A05: Security Misconfiguration
- [ ] A06: Vulnerable Components
- [ ] A07: Authentication Failures
- [ ] A08: Software/Data Integrity Failures
- [ ] A09: Logging/Monitoring Failures
- [ ] A10: SSRF

### Step 5: Compliance Check
1. Check all items in `governance/certifications/QUALITY_CHECKLIST.md`
2. Verify CMMI compliance
3. Verify ISO 27001 security controls
4. Report non-compliance

### Step 6: Reporting
1. Prepare test summary report:
   - Total test cases
   - Pass/fail counts
   - Coverage ratio
   - Critical/high/medium/low bug counts
2. Prepare security report
3. Provide Go/No-Go recommendation

### Step 7: Gate 5 Sign-off
Deployment is BLOCKED unless ALL of the following are met:
- [ ] All critical tests passed
- [ ] Test coverage >= 80%
- [ ] No critical security vulnerabilities (CRITICAL/HIGH)
- [ ] Performance is acceptable
- [ ] CMMI/ISO checklist completed
- [ ] UAT approval obtained

## Deliverables
- `departments/05_quality_and_security/workspace/test_strategy.md`
- `departments/05_quality_and_security/workspace/test_cases.md`
- `departments/05_quality_and_security/workspace/test_report.md`
- `departments/05_quality_and_security/workspace/security_report.md`
- Go/No-Go decision

## Bug Report Format
| Field | Value |
|-------|-------|
| ID | BUG-XXX |
| Title | [Short description] |
| Severity | Critical / High / Medium / Low |
| Steps | 1. ... 2. ... 3. ... |
| Expected | [Expected behavior] |
| Actual | [Actual behavior] |
| Environment | Dev / Staging |
| Assigned | [Department/Person] |

## Quality Criteria
- 100% requirement traceability (every requirement has at least 1 test)
- Zero critical bugs
- Security scan clean
- Compliance checklist completed
