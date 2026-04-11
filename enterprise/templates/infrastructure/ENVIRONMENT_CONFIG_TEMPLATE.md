# Environment Configuration Document

## Document Information
| Field | Value |
|-------|-------|
| Project Name | [PROJECT_NAME] |
| Version | 1.0 |
| Author | DevOps & Infra Dept. |
| Date | [DATE] |
| Related Blueprint | SAD-[NUMBER] |

---

## 1. Environment Overview

| Environment | Purpose | URL | Branch |
|-------------|---------|-----|--------|
| Development | Developer local | localhost:3000 | feature/* |
| Staging | Test and approval | staging.[domain].com | develop |
| Production | Live environment | [domain].com | main |

---

## 2. Environment Variables

### 2.1 All Environments (Common)
| Variable | Description | Required | Example |
|----------|-----------|----------|---------|
| NODE_ENV / APP_ENV | Environment name | Yes | development/staging/production |
| PORT | Application port | Yes | 3000 |
| LOG_LEVEL | Log level | Yes | debug/info/warn/error |

### 2.2 Database
| Variable | Description | Required | Example |
|----------|-----------|----------|---------|
| DATABASE_URL | DB connection URL | Yes | postgresql://user:pass@host:5432/db |
| DB_POOL_MIN | Min connection | No | 2 |
| DB_POOL_MAX | Max connection | No | 10 |
| DB_SSL | SSL enabled | No | true |

### 2.3 Cache
| Variable | Description | Required | Example |
|----------|-----------|----------|---------|
| REDIS_URL | Redis connection URL | Yes | redis://host:6379 |
| REDIS_PASSWORD | Redis password | Production: Yes | [secret] |

### 2.4 Authentication
| Variable | Description | Required | Example |
|----------|-----------|----------|---------|
| JWT_SECRET | JWT signing key | Yes | [secret - min 256 bit] |
| JWT_EXPIRY | Access token duration | Yes | 15m |
| JWT_REFRESH_EXPIRY | Refresh token duration | Yes | 7d |

### 2.5 External Services
| Variable | Description | Required | Example |
|----------|-----------|----------|---------|
| [SERVICE]_API_KEY | API key | Yes | [secret] |
| [SERVICE]_API_URL | API base URL | Yes | https://api.service.com |
| SMTP_HOST | Email server | Yes | smtp.provider.com |
| SMTP_USER | Email user | Yes | [email] |
| SMTP_PASS | Email password | Yes | [secret] |

### 2.6 Storage
| Variable | Description | Required | Example |
|----------|-----------|----------|---------|
| STORAGE_TYPE | Storage type | Yes | s3/local/gcs |
| STORAGE_BUCKET | Bucket name | Yes | [project]-assets |
| AWS_ACCESS_KEY_ID | AWS key | Yes (S3) | [secret] |
| AWS_SECRET_ACCESS_KEY | AWS secret | Yes (S3) | [secret] |
| AWS_REGION | AWS region | Yes (S3) | eu-west-1 |

---

## 3. Environment-Specific Configurations

### 3.1 Development
```env
NODE_ENV=development
PORT=3000
LOG_LEVEL=debug
DATABASE_URL=postgresql://dev:dev@localhost:5432/project_dev
REDIS_URL=redis://localhost:6379
JWT_SECRET=dev-secret-key-not-for-production
JWT_EXPIRY=1h
STORAGE_TYPE=local
```

### 3.2 Staging
```env
NODE_ENV=staging
PORT=3000
LOG_LEVEL=info
DATABASE_URL=postgresql://staging:***@staging-db:5432/project_staging
REDIS_URL=redis://staging-redis:6379
JWT_SECRET=*** (Secret Manager)
JWT_EXPIRY=15m
STORAGE_TYPE=s3
```

### 3.3 Production
```env
NODE_ENV=production
PORT=3000
LOG_LEVEL=warn
DATABASE_URL=*** (Secret Manager)
REDIS_URL=*** (Secret Manager)
JWT_SECRET=*** (Secret Manager)
JWT_EXPIRY=15m
STORAGE_TYPE=s3
```

---

## 4. Docker Configuration

### 4.1 Docker Compose (Development)
```yaml
# docker-compose.yml reference structure
services:
  app:
    build: .
    ports: ["3000:3000"]
    env_file: .env.development
    depends_on: [db, redis]
  db:
    image: postgres:16
    ports: ["5432:5432"]
    volumes: [postgres_data:/var/lib/postgresql/data]
  redis:
    image: redis:7-alpine
    ports: ["6379:6379"]
```

### 4.2 Dockerfile
```dockerfile
# Multi-stage build reference
FROM node:20-alpine AS builder
# Build stage
FROM node:20-alpine AS runner
# Production stage
```

---

## 5. Secret Management

### 5.1 Secret Storage
| Environment | Method | Tool |
|-------------|--------|------|
| Development | .env file (in gitignore) | dotenv |
| Staging | Secret Manager | AWS SSM / Vault / GCP SM |
| Production | Secret Manager | AWS SSM / Vault / GCP SM |

### 5.2 Secret Rotation
| Secret | Rotation Period | Automatic |
|--------|----------------|----------|
| JWT Secret | 90 days | No |
| DB Password | 90 days | Yes |
| API Keys | 180 days | No |

### 5.3 .env.example
> A `.env.example` file is MANDATORY in the project. It contains example/placeholder values instead of real values.

---

## 6. Resource Limits

| Resource | Development | Staging | Production |
|----------|-----------|---------|-----------|
| CPU | 0.5 core | 1 core | 2+ core |
| Memory | 512 MB | 1 GB | 2+ GB |
| Disk | 1 GB | 10 GB | 50+ GB |
| DB Storage | 1 GB | 10 GB | 100+ GB |
| Max File Upload | 5 MB | 10 MB | 10 MB |

---

## 7. Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| DevOps Lead | VSH | [DATE] | Pending |
| Security Lead | VSH | [DATE] | Pending |
