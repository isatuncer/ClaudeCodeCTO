# Zero Trust Architecture Guide

> **Compliance References:**
> - Based on: NIST Zero Trust Architecture
> - Spec: NIST SP 800-207
> - Controls: All 7 tenets
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Principle: "Trust nothing, verify everything."
> Even if within the network, every request is verified. The assumption "internal network = safe" DOES NOT EXIST.

---

## 1. Zero Trust Principles

| Principle | Implementation |
|-----------|---------------|
| **Verify explicitly** | Every request goes through authentication (token + authorization) |
| **Least privilege** | Every user/service gets minimum permissions |
| **Assume breach** | Design as if the system has been breached |
| **Micro-segmentation** | Services are isolated from each other |
| **Encrypt everything** | Transit + rest + backup all encrypted |
| **Log everything** | Every access, every operation, every error is logged |
| **Continuous verification** | Short token lifespan, continuous re-verification |

---

## 2. Layered Implementation

### Network Layer
```
Internet -> WAF -> LB -> [Service A] -X-> [Service B] (direct access NOT allowed)
                           |                |
                           v                v
                        [Auth Service] (every service verifies)
```

| Control | Implementation |
|---------|---------------|
| Network segmentation | Public/private subnet, firewall between services |
| Service mesh | mTLS between services (Istio/Linkerd) or API gateway |
| No lateral movement | Service A does not access Service B directly - through API gateway |
| Encrypted transit | TLS 1.3 including between services |

### Identity Layer
| Control | Implementation |
|---------|---------------|
| Strong auth | JWT + short-lived (15min) + refresh rotation |
| MFA | Admin = MANDATORY, User = recommended |
| Device trust | Login from unknown device = additional verification |
| Session binding | Token + IP + User-Agent binding |
| Continuous auth | Re-authentication for sensitive operations |

### Application Layer
| Control | Implementation |
|---------|---------------|
| RBAC + ABAC | Role + attribute-based authorization (e.g., "sees own orders") |
| Input validation | At every layer (client + API gateway + service) |
| Output encoding | XSS prevention |
| Error handling | Generic error to client, detailed to Sentry |
| Rate limiting | Per-user + per-IP + per-endpoint |

### Data Layer
| Control | Implementation |
|---------|---------------|
| Encryption at rest | AES-256 (DB, backup, object storage) |
| Row-level security | User sees only their own data |
| Column-level encryption | Additional encryption for PII fields (optional) |
| Data classification | PUBLIC / INTERNAL / CONFIDENTIAL / RESTRICTED |
| Audit trail | Every data access is logged, WORM storage |
| Backup encryption | Backups are also encrypted |

---

## 3. WORM (Write Once Read Many) Audit Log

### Why?
Normal audit logs can be modified = breach evidence can be deleted.
WORM = written once, can NEVER be modified/deleted.

### Implementation
```sql
-- In the audit log table:
-- 1. No UPDATE and DELETE triggers
-- 2. Even the table owner cannot delete (at pg_catalog level)
-- 3. Retention: MIN 7 years

REVOKE UPDATE, DELETE ON audit_log FROM ALL;
-- Only INSERT permission
GRANT INSERT ON audit_log TO app_user;
```

### Cloud Alternatives
| Platform | WORM Solution |
|----------|--------------|
| AWS | S3 Object Lock (Governance/Compliance mode) |
| GCP | Cloud Storage Retention Policy |
| Azure | Immutable Blob Storage |

---

## 4. Related Documents
- `governance/standards/THREAT_MODELING.md`
- `governance/standards/SHIFT_LEFT_SECURITY.md`
- `governance/diagrams/faz2_architecture/DG-205_security_architecture.mmd`
- `governance/diagrams/faz5_infrastructure/DG-503_network_security.mmd`
