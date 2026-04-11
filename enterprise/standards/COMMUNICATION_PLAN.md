# Communication Plan

> **Compliance References:**
> - Based on: PMI PMBOK 7th Ed.
> - Spec: Stakeholder engagement
> - Controls: RACI matrix, communication channels
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Standards for all project communication - who communicates what, to whom, when, and through which channel.

---

## 1. Communication Matrix

| Event | To Whom | Channel | When | Responsibility |
|-------|---------|---------|------|----------------|
| Sprint start | Entire team | Meeting | Sprint Day 1 | Scrum Master |
| Daily status | Entire team | Standup / Async | Every day | Entire team |
| Sprint demo | Customer + team | Meeting + video | Sprint end | Scrum Master |
| Release announcement | Customer + team | Email + Slack | Release day | Release Manager |
| Incident (SEV-1/2) | Entire team | Slack + phone | Immediately | On-call |
| Incident (resolved) | Entire team + customer | Email + Slack | After resolution | On-call |
| Postmortem | Entire team | Document + meeting | Within 48 hours | Engineering Lead |
| Weekly status | Customer | Email report | Every Friday | PO / Scrum Master |
| Phase transition | Entire team | Meeting | At gate transition | PO |
| Scope change | Customer + team | Meeting | At change | PO |
| Security vulnerability | CTO + customer | Phone + email | Immediately | DevSecOps |

---

## 2. Channel Definitions

| Channel | Usage | Response Expectation |
|---------|-------|---------------------|
| **Meeting (sync)** | Sprint ceremony, decision meeting, demo | Immediate |
| **Slack/Teams** | Daily communication, Q&A, notifications | < 4 hours |
| **Email** | Official communication, reports, approvals | < 1 business day |
| **Ticket system** | Bug, feature, task tracking | Per SLA |
| **Phone** | ONLY for emergencies (SEV-1) | Immediate |
| **Document** | Decision, analysis, plan | Async reading |

---

## 3. Status Report Format (Weekly)

```
# Weekly Status Report - [DATE]

## Overall Status: 🟢 On Track / 🟡 At Risk / 🔴 Issues

## Completed This Week
- [Item 1]
- [Item 2]

## Planned for Next Week
- [Item 1]
- [Item 2]

## Risks / Blockers
- [Risk/blocker if any]

## Metrics
- Sprint progress: [N]%
- Test coverage: [N]%
- Open bugs: [N] (P1: [N], P2: [N])
```

---

## 4. Escalation Matrix

| Level | Condition | Escalation | Timeframe |
|-------|-----------|-----------|-----------|
| L1 | Normal question/issue | Resolved within team | - |
| L2 | Blocker, decision needed | Scrum Master / PO | 4 hours |
| L3 | Scope change, major risk | Customer + PO | 1 business day |
| L4 | Project risk, SLA violation | CTO + customer upper management | Immediately |

---

## 5. Meeting Rules

| Rule | Detail |
|------|--------|
| Agenda | Agenda shared before meeting |
| Notes | Every meeting has notes (MEETING_NOTES_TEMPLATE) |
| Actions | Every meeting has concrete actions + owner + deadline |
| Duration | Maximum duration is set and adhered to |
| Attendance | Only necessary participants |
