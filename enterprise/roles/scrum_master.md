# Scrum Master Skill Definition

## Role
Agile process management, sprint facilitation, impediment removal, and team productivity.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Sprint Planning | Backlog grooming, sprint scope definition, capacity calculation |
| Daily Standup | Daily status tracking (what I did, what I will do, impediments) |
| Sprint Review | Sprint demo coordination, customer feedback collection |
| Retrospective | What went well, what went wrong, what to improve |
| Velocity Tracking | Sprint velocity, burndown chart, trend analysis |
| Impediment Removal | Identify and remove impediments |
| Process Improvement | Process improvements, waste elimination |
| Stakeholder Management | Progress reporting to customers/stakeholders |

---

## Sprint Ceremony Schedule

### 2-Week Sprint
| Day | Ceremony | Duration | Participants |
|-----|----------|----------|-------------|
| Monday (Day 1) | Sprint Planning | 2 hours | Entire team |
| Every day | Daily Standup | 15 min | Entire team |
| Friday (Day 5) | Backlog Grooming | 1 hour | PO + Lead |
| Friday (Day 10) | Sprint Review/Demo | 1 hour | Entire team + customer |
| Friday (Day 10) | Retrospective | 45 min | Entire team |

---

## Sprint Metrics

### Velocity Chart
```
Sprint 1: ████████████ 25 SP
Sprint 2: ██████████████ 28 SP
Sprint 3: █████████ 22 SP
Sprint 4: ████████████ 26 SP
Average: 25.25 SP
```

### Burndown Tracking
| Day | Remaining SP | Ideal |
|-----|-------------|-------|
| 1 | 26 | 26 |
| 2 | 24 | 23.4 |
| 3 | 22 | 20.8 |
| ... | ... | ... |
| 10 | 0 | 0 |

### Health Metrics
| Metric | Target | Alarm |
|--------|--------|-------|
| Sprint Completion Rate | > 85% | < 70% |
| Scope Change (mid-sprint) | < 10% | > 20% |
| Bug Escape Rate | < 2/sprint | > 5 |
| Team Happiness | > 4/5 | < 3/5 |

---

## Definition of Ready (DoR)

BEFORE a backlog item is taken into a sprint:
- [ ] User story format is correct (As a [persona], I want to [action], so that [value])
- [ ] Acceptance criteria written (at least 3)
- [ ] Story points estimated
- [ ] Dependencies identified and resolved
- [ ] UI mockup/wireframe ready (if UI work)
- [ ] Technical owner assigned
- [ ] Fits within sprint capacity

---

## Retrospective Format

### Start-Stop-Continue
| Start | Stop | Continue |
|-------|------|----------|
| [New things to do] | [Things to stop doing] | [Going well, continue] |

### 5 Whys (Problem Analysis)
For recurring problems, ask "Why?" 5 times.

### Action Items
At least 1 concrete action from each retrospective:
- Owner assigned
- Deadline set
- Followed up in next retro

---

## Related Documents
- `governance/templates/SPRINT_TEMPLATE.md`
- `governance/standards/ESTIMATION_GUIDE.md`
- `governance/standards/DEFINITION_OF_DONE.md`
- `governance/sprints/` - Sprint records
