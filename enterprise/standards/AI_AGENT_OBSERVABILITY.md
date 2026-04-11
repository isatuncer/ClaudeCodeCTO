# AI Agent Observability (OpenTelemetry for Agents)

> **Compliance References:**
> - Based on: OpenTelemetry GenAI Semantic Conventions (2025)
> - Spec: OTel gen_ai.* attributes
> - Controls: Agent traces, metrics, costs
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

AI agent operations need the same observability as production services: traces, metrics, and cost tracking. OpenTelemetry published AI Agent semantic conventions in 2025.

---

## 1. Three Pillars for Agents

| Pillar | What to Observe | Why |
|--------|----------------|-----|
| **Traces** | Tool calls, model invocations, agent chains | Debug failures, understand flow |
| **Metrics** | Tokens/request, cost/sprint, latency, error rate | Budget control, performance |
| **Costs** | $ per agent, per feature, per sprint | Financial governance |

---

## 2. What to Trace

| Event | Attributes | Example |
|-------|-----------|---------|
| Agent invocation | agent_type, task_description, model | `code-reviewer started on PR #42` |
| Tool call | tool_name, parameters, duration, result | `Read file src/auth.ts in 50ms` |
| Model request | model_id, input_tokens, output_tokens, latency | `Sonnet 4.6: 2K in, 1.5K out, 3.2s` |
| Agent completion | status, total_tokens, total_cost, duration | `Completed in 45s, 5K tokens, $0.08` |
| Error | error_type, error_message, recovery_action | `Build failed, retrying with fix` |

---

## 3. Metrics to Collect

| Metric | Aggregation | Dashboard |
|--------|------------|-----------|
| `agent.invocations` | Count per type | Agent usage chart |
| `agent.tokens.input` | Sum per sprint | Token consumption |
| `agent.tokens.output` | Sum per sprint | Token consumption |
| `agent.cost` | Sum per feature | Cost attribution |
| `agent.duration` | p50, p95, p99 | Performance |
| `agent.error_rate` | Percentage | Reliability |
| `agent.cache_hit_rate` | Percentage | Efficiency |
| `model.routing` | Distribution | Model selection |

---

## 4. Agent Performance Dashboard Template

```
AI Agent Dashboard - Sprint [X]

USAGE
  Total invocations: [X]
  Total tokens: [X]M input / [Y]M output
  Total cost: $[Z]

BY AGENT TYPE
| Agent | Invocations | Tokens | Cost | Avg Duration | Error Rate |
|-------|------------|--------|------|-------------|-----------|
| code-reviewer | [X] | [X]K | $[X] | [X]s | [X]% |
| tdd-guide | [X] | [X]K | $[X] | [X]s | [X]% |
| security-reviewer | [X] | [X]K | $[X] | [X]s | [X]% |

ANOMALIES
- [agent] cost spike: $[X] vs avg $[Y] ([Z]% increase)
- [agent] error rate: [X]% vs avg [Y]%

EFFICIENCY
  Cache hit rate: [X]%
  Model routing: Haiku [X]% / Sonnet [Y]% / Opus [Z]%
```

---

## 5. Anomaly Detection

| Anomaly | Trigger | Action |
|---------|---------|--------|
| Cost spike | > 2x average cost per invocation | Alert, investigate prompt |
| High error rate | > 10% failures | Check tool availability |
| Slow execution | > 2x average duration | Check context size |
| Token explosion | > 3x average tokens | Review prompt efficiency |

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| AI_COST_TRACKING.md | Cost data from agent traces |
| OBSERVABILITY_STRATEGY.md | OTel infrastructure |
| OTEL_INSTRUMENTATION.md | Instrumentation standards |
| MONITORING_STRATEGY.md | Alert configuration |
