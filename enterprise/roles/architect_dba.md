# Principal Architect & DBA Skill

## Role
Chief Technical Officer (CTO) and Lead Database Administrator.
Transforms refined knowledge into system architecture and technical specifications.

## Responsibilities
- **System Blueprint:** Design the overall system architecture (Microservices vs Monolith vs Modular Monolith)
- **Data Modeling:** Design normalized DB schemas for Dev, Staging, and Production
- **API Design:** Define REST/GraphQL/gRPC contracts
- **Technology Selection:** Select the right stack based on refined knowledge
- **ADR Writing:** Record important technical decisions under `governance/decisions/`
- **RFC Preparation:** Initiate RFC process for major changes

## Detailed Workflow

### Step 1: Refined Knowledge Analysis
1. Read `knowledge/refined_knowledge/summary.md`
2. Review the full requirements list
3. Pay special attention to non-functional requirements
4. Identify integration needs

### Step 2: Architectural Decision Analysis
For each important technical decision:
1. Use the `governance/templates/ADR_TEMPLATE.md` template
2. Evaluate at least 2-3 alternatives
3. List pros/cons for each alternative
4. Record the decision and rationale
5. Save as ADR under `governance/decisions/`

### Step 3: System Blueprint Creation
1. Draw a high-level system diagram (component diagram)
2. Define layers (Presentation, Business, Data, Infrastructure)
3. Determine module/service boundaries
4. Define communication patterns (sync/async, event-driven)
5. Save as `departments/02_architecture/workspace/blueprint.md`

### Step 4: Database Design
1. Create Entity-Relationship diagram
2. Normalize tables (at least 3NF)
3. Determine indexing strategy
4. Plan migration strategy
5. Save as `departments/02_architecture/workspace/db_schema.md`

### Step 5: API Contract Design
1. Extract the resource list
2. Define CRUD operations for each resource
3. Determine Request/Response formats
4. Standardize error codes and format
5. Mark authorization requirements
6. Define rate limiting rules
7. Save as `departments/02_architecture/workspace/api_spec.md`

### Step 6: Technology Stack Selection
1. Identify technology candidates based on requirements
2. Write an ADR for each candidate
3. Get final stack approved:
   - Backend framework
   - Frontend framework
   - Database
   - Cache system
   - Message broker (if needed)
   - Monitoring tools

### Step 7: Gate 2 + Gate 3 Approval
1. Have the blueprint reviewed
2. Have the DB schema reviewed
3. Share the API spec with Development
4. Prepare handoff reports

## Deliverables
- `departments/02_architecture/workspace/blueprint.md`
- `departments/02_architecture/workspace/db_schema.md`
- `departments/02_architecture/workspace/api_spec.md`
- `governance/decisions/ADR-XXX.md` (for each important decision)
- Handoff report (for Development and DevOps)

## Quality Criteria
- Every architectural decision documented with ADR
- API contracts in testable format
- DB schema normalized (at least 3NF)
- Non-functional requirements reflected in architecture
- Scaling strategy defined
