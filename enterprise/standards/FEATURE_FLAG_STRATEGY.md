# Feature Flag Strategy

> **Compliance References:**
> - Based on: Martin Fowler "Feature Toggles" (2016)
> - Spec: LaunchDarkly patterns
> - Controls: Toggle categories, flag lifecycle
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Enable/disable features independently from code deployment, canary release and A/B testing.

---

## 1. Flag Types

| Type | Purpose | Lifespan | Example |
|------|---------|----------|---------|
| **Release** | Hide/show new feature | Short (1-2 sprints) | `NEW_CHECKOUT_FLOW` |
| **Experiment** | A/B test | Medium (1-3 months) | `EXPERIMENT_PRICING_V2` |
| **Ops** | Operational control | Long/permanent | `ENABLE_CACHE`, `MAINTENANCE_MODE` |
| **Permission** | User-based access | Permanent | `BETA_ACCESS`, `PREMIUM_FEATURE` |

---

## 2. Naming Conventions

```
[TYPE]_[MODULE]_[FEATURE]
```

| Example | Type | Module | Feature |
|---------|------|--------|---------|
| `RELEASE_CHECKOUT_NEW_FLOW` | Release | Checkout | New flow |
| `EXP_PRICING_ANNUAL_DISCOUNT` | Experiment | Pricing | Annual discount |
| `OPS_CACHE_REDIS_ENABLED` | Ops | Cache | Redis |
| `PERM_BETA_DARK_MODE` | Permission | Beta | Dark mode |

---

## 3. Flag Evaluation Order

```
1. User-based override (Permission flag)
2. Percentage-based rollout (Canary)
3. Environment-based (dev=on, prod=off)
4. Default value (usually false)
```

---

## 4. Rollout Strategies

### Canary Release (Gradual Rollout)
```
Day 1:  1%  of users  -> monitor metrics
Day 2:  5%  of users  -> monitor metrics
Day 3:  25% of users  -> monitor metrics
Day 5:  50% of users  -> monitor metrics
Day 7:  100% -> remove flag
```

### A/B Test
```
Group A: 50% control (existing)
Group B: 50% experiment (new)
Duration: 2-4 weeks
Measurement: [conversion rate, engagement, revenue]
Decision: Statistical significance (p < 0.05)
```

---

## 5. Code Example

### Simple Usage
```typescript
if (featureFlags.isEnabled('RELEASE_CHECKOUT_NEW_FLOW', { userId })) {
  return <NewCheckoutFlow />;
}
return <OldCheckoutFlow />;
```

### Clean Pattern (Strategy)
```typescript
const checkoutStrategy = featureFlags.isEnabled('RELEASE_CHECKOUT_NEW_FLOW')
  ? newCheckoutService
  : legacyCheckoutService;

await checkoutStrategy.process(order);
```

---

## 6. Flag Lifecycle

```
CREATED -> TESTING (dev) -> ROLLOUT (canary) -> ENABLED (100%) -> CLEANUP (remove code)
```

| Phase | Action |
|-------|--------|
| Created | Flag defined, code written, default=false |
| Testing | Enabled in dev/staging, being tested |
| Rollout | Gradually enabled in production |
| Enabled | 100% on, stable |
| **Cleanup** | Flag and old code REMOVED (max 2 sprints) |

> **CRITICAL:** Flag must be cleaned up within 2 sprints after being enabled. Otherwise it becomes technical debt.

---

## 7. Tool Recommendations

| Tool | Type | Cost |
|------|------|------|
| Environment variable | Simplest, when few flags | Free |
| DB table | Medium complexity | Free |
| Unleash | Self-hosted, open source | Free |
| LaunchDarkly | SaaS, full-featured | Paid |
| Flagsmith | Open source + SaaS | Free/Paid |
| PostHog | Analytics + flags | Free tier |

---

## 8. Rules

- [ ] Every flag must have a defined owner
- [ ] Every flag must have an expected removal date
- [ ] Release flags older than 2 sprints -> record as technical debt
- [ ] Flag names in UPPER_SNAKE_CASE
- [ ] Flag count should not exceed 20 (cleanup mandatory)
- [ ] A/B test flags must be cleaned up IMMEDIATELY after statistical results
