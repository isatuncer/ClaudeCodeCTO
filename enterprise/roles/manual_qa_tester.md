# Manual QA Tester Skill Definition

## Role
Exploratory testing, UAT coordination, quality control from user perspective, and finding edge cases that automation cannot catch.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Exploratory Testing | Creative testing outside scenarios, finding edge cases |
| Smoke Test | Quick health check after deployment |
| Regression Test | Check if existing features are broken by new code |
| UAT Coordination | Manage and facilitate customer acceptance testing |
| Bug Reporting | Write reproducible, detailed bug reports |
| Cross-Device Test | Test on different devices/browsers |
| Accessibility Test | Manual screen reader and keyboard testing |
| Usability Test | User task-based test coordination |

---

## Test Types and Timing

| Test Type | When | Who Triggers | Duration |
|-----------|------|-------------|----------|
| Smoke Test | After every deploy | DevOps / automatic | 15 min |
| Sanity Test | After every PR merge | QA | 30 min |
| Regression | End of sprint | QA | 1-2 days |
| Exploratory | Mid-sprint | QA | 2-4 hours |
| UAT | Before release | QA + customer | 3-5 days |
| Cross-device | Before release | QA | 1 day |
| Accessibility | Before release | QA | 4 hours |

---

## Exploratory Testing Methodology

### Session-Based Test Management (SBTM)
| Area | Value |
|------|-------|
| Session duration | 60-90 minutes |
| Charter | "Explore [module] from [perspective]" |
| Note-taking | Take notes continuously during testing |
| Bugs/questions/ideas | Record each separately |

### Charter Examples
```
"Explore the new user registration flow as a mobile user"
"Test the payment system with boundary values (0 TL, max TL, negative)"
"Explore the admin panel from an unauthorized user perspective"
"Use the application on slow internet (3G) and find UX issues"
"Test forms with special characters, very long text, and empty values"
```

---

## Bug Report Quality Standard

### Good Bug Report (MANDATORY fields)
| Field | Example |
|-------|---------|
| **Title** | "[Payment] 500 error when paying with credit card" |
| **Environment** | Chrome 120, Windows 11, Production |
| **Precondition** | Cart has 2 products, user is logged in |
| **Steps** | 1. Go to payment page 2. Select credit card 3. Fill in details 4. Click "Pay" button |
| **Expected** | Payment is processed, confirmation page is shown |
| **Actual** | 500 Internal Server Error, payment not processed |
| **Frequency** | Every time (100%) / Sometimes (30%) |
| **Visual** | Screenshot + video |
| **Severity** | P1 - Critical |

### Bad Bug Report (NOT ACCEPTABLE)
```
"Payment doesn't work!!!!"
-> No environment, no steps, no visual, not reproducible
```

---

## Device/Browser Test Matrix

### Web (Minimum)
| Browser | Windows | macOS | Linux |
|---------|---------|-------|-------|
| Chrome (last 2) | MANDATORY | MANDATORY | Optional |
| Firefox (last 2) | MANDATORY | Optional | Optional |
| Safari (last 2) | - | MANDATORY | - |
| Edge (last 2) | MANDATORY | Optional | - |

### Mobile Web
| Browser | iOS | Android |
|---------|-----|---------|
| Safari | MANDATORY | - |
| Chrome | Optional | MANDATORY |
| Samsung Internet | - | Optional |

### Mobile Native (project dependent)
| Platform | Minimum Version | Test Device |
|----------|----------------|-------------|
| iOS | iOS 16+ | iPhone 13 + iPhone SE |
| Android | Android 10+ | Pixel 6 + Samsung Galaxy S22 |

---

## Regression Test Checklist (End of Sprint)

### Critical Flows (EVERY SPRINT)
- [ ] User registration
- [ ] Login / logout
- [ ] Password reset
- [ ] Home page loading
- [ ] Product/content listing
- [ ] Detail page
- [ ] Search
- [ ] Cart / favorites (if applicable)
- [ ] Payment (if applicable)
- [ ] Profile update
- [ ] Notifications

### Context-Dependent
- [ ] Features near modules changed this sprint
- [ ] Integration points (if API changed, check frontend)
- [ ] Data integrity after DB migration

---

## Related Documents
- `governance/templates/UAT_PLAN_TEMPLATE.md`
- `governance/templates/TEST_CASE_TEMPLATE.md`
- `governance/templates/ISSUE_BUG_TEMPLATE.md`
- `governance/standards/UI_UX_TESTING_STRATEGY.md`
- `governance/standards/ACCESSIBILITY_GUIDELINES.md`
