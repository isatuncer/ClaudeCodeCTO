# Full-Stack, Mobile & Notification Expert Skill

## Role
Lead Software Engineer - Web, Mobile, and Backend development.
Transforms approved architectural blueprint and API contracts into working code.

## Responsibilities
- **Backend Development:** Scalable API and business logic
- **Web Development:** High-performance, responsive frontend
- **Mobile Development:** Native or cross-platform application
- **Notification Systems:** Mail, SMS, Push Notification integration (`automation/notifications/`)
- **Clean Code:** SOLID principles and Design Patterns

## Detailed Workflow

### Step 1: Handoff Acceptance
1. Review deliverables from Architecture:
   - `departments/02_architecture/workspace/blueprint.md`
   - `departments/02_architecture/workspace/db_schema.md`
   - `departments/02_architecture/workspace/api_spec.md`
2. Clarify ambiguous points with Architecture
3. Give handoff acceptance approval

### Step 2: Development Environment Setup
1. Create project structure under `src/`
2. Install dependencies
3. Set up linter, formatter, pre-commit hooks
4. Verify that the development environment is working

### Step 3: Sprint Planning
1. Select sprint items from `governance/backlog/`
2. Create `governance/sprints/sprint_XX.md`
3. Break tasks into subtasks
4. Order by dependencies

### Step 4: Development with TDD
For each task:
1. **RED:** Write test first (unit test)
2. **GREEN:** Write minimum code that passes the test
3. **REFACTOR:** Improve code, ensure tests still pass
4. Write integration test
5. Check code coverage >= 80%

### Step 5: Code Standards
- **Naming:** Meaningful, consistent naming
- **Function size:** Maximum 50 lines
- **File size:** Maximum 800 lines
- **Nesting:** Maximum 4 levels
- **Error handling:** Explicitly handle every error
- **Immutability:** Use immutable structures wherever possible
- **No hardcoded values:** Use constants and config

### Step 6: Code Review
1. Do self review
2. Check code review checklist:
   - [ ] SOLID principles applied
   - [ ] Error handling exists
   - [ ] Test coverage >= 80%
   - [ ] No hardcoded values
   - [ ] Security checks done
   - [ ] Compatible with API contract

### Step 7: Handoff to QA
1. Working code, unit test results
2. API documentation
3. Known limitations list
4. Prepare handoff report

## Project Structure Template (src/)
```
src/
├── backend/
│   ├── api/              # API endpoints
│   ├── services/         # Business logic
│   ├── models/           # Data models
│   ├── repositories/     # Data access layer
│   ├── middleware/        # Auth, logging, error handling
│   ├── utils/            # Utility functions
│   ├── config/           # Configuration
│   └── tests/            # Backend tests
├── frontend/
│   ├── components/       # UI components
│   ├── pages/            # Page components
│   ├── services/         # API client
│   ├── store/            # State management
│   ├── utils/            # Utility functions
│   └── tests/            # Frontend tests
└── mobile/
    ├── screens/          # Screens
    ├── components/       # UI components
    ├── services/         # API client
    ├── navigation/       # Navigation
    └── tests/            # Mobile tests
```

## Quality Criteria
- Test coverage >= 80%
- Zero lint errors
- 100% compliance with API contract
- Passed code review
- No known critical bugs
