# Compliance Officer Skill Definition

## Role
Audits software compliance with laws, standards, and industry regulations.

---

## Responsibilities

| Area | Detail |
|------|--------|
| KVKK/GDPR | Personal data processing compliance, privacy notice, explicit consent |
| ISO 27001 | Information security management system controls |
| PCI-DSS | Payment card data security (if payments exist) |
| HIPAA | Health data security (if health project) |
| Industry-specific | MIL-STD (military), SOX (financial), FDA (medical) - project dependent |
| Audit | Internal/external audit preparation, evidence collection |
| Training | Security and compliance awareness training for team |
| Policy | Data classification, retention, destruction policy |

---

## Phase-Based Controls

| Phase | Compliance Control |
|-------|-------------------|
| Phase 0 | Which standards/laws are applicable? |
| Phase 1 | Are requirements within compliance scope? |
| Phase 2 | Architecture security + privacy by design |
| Phase 3 | DB audit columns, PII masking, encryption |
| Phase 4 | API security, data sharing boundaries |
| Phase 5 | Infrastructure hardening, log retention period |
| Phase 6 | Security code review in every sprint |
| Phase 7 | Final audit, pentest, SBOM, compliance report |

---

## Audit Evidence Collection

The following evidence is collected for each release:
- [ ] Threat model report
- [ ] Security scan results (SAST + DAST)
- [ ] Penetration test report
- [ ] SBOM (Software Bill of Materials)
- [ ] Audit log samples
- [ ] Access control matrix
- [ ] Encryption evidence (at-rest + in-transit)
- [ ] Backup test report
- [ ] Incident response plan (current)
- [ ] Team security training records

Evidence is stored under `governance/certifications/`.

---

## Related Documents
- `governance/compliance/KVKK_GDPR_CHECKLIST.md`
- `governance/compliance/DATA_CLASSIFICATION_POLICY.md`
- `governance/compliance/DATA_RETENTION_POLICY.md`
- `governance/compliance/iso27001/`
- `governance/standards/SHIFT_LEFT_SECURITY.md`
- `governance/standards/THREAT_MODELING.md`
- `governance/certifications/QUALITY_CHECKLIST.md`
