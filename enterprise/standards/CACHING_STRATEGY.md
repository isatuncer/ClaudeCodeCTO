# Caching Strategy

> **Compliance References:**
> - Based on: RFC 9111 (HTTP Caching)
> - Spec: Cache-aside, write-through patterns
> - Controls: TTL, invalidation, cache layers
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Consistent caching mechanisms that improve performance on frontend and backend.

---

## 1. Cache Layers

```
User -> [Browser Cache] -> [CDN] -> [API Gateway Cache] -> [App Cache (Redis)] -> [DB Query Cache] -> DB
```

| Layer | TTL | Invalidation | Usage |
|-------|-----|-------------|-------|
| **Browser** | 5min - 1year | ETag/Cache-Control | Static assets, API response |
| **CDN** | 1min - 1hour | Purge API | Static files, public pages |
| **Redis (App)** | 1min - 1hour | Write-through/Event | Session, frequently read data |
| **DB Query** | 5min | TTL | Heavy aggregation queries |

---

## 2. Cache Patterns

### Cache-Aside (Lazy Loading)
```typescript
async function getUser(id: string): Promise<User> {
  // 1. Check cache
  const cached = await redis.get(`user:${id}`);
  if (cached) return JSON.parse(cached);

  // 2. Read from DB
  const user = await db.users.findById(id);

  // 3. Write to cache
  await redis.setex(`user:${id}`, 300, JSON.stringify(user)); // 5 min

  return user;
}
```

### Write-Through
```typescript
async function updateUser(id: string, data: UpdateDTO): Promise<User> {
  // 1. Update DB
  const user = await db.users.update(id, data);

  // 2. Update cache (simultaneously)
  await redis.setex(`user:${id}`, 300, JSON.stringify(user));

  return user;
}
```

### Write-Behind (Async)
```typescript
async function recordPageView(pageId: string): Promise<void> {
  // 1. Increment counter in Redis (fast)
  await redis.incr(`pageview:${pageId}`);

  // 2. Periodically write to DB (cron/worker)
  // Flush Redis -> DB every 5 minutes
}
```

---

## 3. Cache Invalidation Rules

| Event | Invalidation | Pattern |
|-------|-------------|---------|
| Entity updated | Delete that entity's cache | `redis.del('user:123')` |
| List changed | Delete list cache | `redis.del('users:page:*')` |
| Configuration changed | Delete all related cache | Tag-based invalidation |
| Deploy | Delete static asset cache | Cache busting (hash) |

### Tag-Based Invalidation
```typescript
// Add tag when writing
await redis.sadd('tag:products', 'product:123', 'products:list:1');

// When product is updated, delete all related caches
const keys = await redis.smembers('tag:products');
await redis.del(...keys);
await redis.del('tag:products');
```

---

## 4. HTTP Cache Headers

### Static Assets (JS, CSS, Image)
```
Cache-Control: public, max-age=31536000, immutable
```
> Filename must contain hash: `app.a1b2c3.js` -> cache busting

### API Response (Public, variable)
```
Cache-Control: public, max-age=60, s-maxage=300
ETag: "abc123"
```

### API Response (Private, user-specific)
```
Cache-Control: private, max-age=0, must-revalidate
ETag: "user-specific-hash"
```

### Never Cache
```
Cache-Control: no-store
```
> Sensitive data: auth tokens, personal information, payments

---

## 5. What to Cache vs What Not to Cache

### DO CACHE
| Data | TTL | Reason |
|------|-----|--------|
| Product list | 5min | Frequently read, rarely changes |
| Category list | 1hour | Very rarely changes |
| User profile | 5min | Frequently read |
| Configuration | 10min | Rarely changes |
| Search results | 1min | Heavy query |
| Dashboard aggregation | 5min | Heavy query |

### DO NOT CACHE
| Data | Reason |
|------|--------|
| Cart / shopping cart | Changes too frequently, inconsistency risk |
| Stock quantity | Must be real-time |
| Payment status | Must be real-time |
| OTP / token | Security risk |
| Live score / price | Must be real-time |

---

## Related Documents
- `governance/standards/PERFORMANCE_BUDGET.md`
- `governance/standards/MONITORING_STRATEGY.md`
- `governance/templates/BLUEPRINT_TEMPLATE.md` (architecture)
