---
description: "Create an enterprise project document from template. Generates versioned MD with metadata, optionally exports to PDF/DOCX. Usage: /doc-create SRS or /doc-create 'Test Plan'"
---

# Document Create

Create a new enterprise project document using templates and standards.

## Arguments

`$ARGUMENTS` is the document type. Examples:
- `/doc-create SRS` — Software Requirements Specification
- `/doc-create ADR` — Architecture Decision Record
- `/doc-create "Test Plan"` — Master Test Plan
- `/doc-create BRD` — Business Requirements Document
- `/doc-create HLD` — High Level Design
- `/doc-create "Threat Model"` — Threat Modeling Report

## Document Type Mapping

| Short Code | Full Name | Template Location |
|------------|-----------|-------------------|
| SRS | Software Requirements Specification | enterprise/templates/requirements/SRS_TEMPLATE.md |
| PRD | Product Requirements Document | enterprise/templates/requirements/PRD_TEMPLATE.md |
| BRD | Business Requirements Document | enterprise/templates/requirements/BRD_TEMPLATE.md |
| FRD | Functional Requirements Document | enterprise/templates/requirements/FRD_TEMPLATE.md |
| NFR | Non-Functional Requirements | enterprise/templates/requirements/NFR_TEMPLATE.md |
| RTM | Requirements Traceability Matrix | enterprise/templates/requirements/RTM_TEMPLATE.md |
| SAD | Software Architecture Document | enterprise/templates/architecture/SAD_TEMPLATE.md |
| SDD | System Design Document | enterprise/templates/architecture/SDD_TEMPLATE.md |
| HLD | High Level Design | enterprise/templates/architecture/HLD_TEMPLATE.md |
| LLD | Low Level Design | enterprise/templates/architecture/LLD_TEMPLATE.md |
| ADR | Architecture Decision Record | enterprise/templates/architecture/ADR_TEMPLATE.md |
| RFC | Request for Comments | enterprise/templates/architecture/RFC_TEMPLATE.md |
| API | API Specification | enterprise/templates/api/API_SPEC_TEMPLATE.md |
| DB | Database Design | enterprise/templates/database/DB_DESIGN_TEMPLATE.md |
| TP | Test Plan | enterprise/templates/testing/TEST_PLAN_TEMPLATE.md |
| TC | Test Cases | enterprise/templates/testing/TEST_CASE_TEMPLATE.md |
| UAT | User Acceptance Test Plan | enterprise/templates/testing/UAT_PLAN_TEMPLATE.md |
| TM | Threat Model | enterprise/templates/security/THREAT_MODEL_TEMPLATE.md |
| SA | Security Assessment | enterprise/templates/security/SECURITY_ASSESSMENT_TEMPLATE.md |
| IRP | Incident Response Plan | enterprise/templates/security/INCIDENT_RESPONSE_TEMPLATE.md |
| DRP | Disaster Recovery Plan | enterprise/templates/operations/DRP_TEMPLATE.md |
| PM | Postmortem Report | enterprise/templates/operations/POSTMORTEM_TEMPLATE.md |
| UG | User Guide | enterprise/templates/user-docs/USER_GUIDE_TEMPLATE.md |
| DG | Developer Guide | enterprise/templates/user-docs/DEVELOPER_GUIDE_TEMPLATE.md |
| PC | Project Charter | enterprise/templates/project-management/PROJECT_CHARTER_TEMPLATE.md |
| SP | Sprint Plan | enterprise/templates/project-management/SPRINT_TEMPLATE.md |
| SR | Status Report | enterprise/templates/project-management/STATUS_REPORT_TEMPLATE.md |
| RN | Release Notes | enterprise/templates/project-management/RELEASE_NOTES_TEMPLATE.md |

## Steps

1. **Parse document type** from `$ARGUMENTS`

2. **Find the template** in `enterprise/templates/`. If the template exists, read it. If not, generate from the standard format for that document type.

3. **Gather project context** — ask the user:
   - Project name
   - Brief description
   - Technology stack (if relevant to the doc type)
   - Any specific requirements for this document

4. **Generate the document** using the `doc-generator` skill:
   - Fill the template with project-specific content
   - Add metadata header (title, version, date, status)
   - Embed Mermaid diagrams where applicable
   - Cross-reference related documents

5. **Determine version number**:
   - Check `docs/` for existing versions of this document type
   - If new → v1.0
   - If exists → increment minor version (v1.0 → v1.1)

6. **Save** to `docs/{version}/{category}/{DOC_TYPE}_{version}.md`

7. **Ask about export**: "Export to PDF/DOCX? [y/N]"
   - If yes → run `/doc-export` on the created file

8. **Report** the created document path and suggest related documents to create next.

## After Creation — Suggest Next Documents

Based on the document just created, suggest what should come next:
- After SRS → suggest HLD, ADR, Test Plan
- After HLD → suggest LLD, SDD, API Spec
- After Test Plan → suggest Test Cases, UAT Plan
- After ADR → suggest RFC, Blueprint
- After Project Charter → suggest BRD, WBS, Risk Register
