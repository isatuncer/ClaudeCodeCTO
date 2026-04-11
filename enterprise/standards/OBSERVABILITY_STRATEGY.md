# Observability Strategy

> **Compliance References:**
> - Based on: OpenTelemetry Specification
> - Spec: Three Pillars of Observability
> - Controls: Traces, metrics, logs
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Principle: "You can't manage what you can't measure." - 3 Pillars: Metrics + Logs + Traces

---

## 1. Three Pillars

```
         Observability
        /      |       \
   Metrics   Logs    Traces
   (Numbers) (Events) (Flows)
   "How much" "What happened" "Where is it slow"
```

| Pillar | Question | Tool |
|--------|----------|------|
| **Metrics** | What's the error rate? CPU %? | Prometheus + Grafana |
| **Logs** | Why did the error occur? Who did what? | ELK / Loki + Grafana |
| **Traces** | Which services did the request pass through, where did it slow down? | Jaeger / Tempo |

---

## 2. Distributed Tracing

### For Each Request
```
Request ID: req-abc-123
  |
  ├── [API Gateway] 2ms
  │     ├── Auth middleware: 5ms
  │     └── Rate limit: 1ms
  ├── [User Service] 15ms
  │     └── DB query: 8ms
  ├── [Order Service] 45ms
  │     ├── DB query: 12ms
  │     ├── Payment call: 25ms (3rd party - slow!)
  │     └── Cache write: 2ms
  └── [Notification Service] 3ms (async)

TOTAL: 65ms
BOTTLENECK: Payment call (25ms)
```

### Implementation
```typescript
// Add trace ID to every request
app.use((req, res, next) => {
  req.traceId = req.headers['x-request-id'] || crypto.randomUUID();
  res.setHeader('x-request-id', req.traceId);
  next();
});

// Add trace ID to every log
logger.info('Order created', {
  traceId: req.traceId,
  orderId: order.id,
  userId: req.user.id,
  duration_ms: endTime - startTime
});

// Add trace ID to every DB query
const result = await db.query(sql, params, { traceId: req.traceId });
```

---

## 3. Structured Logging

### Log Format (MANDATORY)
```json
{
  "timestamp": "2026-04-07T14:30:00.123Z",
  "level": "error",
  "service": "order-service",
  "traceId": "req-abc-123",
  "spanId": "span-xyz-456",
  "userId": "usr-***-789",
  "method": "POST",
  "path": "/api/v1/orders",
  "status": 500,
  "duration_ms": 234,
  "message": "Payment processing failed",
  "error": {
    "code": "PAYMENT_TIMEOUT",
    "message": "iyzico timeout after 30s",
    "stack": "..."
  },
  "metadata": {
    "orderId": "ord-abc",
    "amount": 150.00,
    "currency": "TRY"
  }
}
```

### Log Correlation
```
With the same traceId, logs from ALL services can be joined:
  API Gateway log + User Service log + Order Service log + DB query log
  = The complete story of a single request
```

---

## 4. Metric Types

| Type | Example | Purpose |
|------|---------|---------|
| **Counter** | Total requests, total errors | Measure rate of increase |
| **Gauge** | Active connections, CPU%, memory% | Current state |
| **Histogram** | Response time distribution | Calculate p50/p95/p99 |
| **Summary** | Request duration | Average + quantile |

### RED Method (For Each Service)
| Metric | Description |
|--------|-------------|
| **R**ate | Requests per second (req/s) |
| **E**rrors | Error rate (%) |
| **D**uration | Request duration (p50, p95, p99) |

### USE Method (For Each Resource)
| Metric | Description |
|--------|-------------|
| **U**tilization | How much of the resource is being used (CPU %) |
| **S**aturation | Queue depth, waiting |
| **E**rrors | Resource errors |

---

## 5. Alert Rules

### Fast Alert (< 5 min)
| Condition | Level |
|-----------|-------|
| Error rate > 5% (within 2min) | CRITICAL |
| All health checks failed | CRITICAL |
| DB connection pool 100% full | CRITICAL |
| Disk > 95% | CRITICAL |

### Slow Alert (< 30 min)
| Condition | Level |
|-----------|-------|
| Response time p95 > 2s (5min avg) | WARNING |
| CPU > 80% (10min avg) | WARNING |
| Error rate > 1% (5min avg) | WARNING |
| SSL cert < 14 days | WARNING |

### ALERT FATIGUE PREVENTION
- Do NOT re-send the same alert within 5min (dedup)
- WARNING = Slack, CRITICAL = phone call (separate channels)
- Every alert must have a RUNBOOK link (clear what to do)
- If false positive > 10%, FIX the alert rule

---

## 6. SLI / SLO / Error Budget

### SLI (Service Level Indicator)
```
Availability SLI = (Successful requests / Total requests) * 100
Latency SLI = (Requests with p95 < 500ms / Total requests) * 100
```

### SLO (Service Level Objective)
| SLI | SLO | Period |
|-----|-----|--------|
| Availability | 99.9% | 30 days |
| Latency (p95) | 99% requests < 500ms | 30 days |
| Error rate | < 0.1% | 30 days |

### Error Budget
```
Error budget = 100% - SLO = 0.1%
30 days = 43,200 minutes
Error budget = 43.2 minutes/month downtime allowed

If remaining budget < 25%:
  - New features STOP
  - Only reliability work is done
  - Chaos engineering is PAUSED
```

---

## Related Documents
- `governance/standards/MONITORING_STRATEGY.md` - Metric details
- `governance/standards/DISASTER_RECOVERY_PLAN.md` - Recovery
- `governance/standards/RUNBOOK_INDEX.md` - Operational guide
- `governance/standards/ONCALL_PROCEDURE.md` - On-call process
