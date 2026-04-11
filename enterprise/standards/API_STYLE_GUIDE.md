# API Style Guide

> **Compliance References:**
> - Based on: RFC 7231 (HTTP Semantics), JSON:API 1.1
> - Spec: OpenAPI 3.1
> - Controls: RESTful conventions
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Consistent design rules for all API endpoints.

---

## 1. URL Structure

### General Rules
```
https://api.[domain].com/v{N}/{resource}
```

| Rule | Correct | Wrong |
|------|---------|-------|
| Use plural nouns | `/users` | `/user` |
| Use kebab-case | `/order-items` | `/orderItems`, `/order_items` |
| No verbs | `/users/123` | `/getUser/123` |
| Lowercase | `/users` | `/Users` |
| No trailing slash | `/users` | `/users/` |

### Nested Resources (max 2 levels)
```
GET /users/123/orders          # User's orders
GET /users/123/orders/456      # Specific order
```

> Avoid 3+ levels of nesting, use filters instead:
> `GET /orders?user_id=123&status=active`

### Special Actions
```
POST /orders/123/cancel        # Cancel order (RPC-style, exception)
POST /users/123/verify-email   # Email verification
```

---

## 2. HTTP Methods

| Method | Usage | Idempotent | Body |
|--------|-------|-----------|------|
| GET | Read / list records | Yes | None |
| POST | Create new record | No | Yes |
| PUT | Fully update record | Yes | Yes |
| PATCH | Partially update record | Yes | Yes |
| DELETE | Delete record (soft delete) | Yes | None |

---

## 3. Pagination

### Offset-based (default)
```
GET /users?page=2&limit=20&sort=created_at&order=desc
```

### Cursor-based (large datasets)
```
GET /users?cursor=eyJpZCI6MTAwfQ&limit=20
```

### Response
```json
{
  "data": [...],
  "meta": {
    "page": 2,
    "limit": 20,
    "total": 150,
    "totalPages": 8,
    "hasNext": true,
    "hasPrev": true
  }
}
```

---

## 4. Filtering and Search

### Simple Filter
```
GET /products?status=active&category=electronics
```

### Range Filter
```
GET /orders?created_after=2026-01-01&created_before=2026-12-31
GET /products?price_min=100&price_max=500
```

### Search
```
GET /users?search=ahmet         # General search (name, email)
GET /users?q=ahmet              # Alternative
```

### Sorting
```
GET /products?sort=price&order=asc
GET /products?sort=-created_at   # - prefix = desc
```

---

## 5. Response Format

### Success (Single)
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "name": "Example",
    "created_at": "2026-01-01T00:00:00Z"
  }
}
```

### Success (List)
```json
{
  "success": true,
  "data": [...],
  "meta": { "page": 1, "limit": 20, "total": 100 }
}
```

### Error
```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid email address",
    "details": [
      { "field": "email", "message": "Enter a valid email", "value": "invalid" }
    ]
  }
}
```

### Empty Result
```json
{
  "success": true,
  "data": [],
  "meta": { "page": 1, "limit": 20, "total": 0 }
}
```

---

## 6. Date/Time Format

| Rule | Format | Example |
|------|--------|---------|
| All dates in UTC | ISO 8601 | `2026-01-15T14:30:00Z` |
| Date only | YYYY-MM-DD | `2026-01-15` |
| Input accepted | ISO 8601 | `2026-01-15T14:30:00Z` |
| Timezone info | Always Z (UTC) | `...T14:30:00Z` |

---

## 7. Versioning

### URL versioning (preferred)
```
/api/v1/users
/api/v2/users
```

### Rules
- Major changes (breaking) -> new version
- Minor/patch -> backward compatible in same version
- Old version supported for at least 6 months
- Deprecation header: `Sunset: Sat, 01 Jan 2027 00:00:00 GMT`

---

## 8. Security Rules

| Rule | Implementation |
|------|---------------|
| Auth header | `Authorization: Bearer <token>` |
| Rate limit header | `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset` |
| Request ID | `X-Request-Id` (on every request, for logging) |
| CORS | Only known origins |
| Input validation | Validate all body/query/param |
| SQL injection | Parameterized query MANDATORY |
| Mass assignment | Whitelist/DTO pattern |
