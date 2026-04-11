# QA Automation Engineer Skill Definition

## Role
Setting up test automation frameworks, writing test scripts, integrating into CI/CD, and managing test infrastructure.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Framework Setup | Test framework selection and configuration |
| E2E Test Writing | Automation of critical flows with Playwright |
| API Test | Automated testing of REST/GraphQL endpoints |
| Visual Regression | Screenshot-based visual comparison |
| Performance Test | Load test automation with k6/Artillery |
| CI/CD Integration | Test pipeline creation and maintenance |
| Test Data | Test data creation and management |
| Flaky Tests | Detecting and fixing flaky tests |
| Reporting | Test reports, coverage reports, trend analysis |

---

## Test Automation Pyramid

```
          /  E2E (Playwright)  \         <- 10% | Slow, expensive, critical flows
         / API Test (Supertest)  \        <- 20% | Medium speed, endpoint verification
        / Integration (TestContainers) \  <- 30% | DB + service integration
       /   Unit Test (Jest/Pytest)       \ <- 40% | Fast, isolated, business logic
```

### Rules for Each Layer
| Layer | Tool | Run Time | When It Runs |
|-------|------|----------|-------------|
| Unit | Jest / Pytest / Go test | < 30s | Every commit |
| Integration | Supertest + TestContainers | < 2min | Every PR |
| API | Supertest / httpx / REST Client | < 1min | Every PR |
| E2E | Playwright | < 5min | Every PR + deploy |
| Visual | Playwright screenshot | < 2min | Every PR |
| Performance | k6 | < 10min | Every deploy (staging) |

---

## E2E Framework: Playwright

### File Structure (Page Object Model)
```
tests/
├── e2e/
│   ├── fixtures/
│   │   └── test-data.ts          # Test data
│   ├── pages/
│   │   ├── BasePage.ts           # Common methods
│   │   ├── LoginPage.ts          # Login page
│   │   ├── DashboardPage.ts      # Dashboard
│   │   └── ProfilePage.ts        # Profile
│   ├── specs/
│   │   ├── auth.spec.ts          # Auth flows
│   │   ├── dashboard.spec.ts     # Dashboard flows
│   │   └── critical-path.spec.ts # Critical path
│   ├── utils/
│   │   ├── api-helpers.ts        # API helpers
│   │   └── test-helpers.ts       # General helpers
│   └── playwright.config.ts      # Configuration
├── api/
│   ├── auth.api.test.ts          # Auth API tests
│   ├── users.api.test.ts         # Users API tests
│   └── orders.api.test.ts        # Orders API tests
└── visual/
    ├── screenshots/              # Baseline screenshots
    └── visual.spec.ts            # Visual regression tests
```

### Page Object Example
```typescript
// pages/LoginPage.ts
import { Page, Locator, expect } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly emailInput: Locator;
  readonly passwordInput: Locator;
  readonly submitButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.emailInput = page.getByLabel('Email');
    this.passwordInput = page.getByLabel('Password');
    this.submitButton = page.getByRole('button', { name: 'Login' });
    this.errorMessage = page.getByRole('alert');
  }

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.emailInput.fill(email);
    await this.passwordInput.fill(password);
    await this.submitButton.click();
  }

  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}
```

### Test Example
```typescript
// specs/auth.spec.ts
import { test, expect } from '@playwright/test';
import { LoginPage } from '../pages/LoginPage';

test.describe('Authentication', () => {
  let loginPage: LoginPage;

  test.beforeEach(async ({ page }) => {
    loginPage = new LoginPage(page);
    await loginPage.goto();
  });

  test('successful login', async ({ page }) => {
    await loginPage.login('user@example.com', 'Password123!');
    await expect(page).toHaveURL('/dashboard');
  });

  test('shows error with wrong password', async () => {
    await loginPage.login('user@example.com', 'wrong');
    await loginPage.expectError('Invalid email or password');
  });

  test('shows validation error on empty form submit', async () => {
    await loginPage.submitButton.click();
    await loginPage.expectError('Email is required');
  });
});
```

---

## API Test Framework

### Supertest Example (Node.js)
```typescript
import request from 'supertest';
import { app } from '../src/app';

describe('POST /api/v1/auth/login', () => {
  it('successful login returns 200 + token', async () => {
    const res = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'test@example.com', password: 'Test123!' })
      .expect(200);

    expect(res.body.success).toBe(true);
    expect(res.body.data.access_token).toBeDefined();
  });

  it('wrong password returns 401', async () => {
    const res = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'test@example.com', password: 'wrong' })
      .expect(401);

    expect(res.body.error.code).toBe('INVALID_CREDENTIALS');
  });

  it('rate limit returns 429', async () => {
    for (let i = 0; i < 10; i++) {
      await request(app)
        .post('/api/v1/auth/login')
        .send({ email: 'test@example.com', password: 'wrong' });
    }
    const res = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'test@example.com', password: 'wrong' })
      .expect(429);
  });
});
```

---

## Flaky Test Management

### Diagnosis
| Symptom | Probable Cause | Solution |
|---------|---------------|----------|
| Sometimes passes, sometimes fails | Timing/race condition | `waitFor` + explicit wait |
| Fails in CI, passes locally | Environment difference | Docker-based test environment |
| Fails when running in parallel | Shared state | Test isolation, unique data |
| Fails at certain hours | 3rd party API | Use mock/stub |

### Flaky Test Policy
1. When a flaky test is detected, add `@flaky` tag
2. Fix or quarantine within 3 days
3. Quarantine: separate test suite, NOT a blocker in CI
4. If not fixed within 2 weeks -> DELETE + create ticket

---

## Reporting

### Per PR
```
Tests: 142 passed, 0 failed, 2 skipped
Coverage: 84.2% lines, 78.1% branches
Duration: 1m 32s
Visual: 0 changes detected
```

### Weekly Report
| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| Total tests | 342 | 328 | +14 |
| Pass rate | 99.1% | 98.5% | Up |
| Flaky tests | 2 | 4 | Down (good) |
| Coverage | 84% | 82% | Up |
| E2E duration | 4m 12s | 4m 45s | Down (good) |

---

## Related Agents & Skills
- `e2e-runner` agent - E2E test creation/execution
- `/e2e` skill - Playwright E2E
- `/tdd` skill - Test-Driven Development
- `/test-coverage` skill - Coverage measurement
- `/verify` skill - Comprehensive verification
- `governance/standards/UI_UX_TESTING_STRATEGY.md`
