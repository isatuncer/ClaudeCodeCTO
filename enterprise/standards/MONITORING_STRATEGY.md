# Monitoring & Alerting Strategy

> **Compliance References:**
> - Based on: Google SRE "Monitoring Distributed Systems"
> - Spec: USE method, RED method
> - Controls: Alert severity levels
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Standards for monitoring system health, performance, and security across all environments.

---

## 1. Monitoring Layers

### 1.1 Infrastructure Monitoring
| Metric | Tool | Alert Threshold | Level |
|--------|------|----------------|-------|
| CPU usage | Prometheus/CloudWatch | > 80% (5min) | Warning |
| CPU usage | Prometheus/CloudWatch | > 95% (2min) | Critical |
| Memory usage | Prometheus/CloudWatch | > 85% | Warning |
| Disk usage | Prometheus/CloudWatch | > 90% | Critical |
| Network I/O | Prometheus/CloudWatch | Anomaly | Warning |

### 1.2 Application Monitoring (APM)
| Metric | Tool | Alert Threshold | Level |
|--------|------|----------------|-------|
| Response time p95 | Datadog/NewRelic/Prometheus | > 500ms | Warning |
| Response time p95 | Datadog/NewRelic/Prometheus | > 2s | Critical |
| Error rate | Sentry/Datadog | > 1% | Warning |
| Error rate | Sentry/Datadog | > 5% | Critical |
| Throughput | Prometheus/Grafana | < 50% normal | Warning |
| Active connections | Prometheus | > 80% pool | Warning |

### 1.3 Database Monitoring
| Metric | Alert Threshold | Level |
|--------|----------------|-------|
| Query time p95 | > 100ms | Warning |
| Connection pool | > 80% full | Warning |
| Replication lag | > 5s | Critical |
| Disk usage | > 85% | Critical |
| Dead tuples | > 20% table size | Warning |
| Long running queries | > 30s | Warning |

### 1.4 Business Monitoring
| Metric | Alert Threshold | Level |
|--------|----------------|-------|
| Registrations/minute | < 50% normal | Warning |
| Payment success rate | < 95% | Critical |
| Login failure | > 10/min same IP | Security |
| API usage | Approaching rate limit | Warning |

### 1.5 Security Monitoring
| Metric | Alert Threshold | Level |
|--------|----------------|-------|
| Failed login | > 5/min same account | Security |
| Brute force | > 20/min same IP | Critical |
| SQL injection attempt | Any | Critical |
| Unauthorized API access | > 3/min | Security |
| SSL certificate expiry | < 30 days | Warning |
| SSL certificate expiry | < 7 days | Critical |

---

## 2. Alert Levels and Escalation

| Level | Response Time | Notification | Action |
|-------|-------------|-------------|--------|
| **Critical** | 5 min | SMS + Phone + Slack | Immediate intervention |
| **Warning** | 30 min | Slack + Email | Review during business hours |
| **Info** | Next business day | Slack | Review in weekly meeting |
| **Security** | 5 min | SMS + Phone + Slack + SIEM | Start incident response |

### Escalation Chain
```
Alert -> On-call engineer (5 min)
  -> Team lead (15 min no response)
    -> CTO (30 min no response or SEV-1)
```

---

## 3. Dashboards

### 3.1 Overview Dashboard
- System uptime (last 30 days)
- Active alert count (by level)
- Response time trend (last 24 hours)
- Error rate trend (last 24 hours)
- Active user count

### 3.2 API Performance Dashboard
- Response time by endpoint (p50, p95, p99)
- Error rate by endpoint
- Request/second throughput
- HTTP status code distribution

### 3.3 Database Dashboard
- Query performance (slow query list)
- Connection pool status
- Replication lag
- Table sizes and growth trend

### 3.4 Security Dashboard
- Failed login attempts
- Rate limit violations
- Abnormal traffic patterns
- SSL certificate statuses

---

## 4. Log Management

### 4.1 Log Levels
| Level | Production | Staging | Development |
|-------|-----------|---------|-------------|
| ERROR | Yes | Yes | Yes |
| WARN | Yes | Yes | Yes |
| INFO | Yes | Yes | Yes |
| DEBUG | No | Yes | Yes |
| TRACE | No | No | Yes |

### 4.2 Log Retention
| Environment | Hot Storage | Cold Storage | Total |
|-------------|-----------|-------------|-------|
| Production | 30 days | 1 year | 1 year |
| Staging | 14 days | - | 14 days |
| Development | 7 days | - | 7 days |

### 4.3 Mandatory Log Fields
```json
{
  "timestamp": "ISO 8601",
  "level": "ERROR",
  "service": "api-service",
  "request_id": "uuid",
  "user_id": "uuid (masked)",
  "method": "POST",
  "path": "/api/v1/orders",
  "status": 500,
  "duration_ms": 234,
  "message": "Order creation failed",
  "error": { "code": "DB_CONNECTION", "stack": "..." }
}
```

---

## 5. Health Check Endpoints

### 5.1 Liveness
```
GET /health/live -> 200 OK
```
Only checks if the process is running.

### 5.2 Readiness
```
GET /health/ready -> 200 OK | 503 Service Unavailable
```
Checks if DB, Redis, external services are ready.

```json
{
  "status": "healthy",
  "checks": {
    "database": { "status": "up", "latency_ms": 5 },
    "redis": { "status": "up", "latency_ms": 2 },
    "external_api": { "status": "up", "latency_ms": 45 }
  },
  "uptime_seconds": 86400,
  "version": "1.2.3"
}
```

---

## 6. Tool Recommendations

| Need | Open Source | SaaS |
|------|-----------|------|
| Metric collection | Prometheus | Datadog, NewRelic |
| Visualization | Grafana | Datadog, NewRelic |
| Log collection | ELK (Elasticsearch+Logstash+Kibana) / Loki | Datadog, Papertrail |
| Error tracking | Sentry (self-hosted) | Sentry Cloud |
| Uptime monitoring | Uptime Kuma | Better Uptime, Pingdom |
| APM | Jaeger / Zipkin | Datadog APM, NewRelic |
| Alert | Alertmanager | PagerDuty, OpsGenie |
