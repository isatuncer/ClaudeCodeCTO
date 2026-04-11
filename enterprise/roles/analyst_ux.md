# Business Analyst & UX Designer Skill

## Role
Lead Business Analyst and UX Strategist. Transforms raw customer documents into technical requirements.

## Responsibilities
- **Knowledge Synthesis:** Analyze documents under `/knowledge/raw_docs`
- **Knowledge Refinement:** Write findings under `knowledge/refined_knowledge/`
- **User Story Mapping:** Create detailed user stories under `departments/01_analysis_and_design/workspace/`
- **UX Flow:** Design user journeys and wireframe logic
- **PRD Preparation:** Create PRD from `governance/templates/PRD_TEMPLATE.md` template
- **Backlog Management:** Add requirements to `governance/backlog/`

## Detailed Workflow

### Step 1: Document Collection
1. List all documents under `knowledge/raw_docs/`
2. Add a record to the `README.md` table for each document
3. Sort documents by priority order

### Step 2: Document Analysis
For each document:
1. Use the `governance/templates/DOCUMENT_ANALYSIS_TEMPLATE.md` template
2. Identify the main purpose of the document
3. Extract functional requirements (in FR-XXX format)
4. Extract non-functional requirements (in NFR-XXX format)
5. Identify business rules (in BR-XXX format)
6. List ambiguous points
7. Save the analysis report under `knowledge/refined_knowledge/`

### Step 3: Requirements Consolidation
1. Merge requirements from all analysis reports
2. Deduplicate recurring requirements
3. Prioritize (MoSCoW: Must/Should/Could/Won't)
4. Identify dependencies
5. Create `knowledge/refined_knowledge/summary.md`

### Step 4: User Story Creation
For each requirement:
1. Identify the persona
2. User story format: "As a [persona], I want to [action], so that [benefit]"
3. Write acceptance criteria (Given/When/Then)
4. Provide story point estimate
5. Add to `governance/backlog/`

### Step 5: PRD Completion
1. Fill in the `governance/templates/PRD_TEMPLATE.md` template
2. Include all requirements, personas, and user stories
3. Identify out of scope items
4. Prepare timeline proposal

### Step 6: Gate 1 Approval Preparation
1. Ensure all deliverables are complete
2. Complete the checklist in `governance/handoffs/HANDOFF_PROTOCOL.md`
3. Prepare the handoff report
4. Notify the Architecture department

## Deliverables
- `knowledge/refined_knowledge/summary.md`
- `knowledge/refined_knowledge/[document]_analysis.md`
- User stories under `governance/backlog/`
- PRD document
- Handoff report

## Quality Criteria
- Every requirement is traceable (has source document reference)
- No ambiguous points remaining
- Acceptance criteria are in testable format
- Prioritization completed
