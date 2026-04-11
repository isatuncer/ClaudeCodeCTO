# Performance Engineer Skill Definition

## Role
Load testing, profiling, bottleneck analysis, and performance optimization.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Load Testing | Load test planning and execution (k6, Artillery) |
| Stress Testing | Find the system's breaking point |
| Profiling | CPU, memory, I/O profiling |
| Bottleneck Analysis | Slow endpoint, N+1 query, memory leak detection |
| Bundle Analysis | Frontend bundle size, tree-shaking, code splitting |
| DB Query Optimization | Slow query log, EXPLAIN ANALYZE, index recommendations |
| Cache Strategy | Cache hit/miss ratio, TTL optimization |
| CDN/Asset Optimization | Image compression, lazy loading, preload |

---

## Performance Budget

### Backend
| Metric | Target | Critical Threshold |
|--------|--------|-------------------|
| API Response p50 | < 100ms | > 500ms |
| API Response p95 | < 300ms | > 1000ms |
| API Response p99 | < 1000ms | > 3000ms |
| DB Query p95 | < 50ms | > 200ms |
| Throughput | > 100 req/s | < 50 req/s |

### Frontend
| Metric | Target | Critical Threshold |
|--------|--------|-------------------|
| LCP | < 2.5s | > 4.0s |
| INP | < 200ms | > 500ms |
| CLS | < 0.1 | > 0.25 |
| Bundle Size (JS) | < 200KB gzip | > 500KB |
| Bundle Size (CSS) | < 50KB gzip | > 150KB |
| First Load | < 3s (3G) | > 5s |

---

## Load Test Plan

### Test Types
| Test | Purpose | Users | Duration |
|------|---------|-------|----------|
| Smoke | Is the system running | 1-5 | 1 min |
| Load | Normal load | Expected | 10 min |
| Stress | Find the limit | 2x expected | 10 min |
| Soak | Long-term durability | Normal | 1 hour |
| Spike | Sudden load increase | 0 -> 10x -> 0 | 5 min |

### k6 Test Example
```javascript
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '2m', target: 50 },   // Ramp up
    { duration: '5m', target: 50 },   // Steady load
    { duration: '2m', target: 100 },  // Stress
    { duration: '1m', target: 0 },    // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],  // p95 < 500ms
    http_req_failed: ['rate<0.01'],    // Error < 1%
  },
};

export default function () {
  const res = http.get('https://api.example.com/health');
  check(res, { 'status 200': (r) => r.status === 200 });
  sleep(1);
}
```

---

## Related Agents & Skills
- `performance-optimizer` agent - Bottleneck analysis
- `/verify` skill - Verification including performance
- `governance/standards/PERFORMANCE_BUDGET.md` - Budget definitions
- `governance/standards/MONITORING_STRATEGY.md` - Metric monitoring
