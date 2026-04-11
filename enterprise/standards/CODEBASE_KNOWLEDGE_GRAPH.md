# Knowledge Graph for Codebase Understanding

> **Compliance References:**
> - Based on: CodeScene (Adam Tornhill 2015), SciTools Understand
> - Spec: Behavioral code analysis
> - Controls: Dependency graph, bus factor
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

A graph of code relationships enabling impact analysis, onboarding, AI context retrieval, and bus factor analysis.

---

## 1. Graph Model

### Nodes
| Type | Examples |
|------|---------|
| Module | `src/auth/`, `src/payments/` |
| File | `auth/service.ts`, `auth/controller.ts` |
| Function | `validateToken()`, `createUser()` |
| API Endpoint | `POST /api/users`, `GET /api/products` |
| Test | `auth.test.ts`, `payment.e2e.ts` |
| Config | `.env`, `docker-compose.yml` |
| Database Table | `users`, `orders`, `audit_log` |

### Edges
| Relationship | Meaning |
|-------------|---------|
| `depends-on` | Module A imports Module B |
| `tested-by` | Function covered by test |
| `owned-by` | Module assigned to team/person |
| `changed-with` | Files that change together (co-change) |
| `calls` | Function A calls Function B |
| `reads/writes` | Function reads/writes DB table |
| `exposes` | Module exposes API endpoint |

---

## 2. Use Cases

### Impact Analysis
```
Q: "What breaks if I change the User model?"
Graph: User model → [depends-on] → Auth, Orders, Profile, Notifications
       User model → [tested-by] → user.test, auth.test, order.test
Answer: 4 modules affected, 3 test files need review
```

### Bus Factor
```
Q: "Who knows the payment module?"
Graph: Payment → [changed-by] → Alice (85%), Bob (10%), Carol (5%)
Answer: Bus factor = 1 (Alice). Knowledge transfer needed.
```

### Onboarding
```
Q: "How does authentication work?"
Graph: Login endpoint → Auth controller → Auth service → JWT util → User repository → DB
Answer: Visual flow from entry point to database
```

### AI Agent Context
```
Q: "What context does code-reviewer need for a payments PR?"
Graph: payments/ → depends-on → auth/, database/, notification/
       payments/ → tested-by → payment.test, payment.e2e
Answer: Load these files as context for the agent
```

---

## 3. Building the Graph

| Source | Data | Tool |
|--------|------|------|
| Static analysis | Import/export relationships | dependency-cruiser, madge |
| Git history | Co-change patterns, ownership | git log, git-of-theseus |
| Test mapping | Test-to-code relationships | Coverage reports |
| Runtime | API call chains | OpenTelemetry traces |
| Schema | DB table relationships | ER diagram, migrations |

---

## 4. Tools

| Tool | Language | What It Builds |
|------|----------|---------------|
| dependency-cruiser | JS/TS | Module dependency graph |
| madge | JS/TS | Circular dependency detection |
| pydeps | Python | Module dependency graph |
| go-callvis | Go | Call graph visualization |
| cargo-depgraph | Rust | Crate dependency graph |
| Understand | Multi | Full code knowledge base |

---

## 5. Integration with VSH

| Standard | Connection |
|----------|-----------|
| REQUIREMENTS_TRACEABILITY_MATRIX.md | Requirement → code mapping |
| DIAGRAM_TEST_MAPPING.md | Diagram → test → code links |
| AI_TECH_DEBT_HEATMAP.md | Hotspot analysis from graph |
| ARCHITECTURE_FITNESS_FUNCTIONS.md | Dependency rule enforcement |
| CODE_HEALTH_GUARDRAILS.md | Coupling metrics from graph |
