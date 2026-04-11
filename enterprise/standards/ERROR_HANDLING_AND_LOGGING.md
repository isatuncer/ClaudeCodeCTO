# Error Handling & Logging Standards

> **Compliance References:**
> - Based on: RFC 9457 (Problem Details for HTTP APIs)
> - Spec: Structured logging (JSON), ELK stack
> - Controls: Error codes, correlation IDs
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

> MANDATORY error handling and logging standards applied across all projects.

---

## 1. Error Handling

### API Error Response Format (Standard)
```json
{
  "success": false,
  "error": {
    "code": "ERR_VALIDATION_FAILED",
    "message": "User-friendly message",
    "details": [
      {
        "field": "email",
        "message": "Please enter a valid email address"
      }
    ],
    "request_id": "req_abc123",
    "timestamp": "2026-04-05T12:00:00Z"
  }
}
```

### HTTP Status Code Standards
| Code | Meaning | When |
|------|---------|------|
| 200 | OK | Successful GET, PUT |
| 201 | Created | Successful POST (record creation) |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Validation error, missing parameter |
| 401 | Unauthorized | Authentication failed |
| 403 | Forbidden | No authorization |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Conflict (duplicate, stale data) |
| 422 | Unprocessable | Business rule violation |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Error | Unexpected server error |

### Error Code Format
```
ERR_[DOMAIN]_[SPECIFIC]

Examples:
ERR_AUTH_INVALID_CREDENTIALS
ERR_AUTH_TOKEN_EXPIRED
ERR_AUTH_ACCOUNT_LOCKED
ERR_USER_NOT_FOUND
ERR_USER_EMAIL_DUPLICATE
ERR_VALIDATION_REQUIRED_FIELD
ERR_PAYMENT_INSUFFICIENT_FUNDS
ERR_RATE_LIMIT_EXCEEDED
```

### Error Layers
```
Controller -> Service -> Repository
    |            |           |
    v            v           v
  HTTP Error   Business    Data Error
  (400-499)    Error       (DB timeout,
               (422)       constraint)
                            |
                            v
                        500 Internal
```

### RULES:
- NEVER show stack trace to the user
- NEVER show DB error message to the user
- Every error carries a request_id (for debugging)
- 500 errors trigger alerts
- Error messages must be i18n compatible

---

## 2. Logging Standards

### Log Levels
| Level | When | Example |
|-------|------|---------|
| FATAL | Application must stop | DB connection completely lost |
| ERROR | Operation failed but application is running | Payment failed |
| WARN | Potential issue, not yet an error | Disk 85% full |
| INFO | Normal business events | User logged in |
| DEBUG | Developer detail (disabled in prod) | SQL query duration |
| TRACE | Very detailed (debug only) | Request/response body |

### Log Format (Structured JSON)
```json
{
  "timestamp": "2026-04-05T12:00:00.123Z",
  "level": "INFO",
  "service": "api-server",
  "request_id": "req_abc123",
  "user_id": "usr_xyz789",
  "action": "user.login",
  "message": "User login successful",
  "metadata": {
    "ip": "192.168.1.***",
    "method": "POST",
    "path": "/api/auth/login",
    "status": 200,
    "duration_ms": 145
  }
}
```

### What to Log / What NOT to Log

**DO LOG:**
- Every HTTP request (method, path, status, duration)
- Authentication events (successful + failed)
- Business logic events (order created, payment received)
- Errors (all levels)
- Performance metrics (slow query, timeout)

**NEVER LOG:**
- Password / token / secret / API key
- Credit card number
- National ID number
- Full request body (if it contains sensitive data)
- The session token itself

### Log Rotation & Retention
| Environment | Retention | Rotation |
|-------------|-----------|----------|
| Development | 7 days | Daily |
| Staging | 30 days | Daily |
| Production | 90 days (INFO+) / 1 year (ERROR+) | Daily |

### Correlation ID (Request Tracing)
Each request is assigned a unique `request_id`. This ID:
- Is present in all log lines
- Is returned in error responses
- Is propagated across microservices (header: X-Request-ID)
- Is used to trace the entire flow during debugging
