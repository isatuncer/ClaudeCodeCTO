# Database Seeding Strategy

> **Compliance References:**
> - Based on: GDPR Art. 25 (Data Protection by Design)
> - Spec: Faker.js methodology
> - Controls: PII anonymization, deterministic seeds
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Creating consistent and secure data for test, demo, and development environments.

---

## 1. Seed Types

| Type | Environment | Purpose | Example |
|------|-------------|---------|---------|
| **System seed** | All environments | Reference data required by the system | Roles, permissions, categories, countries |
| **Dev seed** | Development | Test data for developers | 10 users, 50 products, 20 orders |
| **Demo seed** | Staging/Demo | Realistic data for customer demos | 100 users, realistic names, scenarios |
| **Performance seed** | Test environment | Large dataset for load testing | 100K users, 1M orders |
| **Migration seed** | One-time | Data migration from legacy system | Legacy DB -> new schema |

---

## 2. File Structure

```
src/database/
├── migrations/            # Schema changes
├── seeds/
│   ├── system/            # Runs in all environments
│   │   ├── 001_roles.ts
│   │   ├── 002_permissions.ts
│   │   └── 003_categories.ts
│   ├── development/       # Only in dev environment
│   │   ├── 001_users.ts
│   │   ├── 002_products.ts
│   │   └── 003_orders.ts
│   ├── demo/              # For demo environment
│   │   └── 001_demo_data.ts
│   └── index.ts           # Seed runner
```

---

## 3. PII Rules (CRITICAL)

### NEVER Use Real Data
| Field | Correct (Fake) | Wrong (Real) |
|-------|----------------|--------------|
| Name | `Ahmet Yilmaz` (faker) | Real customer name |
| Email | `test.user1@example.com` | Real email |
| Phone | `+905001234567` | Real number |
| National ID | `11111111110` (invalid) | Real ID |
| Address | `Test Mah. Ornek Sok. No:1` | Real address |
| Credit Card | `4111111111111111` (test) | Real card |

### Rules
- [ ] Seed data must NEVER contain REAL PII
- [ ] Data copied from production DB MUST BE ANONYMIZED
- [ ] Test emails use the `@example.com` domain
- [ ] Test phone numbers start with `+90500` (invalid)
- [ ] Seed files pass code review

---

## 4. Seed Writing Rules

### Must Be Idempotent
```typescript
// CORRECT: Skip if exists, create if not
const adminRole = await Role.findOrCreate({
  where: { name: 'admin' },
  defaults: { name: 'admin', permissions: ['*'] }
});

// WRONG: Creates duplicates every time
await Role.create({ name: 'admin' });
```

### Run in Order
```
System seeds (001, 002, 003...)
  -> Dev seeds (001, 002...)
    -> Demo seeds (if needed)
```

### Must Be Reversible
```typescript
// Seed should be reversible
async function down() {
  await User.destroy({ where: { email: { endsWith: '@example.com' } } });
}
```

---

## 5. Faker / Test Data Tools

| Language | Tool | Installation |
|----------|------|-------------|
| Node.js | @faker-js/faker | `npm i -D @faker-js/faker` |
| Python | Faker | `pip install faker` |
| Go | gofakeit | `go get github.com/brianvoe/gofakeit` |
| PHP | fakerphp/faker | `composer require fakerphp/faker` |

### Example (Node.js)
```typescript
import { faker } from '@faker-js/faker/locale/tr';

function createFakeUser() {
  return {
    id: faker.string.uuid(),
    first_name: faker.person.firstName(),
    last_name: faker.person.lastName(),
    email: faker.internet.email({ provider: 'example.com' }),
    phone: `+90500${faker.string.numeric(7)}`,
    role: faker.helpers.arrayElement(['user', 'admin', 'editor']),
    is_active: true,
    created_at: faker.date.past(),
    created_by: 'seed'
  };
}
```

---

## 6. Copying Data from Production

Only anonymized data may be copied:

```sql
-- Example: Anonymous copy from production
CREATE TABLE staging.users AS
SELECT
  id,
  CONCAT('user_', id, '@example.com') AS email,  -- Masked
  'Test' AS first_name,                            -- Masked
  'User' AS last_name,                             -- Masked
  '+90500' || LPAD(FLOOR(RANDOM()*10000000)::TEXT, 7, '0') AS phone, -- Random
  role,
  is_active,
  created_at,
  'migration' AS created_by
FROM production.users;
```

### Checklist
- [ ] Email masked
- [ ] First/last name masked
- [ ] Phone masked
- [ ] National ID/SSN completely removed
- [ ] Address masked
- [ ] Credit card completely removed
- [ ] Password hashes replaced with new hashes
- [ ] Private notes/messages removed

---

## 7. Running Seeds

```bash
# System seeds (all environments)
npm run seed:system

# Development seeds
npm run seed:dev

# Demo seeds
npm run seed:demo

# All seeds (dev environment)
npm run seed:all

# Undo seeds
npm run seed:undo
```
