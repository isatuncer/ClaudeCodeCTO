# Threat Modeling Guide

> **Compliance References:**
> - Based on: Microsoft STRIDE (2002), OWASP
> - Spec: DREAD Risk Scoring
> - Controls: Threat categorization
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## RULE: Threat model MUST be created BEFORE code is written.
> The question "Where can this system be attacked?" must be answered in Phase 2.

---

## 1. When to Perform

| Trigger | Requirement |
|---------|------------|
| When Phase 2 (Blueprint) is completed | **MANDATORY** - Before Gate 2 |
| When adding a new module | MANDATORY |
| When adding an external integration | MANDATORY |
| When auth/payment/PII code changes | MANDATORY |
| Before major version | MANDATORY |

---

## 2. STRIDE Methodology

Threat analysis is performed in these 6 categories for each system/module:

| Category | Question | Example Threat |
|----------|----------|---------------|
| **S**poofing (Identity Forgery) | Can someone impersonate another? | Fake JWT token, session hijacking |
| **T**ampering (Data Manipulation) | Can data be modified in transit or in DB? | Man-in-the-middle, SQL injection |
| **R**epudiation (Denial) | Can user deny their actions? | If no audit log, actions can be denied |
| **I**nformation Disclosure (Data Leak) | Can unauthorized information access occur? | Stack trace in error message, PII in logs |
| **D**enial of Service (Service Disruption) | Can the system be made unavailable? | DDoS, resource exhaustion, infinite loop |
| **E**levation of Privilege (Privilege Escalation) | Can a regular user become admin? | IDOR, mass assignment, JWT claim manipulation |

---

## 3. Threat Model Template

### For Each Module/Endpoint

```markdown
## Module: [Auth / Payment / User / etc.]
## Date: [DATE]
## Modeled by: Security Team

### Data Flow
[Which data goes from where to where - DG-XXX reference]

### Trust Boundaries
- [ ] Internet <-> WAF (untrusted -> filtered)
- [ ] WAF <-> API (filtered -> validated)
- [ ] API <-> DB (validated -> trusted)
- [ ] API <-> 3rd Party (validated -> external)

### STRIDE Analysis
| # | Category | Threat | Likelihood | Impact | Risk | Mitigation |
|---|----------|--------|-----------|--------|------|-----------|
| T-001 | Spoofing | JWT token theft | Medium | High | HIGH | httpOnly cookie, short expiry, refresh rotation |
| T-002 | Tampering | Request body modification | Low | High | MEDIUM | Input validation, schema validation |
| T-003 | Repudiation | User denies action | Medium | Medium | MEDIUM | Immutable audit log, IP recording |
| T-004 | Info Disclosure | Stack trace in error | High | Medium | HIGH | Generic error in production, details to Sentry |
| T-005 | DoS | Login brute force | High | High | CRITICAL | Rate limiting, account lockout, CAPTCHA |
| T-006 | Elevation | Accessing another user's data via IDOR | Medium | Critical | CRITICAL | Ownership check, row-level security |
```

---

## 4. DREAD Risk Scoring

Score each threat from 1-10:

| Criterion | Description | Score (1-10) |
|-----------|------------|-------------|
| **D**amage | How severe is the damage | |
| **R**eproducibility | How reproducible | |
| **E**xploitability | Ease of exploitation | |
| **A**ffected Users | Number of affected users | |
| **D**iscoverability | How discoverable | |

**Risk Score** = Average(D + R + E + A + D) / 2

| Score | Level | Action |
|-------|-------|--------|
| 7-10 | CRITICAL | Fix BEFORE code is written |
| 4-6 | HIGH | Fix within sprint |
| 2-3 | MEDIUM | Add to backlog |
| 0-1 | LOW | Accept and monitor |

---

## 5. Common Threat Catalog

### Authentication
| Threat | STRIDE | Mitigation |
|--------|--------|-----------|
| Brute force login | DoS + Spoofing | Rate limit (5/min), account lockout, CAPTCHA |
| Credential stuffing | Spoofing | Breached password check (haveibeenpwned API) |
| Session hijacking | Spoofing | httpOnly + Secure + SameSite cookie, IP binding |
| JWT tampering | Tampering | RS256 signing (not HS256), short expiry |
| Token replay | Spoofing | Refresh token rotation, jti claim |

### Authorization
| Threat | STRIDE | Mitigation |
|--------|--------|-----------|
| IDOR (Insecure Direct Object Reference) | Elevation | Ownership check: `WHERE user_id = currentUser.id` |
| Mass assignment | Elevation | DTO whitelist, never use req.body directly |
| Privilege escalation | Elevation | RBAC + authorization check on every endpoint |
| Path traversal | Info Disclosure | Input sanitization, whitelist approach |

### Data
| Threat | STRIDE | Mitigation |
|--------|--------|-----------|
| SQL injection | Tampering | Parameterized query MANDATORY, use ORM |
| XSS | Info Disclosure | CSP header, output encoding, sanitize |
| CSRF | Tampering | SameSite cookie + CSRF token |
| Data leak in logs | Info Disclosure | PII masking, log scrubbing |
| Backup theft | Info Disclosure | Encrypted backup (AES-256) |

### Infrastructure
| Threat | STRIDE | Mitigation |
|--------|--------|-----------|
| DDoS | DoS | WAF + CDN + rate limit |
| Supply chain attack | Tampering | SBOM, dependency pinning, Snyk |
| Container escape | Elevation | Non-root user, read-only FS, seccomp |
| Secret exposure | Info Disclosure | Secret Manager, .env NEVER committed |
| Man-in-the-middle | Tampering + Info | TLS 1.3 everywhere, HSTS |

---

## 6. Outputs

| Output | Location | Phase |
|--------|----------|-------|
| Threat Model Report | `departments/05_quality_and_security/workspace/` | Phase 2 |
| STRIDE Analysis Table | Inside report | Phase 2 |
| Risk Register update | `governance/risks/RISK_REGISTER.md` | Phase 2 |
| Security Test Case | `governance/traceability/DIAGRAM_TEST_MAPPING.md` | Phase 4 |
| Penetration Test Plan | `governance/standards/PENETRATION_TEST_PLAN.md` | Phase 7 |

---

## Related Documents
- `governance/diagrams/faz2_architecture/DG-205_security_architecture.mmd`
- `governance/compliance/iso27001/USER_OPERATIONS_CONTROLS.md`
- `governance/standards/ZERO_TRUST_ARCHITECTURE.md`
- `governance/standards/SHIFT_LEFT_SECURITY.md`
