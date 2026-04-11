---
title: "Data Dictionary"
document-id: "DD-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "DAMA-DMBOK2 — Data Management Body of Knowledge"
---

# Data Dictionary

## Table of Contents
1. [Document Information](#1-document-information)
2. [Overview](#2-overview)
3. [Entity Definitions](#3-entity-definitions)
4. [Attribute Catalog](#4-attribute-catalog)
5. [Code Tables and Enumerations](#5-code-tables-and-enumerations)
6. [Relationships](#6-relationships)
7. [Data Quality Rules](#7-data-quality-rules)
8. [Approval](#8-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| Database / System | [FILL] |
| Data Steward | [FILL] |
| Prepared By | [FILL] |

## 2. Overview

[FILL — Describe the data domain, its business context, and how this dictionary should be used per DAMA-DMBOK guidelines.]

### 2.1 Naming Conventions
| Element | Convention | Example |
|---------|-----------|---------|
| Table/Entity | [FILL — e.g., singular, PascalCase] | Customer |
| Column/Attribute | [FILL — e.g., snake_case] | first_name |
| Primary Key | [FILL] | id |
| Foreign Key | [FILL — e.g., {entity}_id] | customer_id |

## 3. Entity Definitions

| Entity | Description | Owner | Source System | Record Count (est.) |
|--------|-------------|-------|-------------|-------------------|
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

## 4. Attribute Catalog

### 4.1 Entity: [ENTITY_NAME]

| Attribute | Data Type | Length | Nullable | Default | PK/FK | Description | Business Rules |
|-----------|----------|--------|----------|---------|-------|-------------|---------------|
| id | UUID | 36 | No | auto-generated | PK | Unique identifier | [FILL] |
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |
| created_at | TIMESTAMP | - | No | CURRENT_TIMESTAMP | - | Record creation time | Immutable |
| updated_at | TIMESTAMP | - | No | CURRENT_TIMESTAMP | - | Last update time | Auto-updated |

### 4.2 Entity: [ENTITY_NAME]

| Attribute | Data Type | Length | Nullable | Default | PK/FK | Description | Business Rules |
|-----------|----------|--------|----------|---------|-------|-------------|---------------|
| [FILL] | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] | [FILL] |

## 5. Code Tables and Enumerations

### 5.1 [ENUM_NAME]
| Code | Label | Description | Active |
|------|-------|-------------|--------|
| [FILL] | [FILL] | [FILL] | Yes / No |

## 6. Relationships

| Parent Entity | Child Entity | Relationship | Cardinality | FK Column | On Delete |
|--------------|-------------|-------------|-------------|-----------|-----------|
| [FILL] | [FILL] | [FILL] | 1:1 / 1:N / M:N | [FILL] | CASCADE / SET NULL / RESTRICT |

## 7. Data Quality Rules

| Rule ID | Entity.Attribute | Rule | Severity | Validation |
|---------|-----------------|------|----------|------------|
| DQ-001 | [FILL] | [FILL — e.g., Not null, format regex, range] | Error / Warning | [FILL] |

## 8. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| Data Steward | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
