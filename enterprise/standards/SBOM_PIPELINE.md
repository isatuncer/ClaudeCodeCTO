# Software Bill of Materials (SBOM) Generation Pipeline

> **Compliance References:**
> - Based on: NTIA Minimum Elements for SBOM
> - Spec: CycloneDX 1.5, SPDX 2.3
> - Controls: EU CRA Art. 13
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

An SBOM is a nested inventory of all software components in a project. The EU Cyber Resilience Act mandates SBOM by 2027. CISA updated minimum elements in 2025.

---

## 1. Why SBOM Matters

- **Regulatory compliance:** EU CRA, US Executive Order 14028
- **Vulnerability management:** Correlate dependencies with CVE databases
- **License compliance:** Detect GPL/AGPL/proprietary conflicts
- **Supply chain security:** Know exactly what's in your software
- **Incident response:** Quickly identify if affected by a vulnerability (e.g., Log4Shell)

---

## 2. Format Comparison

| Feature | CycloneDX | SPDX |
|---------|-----------|------|
| Focus | Security, vulnerability | License compliance |
| Format | JSON, XML | JSON, RDF, Tag-Value |
| Spec Version | 1.6 | 2.3 |
| OWASP Backed | Yes | No (Linux Foundation) |
| Dependency Graph | Yes | Limited |
| Vulnerability Data | Native (VEX) | Via external |
| **Recommendation** | **Primary** | Secondary |

---

## 3. Generation Tools by Language

| Language | Tool | Command |
|----------|------|---------|
| Node.js | @cyclonedx/cyclonedx-npm | `npx @cyclonedx/cyclonedx-npm --output-file sbom.json` |
| Python | cyclonedx-bom | `cyclonedx-py requirements -i requirements.txt -o sbom.json` |
| Go | cyclonedx-gomod | `cyclonedx-gomod mod -json -output sbom.json` |
| Java/Maven | cyclonedx-maven-plugin | `mvn org.cyclonedx:cyclonedx-maven-plugin:makeAggregateBom` |
| Rust | cargo-cyclonedx | `cargo cyclonedx --format json` |
| .NET | CycloneDX module | `dotnet CycloneDX project.csproj -o sbom.json` |
| Multi-language | Syft (Anchore) | `syft . -o cyclonedx-json > sbom.json` |

---

## 4. CI/CD Integration

### Generate on Every Build
```yaml
# GitHub Actions step
- name: Generate SBOM
  run: |
    npx @cyclonedx/cyclonedx-npm --output-file sbom.json --spec-version 1.5 src/
- name: Upload SBOM
  uses: actions/upload-artifact@v4
  with:
    name: sbom-${{ github.sha }}
    path: sbom.json
```

### Pipeline Flow
```
Code Push → Build → Generate SBOM → Vulnerability Scan → License Check → Store SBOM → Deploy
```

---

## 5. Vulnerability Correlation

| Tool | Purpose | Integration |
|------|---------|------------|
| Grype (Anchore) | Scan SBOM for CVEs | `grype sbom:sbom.json` |
| OSV-Scanner (Google) | Open Source Vulnerabilities | `osv-scanner --sbom sbom.json` |
| Trivy (Aqua) | Multi-purpose scanner | `trivy sbom sbom.json` |

### Severity Actions
| Severity | Action |
|----------|--------|
| Critical | Block deployment, immediate fix |
| High | Block PR merge, fix within sprint |
| Medium | Track in tech debt, fix within 30 days |
| Low | Log, fix at convenience |

---

## 6. License Compliance

### Allowed Licenses
- MIT, Apache 2.0, BSD 2/3-Clause, ISC, MPL 2.0

### Restricted (Require Legal Review)
- LGPL 2.1/3.0, EPL 1.0/2.0, CDDL

### Forbidden
- GPL 2.0/3.0, AGPL 3.0 (copyleft risk for proprietary projects)
- SSPL, Commons Clause

---

## 7. SBOM Storage & Versioning

| Release | SBOM Location | Retention |
|---------|-------------|-----------|
| Every build | CI artifacts | 90 days |
| Every release | `governance/versioning/sbom/v{X.Y.Z}/sbom.json` | Permanent |
| Production | Deployment artifact | Until next release |

---

## 8. SBOM Review Checklist

- [ ] SBOM generated in CycloneDX 1.5+ format
- [ ] All direct dependencies listed
- [ ] Transitive dependencies included
- [ ] License information present for each component
- [ ] No critical/high CVEs in components
- [ ] No forbidden licenses detected
- [ ] SBOM stored with release artifacts
- [ ] SBOM signed (optional, recommended for production)

---

## 9. Integration with VSH

| Standard | Connection |
|----------|-----------|
| DEPENDENCY_MANAGEMENT.md | License and version policies |
| SOURCE_CONTROL_SECURITY.md | Supply chain security |
| UNIFIED_SECURITY_PIPELINE.md | SCA pillar |
| COMPLIANCE_EVIDENCE_AUTOMATION.md | Audit evidence |
