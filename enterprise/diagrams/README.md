# Project Diagrams

> Visual documentation of every development step.
> Diagrams are written in Mermaid (Markdown-compatible) format.

---

## Diagram Types and When to Use

| Type | Code | When | Mandatory |
|------|------|------|-----------|
| System Architecture | ARCH-XXX | During architecture design | Yes (Gate 2) |
| Sequence Diagram | SEQ-XXX | For API/operation flows | Yes (every endpoint) |
| Flow Diagram | FLOW-XXX | For business logic flows | Yes (every feature) |
| ER Diagram | ER-XXX | During DB design | Yes (Gate 2) |
| Component Diagram | COMP-XXX | For module structure | Yes (Gate 2) |
| Deployment Diagram | DEPLOY-XXX | During infrastructure design | Yes (Gate 4) |
| State Diagram | STATE-XXX | For features with state transitions | When needed |
| Class Diagram | CLASS-XXX | For complex OOP structures | When needed |

---

## Diagram Registry Table

| Dia ID | Type | Title | Related Req/Dev | Date | Version | File |
|--------|------|-------|----------------|------|---------|------|
| | | | | | | |

---

## Diagram Templates (Mermaid)

### System Architecture (ARCH)
```mermaid
graph TB
    subgraph Client
        WEB[Web App]
        MOB[Mobile App]
    end

    subgraph API Gateway
        GW[Gateway / Load Balancer]
    end

    subgraph Backend Services
        AUTH[Auth Service]
        API[API Service]
        NOTIFY[Notification Service]
    end

    subgraph Data Layer
        DB[(Database)]
        CACHE[(Cache)]
        QUEUE[Message Queue]
    end

    WEB --> GW
    MOB --> GW
    GW --> AUTH
    GW --> API
    API --> DB
    API --> CACHE
    API --> QUEUE
    QUEUE --> NOTIFY
```

### Sequence Diagram (SEQ)
```mermaid
sequenceDiagram
    actor User
    participant FE as Frontend
    participant API as API Server
    participant AUTH as Auth Service
    participant DB as Database

    User->>FE: Action
    FE->>API: HTTP Request
    API->>AUTH: Verify Token
    AUTH-->>API: Token Valid
    API->>DB: Query
    DB-->>API: Result
    API-->>FE: Response
    FE-->>User: UI Update

    Note over API,DB: Transaction boundary
    Note over AUTH: ISO 27001 A.8.5
```

### Flow Diagram (FLOW)
```mermaid
flowchart TD
    A[Start] --> B{User Authenticated?}
    B -->|Yes| C[Load Dashboard]
    B -->|No| D[Show Login]
    D --> E[Enter Credentials]
    E --> F{Valid?}
    F -->|Yes| G[Create Session]
    F -->|No| H{Attempts > 5?}
    H -->|Yes| I[Lock Account]
    H -->|No| D
    G --> C
    I --> J[Send Alert Email]

    style I fill:#f66,stroke:#333
    style G fill:#6f6,stroke:#333
```

### ER Diagram (ER)
```mermaid
erDiagram
    USERS {
        uuid id PK
        string email UK
        string password_hash
        string role
        boolean is_active
        timestamp created_at
        uuid created_by
        timestamp updated_at
        uuid updated_by
        timestamp deleted_at
        uuid deleted_by
    }

    AUDIT_LOG {
        uuid id PK
        string entity_type
        uuid entity_id
        string action
        json old_values
        json new_values
        uuid user_id FK
        string ip_address
        timestamp created_at
    }

    USERS ||--o{ AUDIT_LOG : "generates"
```

### Component Diagram (COMP)
```mermaid
graph TB
    subgraph Presentation Layer
        UI[UI Components]
        PAGES[Pages/Views]
    end

    subgraph Business Layer
        CTRL[Controllers]
        SVC[Services]
        VALID[Validators]
    end

    subgraph Data Layer
        REPO[Repositories]
        MODEL[Models/Entities]
        MIGR[Migrations]
    end

    subgraph Infrastructure
        AUTH[Auth Middleware]
        LOG[Logger]
        CACHE[Cache]
    end

    PAGES --> CTRL
    CTRL --> VALID
    CTRL --> SVC
    SVC --> REPO
    REPO --> MODEL
    CTRL --> AUTH
    SVC --> LOG
    SVC --> CACHE
```

### Deployment Diagram (DEPLOY)
```mermaid
graph TB
    subgraph Production
        LB[Load Balancer / Nginx]
        APP1[App Server 1]
        APP2[App Server 2]
        DB_PRIMARY[(DB Primary)]
        DB_REPLICA[(DB Replica)]
        REDIS[(Redis Cache)]
    end

    subgraph Monitoring
        PROM[Metrics]
        LOGS[Log Aggregator]
        ALERT[Alert Manager]
    end

    LB --> APP1
    LB --> APP2
    APP1 --> DB_PRIMARY
    APP2 --> DB_PRIMARY
    DB_PRIMARY --> DB_REPLICA
    APP1 --> REDIS
    APP2 --> REDIS
    APP1 --> PROM
    APP2 --> PROM
    APP1 --> LOGS
    PROM --> ALERT
```

### State Diagram (STATE)
```mermaid
stateDiagram-v2
    [*] --> Draft
    Draft --> Review: Submit
    Review --> Approved: Approve
    Review --> Draft: Request Changes
    Approved --> InProgress: Start Work
    InProgress --> Testing: Complete
    Testing --> Done: Tests Pass
    Testing --> InProgress: Tests Fail
    Done --> [*]

    Approved --> Cancelled: Cancel
    Draft --> Cancelled: Cancel
```

---

## Diagram Writing Rules

1. **Give each diagram an ID** (ARCH-001, SEQ-001, etc.)
2. **Link to RTM** - Specify which requirement it relates to
3. **ISO 27001 notes** - Mark security points with Notes
4. **Version tracking** - Changed diagrams get version numbers
5. **Record in Dev Log** - Every diagram creation/update is added to the DEV log
