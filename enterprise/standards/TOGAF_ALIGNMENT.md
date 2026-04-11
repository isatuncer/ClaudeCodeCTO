# TOGAF Enterprise Architecture Alignment

> **Compliance References:**
> - Based on: TOGAF 10, The Open Group
> - Spec: Architecture Development Method (ADM)
> - Controls: Phases A-H mapping
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

TOGAF (The Open Group Architecture Framework) is used by 80% of Fortune 500. This guide maps VSH phases to TOGAF ADM for enterprise alignment.

---

## 1. TOGAF ADM Phase Mapping

| TOGAF Phase | VSH Phase | Artifacts |
|-------------|-----------|-----------|
| **Preliminary** | Phase 0: Discovery | Technology preferences, scope |
| **A: Architecture Vision** | Phase 1: Analysis | PRD, requirements, use cases |
| **B: Business Architecture** | Phase 1: Analysis | Business process flows, journey maps |
| **C: Information Systems** | Phase 2: Blueprint + Phase 3: DB | System design, ER diagrams |
| **D: Technology Architecture** | Phase 2: Blueprint + Phase 5: Infra | Deployment, network, tech stack |
| **E: Opportunities & Solutions** | Phase 4: API Spec | API contracts, integration specs |
| **F: Migration Planning** | Phase 5: Infrastructure | Deployment runbook, migration plan |
| **G: Implementation Governance** | Phase 6: Development | Sprint execution, quality gates |
| **H: Architecture Change Mgmt** | Change Impact Analysis | Impact assessment, ADR updates |

---

## 2. Architecture Principles

| Principle | VSH Implementation |
|-----------|-------------------|
| Business continuity | Disaster recovery, self-healing |
| Common use | Composable architecture, reusable modules |
| Compliance | ISO 27001, KVKK/GDPR, audit trail |
| Data security | Zero trust, encryption, PII masking |
| Interoperability | API standards, contract testing |
| Technology independence | Composable modules, abstraction layers |
| Ease of use | Golden path scaffolding, developer portal |

---

## 3. Architecture Repository

VSH's governance/ directory serves as the architecture repository:

| TOGAF Component | VSH Location |
|----------------|-------------|
| Architecture metamodel | CLAUDE.md (operating model) |
| Architecture landscape | governance/diagrams/ (30 Mermaid diagrams) |
| Standards library | governance/standards/ (70+ standards) |
| Reference library | governance/templates/ (38 templates) |
| Governance log | governance/decisions/ (ADRs) |
| Requirements repository | governance/traceability/ (RTM) |

---

## 4. Governance Alignment

| TOGAF Governance | VSH Equivalent |
|-----------------|---------------|
| Architecture Board | CTO role (Claude) |
| Compliance Review | Gate system (5 gates) |
| Dispensation Process | Change Impact Analysis |
| Architecture Contract | SLA templates, API contracts |
| Architecture Compliance Review | Sprint review + quality gate |

---

## 5. When to Apply TOGAF

| Scenario | TOGAF Depth | Rationale |
|----------|------------|-----------|
| Enterprise/large org | Full ADM | Multiple teams, complex systems |
| Mid-size product | Phases A-D + G | Architecture + governance |
| Startup/MVP | Skip TOGAF | Agility over formality |
| Regulated industry | Full ADM + compliance | Audit requirements |

---

## 6. Enterprise Continuum

```
Foundation ← Common Systems ← Industry ← Organization-Specific
   │              │              │              │
   └── TCP/IP     └── ERP        └── Banking    └── Our Product
       HTTP           CRM            Healthcare      Custom Logic
       REST           Auth            Insurance
```

VSH composable modules fit in the "Common Systems" and "Organization-Specific" layers.

---

## 7. Integration with VSH

| Standard | Connection |
|----------|-----------|
| APPROVAL_PIPELINE.md | Gate system ↔ TOGAF governance |
| governance/decisions/ | ADRs ↔ Architecture governance log |
| governance/diagrams/ | Architecture landscape |
| COMPOSABLE_ARCHITECTURE.md | Building blocks catalog |
| VALUE_STREAM_MANAGEMENT.md | Business architecture flow |
