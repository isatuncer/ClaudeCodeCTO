# MCP (Model Context Protocol) Server Registry

> **Compliance References:**
> - Based on: Model Context Protocol (Anthropic 2024)
> - Spec: MCP Specification v1.0
> - Controls: Server security audit
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Overview

MCP is the standard protocol for AI agents to connect to external tools and data. This registry catalogs recommended MCP servers and security requirements.

---

## 1. MCP Server Categories

| Category | Purpose | Examples |
|----------|---------|---------|
| **Database** | Query, schema inspection | PostgreSQL, MySQL, SQLite |
| **API** | External service integration | GitHub, Slack, Jira, Linear |
| **File System** | File read/write operations | Local FS, S3, Google Drive |
| **Monitoring** | Observability data | Grafana, Datadog, Sentry |
| **Search** | Web and code search | Exa, Brave Search, Context7 |
| **Communication** | Messaging | Slack, Discord, Email |
| **Documentation** | Docs lookup | Context7, ReadTheDocs |
| **DevOps** | CI/CD, infrastructure | GitHub Actions, Docker, K8s |

---

## 2. Recommended Servers by Project Type

### Web Application
| Server | Purpose | Priority |
|--------|---------|----------|
| context7 | Framework documentation lookup | Required |
| postgres | Database queries and schema | Required |
| github | PR/issue management | Required |
| slack | Team notifications | Optional |
| sentry | Error tracking | Recommended |

### Mobile Application
| Server | Purpose | Priority |
|--------|---------|----------|
| context7 | React Native/Flutter docs | Required |
| firebase | Backend services | Recommended |
| github | Code management | Required |

### API-Only Service
| Server | Purpose | Priority |
|--------|---------|----------|
| postgres | Database access | Required |
| redis | Cache management | Recommended |
| github | Code management | Required |

---

## 3. Security Checklist for MCP Servers

Before adding any MCP server to the project:

- [ ] **Source verification:** Is it from a trusted publisher?
- [ ] **Open source:** Can you inspect the code?
- [ ] **Permissions:** Does it request minimum necessary permissions?
- [ ] **Data exposure:** What data does it access?
- [ ] **Network:** Does it send data to external servers?
- [ ] **Authentication:** Does it use secure auth (OAuth 2.1, API keys)?
- [ ] **Audit logging:** Does it log tool invocations?
- [ ] **Update frequency:** Is it actively maintained?
- [ ] **Vulnerability history:** Any known CVEs?

### Risk Levels
| Risk | Criteria | Approval |
|------|----------|----------|
| Low | Read-only, no external network | Auto-approve |
| Medium | Read-write local, no PII | Team lead approval |
| High | Network access, PII potential | Security review required |
| Critical | Production DB, secrets access | CTO approval + audit |

---

## 4. MCP Configuration Template

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "description": "Framework documentation lookup"
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_URL": "${DATABASE_URL}"
      },
      "description": "Database queries"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      },
      "description": "GitHub integration"
    }
  }
}
```

---

## 5. Custom MCP Server Development

When no existing server meets requirements:

1. Use official MCP SDK (Node.js or Python)
2. Define tools with Zod/JSON Schema validation
3. Implement stdio or Streamable HTTP transport
4. Add authentication layer
5. Write tests for all tool handlers
6. Document in this registry
7. Security review before deployment

---

## 6. Integration with VSH

| Standard | Connection |
|----------|-----------|
| AI_AGENT_OBSERVABILITY.md | Monitor MCP server performance |
| AI_COST_TRACKING.md | Track MCP-related token usage |
| SECURITY_ASSESSMENT_TEMPLATE.md | MCP security review |
| DEPENDENCY_MANAGEMENT.md | MCP server as dependency |
