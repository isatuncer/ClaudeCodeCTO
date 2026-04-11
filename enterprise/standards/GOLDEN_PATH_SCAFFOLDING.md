# Automated Project Scaffolding & Golden Paths

> **Compliance References:**
> - Based on: Spotify Golden Path (2020), Backstage.io
> - Spec: Internal Developer Platform
> - Controls: Template registry
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

Golden paths are pre-paved, opinionated project templates with all standards pre-applied. One command creates a fully configured project with CI/CD, testing, security, and compliance built in.

---

## 1. Scaffolding Templates

### Available Templates

| Template | Stack | Use Case |
|----------|-------|----------|
| `web-api-node` | Node.js + Express + PostgreSQL | REST API service |
| `web-api-python` | Python + Django + PostgreSQL | REST API service |
| `web-api-go` | Go + Gin + PostgreSQL | REST API service |
| `web-api-java` | Java + Spring Boot + PostgreSQL | REST API service |
| `web-frontend-react` | React + Next.js + TypeScript | Web frontend |
| `web-frontend-vue` | Vue + Nuxt + TypeScript | Web frontend |
| `mobile-rn` | React Native + TypeScript | Cross-platform mobile |
| `mobile-flutter` | Flutter + Dart | Cross-platform mobile |
| `microservice` | Language-agnostic | Single-purpose service |
| `cli-tool` | Node.js/Go/Rust | Command-line tool |

---

## 2. What Each Scaffold Includes

### Project Structure
```
generated-project/
├── CLAUDE.md                    # AI-ready project instructions
├── .github/workflows/           # CI/CD pipelines
│   ├── ci.yml
│   ├── security-scan.yml
│   └── deploy.yml
├── .env.example                 # Environment template
├── .gitignore                   # Language-specific ignores
├── docker-compose.yml           # Local development services
├── Dockerfile                   # Production container
├── src/                         # Source code with starter structure
│   ├── config/                  # Configuration management
│   ├── middleware/               # Auth, validation, rate limiting
│   ├── routes/                  # API routes (pre-configured health endpoint)
│   └── tests/                   # Test directory with example tests
├── docs/                        # Documentation
└── scripts/                     # Utility scripts
```

### Pre-Baked Controls
| Control | Implementation |
|---------|---------------|
| Authentication | JWT middleware pre-configured |
| Input validation | Schema validation on all routes |
| Rate limiting | Configurable per endpoint |
| CORS | Environment-based configuration |
| Security headers | Helmet/equivalent pre-configured |
| Audit columns | created_at/by, updated_at/by, deleted_at/by |
| Soft delete | Default on all entities |
| Error handling | Centralized error handler |
| Logging | Structured JSON logging |
| Health endpoint | /health with DB connectivity check |
| Test setup | Framework configured with 80% target |
| Linting | ESLint/Prettier or equivalent |
| Docker | Multi-stage build, non-root user |

---

## 3. Usage

```bash
# Initialize new project from golden path template
bash automation/scripts/init_project.sh my-project --template web-api-node

# This creates:
# 1. Project directory with full scaffold
# 2. Git repository initialized
# 3. .env from .env.example
# 4. Dependencies installed
# 5. Initial commit
# 6. Dev Log DEV-100 created
```

---

## 4. Template Registry

| Field | Description |
|-------|------------|
| Name | Template identifier |
| Version | Semantic version |
| Stack | Technology stack |
| Maintainer | Owner of template |
| Last Updated | Date of last update |
| Standards Applied | Which governance standards are pre-baked |

---

## 5. Customization Points

Templates are opinionated but extensible:

| Layer | Default | Customizable |
|-------|---------|-------------|
| Database | PostgreSQL | MySQL, MongoDB |
| Auth | JWT | OAuth 2.0, Session |
| ORM | Prisma (Node), Django ORM | TypeORM, Sequelize |
| Testing | Jest (Node), pytest | Vitest, Mocha |
| CI/CD | GitHub Actions | GitLab CI, Jenkins |
| Container | Docker | Podman |
| Monitoring | OpenTelemetry | Datadog, New Relic |

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| DEFINITION_OF_DONE.md | Templates enforce DoD from day 1 |
| ISO 27001 controls | Pre-baked audit columns, auth, logging |
| PERFORMANCE_BUDGET.md | Performance targets in CI |
| UNIFIED_SECURITY_PIPELINE.md | Security scanning in CI |
| SBOM_PIPELINE.md | SBOM generation in CI |
