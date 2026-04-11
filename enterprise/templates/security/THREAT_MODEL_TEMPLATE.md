---
title: "Threat Modeling Report"
document-id: "THM-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "STRIDE Threat Model (Microsoft)"
---

# Threat Modeling Report

## Table of Contents
1. [Document Information](#1-document-information)
2. [System Overview](#2-system-overview)
3. [Trust Boundaries](#3-trust-boundaries)
4. [STRIDE Analysis](#4-stride-analysis)
5. [Threat Catalog](#5-threat-catalog)
6. [Risk Assessment](#6-risk-assessment)
7. [Mitigations](#7-mitigations)
8. [Approval](#8-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| System | [SYSTEM_NAME] |
| Prepared By | [FILL] |
| Threat Modeler | [FILL] |
| Distribution | [FILL] |

## 2. System Overview

### 2.1 Description
[FILL — Describe the system, its purpose, and key assets being protected.]

### 2.2 Data Flow Diagram
[FILL — Insert DFD showing processes, data stores, data flows, external entities, and trust boundaries.]

### 2.3 Assets
| Asset | Classification | Owner | Value |
|-------|---------------|-------|-------|
| [FILL] | Public / Internal / Confidential / Restricted | [FILL] | High / Medium / Low |

## 3. Trust Boundaries

| Boundary | Description | Components Inside | Components Outside |
|----------|-------------|-------------------|-------------------|
| [FILL] | [FILL] | [FILL] | [FILL] |

## 4. STRIDE Analysis

### 4.1 Spoofing (Identity)
| ID | Threat | Component | Entry Point | Severity |
|----|--------|-----------|-------------|----------|
| S-001 | [FILL] | [FILL] | [FILL] | Critical / High / Medium / Low |

### 4.2 Tampering (Data Integrity)
| ID | Threat | Component | Entry Point | Severity |
|----|--------|-----------|-------------|----------|
| T-001 | [FILL] | [FILL] | [FILL] | [FILL] |

### 4.3 Repudiation
| ID | Threat | Component | Entry Point | Severity |
|----|--------|-----------|-------------|----------|
| R-001 | [FILL] | [FILL] | [FILL] | [FILL] |

### 4.4 Information Disclosure
| ID | Threat | Component | Entry Point | Severity |
|----|--------|-----------|-------------|----------|
| I-001 | [FILL] | [FILL] | [FILL] | [FILL] |

### 4.5 Denial of Service
| ID | Threat | Component | Entry Point | Severity |
|----|--------|-----------|-------------|----------|
| D-001 | [FILL] | [FILL] | [FILL] | [FILL] |

### 4.6 Elevation of Privilege
| ID | Threat | Component | Entry Point | Severity |
|----|--------|-----------|-------------|----------|
| E-001 | [FILL] | [FILL] | [FILL] | [FILL] |

## 5. Threat Catalog

| Threat ID | STRIDE | Description | Likelihood | Impact | Risk Score |
|-----------|--------|-------------|------------|--------|------------|
| S-001 | Spoofing | [FILL] | 1-5 | 1-5 | [L x I] |
| T-001 | Tampering | [FILL] | [FILL] | [FILL] | [FILL] |

## 6. Risk Assessment

| Risk Level | Count | Action Required |
|------------|-------|----------------|
| Critical (20-25) | [FILL] | Immediate mitigation before deployment |
| High (12-19) | [FILL] | Mitigate before production release |
| Medium (6-11) | [FILL] | Plan mitigation within next sprint |
| Low (1-5) | [FILL] | Accept or address in backlog |

## 7. Mitigations

| Threat ID | Mitigation | Implementation | Owner | Status |
|-----------|-----------|----------------|-------|--------|
| S-001 | [FILL] | [FILL] | [FILL] | Planned / In Progress / Done |

## 8. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| Security Lead | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
