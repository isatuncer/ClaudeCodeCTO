# Diagram Catalog

## System
Each diagram is stored as a **separate `.mmd` (Mermaid) file**.
Users edit diagrams in a web editor, approve them, then they are implemented.

---

## Web Editors

| Tool | URL | Format | Usage |
|------|-----|--------|-------|
| **Mermaid Live** | https://mermaid.live | `.mmd` | All diagrams (primary) |
| **Draw.io** | https://app.diagrams.net | `.drawio` | Freeform, complex layouts |
| **Excalidraw** | https://excalidraw.com | `.excalidraw` | Wireframes, hand-drawn style |
| **PlantUML** | https://www.plantuml.com/plantuml | `.puml` | UML diagrams |
| **dbdiagram.io** | https://dbdiagram.io | `.dbml` | ER diagrams |

### How to Use
1. Open the `.mmd` file
2. Copy the contents
3. Paste at https://mermaid.live
4. Edit visually
5. Copy the result, paste back into the file

---

## Approval Flow

```
DRAFT -> REVIEW -> APPROVED -> IMPLEMENTED
  |                   |
  +--- REVISION <-----+  (if revision needed)
```

| Status | Meaning | Who Does It |
|--------|---------|------------|
| DRAFT | Initial draft created | CTO (Claude) |
| REVIEW | Presented to user, awaiting feedback | User reviews |
| REVISION | User requested changes | CTO revises |
| APPROVED | User approved | User says "approved" |
| IMPLEMENTED | Code/infrastructure written according to this diagram | CTO implements |

### RULE: Code CANNOT be written until APPROVED.
Phase cannot proceed until diagrams are approved.

---

## Diagram List

### Phase 1: Analysis
| ID | File | Type | Status |
|----|------|------|--------|
| DG-101 | `faz1_analysis/DG-101_use_case_diagram.mmd` | Use Case | DRAFT |
| DG-102 | `faz1_analysis/DG-102_business_process_flow.mmd` | BPMN Flow | DRAFT |
| DG-103 | `faz1_analysis/DG-103_user_journey_map.mmd` | Journey Map | DRAFT |
| DG-104 | `faz1_analysis/DG-104_data_flow_overview.mmd` | Data Flow | DRAFT |

### Phase 2: Architecture
| ID | File | Type | Status |
|----|------|------|--------|
| DG-201 | `faz2_architecture/DG-201_system_context_c4l1.mmd` | C4 Level 1 | DRAFT |
| DG-202 | `faz2_architecture/DG-202_container_diagram_c4l2.mmd` | C4 Level 2 | DRAFT |
| DG-203 | `faz2_architecture/DG-203_component_diagram_c4l3.mmd` | C4 Level 3 | DRAFT |
| DG-204 | `faz2_architecture/DG-204_deployment_diagram.mmd` | Deployment | DRAFT |
| DG-205 | `faz2_architecture/DG-205_security_architecture.mmd` | Security | DRAFT |
| DG-206 | `faz2_architecture/DG-206_tech_stack_overview.mmd` | Tech Stack | DRAFT |

### Phase 3: Database
| ID | File | Type | Status |
|----|------|------|--------|
| DG-301 | `faz3_database/DG-301_er_diagram.mmd` | ER Diagram | DRAFT |
| DG-302 | `faz3_database/DG-302_data_flow_detail.mmd` | Data Flow | DRAFT |
| DG-303 | `faz3_database/DG-303_migration_flow.mmd` | Migration | DRAFT |

### Phase 4: API
| ID | File | Type | Status |
|----|------|------|--------|
| DG-401 | `faz4_api/DG-401_auth_sequence.mmd` | Sequence | DRAFT |
| DG-402 | `faz4_api/DG-402_crud_sequence.mmd` | Sequence | DRAFT |
| DG-403 | `faz4_api/DG-403_payment_sequence.mmd` | Sequence | DRAFT |
| DG-404 | `faz4_api/DG-404_notification_sequence.mmd` | Sequence | DRAFT |
| DG-405 | `faz4_api/DG-405_file_upload_sequence.mmd` | Sequence | DRAFT |
| DG-406 | `faz4_api/DG-406_api_overview.mmd` | API Map | DRAFT |

### Phase 5: Infrastructure
| ID | File | Type | Status |
|----|------|------|--------|
| DG-501 | `faz5_infrastructure/DG-501_infra_topology.mmd` | Infra | DRAFT |
| DG-502 | `faz5_infrastructure/DG-502_cicd_pipeline.mmd` | CI/CD | DRAFT |
| DG-503 | `faz5_infrastructure/DG-503_network_security.mmd` | Network | DRAFT |
| DG-504 | `faz5_infrastructure/DG-504_monitoring_architecture.mmd` | Monitoring | DRAFT |

### Phase 6: Development
| ID | File | Type | Status |
|----|------|------|--------|
| DG-601 | `faz6_development/DG-601_module_dependency.mmd` | Dependency | DRAFT |
| DG-602 | `faz6_development/DG-602_state_diagrams.mmd` | State | DRAFT |
| DG-603 | `faz6_development/DG-603_class_diagram.mmd` | Class | DRAFT |
| DG-604 | `faz6_development/DG-604_frontend_component_tree.mmd` | Component | DRAFT |

### Phase 7: QA
| ID | File | Type | Status |
|----|------|------|--------|
| DG-701 | `faz7_qa/DG-701_test_strategy_flow.mmd` | Test Flow | DRAFT |
| DG-702 | `faz7_qa/DG-702_e2e_test_flow.mmd` | E2E Flow | DRAFT |
| DG-703 | `faz7_qa/DG-703_release_flow.mmd` | Release | DRAFT |

---

## Total: 27 diagrams

### When the project starts
1. Relevant diagrams are created as DRAFT at the start of each phase
2. Presented to user (with mermaid.live link)
3. User edits/approves
4. Code is written according to APPROVED diagrams
5. Marked as IMPLEMENTED when implementation is complete
