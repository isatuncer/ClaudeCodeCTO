# Security Assessment Report

## Document Information
| Field | Value |
|-------|-------|
| Project Name | [PROJECT_NAME] |
| Version | 1.0 |
| Author | QA & Security Dept. |
| Date | [DATE] |
| Status | Draft / Review / Approved |
| Assessment Type | Pre-release / Periodic / Incident-driven |
| Related Standard | OWASP Top 10, ISO 27001 |

---

## 1. Executive Summary
[3-5 sentence summary of the security assessment, critical findings and overall risk level]

**Overall Risk Level:** Low / Medium / High / Critical

---

## 2. Assessment Scope

### 2.1 In Scope
| Area | Description |
|------|-------------|
| Web application | [URL/endpoints] |
| API | [API endpoints] |
| Database | [DB type and access] |
| Infrastructure | [Server/container] |
| 3rd Party | [External integrations] |

### 2.2 Out of Scope
| Area | Reason |
|------|--------|
| [Area] | [Reason] |

---

## 3. OWASP Top 10 Assessment

| # | Category | Status | Finding Count | Detail |
|---|----------|--------|--------------|--------|
| A01 | Broken Access Control | Pass/Fail | [N] | [Summary] |
| A02 | Cryptographic Failures | Pass/Fail | [N] | [Summary] |
| A03 | Injection | Pass/Fail | [N] | [Summary] |
| A04 | Insecure Design | Pass/Fail | [N] | [Summary] |
| A05 | Security Misconfiguration | Pass/Fail | [N] | [Summary] |
| A06 | Vulnerable Components | Pass/Fail | [N] | [Summary] |
| A07 | Auth Failures | Pass/Fail | [N] | [Summary] |
| A08 | Software/Data Integrity | Pass/Fail | [N] | [Summary] |
| A09 | Logging/Monitoring Failures | Pass/Fail | [N] | [Summary] |
| A10 | SSRF | Pass/Fail | [N] | [Summary] |

---

## 4. ISO 27001 Control Assessment

### 4.1 User Operations (A.9)
| Control | Status | Finding |
|---------|--------|---------|
| Authentication | Compliant/Non-compliant | [Finding] |
| Authorization (RBAC) | Compliant/Non-compliant | [Finding] |
| Session management | Compliant/Non-compliant | [Finding] |
| Password policy | Compliant/Non-compliant | [Finding] |
| MFA | Compliant/Non-compliant/N/A | [Finding] |

### 4.2 Data Protection (A.8)
| Control | Status | Finding |
|---------|--------|---------|
| Encryption (transit) | Compliant/Non-compliant | [Finding] |
| Encryption (rest) | Compliant/Non-compliant | [Finding] |
| PII masking | Compliant/Non-compliant | [Finding] |
| Data deletion (soft delete) | Compliant/Non-compliant | [Finding] |
| Backup | Compliant/Non-compliant | [Finding] |

### 4.3 Logging and Monitoring (A.12)
| Control | Status | Finding |
|---------|--------|---------|
| Audit log | Compliant/Non-compliant | [Finding] |
| Login logging | Compliant/Non-compliant | [Finding] |
| Critical operation logging | Compliant/Non-compliant | [Finding] |
| Log integrity | Compliant/Non-compliant | [Finding] |

---

## 5. Finding Details

### SEC-001: [Finding Name]

| Field | Value |
|-------|-------|
| ID | SEC-001 |
| Severity | Critical / High / Medium / Low / Informational |
| OWASP | A0[X] |
| CVSS | [Score] |
| Affected | [Module/endpoint/file] |

**Description:**
[Detailed description of the security vulnerability]

**Reproduction Steps:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Impact:**
[What happens if this vulnerability is exploited]

**Recommended Fix:**
[How to fix - include code example if applicable]

**Reference:**
- [CWE-XXX]
- [CVE-XXXX-XXXXX (if applicable)]

---

### SEC-002: [Finding Name]
[Same format]

---

## 6. Dependency Security Scan

### 6.1 Known Vulnerabilities
| Package | Current Version | Vulnerability | Severity | Fix |
|---------|----------------|---------------|----------|-----|
| [package] | v[old] | [CVE-XXXX] | Critical/High | Update to v[new] |

### 6.2 License Compatibility
| Package | License | Compatible |
|---------|---------|-----------|
| [package] | MIT | Yes |
| [package] | GPL-3.0 | Review needed |

---

## 7. Infrastructure Security Controls

| Control | Status | Note |
|---------|--------|------|
| Firewall/WAF | Active/Inactive | [Note] |
| DDoS protection | Active/Inactive | [Note] |
| SSL/TLS | TLS [version] | [Note] |
| CORS policy | Correct/Incorrect | [Note] |
| Security headers | Complete/Incomplete | [Note] |
| Container security | Scanned/Not scanned | [Note] |

### 7.1 HTTP Security Headers
| Header | Value | Status |
|--------|-------|--------|
| Content-Security-Policy | [value] | Present/Missing |
| X-Content-Type-Options | nosniff | Present/Missing |
| X-Frame-Options | DENY | Present/Missing |
| Strict-Transport-Security | max-age=31536000 | Present/Missing |
| X-XSS-Protection | 0 | Present/Missing |
| Referrer-Policy | strict-origin | Present/Missing |

---

## 8. Summary and Recommendations

### 8.1 Finding Summary
| Severity | Count | Fixed | Open |
|----------|-------|-------|------|
| Critical | [N] | [N] | [N] |
| High | [N] | [N] | [N] |
| Medium | [N] | [N] | [N] |
| Low | [N] | [N] | [N] |
| Informational | [N] | - | - |

### 8.2 Decision
- [ ] **PASS** - No Critical/High findings, can be deployed
- [ ] **PASS WITH CONDITIONS** - Can deploy after [N] findings are fixed
- [ ] **FAIL** - Critical findings exist, deployment BLOCKED

---

## 9. Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| Security Lead | VSH | [DATE] | Pending |
| CTO | VSH | [DATE] | Pending |
| DevOps Lead | VSH | [DATE] | Pending |
