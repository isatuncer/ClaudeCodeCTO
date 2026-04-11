# Operational Runbook Index

> **Compliance References:**
> - Based on: Google SRE Workbook (2018)
> - Spec: Operational runbook format
> - Controls: 8 runbook templates
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
A quick "what do I do" guide for production issues. Step-by-step solutions for each scenario.

---

## Emergency Runbooks

### RB-001: Application Crashed (503/502)
**Symptoms:** Users cannot access the site, health check failing
**Priority:** SEV-1

| Step | Command / Action |
|------|-----------------|
| 1 | Health check: `bash automation/scripts/health_check.sh production` |
| 2 | Check logs: `docker logs [container] --tail 100` |
| 3 | Check pod/container status: `docker ps` |
| 4 | Try restart: `docker compose restart [service]` |
| 5 | If failed, rollback: `bash automation/scripts/rollback.sh production` |
| 6 | Open incident report |

---

### RB-002: Database Connection Error
**Symptoms:** "Connection refused", "too many connections", slow queries
**Priority:** SEV-1

| Step | Command / Action |
|------|-----------------|
| 1 | Check DB status: `pg_isready -h [host]` |
| 2 | Active connections: `SELECT count(*) FROM pg_stat_activity;` |
| 3 | Long-running queries: `SELECT * FROM pg_stat_activity WHERE state='active' AND duration > interval '30s';` |
| 4 | Kill long query: `SELECT pg_terminate_backend(pid);` |
| 5 | Restart connection pool: application restart |
| 6 | Increase max connections (temporary): `ALTER SYSTEM SET max_connections = 200;` |

---

### RB-003: Disk Full
**Symptoms:** "No space left on device", write errors
**Priority:** SEV-1

| Step | Command / Action |
|------|-----------------|
| 1 | Disk status: `df -h` |
| 2 | Large files: `du -sh /* \| sort -rh \| head 10` |
| 3 | Clean logs: `truncate -s 0 /var/log/[app].log` |
| 4 | Clean Docker: `docker system prune -f` |
| 5 | Delete old backups: `find /backups -mtime +7 -delete` |
| 6 | Review disk alarm threshold |

---

### RB-004: High CPU / Memory
**Symptoms:** Slow response, timeout, OOM killer
**Priority:** SEV-2

| Step | Command / Action |
|------|-----------------|
| 1 | Resource status: `top` or `htop` |
| 2 | Container resources: `docker stats` |
| 3 | Memory leak suspect: application restart |
| 4 | Horizontal scale: add replica |
| 5 | Root cause: profiling with APM |

---

### RB-005: SSL Certificate Expired
**Symptoms:** "NET::ERR_CERT_DATE_INVALID", browser warning
**Priority:** SEV-1

| Step | Command / Action |
|------|-----------------|
| 1 | Certificate check: `openssl s_client -connect [domain]:443` |
| 2 | Renew Let's Encrypt: `certbot renew` |
| 3 | Restart Nginx/reverse proxy: `nginx -s reload` |
| 4 | Check auto-renewal cron |

---

### RB-006: Suspected Security Breach
**Symptoms:** Abnormal traffic, data leak, unknown operations
**Priority:** SEV-1

| Step | Command / Action |
|------|-----------------|
| 1 | **Initiate INCIDENT RESPONSE PLAN** (governance/incidents/) |
| 2 | Isolate affected service |
| 3 | Preserve logs (DO NOT DELETE) |
| 4 | Rotate passwords/tokens |
| 5 | Take snapshot for forensic analysis |
| 6 | Notify authorities if required (KVKK: 72 hours) |

---

### RB-007: Redis/Cache Crashed
**Symptoms:** Session loss, slow response, increased cache miss
**Priority:** SEV-2

| Step | Command / Action |
|------|-----------------|
| 1 | Redis status: `redis-cli ping` |
| 2 | Memory: `redis-cli info memory` |
| 3 | Restart: `docker restart redis` |
| 4 | Application graceful degrade: operate without cache |

---

### RB-008: Migration Failed
**Symptoms:** Post-deploy errors, schema mismatch
**Priority:** SEV-2

| Step | Command / Action |
|------|-----------------|
| 1 | Check migration status |
| 2 | Run DOWN migration (rollback) |
| 3 | Application rollback: `bash automation/scripts/rollback.sh production` |
| 4 | Debug migration on staging |
| 5 | Retry with corrected migration |

---

## References
- Incident Response: `governance/incidents/INCIDENT_RESPONSE_PLAN.md`
- Deployment Runbook: `governance/templates/DEPLOYMENT_RUNBOOK_TEMPLATE.md`
- Postmortem: `governance/templates/POSTMORTEM_TEMPLATE.md`
- Monitoring: `governance/standards/MONITORING_STRATEGY.md`
