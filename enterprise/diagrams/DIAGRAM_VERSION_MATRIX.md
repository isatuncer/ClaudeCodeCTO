# Diagram Version Matrix

## Purpose
Tracks when each diagram was created, changed, and why across software versions.

---

## 1. System

### Active Work
`governance/diagrams/faz[N]_[name]/DG-XXX.mmd` -> Always the LATEST version here

### Version Archive
`governance/diagrams/versions/vX.Y.Z/` -> Snapshot from that version (immutable, frozen)

### Flow
```
1. Diagram is created/updated (under faz[N]/ - ACTIVE)
2. User approves (APPROVED)
3. When release is made:
   -> snapshot_version.sh runs
   -> All APPROVED diagrams are COPIED under versions/vX.Y.Z/
   -> DIAGRAM_CHANGELOG_vX.Y.Z.md is written
   -> This matrix is updated
4. If changes occur in the next version:
   -> Active file is updated
   -> New snapshot is taken in new release
   -> DIFF is visible: v1.0 vs v1.1 difference
```

---

## 2. Version Matrix

| Diagram ID | Name | v1.0.0 | v1.1.0 | v2.0.0 | Current Status |
|------------|------|--------|--------|--------|---------------|
| DG-101 | Use Case | CREATED | - | UPDATED | IMPLEMENTED |
| DG-102 | Business Flow | CREATED | - | - | IMPLEMENTED |
| DG-103 | User Journey | CREATED | UPDATED | - | IMPLEMENTED |
| DG-201 | System Context (C4 L1) | CREATED | - | UPDATED | IMPLEMENTED |
| DG-202 | Container (C4 L2) | CREATED | - | UPDATED | IMPLEMENTED |
| DG-203 | Component (C4 L3) | CREATED | UPDATED | UPDATED | IMPLEMENTED |
| DG-301 | ER Diagram | CREATED | UPDATED | UPDATED | IMPLEMENTED |
| DG-401 | Auth Sequence | CREATED | - | UPDATED | IMPLEMENTED |
| DG-402 | CRUD Sequence | CREATED | - | - | IMPLEMENTED |
| ... | ... | ... | ... | ... | ... |

> **`-`** = No change in this version (previous version applies)
> **CREATED** = First created in this version
> **UPDATED** = Different from previous version

---

## 3. Diagram Change Reasons

| Reason Code | Description | Example |
|------------|-------------|---------|
| NEW | New diagram | New module added |
| REQ_CHANGE | Requirement changed | Customer requested new feature |
| BUG_FIX | Bug fix | Incorrect relationship/flow |
| REFACTOR | Architecture restructuring | Monolith -> microservice |
| SECURITY | Security change | New auth flow |
| PERF | Performance optimization | Cache layer added |
| DEPRECATION | Removal | Old API version deleted |

---

## 4. Version Archive Structure

```
governance/diagrams/
├── faz1_analysis/              # ACTIVE - latest version
│   ├── DG-101_use_case.mmd
│   ├── DG-102_business_flow.mmd
│   └── ...
├── faz2_architecture/          # ACTIVE
├── faz3_database/              # ACTIVE
├── faz4_api/                   # ACTIVE
├── faz5_infrastructure/        # ACTIVE
├── faz6_development/           # ACTIVE
├── faz7_qa/                    # ACTIVE
│
├── versions/                   # FROZEN ARCHIVE
│   ├── v1.0.0/
│   │   ├── DG-101_use_case.mmd
│   │   ├── DG-201_system_context.mmd
│   │   ├── DG-301_er_diagram.mmd
│   │   ├── DG-401_auth_sequence.mmd
│   │   └── DIAGRAM_CHANGELOG_v1.0.0.md
│   ├── v1.1.0/
│   │   ├── DG-103_user_journey.mmd      # CHANGED
│   │   ├── DG-203_component.mmd          # CHANGED
│   │   ├── DG-301_er_diagram.mmd         # CHANGED (new table)
│   │   └── DIAGRAM_CHANGELOG_v1.1.0.md
│   └── v2.0.0/
│       └── ...
│
├── DIAGRAM_CATALOG.md          # General catalog
└── DIAGRAM_VERSION_MATRIX.md   # This file
```

### RULE: Files under versions/ are NEVER MODIFIED (frozen snapshot)

---

## 5. Version-Based Diagram Changelog Template

For each version `DIAGRAM_CHANGELOG_vX.Y.Z.md`:

```markdown
# Diagram Change Log - vX.Y.Z

| DG ID | Change | Reason | Previous | Detail |
|-------|--------|--------|----------|--------|
| DG-301 | UPDATED | REQ_CHANGE | v1.0.0 | "notifications" table added |
| DG-203 | UPDATED | REFACTOR | v1.0.0 | Notification Module separated |
| DG-407 | NEW | NEW | - | New: Notification Sequence |
| DG-105 | REMOVED | DEPRECATION | v1.0.0 | Old data flow diagram |
```

---

## 6. Diff Viewing

To see diagram differences between two versions:

```bash
# Text diff
diff governance/diagrams/versions/v1.0.0/DG-301_er_diagram.mmd \
     governance/diagrams/versions/v1.1.0/DG-301_er_diagram.mmd

# Visual diff: Open both versions in mermaid.live and compare
```

---

## Related Documents
- `governance/diagrams/DIAGRAM_CATALOG.md`
- `governance/standards/DIAGRAM_DRIVEN_TESTING.md`
- `governance/traceability/DIAGRAM_TEST_MAPPING.md`
- `automation/scripts/snapshot_version.sh`
