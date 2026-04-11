# Self-Healing Architecture Patterns

> **Compliance References:**
> - Based on: Michael Nygard "Release It!" 2nd Ed. (2018)
> - Spec: Stability patterns
> - Controls: Circuit breaker, bulkhead, retry
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Systems that automatically detect, diagnose, and recover from failures without human intervention.

---

## 1. Pattern Catalog

### 1.1 Circuit Breaker
```
States: CLOSED → OPEN → HALF-OPEN → CLOSED

CLOSED: Normal operation, requests pass through
  → Failure count > threshold → OPEN

OPEN: All requests fail fast (no attempt)
  → After timeout → HALF-OPEN

HALF-OPEN: Allow limited test requests
  → Success → CLOSED
  → Failure → OPEN
```

**Config:** threshold=5 failures, timeout=30s, half-open-max=3

### 1.2 Retry with Exponential Backoff
```
Attempt 1: immediate
Attempt 2: wait 1s + random(0-500ms)
Attempt 3: wait 2s + random(0-500ms)
Attempt 4: wait 4s + random(0-500ms)
Max attempts: 4, Max delay: 30s
```

### 1.3 Bulkhead Isolation
Isolate failures to prevent cascade:
- Thread pool per dependency
- Connection pool per service
- Queue per consumer

### 1.4 Health-Check-Driven Restarts
```
/health → checks DB, Redis, dependencies
  → Unhealthy 3 consecutive times → Container restart
  → Healthy → Reset counter
```

### 1.5 Connection Pool Recovery
```
Pool exhausted → Create emergency connections (10% over limit)
  → Alert operations team
  → Kill idle connections > 5 minutes
  → Gradually restore to normal pool size
```

### 1.6 Graceful Degradation
When dependent service fails, degrade instead of crash:
- Cache unavailable → Serve stale data or skip caching
- Search unavailable → Show recent items instead
- Payment provider down → Queue for retry
- Notification service down → Log for batch send later

### 1.7 Dead Letter Queue
Failed messages → DLQ → Alert → Manual/auto retry after investigation

### 1.8 Timeout Cascade Prevention
Set timeouts at each layer, decreasing inward:
```
Load Balancer: 60s
API Gateway: 30s
Service: 15s
Database: 5s
External API: 10s
```

---

## 2. Maturity Levels

| Level | Name | Capabilities |
|-------|------|-------------|
| L1 | Manual | Runbooks, manual recovery |
| L2 | Scripted | Recovery scripts, automated alerts |
| L3 | Automated | Self-healing patterns active, auto-restart |
| L4 | Predictive | ML-based anomaly detection, proactive scaling |

---

## 3. Testing Self-Healing

Use chaos engineering to verify patterns:

| Pattern | Chaos Test | Expected Behavior |
|---------|-----------|-------------------|
| Circuit Breaker | Kill dependency | Requests fail fast, recover when back |
| Retry | Inject transient errors | Automatic retry succeeds |
| Bulkhead | Overwhelm one dependency | Other deps unaffected |
| Health restart | Return unhealthy | Container restarts automatically |
| Graceful degradation | Kill cache | Service continues with fallback |

---

## 4. Integration with VSH

| Standard | Connection |
|----------|-----------|
| CHAOS_ENGINEERING.md | Testing self-healing |
| CHAOS_GAME_DAYS.md | Game day experiments |
| DISASTER_RECOVERY_PLAN.md | DR extends self-healing |
| SRE_ERROR_BUDGET.md | Self-healing preserves budget |
| MONITORING_STRATEGY.md | Detection layer |
