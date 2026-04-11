# Definition of Done (DoD)

> **Compliance References:**
> - Based on: Scrum Guide 2020 (Schwaber & Sutherland)
> - Spec: Increment transparency
> - Controls: DoD checklist
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

> When is a work item considered "done"? These standards are universal.

---

## Requirement Level DoD
- [x] Extracted from source document (SRC ref exists)
- [x] FR/NFR/BR ID assigned
- [x] Priority determined (MoSCoW)
- [x] Acceptance criteria written
- [x] Added to RTM
- [x] Approved by the user

## Design Level DoD
- [x] Incorporated into blueprint
- [x] Diagram created (as .mmd file, governance/diagrams/)
- [x] Diagram in APPROVED status (user approved)
- [x] ADR written (for important decisions)
- [x] DB schema defined (if DB is required)
- [x] API spec written (if API is required)
- [x] ISO 27001 controls checked
- [x] Approved by the user

## Code Level DoD
- [x] Source diagram(s) in APPROVED status (DG-XXX)
- [x] Test cases derived from diagram (per DIAGRAM_DRIVEN_TESTING.md)
- [x] Test cases linked to diagram ID (TC -> DG-XXX)
- [x] Tests written FIRST (RED) - TDD
- [x] Code written and compiles/builds (GREEN)
- [x] All diagram elements covered by tests (100%)
- [x] Unit tests written and passing
- [x] Test coverage >= 80%
- [x] Zero lint errors
- [x] NO hardcoded secrets/credentials
- [x] Input validation present (at boundaries)
- [x] Error handling present
- [x] Compliant with logging standards
- [x] SQL injection / XSS / CSRF protections in place
- [x] Audit columns present (created_at/by, etc.)
- [x] Code review completed
- [x] RTM updated (code reference added)
- [x] Dev Log written (DEV-XXX)

## Sprint Level DoD
- [x] All sprint backlog items in "Done" status
- [x] Integration tests passing
- [x] Sprint retrospective written
- [x] project_status.md updated
- [x] Demo/summary presented to the user

## Release Level DoD
- [x] All tests passing (unit + integration + e2e)
- [x] Security scan clean
- [x] Within performance budget
- [x] ISO 27001 checklist completed
- [x] Deployment documentation ready
- [x] Rollback procedure tested
- [x] User approval obtained
- [x] Version number assigned
- [x] CHANGELOG written
