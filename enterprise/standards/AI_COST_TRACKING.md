# AI Cost & Token Budget Tracking

> **Compliance References:**
> - Based on: FinOps Foundation Principles
> - Spec: Cloud cost management
> - Controls: Cost attribution, budget alerts
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

AI agent operations consume tokens which translate to direct costs. This standard defines how to track, budget, and optimize AI spending across the project lifecycle.

---

## 1. Model Pricing Reference

| Model | Input (per 1M tokens) | Output (per 1M tokens) | Best For |
|-------|----------------------|----------------------|----------|
| Claude Haiku 4.5 | $0.80 | $4.00 | Lightweight agents, code gen, workers |
| Claude Sonnet 4.6 | $3.00 | $15.00 | Main development, orchestration |
| Claude Opus 4.6 | $15.00 | $75.00 | Architecture, deep reasoning |

**Rule of Thumb:** Haiku = 90% of Sonnet capability at 3x cost savings

---

## 2. Budget Allocation by Phase

| Phase | % of Total Budget | Recommended Model | Rationale |
|-------|------------------|-------------------|-----------|
| Phase 0: Discovery | 2% | Opus | Architecture decisions need deep reasoning |
| Phase 1: Analysis | 5% | Sonnet | Document analysis, requirement extraction |
| Phase 2: Blueprint | 8% | Opus + Sonnet | Architecture = Opus, documentation = Sonnet |
| Phase 3: DB Schema | 5% | Sonnet | Schema design and validation |
| Phase 4: API Spec | 5% | Sonnet | API contract design |
| Phase 5: Infrastructure | 5% | Haiku + Sonnet | Config generation = Haiku, validation = Sonnet |
| Phase 6: Development | 55% | Haiku + Sonnet | Code gen = Haiku, review = Sonnet |
| Phase 7: QA & Delivery | 15% | Sonnet + Opus | Testing = Sonnet, final review = Opus |

---

## 3. Token Usage Tracking

### Per-Agent Tracking Template

| Agent | Invocations | Input Tokens | Output Tokens | Model | Cost |
|-------|------------|-------------|--------------|-------|------|
| planner | | | | Opus | |
| code-reviewer | | | | Sonnet | |
| tdd-guide | | | | Sonnet | |
| security-reviewer | | | | Sonnet | |
| build-error-resolver | | | | Haiku | |

### Per-Sprint Summary

| Sprint | Total Tokens | Total Cost | Features Delivered | Cost/Feature | Budget Remaining |
|--------|-------------|-----------|-------------------|-------------|-----------------|
| Sprint 1 | | | | | |
| Sprint 2 | | | | | |

### Per-Feature Cost

| Feature | Tokens Used | Cost | Story Points | Cost/Point |
|---------|------------|------|-------------|-----------|
| User Auth | | | | |
| CRUD API | | | | |

---

## 4. Budget Alerts & Thresholds

| Alert Level | Trigger | Action |
|-------------|---------|--------|
| **INFO** | 50% budget consumed | Log, continue |
| **WARNING** | 75% budget consumed | Switch to Haiku where possible |
| **CRITICAL** | 90% budget consumed | Pause non-essential agents, notify user |
| **STOP** | 100% budget consumed | Feature freeze, only bug fixes |

---

## 5. Optimization Strategies

### 5.1 Model Routing
```
Simple tasks (formatting, simple edits) → Haiku
Code generation, review → Sonnet  
Architecture, complex reasoning → Opus
```

### 5.2 Prompt Optimization
- Keep system prompts concise
- Use structured output (JSON) to reduce token waste
- Avoid repeating context already in CLAUDE.md
- Use `/strategic-compact` before context window fills

### 5.3 Caching Strategies
- Cache repeated code review patterns
- Reuse test templates instead of regenerating
- Store common architectural decisions in ADRs (don't re-derive)

### 5.4 Agent Efficiency
- Use parallel agents (reduce wall time, same tokens)
- Kill stuck agents early (loop-operator)
- Batch similar operations (review multiple files at once)

---

## 6. ROI Calculation

### Formula
```
ROI = (Value Delivered - AI Cost) / AI Cost * 100

Where:
  Value Delivered = Developer Hours Saved * Hourly Rate
  AI Cost = Total Token Cost + Infrastructure Cost
```

### Benchmark Targets
| Metric | Target | Elite |
|--------|--------|-------|
| Cost per feature | < $50 | < $20 |
| Cost per story point | < $10 | < $5 |
| Cost per sprint | < $500 | < $200 |
| ROI | > 500% | > 1000% |

---

## 7. Monthly Cost Report Template

```
Month: [MONTH YEAR]
Project: [PROJECT_NAME]

SUMMARY
  Total tokens: [X]M input / [Y]M output
  Total cost: $[Z]
  Budget used: [X]%
  Budget remaining: $[R]

BY MODEL
  Haiku:  [X]M tokens / $[A] ([X]%)
  Sonnet: [Y]M tokens / $[B] ([Y]%)
  Opus:   [Z]M tokens / $[C] ([Z]%)

BY PHASE
  [phase]: $[cost] ([X]%)

TOP COST AGENTS
  1. [agent]: $[cost] ([invocations] calls)
  2. [agent]: $[cost] ([invocations] calls)

OPTIMIZATION ACTIONS TAKEN
  - [action]: saved $[amount]

NEXT MONTH FORECAST
  Estimated: $[forecast]
  Budget: $[budget]
```

---

## 8. Integration with VSH

- `/model-route` command selects optimal model per task
- `harness-optimizer` agent optimizes agent configuration for cost
- Sprint retrospective includes cost review
- DORA metrics correlated with cost efficiency
