# Penetration Test Plan

> **Compliance References:**
> - Based on: OWASP Testing Guide v4.2, PTES
> - Spec: OWASP Top 10 (2021)
> - Controls: Full OWASP matrix
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Test the system from an attacker's perspective, find vulnerabilities, report them, and close them.

---

## 1. Test Types

| Type | Knowledge Level | When |
|------|----------------|------|
| **Black Box** | Tester has no information | External perspective (annual) |
| **Gray Box** | User account + limited information | Most common (pre-release) |
| **White Box** | Full source code + architecture access | Most comprehensive (major release) |

---

## 2. Test Scope

### Web Application
| Area | Test Detail |
|------|------------|
| Authentication | Brute force, credential stuffing, session hijack, JWT bypass |
| Authorization | IDOR, privilege escalation, RBAC bypass, forced browsing |
| Input Validation | SQL injection, XSS (reflected/stored/DOM), command injection, SSRF |
| Business Logic | Rate limit bypass, price manipulation, coupon abuse, race condition |
| File Upload | Malicious file, path traversal, MIME bypass, size bypass |
| API | Mass assignment, verb tampering, parameter pollution, GraphQL introspection |
| Session | Fixation, timeout, concurrent session, cookie security |

### Infrastructure
| Area | Test Detail |
|------|------------|
| Network | Port scan, service enumeration, SSL/TLS config |
| Server | Default credentials, unnecessary services, misconfig |
| Container | Escape, privileged mode, secret exposure |
| Cloud | S3 bucket permission, IAM misconfig, metadata endpoint |

---

## 3. OWASP Top 10 Control Matrix

| # | Vulnerability | Test Method | Tool |
|---|--------------|-------------|------|
| A01 | Broken Access Control | IDOR, forced browsing, CORS misconfig | Burp Suite, manual |
| A02 | Cryptographic Failures | Weak cipher, plain text storage, HTTP | SSLScan, manual |
| A03 | Injection | SQLi, XSS, Command injection | SQLMap, Burp, ZAP |
| A04 | Insecure Design | Business logic flaw, threat model gap | Manual review |
| A05 | Security Misconfiguration | Default creds, verbose errors, headers | Nikto, Nmap, ZAP |
| A06 | Vulnerable Components | Known CVE in dependencies | Snyk, npm audit |
| A07 | Auth Failures | Brute force, weak password, MFA bypass | Hydra, Burp |
| A08 | Software/Data Integrity | Unsigned update, CI/CD manipulation | Manual review |
| A09 | Logging Failures | Missing audit, log injection | Manual review |
| A10 | SSRF | Internal resource access via URL param | Burp, manual |

---

## 4. Test Tools

| Tool | Type | Cost | Usage |
|------|------|------|-------|
| OWASP ZAP | DAST | Free | Automated web scan |
| Burp Suite Pro | DAST + manual | Paid | Manual pentest |
| SQLMap | SQLi | Free | SQL injection |
| Nikto | Web server scan | Free | Misconfig |
| Nmap | Network scan | Free | Port/service discovery |
| Nuclei | Vuln scanner | Free | Template-based scanning |
| ffuf | Fuzzing | Free | Directory/parameter brute |
| Hydra | Brute force | Free | Credential testing |

---

## 5. Pentest Report Format

### Finding Detail
```markdown
### PT-001: [Vulnerability Name]

| Field | Value |
|-------|-------|
| Severity | Critical / High / Medium / Low |
| OWASP | A0[X] |
| CVSS | [X.Y] |
| Affected | [URL/endpoint/module] |
| CWE | CWE-[N] |

**Description:** [Vulnerability detail]

**Reproduction:**
1. [Step]
2. [Step]
3. [Result - what was achieved]

**Evidence:** [Screenshot / HTTP request-response]

**Impact:** [What happens if this vulnerability is exploited]

**Remediation:** [How to fix - code example]

**Reference:** [CWE/CVE/OWASP link]
```

---

## 6. Schedule

| Test | Frequency | Responsibility |
|------|-----------|---------------|
| Automated DAST (ZAP) | Every release | CI/CD (automated) |
| Manual pentest (Gray Box) | Quarterly | Security engineer |
| Full pentest (White Box) | Annual | External firm / specialist |
| Social engineering | Annual | External firm |

---

## 7. Finding Management

| Severity | SLA | Action |
|----------|-----|--------|
| Critical | 24 hours | Fix IMMEDIATELY, deploy hotfix |
| High | 1 week | Fix within sprint |
| Medium | 1 month | Plan for next sprint |
| Low | 3 months | Add to backlog |

> **RULE:** Release is PROHIBITED while Critical and High findings are open.

---

## Related Documents
- `governance/standards/THREAT_MODELING.md`
- `governance/standards/SHIFT_LEFT_SECURITY.md`
- `governance/templates/SECURITY_ASSESSMENT_TEMPLATE.md`
- `departments/05_quality_and_security/skills/devsecops_engineer.md`
