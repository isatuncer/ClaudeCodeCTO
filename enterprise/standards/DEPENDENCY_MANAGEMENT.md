# Dependency Management & Security Scanning

> **Compliance References:**
> - Based on: OWASP Dependency-Check, Snyk
> - Spec: SemVer 2.0.0, License compatibility
> - Controls: Pinned versions, security scanning
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

> Security, license, and version management for all dependencies.

---

## Dependency Addition Rules

### Checks BEFORE Adding a New Dependency:
1. **Is it necessary?** Can it be solved with standard libraries?
2. **Is it active?** Any commits in the last 6 months?
3. **Is it secure?** Any known vulnerabilities? (npm audit / pip audit / etc.)
4. **Is the license compatible?** MIT, Apache 2.0 -> OK. GPL -> CAUTION.
5. **Is the size reasonable?** Is the bundle size impact acceptable?
6. **Are there alternatives?** Is there a lighter/more secure alternative?

### Prohibited Licenses
| License | Status | Reason |
|---------|--------|--------|
| GPL v2/v3 | PROHIBITED (commercial project) | Copyleft - requires you to open all code |
| AGPL | PROHIBITED | Triggers even on server-side |
| Unlicensed | PROHIBITED | Legal risk |
| WTFPL | CAUTION | Unprofessional, legal ambiguity |

### Allowed Licenses
MIT, Apache 2.0, BSD 2/3-Clause, ISC, MPL 2.0

---

## Security Scanning

### Automated Scanning (in CI/CD)
- **Every commit:** `npm audit` / `pip audit` / `cargo audit`
- **Weekly:** Full dependency tree scan
- **Monthly:** License compliance scan

### If a Vulnerability Is Found:
| Severity | Action | Timeframe |
|----------|--------|-----------|
| Critical | Update IMMEDIATELY, block deployment | 24 hours |
| High | Update within this sprint | 1 week |
| Medium | Plan for next sprint | 2 weeks |
| Low | Add to backlog | When possible |

---

## Version Pinning Strategy

### Prod Dependencies: EXACT version
```json
"dependencies": {
  "express": "4.18.2"     // EXACT - pinned
}
```

### Dev Dependencies: MINOR range
```json
"devDependencies": {
  "jest": "^29.7.0"       // Minor updates OK
}
```

### Update Schedule
| Type | Frequency | Scope |
|------|-----------|-------|
| Security patch | Immediately | Affected packages |
| Minor update | Monthly | All packages |
| Major update | Quarterly | One at a time, with tests |

---

## Dependency Registry Table

| Package | Version | License | Last Updated | Security | Notes |
|---------|---------|---------|-------------|----------|-------|
| [package] | [ver] | MIT/Apache/... | [date] | OK/WARN | [note] |
