---
title: "Data Classification Policy"
document-id: "DCP-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "ISO/IEC 27001:2022 — Information Security Management Systems (Annex A.8.2)"
---

# Data Classification Policy

## Table of Contents
1. [Document Information](#1-document-information)
2. [Purpose and Scope](#2-purpose-and-scope)
3. [Classification Levels](#3-classification-levels)
4. [Handling Requirements](#4-handling-requirements)
5. [Data Inventory](#5-data-inventory)
6. [Labeling and Marking](#6-labeling-and-marking)
7. [Roles and Responsibilities](#7-roles-and-responsibilities)
8. [Approval](#8-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Organization | [FILL] |
| Information Security Officer | [FILL] |
| Prepared By | [FILL] |
| Review Frequency | [FILL — e.g., Annually] |

## 2. Purpose and Scope

[FILL — Define the purpose of data classification, applicable systems, and personnel scope per ISO 27001 Annex A.8.2.]

## 3. Classification Levels

| Level | Label | Description | Examples |
|-------|-------|-------------|----------|
| 1 | **Public** | No impact if disclosed | Marketing materials, public docs |
| 2 | **Internal** | Minor impact if disclosed externally | Internal policies, org charts |
| 3 | **Confidential** | Significant impact if disclosed | Customer data, financial reports, contracts |
| 4 | **Restricted** | Severe impact if disclosed | PII, credentials, trade secrets, health data |

## 4. Handling Requirements

| Control | Public | Internal | Confidential | Restricted |
|---------|--------|----------|-------------|------------|
| Encryption at rest | Optional | Optional | Required | Required (AES-256) |
| Encryption in transit | Optional | TLS 1.2+ | TLS 1.2+ | TLS 1.3 required |
| Access control | None | Role-based | Need-to-know | Need-to-know + MFA |
| Storage | Any | Approved systems | Approved, encrypted | Dedicated secure storage |
| Sharing | Unrestricted | Internal only | Approved recipients | Explicit approval required |
| Disposal | Normal delete | Secure delete | Certified destruction | Certified destruction + log |
| Backup | Standard | Standard | Encrypted backup | Encrypted, separate location |
| Audit logging | Optional | Optional | Required | Required, tamper-proof |
| Retention | [FILL] | [FILL] | [FILL] | [FILL] |

## 5. Data Inventory

| Data Asset | Owner | Classification | System | Location | Retention |
|-----------|-------|---------------|--------|----------|-----------|
| [FILL] | [FILL] | Public / Internal / Confidential / Restricted | [FILL] | [FILL] | [FILL] |

## 6. Labeling and Marking

### 6.1 Document Labeling
[FILL — How documents should be labeled: headers, footers, metadata, watermarks.]

### 6.2 System Labeling
[FILL — How systems and databases should display classification levels.]

### 6.3 Email and Communication
[FILL — Subject line prefixes, banner requirements for classified communications.]

## 7. Roles and Responsibilities

| Role | Responsibility |
|------|---------------|
| Data Owner | Classify data, approve access, review classification periodically |
| Data Custodian | Implement handling controls per classification level |
| All Employees | Follow handling requirements, report misclassification |
| Information Security | Define policy, audit compliance, provide training |

### 7.1 Classification Review
| Trigger | Action |
|---------|--------|
| New data asset created | Owner assigns classification |
| Annual review | Owner re-evaluates classification |
| Data breach | Immediate review of affected data |
| Regulatory change | Review impacted classifications |

## 8. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| CISO | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
