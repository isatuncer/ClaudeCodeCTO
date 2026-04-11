# Incident Postmortem

## Incident Information
| Field | Value |
|-------|-------|
| Incident ID | INC-[NUMBER] |
| Title | [Short, clear description] |
| Severity | SEV-1 / SEV-2 / SEV-3 / SEV-4 |
| Date | [YYYY-MM-DD] |
| Duration | [Start] - [End] (total: X hours Y min) |
| Affected Users | [N users / X%] |
| Affected Services | [service list] |
| Oncall | [Name] |

---

## 1. Summary
[2-3 sentence summary of the incident - what happened, who was affected, how long it lasted]

---

## 2. Timeline

| Time | Event |
|------|-------|
| HH:MM | First alert/user report |
| HH:MM | Oncall notified |
| HH:MM | Issue diagnosed |
| HH:MM | First intervention (fix/rollback/workaround) |
| HH:MM | Service returned to normal |
| HH:MM | All users confirmed |

---

## 3. Root Cause
[Technical root cause of the issue - detailed explanation]

### 5 Whys Analysis
1. **Why?** [Answer]
2. **Why?** [Answer]
3. **Why?** [Answer]
4. **Why?** [Answer]
5. **Why?** [Root cause]

---

## 4. Impact Analysis

| Metric | Value |
|--------|-------|
| Total downtime | [X hours Y min] |
| Affected user count | [N] |
| Lost transactions | [N transactions / $X revenue] |
| SLA violation | Yes / No |
| Data loss | Yes (detail) / No |

---

## 5. Resolution
[What was done to resolve the issue - technical detail]

---

## 6. What Went Well
- [Thing that went well 1]
- [Thing that went well 2]

## 7. What Went Wrong
- [Thing that went wrong 1]
- [Thing that went wrong 2]

## 8. Things We Got Lucky With
- [Thing that could have been worse]

---

## 9. Action Items

| ID | Action | Responsibility | Priority | Target Date | Status |
|----|--------|---------------|----------|-------------|--------|
| AI-001 | [Preventive action] | [Name] | P1 | [DATE] | Open |
| AI-002 | [Improvement] | [Name] | P2 | [DATE] | Open |
| AI-003 | [Add monitoring] | [Name] | P2 | [DATE] | Open |

---

## 10. Lessons
[The 1-3 most important lessons from this incident]

---

## Approval
| Role | Name | Date |
|------|------|------|
| Oncall | [Name] | [DATE] |
| Engineering Lead | VSH | [DATE] |
