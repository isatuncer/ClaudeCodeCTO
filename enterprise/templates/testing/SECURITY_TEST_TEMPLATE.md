---
title: "Security Test Plan"
document-id: "STP-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "OWASP Testing Guide v4.2"
---

# Security Test Plan

## Table of Contents
1. [Document Information](#1-document-information)
2. [Objectives](#2-objectives)
3. [Scope](#3-scope)
4. [OWASP Top 10 Test Matrix](#4-owasp-top-10-test-matrix)
5. [Test Cases](#5-test-cases)
6. [Tools](#6-tools)
7. [Findings and Remediation](#7-findings-and-remediation)
8. [Schedule](#8-schedule)
9. [Approval](#9-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| Application | [FILL] |
| Security Tester | [FILL] |
| Prepared By | [FILL] |
| Test Type | SAST / DAST / Penetration / All |

## 2. Objectives

[FILL — Define security testing goals: identify vulnerabilities, validate controls, verify compliance per OWASP Testing Guide.]

## 3. Scope

### 3.1 In Scope
| Target | Type | URL / Endpoint | Authentication |
|--------|------|---------------|----------------|
| [FILL] | Web App / API / Mobile / Infrastructure | [FILL] | [FILL] |

### 3.2 Out of Scope
- [FILL]

### 3.3 Rules of Engagement
| Rule | Value |
|------|-------|
| Testing window | [FILL] |
| Rate limiting | [FILL] |
| Prohibited actions | [FILL — e.g., DoS, social engineering] |
| Data handling | [FILL — No production data exfiltration] |

## 4. OWASP Top 10 Test Matrix

| # | Category | Test Cases | Priority | Status |
|---|----------|-----------|----------|--------|
| A01 | Broken Access Control | [FILL] | Critical | [FILL] |
| A02 | Cryptographic Failures | [FILL] | Critical | [FILL] |
| A03 | Injection | [FILL] | Critical | [FILL] |
| A04 | Insecure Design | [FILL] | High | [FILL] |
| A05 | Security Misconfiguration | [FILL] | High | [FILL] |
| A06 | Vulnerable Components | [FILL] | High | [FILL] |
| A07 | Auth Failures | [FILL] | Critical | [FILL] |
| A08 | Software/Data Integrity | [FILL] | High | [FILL] |
| A09 | Logging/Monitoring Failures | [FILL] | Medium | [FILL] |
| A10 | SSRF | [FILL] | High | [FILL] |

## 5. Test Cases

### 5.1 Authentication Tests
| TC ID | Test | Method | Expected Result | Result |
|-------|------|--------|-----------------|--------|
| SEC-001 | Brute force protection | [FILL] | Account lockout after [FILL] attempts | [FILL] |
| SEC-002 | Session management | [FILL] | [FILL] | [FILL] |

### 5.2 Authorization Tests
| TC ID | Test | Method | Expected Result | Result |
|-------|------|--------|-----------------|--------|
| SEC-010 | Horizontal privilege escalation | [FILL] | Access denied | [FILL] |
| SEC-011 | Vertical privilege escalation | [FILL] | Access denied | [FILL] |

### 5.3 Input Validation Tests
| TC ID | Test | Method | Expected Result | Result |
|-------|------|--------|-----------------|--------|
| SEC-020 | SQL injection | [FILL] | Input sanitized | [FILL] |
| SEC-021 | XSS (reflected/stored) | [FILL] | Output encoded | [FILL] |
| SEC-022 | Path traversal | [FILL] | Access denied | [FILL] |

## 6. Tools

| Tool | Purpose | License |
|------|---------|---------|
| [FILL — e.g., OWASP ZAP] | DAST scanning | [FILL] |
| [FILL — e.g., Semgrep] | SAST scanning | [FILL] |
| [FILL — e.g., Trivy] | Dependency/container scanning | [FILL] |
| [FILL — e.g., Burp Suite] | Manual penetration testing | [FILL] |

## 7. Findings and Remediation

| Finding ID | OWASP Cat | Severity | Description | Affected Component | Remediation | Status |
|-----------|-----------|----------|-------------|-------------------|-------------|--------|
| F-001 | [FILL] | Critical / High / Medium / Low | [FILL] | [FILL] | [FILL] | Open / In Progress / Closed |

### 7.1 Severity Definitions
| Severity | CVSS Range | SLA for Fix |
|----------|-----------|-------------|
| Critical | 9.0 - 10.0 | [FILL] days |
| High | 7.0 - 8.9 | [FILL] days |
| Medium | 4.0 - 6.9 | [FILL] days |
| Low | 0.1 - 3.9 | [FILL] days |

## 8. Schedule

| Activity | Start | End | Owner |
|----------|-------|-----|-------|
| SAST scan | [FILL] | [FILL] | [FILL] |
| DAST scan | [FILL] | [FILL] | [FILL] |
| Manual testing | [FILL] | [FILL] | [FILL] |
| Report delivery | [FILL] | [FILL] | [FILL] |
| Remediation verification | [FILL] | [FILL] | [FILL] |

## 9. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| Security Lead | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
