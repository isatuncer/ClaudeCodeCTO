# OpenTelemetry Auto-Instrumentation Standards

> **Compliance References:**
> - Based on: OpenTelemetry Specification v1.x
> - Spec: OTel Semantic Conventions v1.25+
> - Controls: Resource, span, metric conventions
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

OpenTelemetry (OTel) is the vendor-neutral observability standard. This guide defines how to instrument all generated projects for traces, metrics, and logs.

---

## 1. Setup by Language

### Node.js
```bash
npm install @opentelemetry/api @opentelemetry/sdk-node \
  @opentelemetry/auto-instrumentations-node \
  @opentelemetry/exporter-trace-otlp-http
```

### Python
```bash
pip install opentelemetry-api opentelemetry-sdk \
  opentelemetry-instrumentation \
  opentelemetry-exporter-otlp
opentelemetry-bootstrap -a install  # auto-detect and install
```

### Go
```bash
go get go.opentelemetry.io/otel
go get go.opentelemetry.io/contrib/instrumentation/net/http/otelhttp
```

### Java
```bash
# Download Java agent JAR
java -javaagent:opentelemetry-javaagent.jar -jar app.jar
```

---

## 2. Resource Attributes (Required)

| Attribute | Example | Purpose |
|-----------|---------|---------|
| `service.name` | `user-api` | Identify service |
| `service.version` | `1.2.3` | Track by version |
| `deployment.environment` | `production` | Filter by env |
| `service.namespace` | `myapp` | Group services |

---

## 3. Custom Spans for Business Logic

Add spans for:
- Database transactions
- External API calls
- Cache operations
- Queue publish/consume
- Authentication flows
- Payment processing
- File operations

---

## 4. Exporter Configuration

| Exporter | Protocol | Use Case |
|----------|----------|----------|
| OTLP/HTTP | HTTP/protobuf | Default, most compatible |
| OTLP/gRPC | gRPC | High throughput |
| Jaeger | HTTP | Jaeger-native |
| Prometheus | Pull | Metrics only |

### Environment Variables
```bash
OTEL_SERVICE_NAME=user-api
OTEL_EXPORTER_OTLP_ENDPOINT=http://collector:4318
OTEL_TRACES_SAMPLER=parentbased_traceidratio
OTEL_TRACES_SAMPLER_ARG=0.1  # 10% sampling in production
```

---

## 5. Sampling Strategies

| Strategy | When | Rate |
|----------|------|------|
| Always On | Development | 100% |
| Parent-based ratio | Staging | 50% |
| Parent-based ratio | Production | 1-10% |
| Tail-based | High-value analysis | Dynamic |

**Performance target:** < 2% latency overhead from instrumentation.

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| OBSERVABILITY_STRATEGY.md | Three pillars implementation |
| MONITORING_STRATEGY.md | Metrics and alerting |
| AI_AGENT_OBSERVABILITY.md | OTel for AI agents |
| SRE_ERROR_BUDGET.md | SLI data from traces |
