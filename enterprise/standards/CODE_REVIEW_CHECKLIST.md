# Code Review Quick Checklist

> **Compliance References:**
> - Based on: Google Engineering Practices, SmartBear Best Practices
> - Spec: Peer review methodology
> - Controls: Review checklist items
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

> Quick-reference for reviewers. Scan this list on every PR.

---

## Security (PRIORITY - check first)
- [ ] No hardcoded secrets (API key, password, token)
- [ ] No SQL injection (parameterized query used)
- [ ] XSS protection (user input escaped)
- [ ] Auth/authorization checks on correct endpoints
- [ ] Input validation exists (body, query, params)
- [ ] Rate limiting applied (public endpoints)
- [ ] CSRF protection (state-changing operations)
- [ ] Sensitive data not written to logs (PII masked)
- [ ] File upload has type/size validation

## Code Quality
- [ ] Functions are short (<50 lines)
- [ ] Files are focused (<800 lines)
- [ ] Nesting depth is reasonable (<4 levels, early return used)
- [ ] Variable/function names are meaningful
- [ ] No magic numbers (constants/config used)
- [ ] DRY - no duplicated code
- [ ] Immutable pattern (new object instead of mutation)
- [ ] No console.log / print / debug leftovers

## Error Handling
- [ ] Errors are explicitly handled (try-catch / error return)
- [ ] Meaningful error message returned to user
- [ ] Errors are logged (with request_id)
- [ ] No silent swallowing

## Testing
- [ ] Tests written for new functions
- [ ] Happy path test exists
- [ ] Edge case / negative tests exist
- [ ] Test coverage 80%+ (for new code)
- [ ] Tests are isolated (no external dependencies/mocked)

## Database
- [ ] New table/column has audit columns (created_at/by, updated_at/by)
- [ ] Soft delete used (not hard delete)
- [ ] Index added (frequently queried columns)
- [ ] Migration UP + DOWN exists
- [ ] No N+1 queries (JOIN or batch used)

## API
- [ ] Response format is standard (success/data/error)
- [ ] HTTP status codes are correct
- [ ] Pagination exists (on list endpoints)
- [ ] Input validation schema used

## Performance
- [ ] No unnecessary DB queries
- [ ] Pagination/limit on large datasets
- [ ] Cache used (where needed)
- [ ] Async/await used correctly (no blocking)

## Documentation
- [ ] Comments on complex logic
- [ ] API endpoint documented
- [ ] If breaking change, added to CHANGELOG
- [ ] If new env variable, .env.example updated

---

## Decision

| Result | Condition |
|--------|-----------|
| **APPROVE** | Security clean, quality good, tests exist |
| **REQUEST CHANGES** | Security issue or critical bug |
| **COMMENT** | Minor suggestions, does not block approval |
