# Database Migration Plan

## Document Information
| Field | Value |
|-------|-------|
| Migration ID | MIG-[NUMBER] |
| Project Name | [PROJECT_NAME] |
| Author | Architecture Dept. (DBA) |
| Date | [DATE] |
| Priority | Critical / High / Normal |
| Target Environment | Dev / Staging / Production |
| Related DB Design | DB_DESIGN-[NUMBER] |

---

## 1. Migration Summary
[Brief description of what this migration does]

## 2. Change Details

### 2.1 New Tables
| Table | Column Count | Purpose |
|-------|-------------|---------|
| [table_name] | [N] | [Purpose] |

### 2.2 Table Changes
| Table | Operation | Detail |
|-------|-----------|--------|
| [table] | ADD COLUMN | [column_name] [type] |
| [table] | ALTER COLUMN | [column_name] [old_type] -> [new_type] |
| [table] | ADD INDEX | idx_[table]_[column] |
| [table] | ADD CONSTRAINT | fk_[table]_[ref] |

### 2.3 Removed Structures
| Table/Column | Operation | Data Loss Risk |
|-------------|-----------|---------------|
| [structure] | DROP | None / Yes (backup required) |

---

## 3. Migration Scripts

### 3.1 UP (Apply)
```sql
-- Migration: [YYYYMMDDHHMMSS]_[description]
-- Author: [author]
-- Date: [date]

BEGIN;

-- Changes go here
CREATE TABLE IF NOT EXISTS [table] (
    -- columns
);

COMMIT;
```

### 3.2 DOWN (Rollback)
```sql
-- Rollback: [YYYYMMDDHHMMSS]_[description]

BEGIN;

-- Rollback steps
DROP TABLE IF EXISTS [table];

COMMIT;
```

---

## 4. Impact Analysis

### 4.1 Affected Services
| Service | Impact | Action |
|---------|--------|--------|
| [service] | New entity | Update model |
| [service] | Column change | Update DTO |

### 4.2 Downtime Requirement
| Scenario | Downtime | Description |
|---------|----------|------------|
| This migration | None / Required | [Reason] |
| Expand-contract | None | [Phase 1: expand, Phase 2: contract] |

### 4.3 Data Migration
| Source | Target | Record Count | Estimated Duration |
|--------|--------|-------------|-------------------|
| [source] | [target] | [N] | [duration] |

---

## 5. Test Plan

### 5.1 Pre-Migration Checks
- [ ] Backup taken
- [ ] Sufficient disk space
- [ ] Dependencies ready (enum types, referenced tables)
- [ ] Tested on staging

### 5.2 Post-Migration Checks
- [ ] Table/column created correctly
- [ ] Indexes active
- [ ] Constraints working
- [ ] Seed data loaded (if required)
- [ ] Application services running
- [ ] Query performance acceptable

### 5.3 Rollback Test
- [ ] DOWN script tested on staging
- [ ] Data loss check performed
- [ ] Services running after rollback

---

## 6. Execution Plan

### 6.1 Pre-deployment
| Step | Responsibility | Status |
|------|---------------|--------|
| Take backup | DBA | [ ] |
| Test on staging | DBA | [ ] |
| Notify affected services | DevOps | [ ] |

### 6.2 Deployment
| Step | Command | Expected Duration |
|------|---------|------------------|
| 1 | `[migration command]` | [duration] |
| 2 | Verification queries | 5 min |
| 3 | Service restart (if required) | [duration] |

### 6.3 Post-deployment
| Step | Responsibility | Status |
|------|---------------|--------|
| Performance check | DBA | [ ] |
| Review logs | DevOps | [ ] |
| Smoke test | QA | [ ] |

---

## 7. Rollback Plan
| Condition | Action |
|-----------|--------|
| Migration failed | Run DOWN script |
| Performance issue | DOWN + revert to previous backup |
| Data inconsistency | DOWN + backup restore |

---

## 8. Approval

| Role | Name | Date | Status |
|------|------|------|--------|
| DBA | VSH | [DATE] | Pending |
| DevOps | VSH | [DATE] | Pending |
