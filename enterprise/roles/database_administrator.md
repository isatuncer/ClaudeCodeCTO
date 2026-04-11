# Database Administrator (DBA) Skill Definition

## Role
Database performance, security, backup, replication, and operational DBA duties.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Schema Design | ER modeling, normalization, denormalization decisions |
| Query Optimization | EXPLAIN ANALYZE, index strategy, query rewrite |
| Index Management | Correct index type selection, unnecessary index cleanup |
| Replication | Primary-replica setup, failover, read replica |
| Backup | Daily full + incremental backup, restore testing |
| Monitoring | Slow query log, connection pool, disk, replication lag |
| Security | User permissions, row-level security, audit |
| Migration | Zero-downtime migration, expand-contract pattern |
| Partitioning | Partition strategy for large tables |
| Connection Pool | Pool size, timeout, idle management |

---

## Query Optimization Checklist

### Reading EXPLAIN ANALYZE
```sql
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM orders WHERE user_id = 'uuid' AND status = 'active';
```

### Checklist
- [ ] **Seq Scan** on large table -> Add index
- [ ] **Nested Loop** on large data set -> Convert to Hash/Merge Join
- [ ] **High cost** -> Optimize WHERE conditions
- [ ] **Rows estimated vs actual** large discrepancy -> Run ANALYZE (update statistics)
- [ ] **Disk sort** -> Increase work_mem or add index

### Index Strategy
| Scenario | Index Type | Example |
|----------|-----------|---------|
| Equality query (=) | B-tree (default) | `WHERE status = 'active'` |
| Range query (<, >) | B-tree | `WHERE created_at > '2026-01-01'` |
| Full-text search | GIN | `WHERE content @@ 'search'` |
| JSON field query | GIN | `WHERE metadata @> '{"key": "val"}'` |
| Geographic query | GiST | `WHERE location <-> point` |
| Composite query | Composite B-tree | `WHERE user_id = X AND status = Y` |
| Null check | Partial index | `WHERE deleted_at IS NULL` |

### Anti-Patterns
| Anti-Pattern | Problem | Solution |
|-------------|---------|----------|
| `SELECT *` | Unnecessary data | Select only required columns |
| `LIKE '%text%'` | Full table scan | Use full-text search |
| N+1 query | N trips to DB | JOIN or batch |
| No LIMIT | Fetches all data | Add pagination |
| Function on index col | Index not used | `WHERE created_at > X` (no function) |
| OR on different cols | Index not used | Use UNION ALL |

---

## Backup Strategy

### PostgreSQL
```bash
# Full backup (daily)
pg_dump -Fc -f backup_$(date +%Y%m%d).dump $DATABASE_URL

# Incremental (WAL archiving - continuous)
archive_mode = on
archive_command = 'cp %p /archive/%f'

# Point-in-Time Recovery (PITR)
pg_restore -d newdb backup.dump
# + WAL replay to specific time
recovery_target_time = '2026-04-06 14:30:00'
```

### Backup Schedule
| Environment | Type | Frequency | Retention | Test |
|-------------|------|-----------|-----------|------|
| Production | Full dump | Daily 02:00 | 30 days | Monthly restore |
| Production | WAL archive | Continuous | 7 days | - |
| Staging | Full dump | Weekly | 7 days | - |
| Development | - | - | - | - |

---

## Connection Pool Management

### Calculation Formula
```
max_connections = (core_count * 2) + effective_spindle_count
```

| Environment | Min Pool | Max Pool | Idle Timeout | Max Lifetime |
|-------------|---------|---------|-------------|-------------|
| Development | 2 | 10 | 30s | 30m |
| Staging | 5 | 25 | 30s | 30m |
| Production | 10 | 50 | 60s | 60m |

### PgBouncer (Recommended)
```ini
[pgbouncer]
pool_mode = transaction      # transaction-based pooling
max_client_conn = 1000       # max client connections
default_pool_size = 25       # connections per pool
reserve_pool_size = 5        # reserve pool
reserve_pool_timeout = 3     # reserve pool timeout
```

---

## Monitoring Metrics

| Metric | Query | Alert Threshold |
|--------|-------|-----------------|
| Active connections | `SELECT count(*) FROM pg_stat_activity WHERE state='active'` | > 80% max_conn |
| Long queries | `SELECT * FROM pg_stat_activity WHERE duration > '30s'` | > 0 |
| Dead tuples | `SELECT relname, n_dead_tup FROM pg_stat_user_tables` | > 20% of live |
| Replication lag | `SELECT extract(epoch from replay_lag) FROM pg_stat_replication` | > 5s |
| Cache hit ratio | `SELECT sum(heap_blks_hit) / sum(heap_blks_hit + heap_blks_read) FROM pg_statio_user_tables` | < 99% |
| Index usage | `SELECT indexrelname, idx_scan FROM pg_stat_user_indexes WHERE idx_scan = 0` | Unused index |

---

## Related Documents
- `governance/templates/DB_DESIGN_TEMPLATE.md`
- `governance/templates/MIGRATION_PLAN_TEMPLATE.md`
- `governance/standards/DATABASE_SEEDING.md`
- `governance/compliance/iso27001/DATABASE_OPERATIONS_CONTROLS.md`
- `governance/standards/MONITORING_STRATEGY.md`
