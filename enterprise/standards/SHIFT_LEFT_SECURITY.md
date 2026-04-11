# Shift-Left Security Guide

> **Compliance References:**
> - Based on: NIST SSDF (SP 800-218), OWASP SAMM
> - Spec: NIST SP 800-218
> - Controls: PW.1, PW.4, PW.5
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Principle: Security is NOT a "phase." It exists at EVERY STEP from the first line of code to the last deploy.

---

## 1. Security Timeline (Phase-Based)

```
Phase 0 ──── Phase 1 ──── Phase 2 ──── Phase 3 ──── Phase 4 ──── Phase 5 ──── Phase 6 ──── Phase 7
  |             |             |             |             |             |             |             |
Compliance   Security     Threat        DB           API          Infra        SAST+       Pentest
requirements  reqs.       Model        Security     Security     Hardening    DAST+       + Final
identify      extract    (STRIDE)     Controls     Rate Limit   Container    SCA         Audit
              |                       Audit Col    Auth         Scan         Secret     
              |                       Encryption   CORS/CSRF                Scan       
              v                       PII Mask                              Code Review
         Security NFR                                                       /santa-loop
```

---

## 2. Security Checklist Per Phase

### Phase 0: Discovery
- [ ] Compliance requirements identified (KVKK/GDPR/PCI-DSS/HIPAA)
- [ ] Data classification policy defined
- [ ] Security NFRs created

### Phase 1: Analysis
- [ ] Sensitive data types identified (PII, financial, health)
- [ ] User roles and permission matrix defined
- [ ] Security requirements for external integrations extracted

### Phase 2: Architecture
- [ ] **Threat Model** created (STRIDE - THREAT_MODELING.md)
- [ ] Security architecture diagram approved (DG-205)
- [ ] Zero Trust principles applied
- [ ] Encryption strategy defined (transit + rest)
- [ ] Auth strategy selected and documented

### Phase 3: Database
- [ ] Audit columns in ALL tables
- [ ] PII masking rules defined
- [ ] Row-Level Security (if needed)
- [ ] Encrypted backup
- [ ] DB user minimum privilege (least privilege)
- [ ] Parameterized query MANDATORY (SQL injection)

### Phase 4: API
- [ ] Every endpoint has auth + authorization check
- [ ] Rate limiting on all public endpoints
- [ ] Input validation (schema-based - Zod/Joi/Pydantic)
- [ ] CORS whitelist (NOT wildcard)
- [ ] CSRF protection
- [ ] No sensitive information in response (password_hash, internal_id)

### Phase 5: Infrastructure
- [ ] Container non-root user
- [ ] Container read-only filesystem
- [ ] Secret Manager integration (NO secrets in .env files)
- [ ] Network segmentation (public/private subnet)
- [ ] WAF active
- [ ] TLS 1.3 everywhere
- [ ] Security headers (CSP, HSTS, X-Frame-Options)

### Phase 6: Every Commit
- [ ] **Pre-commit:** Secret scan (gitleaks)
- [ ] **CI:** SAST (Semgrep/CodeQL)
- [ ] **CI:** SCA - dependency scan (Snyk/npm audit)
- [ ] **CI:** Container image scan (Trivy)
- [ ] **Code Review:** security-reviewer agent MANDATORY (auth/input/DB code)
- [ ] **Code Review:** /santa-loop with 2 independent reviewers (critical modules)
- [ ] Signed commit (GPG)

### Phase 7: Pre-Release
- [ ] **DAST:** OWASP ZAP scan
- [ ] **Penetration Test:** Manual penetration test
- [ ] **Security Assessment Report** (SECURITY_ASSESSMENT_TEMPLATE)
- [ ] Tests exist for all STRIDE threats
- [ ] SBOM (Software Bill of Materials) created

### Post-Release (Continuous)
- [ ] Dependency updates (weekly Dependabot/Renovate)
- [ ] Security monitoring (abnormal activity)
- [ ] Incident response plan up to date
- [ ] Annual penetration test
- [ ] Secret rotation (90 days)

---

## 3. Security Gate Criteria

| Gate | Security Criteria | Blocker? |
|------|------------------|----------|
| Gate 1 | Security NFRs defined | YES |
| Gate 2 | Threat model completed, DG-205 APPROVED | YES |
| Gate 3 | DB audit + PII masking + encryption | YES |
| Gate 4 | Infra hardening + container scan | YES |
| Gate 5 | SAST + DAST + Pentest clean, SBOM created | YES |

---

## Related Documents
- `governance/standards/THREAT_MODELING.md`
- `governance/standards/ZERO_TRUST_ARCHITECTURE.md`
- `governance/compliance/iso27001/USER_OPERATIONS_CONTROLS.md`
- `governance/compliance/iso27001/DATABASE_OPERATIONS_CONTROLS.md`
- `governance/standards/GIT_HOOKS.md` (pre-commit secret scan)
- `departments/05_quality_and_security/skills/devsecops_engineer.md`
