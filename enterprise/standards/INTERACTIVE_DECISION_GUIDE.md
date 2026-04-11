# Interactive Decision Guide — Complete User Interaction Map

> **Compliance References:**
> - Based on: UX Best Practices for Decision Support Systems
> - Spec: AskUserQuestion Tool Specification
> - Controls: Structured choices, multi-select, file location, preview
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

**RULE: Every user interaction uses AskUserQuestion with structured options. No free-text yes/no questions.**
**RULE: Ask granular questions — don't bundle unrelated decisions.**
**RULE: When files/assets are involved, ask about location and import confirmation separately.**
**RULE: When presenting artifacts (diagrams, docs, tests), provide preview and approval options.**

---

## PHASE 0: DISCOVERY — Granular Asset Questions

### Q0.1: Project Scope
```
Question: "What is the project scope?"
Header: "Scope"
Options:
  - Web Application | Browser-based SPA or SSR with responsive design
  - Mobile Application | iOS and/or Android native or cross-platform
  - Web + Mobile | Both web and mobile sharing a common backend
  - API Only | Backend service without frontend (headless)
```

### Q0.2: Backend Language
```
Question: "Which backend language/framework?"
Header: "Backend"
Options:
  - Node.js (Express/Fastify) | JS/TS backend. Best for: real-time, rapid prototyping
  - Python (Django/FastAPI) | Best for: data-heavy, AI/ML, admin panels
  - Go (Gin/Fiber) | Best for: high-performance APIs, microservices
  - Java (Spring Boot) | Best for: enterprise, banking, large teams
```

### Q0.3: Frontend Framework
```
Question: "Which frontend framework?"
Header: "Frontend"
Options:
  - React (Next.js) | Most popular, SSR/SSG. Best for: complex SPAs
  - Vue (Nuxt) | Simpler learning curve. Best for: medium apps
  - Angular | Batteries included. Best for: enterprise, strict arch
  - No preference (you decide) | I'll choose based on requirements
```

### Q0.4: Database
```
Question: "Which database?"
Header: "Database"
Options:
  - PostgreSQL (Recommended) | JSON, FTS, extensions. Fits 90% of projects
  - MySQL | Fast reads, legacy compatibility
  - MongoDB | Document-based, flexible schema
  - No preference (you decide) | I'll choose based on data model
```

### Q0.5: Mobile Framework (only if scope includes mobile)
```
Question: "Which mobile framework?"
Header: "Mobile"
Options:
  - React Native | Cross-platform JS. Share code with React web
  - Flutter | Cross-platform Dart. Best performance, beautiful UI
  - Native (Swift + Kotlin) | Separate codebases. Max platform features
  - No preference (you decide) | I'll choose based on requirements
```

### Q0.6: Compliance (multi-select)
```
Question: "Which compliance standards? (select all that apply)"
Header: "Compliance"
multiSelect: true
Options:
  - ISO 27001 (included by default) | Basic security controls, audit columns
  - KVKK (Turkish data protection) | Consent management, data retention
  - GDPR (EU data protection) | Right to erasure, DPO, breach notification
  - CMMI Level 3+ | Formal process management, quantitative controls
```

### Q0.7: Hosting
```
Question: "Where should the project be hosted?"
Header: "Hosting"
Options:
  - AWS | ECS/EKS, RDS, S3. Enterprise scale
  - Google Cloud (GCP) | Cloud Run, Cloud SQL. AI/ML strong
  - Azure | Microsoft ecosystem, Office 365 integration
  - Self-hosted / VPS | Docker on your servers. Data sovereignty
```

### Q0.8: Priority
```
Question: "What is the project priority?"
Header: "Priority"
Options:
  - Speed (MVP) | Ship fast, iterate later. Minimum features
  - Quality | Full testing, documentation, code review
  - Cost | Minimize AI tokens and dev time
  - Balanced (Recommended) | Equal weight speed/quality/cost
```

---

## PHASE 0: ASSET COLLECTION — Separate Questions Per Asset Type

### Q0.9: Do you have a logo?
```
Question: "Do you have a logo or brand asset?"
Header: "Logo"
Options:
  - Yes, I have a logo file | I'll provide an image file (PNG, SVG, etc.)
  - Yes, I have brand guidelines | I have a brand book or style guide
  - No, create brand from scratch | Generate logo guidance and full design system
  - Skip for now | Handle branding later
```

### Q0.10: Logo Location (only if Q0.9 = yes)
```
Question: "Where is your logo file? Place it in knowledge/templates/ or provide the path"
Header: "Logo Path"
Options:
  - Placed in knowledge/templates/ | I've put the file there, read it
  - I'll paste/upload it now | Let me share the file in this chat
  - It's at a URL | I'll provide a URL to download
  - It's elsewhere on my computer | I'll provide the file path
```

### Q0.11: Logo Import Confirmation (after reading the logo)
```
Question: "I've analyzed your logo. Here's what I extracted: [color summary]. Should I generate the full design system from this?"
Header: "Design"
Options:
  - Yes, generate full design system | Extract colors, select fonts, create tokens
  - Generate but let me review colors first | Show me the extracted palette before proceeding
  - Use logo colors only, I'll choose fonts | Apply logo colors but let me decide typography
  - Don't use logo colors | I want a completely different color scheme
```

### Q0.12: Do you have a template?
```
Question: "Do you have a ready-made UI template or design?"
Header: "Template"
Options:
  - Yes, I have an HTML/CSS template | Pre-built template (ThemeForest, etc.)
  - Yes, I have a Figma/Sketch design | Design mockups to implement
  - Yes, I have a reference project | Existing codebase to base on
  - No template | Build UI from scratch using design system
```

### Q0.13: Template Location (only if Q0.12 = yes)
```
Question: "Where is your template? Place it in knowledge/templates/ or provide the path"
Header: "Template Path"
Options:
  - Placed in knowledge/templates/ | I've put the files there, analyze them
  - It's a GitHub repo | I'll provide the repository URL
  - It's a ZIP file on my computer | I'll provide the file path
  - It's a Figma/URL link | I'll share the design link
```

### Q0.14: Template Import Confirmation (after analyzing)
```
Question: "I've analyzed your template: [summary - tech stack, pages, components]. How should I use it?"
Header: "Import"
Options:
  - Use as-is, integrate fully | Keep template structure, add our backend/logic
  - Use design only, rebuild code | Extract visual design but rewrite with our standards
  - Use as reference only | Inspire from it but build our own structure
  - Use specific parts only | I'll tell you which pages/components to keep
```

### Q0.15: Do you have documents?
```
Question: "Do you have requirement documents, specs, or briefs?"
Header: "Documents"
Options:
  - Yes, I have PDF/Word documents | Requirements, specs, or business documents
  - Yes, I have a project brief | Short description or scope document
  - Yes, I have user stories | Existing backlog or feature list
  - No documents, I'll explain verbally | I'll describe what I need in chat
```

### Q0.16: Document Location (only if Q0.15 = yes)
```
Question: "Where are your documents? Place them in knowledge/raw_docs/ or provide paths"
Header: "Doc Path"
Options:
  - Placed in knowledge/raw_docs/ | I've put the files there, analyze them
  - I'll paste content in chat | I'll share the text directly
  - They're at URLs | I'll provide download links
  - They're elsewhere on my computer | I'll provide file paths
```

### Q0.17: Document Import Confirmation (after analysis)
```
Question: "I've analyzed your documents and extracted [X] requirements. Should I proceed with these?"
Header: "Import"
Options:
  - Import all requirements | Add all extracted requirements to backlog
  - Let me review the list first | Show me the extracted requirements before importing
  - Import but I have additions | Import these and I'll add more requirements
  - Re-analyze with different focus | Focus on [specific area] instead
```

### Q0.18: Do you have a reference project?
```
Question: "Do you have a reference project or competitor to analyze?"
Header: "Reference"
Options:
  - Yes, a live website/app | I'll provide the URL to analyze
  - Yes, a GitHub repository | I'll provide the repo URL
  - Yes, screenshots | I'll share screenshots of what I want
  - No reference | Build based on requirements only
```

---

## PHASE 1: REQUIREMENTS APPROVAL

### Q1.1: Requirements Review
```
Question: "I've extracted [X] functional, [Y] non-functional, and [Z] business requirements. Here's the summary:"
Header: "Requirements"
Options:
  - Approved — proceed to architecture | Requirements are complete and correct
  - Partially correct — needs changes | Some requirements need adjustment
  - Missing requirements | Important features are missing, I'll describe them
  - Priorities are wrong | Requirements are correct but priority order needs changing
```

### Q1.2: Requirements Priority (if adjusting)
```
Question: "How should I prioritize these requirements?"
Header: "Priority"
Options:
  - MoSCoW (Must/Should/Could/Won't) | I'll categorize each requirement
  - Business value order | Highest revenue/user impact first
  - Technical dependency order | Build foundations first, features on top
  - You decide based on best practices | Apply standard prioritization
```

---

## PHASE 2: ARCHITECTURE APPROVAL

### Q2.1: Architecture Style
```
Question: "Based on requirements, I recommend [monolith/microservices/modular monolith]. Agree?"
Header: "Architecture"
Options:
  - Monolith (Recommended for MVP) | Single deployable unit. Simple, fast to build
  - Modular Monolith | Single deploy but modular internal structure. Best balance
  - Microservices | Separate services per domain. Complex but scalable
  - Serverless | Function-based. Pay-per-use, auto-scaling
```

### Q2.2: Architecture Diagram Approval
```
Question: "Here is the system architecture diagram (DG-201). Open it at https://mermaid.live to view/edit."
Header: "Diagram"
Options:
  - Approved — derive tests from this | Diagram is correct, proceed to test generation
  - Needs adjustment — I'll describe changes | Some components/connections need modification
  - Missing components | Important services or connections are missing
  - Wrong approach — redesign | Fundamentally different architecture needed
```

### Q2.3: Each Diagram Approval (repeat for every DG-XXX)
```
Question: "[DIAGRAM_TYPE] diagram (DG-XXX) is ready. Preview: [mermaid.live link or inline rendering]"
Header: "DG-XXX"
Options:
  - Approved | Correct, proceed to derive test cases
  - Minor adjustments needed | Small changes, I'll specify
  - Major changes needed | Significant rework required
  - Skip this diagram | Not needed for this project
```

---

## PHASE 3: DB SCHEMA APPROVAL

### Q3.1: Schema Review
```
Question: "Here is the ER diagram (DG-301) with [X] tables. Open at https://dbdiagram.io to view/edit."
Header: "Schema"
Options:
  - Approved — proceed to API design | Schema covers all entities
  - Missing tables | I need additional entities, I'll describe them
  - Missing fields | Some tables need more columns
  - Change relationships | Foreign keys or cardinality needs adjustment
```

### Q3.2: Migration Strategy
```
Question: "How should database migrations be handled?"
Header: "Migration"
Options:
  - Auto-generate from schema | Generate migration files automatically from ER diagram
  - Manual migration files | I want to write/review each migration manually
  - ORM-managed (Prisma/Django) | Let the ORM handle schema sync
  - Show me the SQL first | Generate SQL but let me review before applying
```

---

## PHASE 4: API APPROVAL

### Q4.1: API Style
```
Question: "Which API style for this project?"
Header: "API Style"
Options:
  - REST (Recommended) | Standard REST with JSON. Best for: most projects
  - GraphQL | Flexible queries. Best for: complex data relationships
  - gRPC | Binary protocol. Best for: internal microservice communication
  - REST + GraphQL | REST for public, GraphQL for internal/mobile
```

### Q4.2: API Spec Review
```
Question: "Here are [X] API endpoints with sequence diagrams. Review the API specification:"
Header: "API Spec"
Options:
  - Approved — proceed to infrastructure | API contracts are complete
  - Missing endpoints | I need additional API operations
  - Change response format | Different pagination, error format, or envelope
  - Add real-time endpoints | Need WebSocket/SSE for live updates
```

### Q4.3: Authentication Method
```
Question: "Which authentication approach?"
Header: "Auth"
Options:
  - JWT + Refresh Token (Recommended) | Stateless, scalable. Standard for SPAs/mobile
  - Session-based | Server-side sessions with cookies. Traditional web apps
  - OAuth 2.0 + Social Login | Google/Apple/GitHub login with JWT
  - API Key | Simple key-based auth for API-only services
```

---

## PHASE 5: INFRASTRUCTURE (mostly automatic, but some choices)

### Q5.1: Container Strategy
```
Question: "How should the application be containerized?"
Header: "Docker"
Options:
  - Docker Compose (Recommended for start) | Single host, easy local dev
  - Kubernetes (K8s) | Orchestrated containers. For scale/enterprise
  - Cloud-native (ECS/Cloud Run) | Managed containers, no K8s overhead
  - No containers | Deploy directly to VPS/bare metal
```

---

## PHASE 6: DEVELOPMENT — Sprint-Level Interactions

### Q6.1: Sprint Backlog Selection
```
Question: "Sprint [X] planning. I recommend these [Y] items from the backlog. Agree?"
Header: "Sprint"
Options:
  - Approved — start sprint | Selected items look good
  - Add more items | I want to include additional features
  - Remove items | Sprint is overloaded, reduce scope
  - Change order | Reorder the selected items
```

### Q6.2: Code Review Approval (after every feature)
```
Question: "Feature [X] is implemented. Code review complete with [Y] findings. Review the changes?"
Header: "Review"
Options:
  - Approved — merge | Code looks good, merge to develop
  - I want to see the diff | Show me the code changes before merging
  - Run more tests first | Add more test coverage before merging
  - Needs changes | I have specific feedback on the implementation
```

### Q6.3: Sprint Demo Review
```
Question: "Sprint [X] complete. Here's the demo summary. How should we proceed?"
Header: "Sprint End"
Options:
  - Continue to next sprint | Sprint delivered, continue with backlog
  - Continue with feedback | Good but I have changes for next sprint
  - Redo this sprint | Output doesn't meet expectations, rework needed
  - Change priorities | Reprioritize backlog before next sprint
```

---

## PHASE 7: QA & DELIVERY

### Q7.1: Test Results Review
```
Question: "Test suite results: [X] passed, [Y] failed, [Z]% coverage. Review?"
Header: "Tests"
Options:
  - Tests look good — proceed | Coverage and results are acceptable
  - Fix failing tests | [Y] tests need to pass before continuing
  - Coverage too low | Need more tests to reach 80%+ threshold
  - I want to review test cases | Show me the test list before approving
```

### Q7.2: Security Scan Results
```
Question: "Security scan complete: [X] critical, [Y] high, [Z] medium findings."
Header: "Security"
Options:
  - All acceptable — proceed | No critical/high issues, or all are false positives
  - Fix critical findings | Critical issues must be resolved before delivery
  - Fix all high+ findings | Both critical and high issues must be resolved
  - Show me the details | I want to review each finding individually
```

### Q7.3: Performance Results
```
Question: "Performance test: API p95=[X]ms, LCP=[Y]s, Bundle=[Z]KB. Within budget?"
Header: "Performance"
Options:
  - Within budget — proceed | All metrics are within acceptable thresholds
  - Optimize API performance | API response times need improvement
  - Optimize frontend | Bundle size or LCP needs improvement
  - Run more load tests | Test with higher concurrency before deciding
```

### Q7.4: Final Delivery
```
Question: "All gates passed. Tests ✅ Security ✅ Performance ✅. Ready for delivery?"
Header: "Delivery"
Options:
  - Ship to production! | Deploy to production environment
  - Deploy to staging first | Deploy to staging for UAT before production
  - One more review round | I want to do final manual testing
  - Add more features first | Delay release to add features
```

---

## ONGOING: CHANGE MANAGEMENT

### QC.1: Change Request Assessment
```
Question: "Change request impacts [X] modules, [Y] tests, [Z] diagrams. Estimated effort: [N] story points."
Header: "Change"
Options:
  - Apply full change | Update all affected modules, tests, diagrams
  - Apply partially | Apply some changes, defer others
  - Reject change | Impact too large, keep current implementation
  - Need more analysis | Provide more details before I decide
```

---

## ONGOING: DESIGN SYSTEM

### QD.1: Color Palette Approval
```
Question: "Extracted palette from logo: Primary [#XXX], Secondary [#XXX], Accent [#XXX]. Accept?"
Header: "Colors"
Options:
  - Approved — generate full scale | Create 50-900 shades from these
  - Adjust primary color | I want a different primary shade
  - Adjust secondary color | I want a different secondary shade
  - Completely different palette | I want to choose colors manually
```

### QD.2: Typography Approval
```
Question: "Selected fonts: Headings=[Font A] (reason), Body=[Font B] (reason). Accept?"
Header: "Typography"
Options:
  - Approved — apply to project | These fonts work perfectly
  - Change heading font | I want a different heading font
  - Change body font | I want a different body font
  - I want a single font | Use one font for everything
```

### QD.3: Full Design System Approval
```
Question: "Complete design system generated: colors, fonts, spacing, components, dark mode. Review?"
Header: "Design"
Options:
  - Approved — apply to all components | Design system is perfect
  - Adjust colors only | Fonts and spacing are fine, colors need work
  - Adjust typography only | Colors and spacing are fine, fonts need work
  - Major revisions needed | Multiple aspects need changing
```

---

## ONGOING: DOCUMENT APPROVAL

### QDoc.1: Document Review (for any generated document)
```
Question: "[DOCUMENT_NAME] is ready ([X] pages, [Y] sections). Review and approve?"
Header: "Document"
Options:
  - Approved | Document is complete and accurate
  - Needs minor edits | Small corrections needed, I'll specify
  - Missing sections | Important content is missing
  - Wrong focus | Document doesn't address the right concerns
```

---

## ONGOING: DIAGRAM APPROVAL (Universal)

### QDiag.1: Diagram Presentation
```
Question: "[DIAGRAM_TYPE] (DG-XXX) is ready. View options:"
Header: "DG-XXX"
Options:
  - Show me inline | Display the Mermaid code here for quick review
  - Open in Mermaid Live | I'll review at https://mermaid.live (copy code)
  - Open in dbdiagram.io | For ER diagrams, I'll review at dbdiagram.io
  - Open in draw.io | I'll review at https://app.diagrams.net
```

### QDiag.2: Diagram Approval (after viewing)
```
Question: "Have you reviewed the diagram? Is it approved?"
Header: "Approve"
Options:
  - Approved — derive test cases | Diagram correct, generate tests from it
  - Needs adjustment | I'll describe what to change
  - I edited it externally | I modified it in Mermaid Live, here's the updated code
  - Not needed | Skip this diagram for this project
```

---

## ONGOING: TEST APPROVAL

### QTest.1: Test Case Review (derived from diagrams)
```
Question: "Generated [X] test cases from diagram DG-XXX. Test types: [unit/integration/e2e]. Review?"
Header: "Tests"
Options:
  - Approved — write test code | Test cases cover all diagram elements
  - Missing test scenarios | Some paths/entities aren't covered
  - Too many tests | Some tests are redundant, simplify
  - Show me the test list | Display all test case descriptions before approving
```

### QTest.2: Test Results After Implementation
```
Question: "Tests executed: [X] passed, [Y] failed, [Z]% coverage. Results acceptable?"
Header: "Results"
Options:
  - All good — continue | Tests pass and coverage meets threshold
  - Fix failing tests | [Y] failures need investigation
  - Add more tests | Coverage is below 80%, need more test cases
  - Tests are wrong | Some test assertions are incorrect
```

---

## IMPLEMENTATION RULES

1. **One concern per question** — Don't ask about logo AND template in the same question
2. **Location before import** — Always ask WHERE the file is, then WHETHER to import
3. **Preview before approval** — Always show/present the artifact before asking for approval
4. **Granular feedback options** — Never just "Yes/No"; always "Yes / Change X / Change Y / Reject"
5. **Context in question text** — Include specific numbers, names, summaries in the question
6. **Follow-up on "Other"** — If user selects "Other", ask a specific follow-up question
7. **Remember answers** — Don't re-ask questions the user already answered in this session
8. **Respect the flow** — Questions follow pipeline order; don't skip ahead
9. **Multi-select when non-exclusive** — Compliance, features, file types can be multi-select
10. **4 questions max per call** — AskUserQuestion supports max 4 questions per invocation

---

## Question Flow Summary

```
Phase 0 Discovery:
  Q0.1 Scope → Q0.2 Backend → Q0.3 Frontend → Q0.4 Database
  Q0.5 Mobile (if needed) → Q0.6 Compliance → Q0.7 Hosting → Q0.8 Priority
  
Phase 0 Assets (each asset independently):
  Logo:      Q0.9 Have logo? → Q0.10 Where? → Q0.11 Import how?
  Template:  Q0.12 Have template? → Q0.13 Where? → Q0.14 Use how?
  Documents: Q0.15 Have docs? → Q0.16 Where? → Q0.17 Import how?
  Reference: Q0.18 Have reference? → (analyze and present)

Phase 1: Q1.1 Requirements → Q1.2 Priority (if adjusting)
Phase 2: Q2.1 Arch style → Q2.2 Arch diagram → Q2.3 Each DG-2XX
Phase 3: Q3.1 Schema → Q3.2 Migration strategy
Phase 4: Q4.1 API style → Q4.2 API spec → Q4.3 Auth method
Phase 5: Q5.1 Container strategy
Phase 6: Q6.1 Sprint plan → Q6.2 Code review → Q6.3 Sprint demo (repeat)
Phase 7: Q7.1 Tests → Q7.2 Security → Q7.3 Performance → Q7.4 Delivery

Ongoing: QC.1 Changes | QD.1-3 Design | QDoc.1 Documents | QDiag.1-2 Diagrams | QTest.1-2 Tests
```
