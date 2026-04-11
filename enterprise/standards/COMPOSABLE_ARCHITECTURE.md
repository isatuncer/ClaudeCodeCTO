# Composable Architecture Patterns Library

> **Compliance References:**
> - Based on: Gartner Composable Enterprise (2020)
> - Spec: Modular business capabilities
> - Controls: Module interface contracts
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Pre-built, independently deployable modules with standardized interfaces. Plug-and-play into any project.

---

## 1. Module Catalog

| Module | Responsibility | Interface |
|--------|---------------|-----------|
| **Auth** | Authentication & authorization | JWT, OAuth 2.0, MFA |
| **Payment** | Payment processing & refunds | Stripe, iyzico adapter |
| **Notification** | Push, email, SMS, in-app | Event-driven, template-based |
| **File Storage** | Upload, serve, transform | Presigned URLs, virus scan |
| **Search** | Full-text, autocomplete | PostgreSQL FTS, Elasticsearch |
| **Cache** | Multi-layer caching | Redis, in-memory |
| **Audit** | Event logging, WORM | Append-only, event sourcing |
| **i18n** | Multi-language support | Key-based, lazy loading |
| **Rate Limiter** | API throttling | Token bucket, sliding window |
| **Health Check** | Service health reporting | /health, /ready, /live |

---

## 2. Module Interface Contract

Every module exposes:

```typescript
interface ComposableModule {
  // Initialization
  init(config: ModuleConfig): Promise<void>;
  
  // Health
  healthCheck(): Promise<HealthStatus>;
  
  // Cleanup
  shutdown(): Promise<void>;
}
```

### Communication Patterns
| Pattern | When | Example |
|---------|------|---------|
| Synchronous (REST/gRPC) | Real-time response needed | Auth validation |
| Asynchronous (Events) | Fire-and-forget | Send notification |
| Request-Reply (Queue) | Async with response needed | Payment processing |

---

## 3. Module Dependencies

```
Auth ← (required by all modules)
Payment → Auth, Notification, Audit
Notification → Auth (for user preferences)
File Storage → Auth, Audit
Search → Cache
All → Health Check, Rate Limiter, Audit
```

---

## 4. Integration Guide

### Adding a Module
1. Install module package/copy module code
2. Configure in environment (.env)
3. Initialize in application bootstrap
4. Register health check endpoint
5. Add module-specific tests
6. Update architecture diagram

---

## 5. Testing per Module

| Module | Test Types |
|--------|-----------|
| Auth | Unit (token gen), Integration (DB), E2E (login flow) |
| Payment | Unit (calculation), Integration (provider mock), E2E (checkout) |
| Notification | Unit (template), Integration (provider mock) |
| Search | Unit (query build), Integration (index), E2E (search flow) |

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| AUTH_INTEGRATION_GUIDE.md | Auth module details |
| PAYMENT_INTEGRATION_GUIDE.md | Payment module details |
| NOTIFICATION_SYSTEM_GUIDE.md | Notification module |
| FILE_UPLOAD_STRATEGY.md | File storage module |
| SEARCH_IMPLEMENTATION_GUIDE.md | Search module |
| CACHING_STRATEGY.md | Cache module |
