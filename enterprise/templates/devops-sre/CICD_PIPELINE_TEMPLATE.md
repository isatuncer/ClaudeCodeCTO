---
title: "CI/CD Pipeline Document"
document-id: "CICD-[PROJECT_CODE]-001"
version: "1.0"
status: "Draft"
date: "[DATE]"
standard: "SLSA v1.0 — Supply-chain Levels for Software Artifacts"
---

# CI/CD Pipeline Document

## Table of Contents
1. [Document Information](#1-document-information)
2. [Pipeline Overview](#2-pipeline-overview)
3. [Build Stage](#3-build-stage)
4. [Test Stage](#4-test-stage)
5. [Security Stage](#5-security-stage)
6. [Deploy Stage](#6-deploy-stage)
7. [SLSA Compliance](#7-slsa-compliance)
8. [Rollback Procedures](#8-rollback-procedures)
9. [Approval](#9-approval)

## 1. Document Information

| Field | Value |
|-------|-------|
| Project | [PROJECT_NAME] |
| CI/CD Platform | [FILL — e.g., GitHub Actions, GitLab CI, Jenkins] |
| Prepared By | [FILL] |
| Repository | [FILL] |
| Distribution | [FILL] |

## 2. Pipeline Overview

### 2.1 Pipeline Diagram
[FILL — Insert pipeline flow diagram: Source -> Build -> Test -> Security -> Deploy]

### 2.2 Environments and Triggers
| Environment | Branch/Tag | Trigger | Approval Required |
|-------------|-----------|---------|-------------------|
| Development | [FILL] | Push | No |
| Staging | [FILL] | Merge to [FILL] | No |
| Production | [FILL] | Tag / Manual | Yes — [FILL] |

## 3. Build Stage

| Step | Tool | Purpose | Timeout | Artifact |
|------|------|---------|---------|----------|
| Dependency install | [FILL] | Resolve dependencies | [FILL] min | lock file |
| Compile / Build | [FILL] | Produce build artifacts | [FILL] min | [FILL] |
| Container image | [FILL] | Build Docker image | [FILL] min | image:tag |

### 3.1 Artifact Management
| Artifact | Registry | Retention | Signing |
|----------|----------|-----------|---------|
| [FILL] | [FILL] | [FILL] days | Yes / No |

## 4. Test Stage

| Step | Tool | Gate Criteria | Timeout |
|------|------|---------------|---------|
| Unit tests | [FILL] | >= [FILL]% coverage | [FILL] min |
| Integration tests | [FILL] | All pass | [FILL] min |
| E2E tests | [FILL] | Critical paths pass | [FILL] min |
| Lint / Format | [FILL] | Zero violations | [FILL] min |

## 5. Security Stage

| Step | Tool | Gate Criteria | Frequency |
|------|------|---------------|-----------|
| SAST | [FILL] | No Critical/High | Every build |
| Dependency scan (SCA) | [FILL] | No known Critical CVEs | Every build |
| Container scan | [FILL] | No Critical vulnerabilities | Every build |
| Secret detection | [FILL] | No secrets found | Every build |
| DAST | [FILL] | No Critical findings | [FILL] |

## 6. Deploy Stage

### 6.1 Deployment Strategy
| Environment | Strategy | Details |
|-------------|----------|---------|
| [FILL] | Blue-Green / Canary / Rolling / Recreate | [FILL] |

### 6.2 Health Checks
| Check | Endpoint | Expected | Timeout |
|-------|----------|----------|---------|
| Readiness | [FILL] | HTTP 200 | [FILL] s |
| Liveness | [FILL] | HTTP 200 | [FILL] s |

### 6.3 Post-Deploy Verification
- [ ] Smoke tests pass
- [ ] Key metrics within normal range
- [ ] No error rate spike

## 7. SLSA Compliance

| SLSA Level | Requirement | Status |
|-----------|-------------|--------|
| L1 | Build process documented | [FILL] |
| L2 | Hosted build platform, signed provenance | [FILL] |
| L3 | Hardened build platform, non-falsifiable provenance | [FILL] |

## 8. Rollback Procedures

### 8.1 Automated Rollback Triggers
- [FILL — e.g., Error rate > X%, Health check failure]

### 8.2 Manual Rollback
```bash
# [FILL — Rollback command or procedure]
```

## 9. Approval

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Author | [FILL] | [FILL] | |
| DevOps Lead | [FILL] | [FILL] | |
| Approver | [FILL] | [FILL] | |
