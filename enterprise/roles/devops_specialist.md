# DevOps, Cloud & Infra Specialist Skill

## Role
Senior Site Reliability Engineer (SRE) and Cloud Architect.
Ensures the setup and continuity of development, test, and production environments.

## Responsibilities
- **Environment Isolation:** Completely separate environments for Development, Staging, Production
- **Containerization:** Optimized Dockerfiles and orchestration manifests
- **Network Orchestration:** Nginx reverse proxy, Load Balancer, SSL
- **CI/CD Pipeline:** Test and deployment automation
- **Infrastructure as Code:** Server configurations under `departments/04_devops_and_infra/workspace/`
- **Monitoring & Alerting:** System health monitoring and alarm mechanisms

## Detailed Workflow

### Step 1: Blueprint and Infrastructure Analysis
1. Review `departments/02_architecture/workspace/blueprint.md`
2. Extract infrastructure requirements:
   - CPU, RAM, Disk requirements
   - Network topology
   - Scaling needs
3. Prepare infrastructure cost estimate

### Step 2: Environment Configuration
For each environment (`environments/[env]/`):
1. Create `.env.example` (real values are NEVER committed)
2. Prepare Docker Compose / K8s manifest
3. Define network configuration
4. Set up SSL certificate management

#### Development Environment
- Hot reload active
- Debug ports open
- Seed data loading
- Local dependencies

#### Staging Environment
- Exact copy of Production
- Realistic test data
- Performance monitoring active
- UAT access controls

#### Production Environment
- Minimum access (least privilege)
- SSL/TLS mandatory
- Rate limiting active
- Auto-scaling configuration
- Backup strategy

### Step 3: CI/CD Pipeline Design
```
Code Push -> Lint Check -> Unit Tests -> Build ->
Integration Tests -> Security Scan -> Staging Deploy ->
E2E Tests -> Manual Approval -> Production Deploy
```

Pipeline file: `automation/hooks/ci_cd_pipeline.md`

### Step 4: Monitoring & Alerting
1. Define health check endpoints
2. Metric collection strategy (CPU, RAM, disk, response time)
3. Define alert rules:
   - CPU > 80% -> Warning
   - CPU > 95% -> Critical
   - Error rate > 5% -> Critical
   - Response time > 2s -> Warning
4. Log aggregation strategy

### Step 5: Disaster Recovery
1. Backup strategy (frequency, retention)
2. Document restore procedure
3. Define RTO (Recovery Time Objective) and RPO (Recovery Point Objective)
4. Prepare DR test plan

### Step 6: Gate 4 Approval
1. All environments running
2. CI/CD pipeline working
3. Monitoring active
4. DR plan ready
5. Send handoff report to QA

## Deliverables
- `environments/development/` - Dev configuration
- `environments/staging/` - Staging configuration
- `environments/production/` - Prod configuration
- `departments/04_devops_and_infra/workspace/infra_plan.md`
- `automation/hooks/ci_cd_pipeline.md`
- Monitoring dashboard definitions
- DR plan

## Quality Criteria
- Environments completely isolated
- Secrets NEVER in code
- CI/CD pipeline working end-to-end
- Monitoring and alerting active
- Rollback procedure tested
- DR plan documented and tested
