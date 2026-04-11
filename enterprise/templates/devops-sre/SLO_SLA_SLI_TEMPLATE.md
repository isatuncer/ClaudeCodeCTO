---
title: "SLO/SLA/SLI Document"
document-id: "SRE-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "Google SRE Book — Service Level Objectives"
---

# SLO / SLA / SLI Document

## Table of Contents
1. [Document Information](#1-document-information)
2. [Service Overview](#2-service-overview)
3. [Service Level Indicators (SLIs)](#3-service-level-indicators-slis)
4. [Service Level Objectives (SLOs)](#4-service-level-objectives-slos)
5. [Service Level Agreements (SLAs)](#5-service-level-agreements-slas)
6. [Error Budget Policy](#6-error-budget-policy)
7. [Monitoring and Alerting](#7-monitoring-and-alerting)
8. [Approval](#8-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Service | [SERVICE_NAME] |
| Team | [FILL] |
| Service Owner | [FILL] |
| Prepared By | [FILL] |
| Review Cadence | [FILL — e.g., Monthly] |

## 2. Service Overview

[FILL — Describe the service, its users, critical user journeys (CUJs), and dependencies.]

### 2.1 Critical User Journeys
| CUJ ID | Journey | Users Affected | Business Impact |
|--------|---------|----------------|-----------------|
| CUJ-001 | [FILL] | [FILL] | [FILL] |

## 3. Service Level Indicators (SLIs)

| SLI ID | Category | Indicator | Measurement | Data Source |
|--------|----------|-----------|-------------|-------------|
| SLI-001 | Availability | Successful requests / Total requests | Ratio (0-1) | [FILL — e.g., Prometheus] |
| SLI-002 | Latency | Requests served < threshold / Total requests | Ratio (0-1) | [FILL] |
| SLI-003 | Throughput | [FILL] | [FILL] | [FILL] |
| SLI-004 | Error Rate | [FILL] | [FILL] | [FILL] |

## 4. Service Level Objectives (SLOs)

| SLO ID | Related SLI | Objective | Window | Consequence of Breach |
|--------|-------------|-----------|--------|----------------------|
| SLO-001 | SLI-001 | >= [FILL]% (e.g., 99.9%) | 30-day rolling | [FILL] |
| SLO-002 | SLI-002 | p99 < [FILL] ms | 30-day rolling | [FILL] |

### 4.1 Error Budget Calculation
| SLO | Budget (30 days) | Budget Remaining | Status |
|-----|-----------------|-----------------|--------|
| SLO-001 (99.9%) | 43.2 min downtime | [FILL] | Healthy / Warning / Exhausted |
| SLO-002 | [FILL] | [FILL] | [FILL] |

## 5. Service Level Agreements (SLAs)

| SLA ID | Customer / Tier | Metric | Target | Penalty | Contract Ref |
|--------|----------------|--------|--------|---------|-------------|
| SLA-001 | [FILL] | Availability | >= [FILL]% | [FILL] | [FILL] |
| SLA-002 | [FILL] | Support Response | < [FILL] hr | [FILL] | [FILL] |

## 6. Error Budget Policy

### 6.1 Budget Thresholds
| Budget Remaining | Action |
|-----------------|--------|
| > 50% | Normal development velocity |
| 25-50% | Increase reliability focus, reduce risky releases |
| < 25% | Freeze non-critical releases, focus on reliability |
| Exhausted | Full feature freeze, all effort on reliability |

### 6.2 Escalation
[FILL — Who is notified at each threshold, decision-making authority.]

## 7. Monitoring and Alerting

| Alert | Condition | Severity | Notification Channel | Runbook |
|-------|-----------|----------|---------------------|---------|
| [FILL] | SLO burn rate > [FILL] | Page / Ticket | [FILL] | [FILL] |

## 8. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| SRE Lead | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
