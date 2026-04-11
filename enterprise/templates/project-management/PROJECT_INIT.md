# Project Initialization Protocol

> This file is the workflow that Claude automatically follows.
> The user does NOT need to read this file or follow it step by step.
> The user only provides their documents and answers questions.

---

## Phase 0: Discovery and Preference Gathering
**Trigger:** When user says "new project" or provides a document
**Performed by:** Claude (Product Owner)

### Automatic Steps:
1. Ask the user preference questions via AskUserQuestion:

   **Project Scope:**
   - Web application
   - Mobile application
   - Web + Mobile
   - API/Backend only

   **Technology Preferences (if none, Claude chooses):**
   - Frontend: React / Vue / Angular / Next.js / Other
   - Mobile: React Native / Flutter / Native (Swift+Kotlin) / Other
   - Backend: Node.js / Python(Django/FastAPI) / Go / Java(Spring) / Other
   - Database: PostgreSQL / MySQL / MongoDB / Other
   - Hosting: AWS / GCP / Azure / Self-hosted / Docker only

   **Template Status:**
   - "Do you have a ready-made template/design?"
   - Yes -> Ask them to place it in `knowledge/templates/`, then read it
   - No -> Claude creates the most suitable structure

   **Standards:**
   - Is multi-language support needed?
   - Compliance: KVKK / GDPR / ISO 27001 / CMMI / None
   - Priority: Speed / Quality / Cost balance

2. Create `governance/decisions/ADR-001-tech-stack.md` based on answers
3. Update `governance/project_status.md`

---

## Phase 1: Document Analysis
**Trigger:** When user provides a document (or a file is placed in raw_docs)
**Performed by:** Claude (Analyst role)

### Automatic Steps:
1. Save the document under `knowledge/raw_docs/`
2. Automatically add a record to `knowledge/raw_docs/README.md` table
3. Read and analyze the document:
   - Functional requirements (FR-XXX)
   - Non-functional requirements (NFR-XXX)
   - Business rules (BR-XXX)
   - Ambiguous points
4. Create `knowledge/refined_knowledge/summary.md`
5. Ask user about missing or ambiguous information
6. Write user stories under `governance/backlog/`
7. Create PRD from `governance/templates/PRD_TEMPLATE.md` template
8. Update `governance/project_status.md` -> **Gate 1: PASSED**

---

## Phase 2: Architectural Design
**Trigger:** When Gate 1 is passed (automatic)
**Performed by:** Claude (Architect role)

### Automatic Steps:
1. Analyze refined knowledge
2. Apply technology preferences from Phase 0
3. Create `departments/02_architecture/workspace/blueprint.md`:
   - System diagram
   - Layer structure
   - Module boundaries
   - Communication patterns
4. Create `departments/02_architecture/workspace/db_schema.md`:
   - ER diagram
   - Table definitions
   - Index strategy
5. Create `departments/02_architecture/workspace/api_spec.md`:
   - Endpoint list
   - Request/Response formats
   - Auth requirements
6. Write ADR for each important decision -> `governance/decisions/`
7. Update `governance/project_status.md` -> **Gate 2+3: PASSED**

---

## Phase 3: Infrastructure Setup
**Trigger:** When Gate 2+3 is passed (automatic)
**Performed by:** Claude (DevOps role)

### Automatic Steps:
1. Create project structure under `src/`
2. Write environment configs under `environments/`
3. Create Dockerfile and docker-compose.yml
4. Define CI/CD pipeline
5. Create .env.example (real values are NEVER written)
6. Update `governance/project_status.md` -> **Gate 4: PASSED**

---

## Phase 4: Development
**Trigger:** When Gate 4 is passed (automatic)
**Performed by:** Claude (Developer role)

### Automatic Steps:
1. Take tasks from backlog in priority order
2. Create sprint -> `governance/sprints/sprint_01.md`
3. For each task:
   a. Write tests (RED)
   b. Write code (GREEN)
   c. Refactor (IMPROVE)
4. Present a brief summary to user at every meaningful milestone
5. Integrate template if available (`knowledge/templates/`)
6. Update `governance/project_status.md`

---

## Phase 5: QA & Delivery
**Trigger:** When development is completed (automatic)
**Performed by:** Claude (QA role)

### Automatic Steps:
1. Run all tests (unit, integration, e2e)
2. Check test coverage (>= 80%)
3. Perform security scan (OWASP Top 10)
4. Check compliance checklist
5. Fix bugs if any, retest
6. Update `governance/project_status.md` -> **Gate 5: PASSED**
7. DELIVER to user:
   - Working code
   - Deployment instructions
   - API documentation
   - Test report

---

## What is Expected from the User (ONLY THESE)
1. Provide their documents (PDF, Word, text, image, any format)
2. Answer preference questions (DB, framework, etc.)
3. Place their template under `knowledge/templates/` if they have one
4. Answer when asked about missing information

**Everything else is Claude's responsibility.**
