# Internal Developer Platform (IDP) & Self-Service Portal

> **Compliance References:**
> - Based on: Backstage.io (Spotify 2020), CNCF IDP Whitepaper
> - Spec: Internal Developer Platform
> - Controls: Service catalog, scorecards
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

An IDP provides a unified portal for service catalog, documentation, templates, deployment status, and scorecards. Based on the Backstage model.

---

## 1. Core Components

| Component | Purpose | Implementation |
|-----------|---------|---------------|
| **Service Catalog** | List all services with ownership | YAML registry |
| **Software Templates** | Create-from-template scaffolding | Golden path templates |
| **Tech Docs** | Aggregated documentation | Markdown docs from repos |
| **Deployment Status** | Per-service deployment info | CI/CD integration |
| **Scorecards** | Health, security, compliance scores | Automated checks |
| **API Docs** | OpenAPI documentation hub | Swagger/Redoc |

---

## 2. Service Catalog Entry

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: user-api
  description: User management REST API
  tags: [backend, api, node]
  annotations:
    github.com/project-slug: org/user-api
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: production
  owner: team-backend
  system: user-management
  providesApis: [user-api]
  dependsOn:
    - resource:postgres-main
    - component:auth-service
```

---

## 3. Scorecards

### Service Health Scorecard
| Dimension | Weight | Check | Source |
|-----------|--------|-------|--------|
| Test Coverage | 20% | > 80% | CI reports |
| Security Scan | 20% | No critical findings | Security pipeline |
| Documentation | 15% | README, API docs exist | Repo check |
| Deployment | 15% | Automated CI/CD | Pipeline check |
| Monitoring | 15% | Dashboards, alerts exist | Monitoring check |
| Dependencies | 15% | No critical CVEs | SCA report |

### Score = Weighted sum → A (90+) / B (75+) / C (60+) / D (40+) / F (<40)

---

## 4. Golden Path Templates

Available via "Create" button in portal:

| Template | Creates |
|----------|---------|
| Web API (Node) | Express + PostgreSQL + Docker + CI/CD |
| Web API (Python) | Django + PostgreSQL + Docker + CI/CD |
| Web Frontend | Next.js + TypeScript + CI/CD |
| Microservice | Minimal service with health + metrics |

Each template comes pre-configured with all VSH standards.

---

## 5. Team Topology View

```
Platform Team
  └── Shared Infrastructure
       ├── Auth Service (Team: Identity)
       ├── Notification Service (Team: Comms)
       └── Storage Service (Team: Platform)

Stream-Aligned Teams
  ├── Team Payments → Payment Service, Invoice Service
  ├── Team Users → User API, Profile Service
  └── Team Search → Search Service, Index Service
```

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| GOLDEN_PATH_SCAFFOLDING.md | Template source |
| CODE_HEALTH_GUARDRAILS.md | Scorecard data |
| UNIFIED_SECURITY_PIPELINE.md | Security scorecard |
| API_STYLE_GUIDE.md | API documentation |
| COMMUNICATION_PLAN.md | Team ownership |
