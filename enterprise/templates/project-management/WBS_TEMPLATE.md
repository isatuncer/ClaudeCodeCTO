---
title: "Work Breakdown Structure"
document-id: "WBS-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "PMBOK 7th Edition — Project Management Body of Knowledge"
---

# Work Breakdown Structure

## Table of Contents
1. [Document Information](#1-document-information)
2. [Project Overview](#2-project-overview)
3. [WBS Dictionary](#3-wbs-dictionary)
4. [WBS Hierarchy](#4-wbs-hierarchy)
5. [Effort Estimates](#5-effort-estimates)
6. [Dependencies](#6-dependencies)
7. [Approval](#7-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| Project Manager | [FILL] |
| Prepared By | [FILL] |
| Decomposition Level | [FILL — e.g., 4 levels] |
| Estimation Method | [FILL — e.g., Expert judgment, Three-point, Planning poker] |

## 2. Project Overview

### 2.1 Project Objective
[FILL — Concise statement of what the project delivers.]

### 2.2 Major Deliverables
| Deliverable | Description | Owner |
|------------|-------------|-------|
| [FILL] | [FILL] | [FILL] |

## 3. WBS Dictionary

| WBS ID | Work Package | Description | Deliverable | Acceptance Criteria | Owner |
|--------|-------------|-------------|-------------|-------------------|-------|
| 1.1.1 | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |
| 1.1.2 | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |
| 1.2.1 | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

## 4. WBS Hierarchy

```
1.0 [PROJECT_NAME]
├── 1.1 [PHASE_1 — e.g., Initiation]
│   ├── 1.1.1 [FILL — e.g., Project charter]
│   ├── 1.1.2 [FILL — e.g., Stakeholder analysis]
│   └── 1.1.3 [FILL — e.g., Kickoff meeting]
├── 1.2 [PHASE_2 — e.g., Planning]
│   ├── 1.2.1 [FILL — e.g., Requirements gathering]
│   ├── 1.2.2 [FILL — e.g., Architecture design]
│   └── 1.2.3 [FILL — e.g., Sprint planning]
├── 1.3 [PHASE_3 — e.g., Execution]
│   ├── 1.3.1 [FILL — e.g., Sprint 1]
│   ├── 1.3.2 [FILL — e.g., Sprint 2]
│   └── 1.3.3 [FILL — e.g., Sprint N]
├── 1.4 [PHASE_4 — e.g., Testing]
│   ├── 1.4.1 [FILL — e.g., Integration testing]
│   ├── 1.4.2 [FILL — e.g., UAT]
│   └── 1.4.3 [FILL — e.g., Performance testing]
└── 1.5 [PHASE_5 — e.g., Deployment & Closure]
    ├── 1.5.1 [FILL — e.g., Production deployment]
    ├── 1.5.2 [FILL — e.g., Training]
    └── 1.5.3 [FILL — e.g., Project closure]
```

## 5. Effort Estimates

| WBS ID | Work Package | Optimistic | Most Likely | Pessimistic | Expected (PERT) | Assigned To |
|--------|-------------|-----------|------------|------------|----------------|-------------|
| 1.1.1 | [FILL] | [FILL] d | [FILL] d | [FILL] d | [FILL] d | [FILL] |
| 1.1.2 | [FILL] | [FILL] d | [FILL] d | [FILL] d | [FILL] d | [FILL] |

### 5.1 Summary
| Phase | Total Effort | Cost Estimate |
|-------|-------------|---------------|
| 1.1 [FILL] | [FILL] person-days | $[FILL] |
| 1.2 [FILL] | [FILL] person-days | $[FILL] |
| **Total** | **[FILL] person-days** | **$[FILL]** |

## 6. Dependencies

| WBS ID | Depends On | Type | Lag |
|--------|-----------|------|-----|
| 1.2.1 | 1.1.3 | FS (Finish-to-Start) | [FILL] d |
| [FILL] | [FILL] | FS / FF / SS / SF | [FILL] |

## 7. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| Project Manager | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
