# Performance Budget & SLA Targets

> **Compliance References:**
> - Based on: ISO/IEC 25010:2011 (Performance Efficiency)
> - Spec: Core Web Vitals (Google)
> - Controls: API, frontend, DB thresholds
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

> Project performance targets. These targets are checked with every development.

---

## API Performance Targets

| Metric | Target | Unacceptable | Measurement |
|--------|--------|-------------|-------------|
| Response Time (p50) | < 200ms | > 500ms | Per endpoint |
| Response Time (p95) | < 500ms | > 2s | Per endpoint |
| Response Time (p99) | < 1s | > 5s | Per endpoint |
| Error Rate | < 0.1% | > 1% | Total |
| Availability | >= 99.9% | < 99% | Monthly |
| Throughput | Project-specific | Project-specific | req/s |

## Frontend Performance Targets (Web)

| Metric | Target | Unacceptable | Measurement |
|--------|--------|-------------|-------------|
| First Contentful Paint (FCP) | < 1.5s | > 3s | Lighthouse |
| Largest Contentful Paint (LCP) | < 2.5s | > 4s | Lighthouse |
| Cumulative Layout Shift (CLS) | < 0.1 | > 0.25 | Lighthouse |
| First Input Delay (FID) | < 100ms | > 300ms | Lighthouse |
| Time to Interactive (TTI) | < 3.5s | > 7s | Lighthouse |
| Bundle Size (Initial) | < 200KB gzip | > 500KB | Build |
| Lighthouse Score | >= 90 | < 70 | Lighthouse |

## Database Performance Targets

| Metric | Target | Unacceptable | Action |
|--------|--------|-------------|--------|
| Query Time (simple) | < 10ms | > 100ms | Add index |
| Query Time (complex) | < 100ms | > 1s | Optimize query |
| Connection Pool | < 70% usage | > 90% | Increase pool size |
| Slow Query Log | 0 | > 5/hour | Investigate |

## Mobile Performance Targets

| Metric | Target | Unacceptable |
|--------|--------|-------------|
| App Start (cold) | < 2s | > 5s |
| App Start (warm) | < 1s | > 2s |
| Memory Usage | < 150MB | > 300MB |
| APK/IPA Size | < 30MB | > 80MB |
| Battery Impact | Minimal | High drain |
| Offline Support | Graceful degradation | Crash |

## Monitoring Alert Thresholds

| Metric | Warning | Critical | Action |
|--------|---------|----------|--------|
| CPU | > 70% | > 90% | Scale up |
| Memory | > 75% | > 90% | Investigate |
| Disk | > 80% | > 95% | Cleanup/extend |
| Error Rate | > 0.5% | > 2% | Investigate |
| Response Time p95 | > 1s | > 3s | Optimize |
| Queue Depth | > 1000 | > 5000 | Scale consumers |

## Performance Test Requirements

### MANDATORY Before Every Release:
- [ ] Load test: 2x the expected user count
- [ ] Stress test: Identify breaking point
- [ ] Soak test: 1-hour sustained load
- [ ] Spike test: Sudden load increase
- [ ] Slow query analysis
- [ ] Bundle size check (frontend)
- [ ] Lighthouse scan (web)
