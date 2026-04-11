---
title: "Disaster Recovery Plan"
document-id: "DRP-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "ISO 22301:2019 — Business Continuity Management Systems"
---

# Disaster Recovery Plan

## Table of Contents
1. [Document Information](#1-document-information)
2. [Purpose and Scope](#2-purpose-and-scope)
3. [Business Impact Analysis](#3-business-impact-analysis)
4. [Recovery Objectives](#4-recovery-objectives)
5. [Recovery Strategies](#5-recovery-strategies)
6. [Recovery Procedures](#6-recovery-procedures)
7. [Testing and Maintenance](#7-testing-and-maintenance)
8. [Approval](#8-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| Organization | [FILL] |
| DR Coordinator | [FILL] |
| Prepared By | [FILL] |
| Review Frequency | [FILL — e.g., Annually] |

## 2. Purpose and Scope

[FILL — Define the systems, services, and locations covered by this DRP per ISO 22301.]

## 3. Business Impact Analysis

| System / Service | Business Function | Users Affected | Revenue Impact (per hour) | Criticality |
|-----------------|-------------------|----------------|--------------------------|-------------|
| [FILL] | [FILL] | [FILL] | $[FILL] | Critical / High / Medium / Low |

## 4. Recovery Objectives

| System / Service | RTO (Recovery Time Objective) | RPO (Recovery Point Objective) | MTPD (Maximum Tolerable Period of Disruption) |
|-----------------|-------------------------------|-------------------------------|----------------------------------------------|
| [FILL] | [FILL] hrs | [FILL] hrs | [FILL] hrs |

## 5. Recovery Strategies

### 5.1 Infrastructure Recovery
| Component | Primary | DR Strategy | DR Location | Failover Type |
|-----------|---------|-------------|-------------|---------------|
| [FILL] | [FILL] | Hot / Warm / Cold | [FILL] | Auto / Manual |

### 5.2 Data Recovery
| Data Store | Backup Method | Backup Frequency | Retention | Restore Tested |
|-----------|---------------|-------------------|-----------|---------------|
| [FILL] | [FILL] | [FILL] | [FILL] days | Yes / No — Date: [FILL] |

### 5.3 Application Recovery
| Application | Dependencies | Recovery Order | Estimated Recovery Time |
|-------------|-------------|----------------|------------------------|
| [FILL] | [FILL] | [FILL] | [FILL] hrs |

## 6. Recovery Procedures

### 6.1 Declaration Criteria
[FILL — Define what constitutes a disaster requiring plan activation.]

### 6.2 Activation Procedure
1. [FILL — Assess impact and notify DR Coordinator]
2. [FILL — Declare disaster and activate DR team]
3. [FILL — Begin recovery procedures per priority order]

### 6.3 DR Team Contacts
| Role | Name | Phone | Email | Backup |
|------|------|-------|-------|--------|
| DR Coordinator | [FILL] | [FILL] | [FILL] | [FILL] |
| Infrastructure Lead | [FILL] | [FILL] | [FILL] | [FILL] |
| Application Lead | [FILL] | [FILL] | [FILL] | [FILL] |
| Database Admin | [FILL] | [FILL] | [FILL] | [FILL] |

### 6.4 Return to Normal Operations
[FILL — Steps to failback from DR to primary environment and verify data integrity.]

## 7. Testing and Maintenance

| Test Type | Frequency | Last Tested | Next Scheduled | Result |
|-----------|-----------|-------------|---------------|--------|
| Tabletop Exercise | [FILL] | [FILL] | [FILL] | Pass / Fail |
| Partial Failover | [FILL] | [FILL] | [FILL] | [FILL] |
| Full DR Test | [FILL] | [FILL] | [FILL] | [FILL] |
| Backup Restore | [FILL] | [FILL] | [FILL] | [FILL] |

## 8. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| IT Director | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
