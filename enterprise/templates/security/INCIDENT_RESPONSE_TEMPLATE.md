---
title: "Incident Response Plan"
document-id: "IRP-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "NIST SP 800-61 Rev. 2 — Computer Security Incident Handling Guide"
---

# Incident Response Plan

## Table of Contents
1. [Document Information](#1-document-information)
2. [Purpose and Scope](#2-purpose-and-scope)
3. [Incident Classification](#3-incident-classification)
4. [Phase 1: Preparation](#4-phase-1-preparation)
5. [Phase 2: Detection and Analysis](#5-phase-2-detection-and-analysis)
6. [Phase 3: Containment, Eradication, Recovery](#6-phase-3-containment-eradication-recovery)
7. [Phase 4: Post-Incident Activity](#7-phase-4-post-incident-activity)
8. [Communication Plan](#8-communication-plan)
9. [Approval](#9-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| Organization | [FILL] |
| Incident Commander | [FILL] |
| Prepared By | [FILL] |
| Review Frequency | [FILL — e.g., Quarterly] |

## 2. Purpose and Scope

[FILL — Define the scope of incidents covered (security breaches, data loss, service outages) and the systems/teams in scope per NIST 800-61.]

## 3. Incident Classification

| Severity | Description | Response Time | Examples |
|----------|-------------|---------------|----------|
| SEV-1 (Critical) | [FILL] | < [FILL] min | Data breach, full outage |
| SEV-2 (High) | [FILL] | < [FILL] hr | Partial outage, compromised account |
| SEV-3 (Medium) | [FILL] | < [FILL] hr | Performance degradation |
| SEV-4 (Low) | [FILL] | < [FILL] business days | Policy violation, minor anomaly |

## 4. Phase 1: Preparation

### 4.1 Incident Response Team
| Role | Name | Contact | Backup |
|------|------|---------|--------|
| Incident Commander | [FILL] | [FILL] | [FILL] |
| Security Analyst | [FILL] | [FILL] | [FILL] |
| Communications Lead | [FILL] | [FILL] | [FILL] |
| Legal Counsel | [FILL] | [FILL] | [FILL] |

### 4.2 Tools and Resources
- Monitoring: [FILL]
- SIEM: [FILL]
- Forensics: [FILL]
- Communication: [FILL]

### 4.3 Preparation Checklist
- [ ] IR team trained and aware of roles
- [ ] Runbooks documented for common incident types
- [ ] Tabletop exercises conducted within last [FILL] months
- [ ] Backup and recovery procedures tested

## 5. Phase 2: Detection and Analysis

### 5.1 Detection Sources
| Source | Type | Alert Threshold |
|--------|------|----------------|
| [FILL] | SIEM / IDS / APM / User Report | [FILL] |

### 5.2 Analysis Procedure
1. [FILL — Triage and validate the alert]
2. [FILL — Determine scope and impact]
3. [FILL — Classify severity per Section 3]
4. [FILL — Document initial findings in incident log]

## 6. Phase 3: Containment, Eradication, Recovery

### 6.1 Containment
| Strategy | Short-term | Long-term |
|----------|-----------|-----------|
| [FILL — e.g., Network isolation] | [FILL] | [FILL] |

### 6.2 Eradication
[FILL — Steps to remove the root cause: patch, credential rotation, malware removal.]

### 6.3 Recovery
[FILL — Steps to restore systems: restore from backup, verify integrity, monitor for recurrence.]

## 7. Phase 4: Post-Incident Activity

### 7.1 Post-Mortem Template
| Field | Value |
|-------|-------|
| Incident ID | [FILL] |
| Timeline | [FILL] |
| Root Cause | [FILL] |
| Impact | [FILL] |
| Lessons Learned | [FILL] |
| Action Items | [FILL] |

### 7.2 Metrics
| Metric | Target | Actual |
|--------|--------|--------|
| Mean Time to Detect (MTTD) | [FILL] | [FILL] |
| Mean Time to Respond (MTTR) | [FILL] | [FILL] |
| Mean Time to Recover | [FILL] | [FILL] |

## 8. Communication Plan

| Audience | Channel | Timing | Owner | Template |
|----------|---------|--------|-------|----------|
| Internal Team | [FILL] | Immediate | [FILL] | [FILL] |
| Management | [FILL] | Within [FILL] hr | [FILL] | [FILL] |
| Customers | [FILL] | Within [FILL] hr | [FILL] | [FILL] |
| Regulators | [FILL] | Within [FILL] hr | Legal | [FILL] |

## 9. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| CISO | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
