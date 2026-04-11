# Accessibility Guidelines

> **Compliance References:**
> - Based on: W3C Web Content Accessibility Guidelines
> - Spec: WCAG 2.1 AA
> - Controls: POUR principles
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Standard: WCAG 2.1 AA

---

## 1. Core Principles (POUR)

| Principle | Meaning | Example |
|-----------|---------|---------|
| **Perceivable** | Content must be perceivable | Alt text, contrast, captions |
| **Operable** | Interface must be operable | Keyboard access, sufficient time |
| **Understandable** | Content must be understandable | Clear language, consistent navigation |
| **Robust** | Content must be interpretable | Semantic HTML, ARIA |

---

## 2. Mandatory Checklist

### Images
- [ ] All `<img>` tags have an `alt` attribute
- [ ] Decorative images have `alt=""` (empty)
- [ ] Complex images have detailed `alt` text
- [ ] Images containing text have text provided separately

### Color and Contrast
- [ ] Text/background contrast ratio >= 4.5:1 (normal text)
- [ ] Text/background contrast ratio >= 3:1 (large text, 18px+)
- [ ] Color alone does not convey information (add icon/text too)
- [ ] Focus indicator is visible (do not remove outline)

### Keyboard Navigation
- [ ] All interactive elements are accessible via Tab
- [ ] Visible focus indicator exists
- [ ] Tab order is logical (follows DOM order)
- [ ] Modal/dropdown can be closed with Escape
- [ ] Skip to content link exists

### Forms
- [ ] Every input has a label associated via `<label>`
- [ ] Error messages are programmatically linked to input (`aria-describedby`)
- [ ] Required fields are marked with `aria-required="true"`
- [ ] Form errors are in clear language

### Semantic HTML
- [ ] Headings are in order (`h1` -> `h2` -> `h3`, no skipping)
- [ ] Lists use `<ul>/<ol>/<dl>`
- [ ] Tables have `<th>` and `scope` attribute
- [ ] `<nav>`, `<main>`, `<header>`, `<footer>` landmarks exist
- [ ] `<button>` is used for clickable elements (not div)
- [ ] `<a>` is used for navigation

### ARIA
- [ ] ARIA is used only when native HTML is insufficient
- [ ] `aria-label` or `aria-labelledby` on icon-only buttons
- [ ] `aria-expanded` for collapsible/expandable elements
- [ ] `aria-live="polite"` for dynamic content updates
- [ ] `role` attribute is used correctly

### Media
- [ ] Videos have captions
- [ ] Audio content has a transcript
- [ ] No auto-playing media (or pause control is available)

---

## 3. Testing Tools

| Tool | Type | Usage |
|------|------|-------|
| axe-core | Automated | `@axe-core/playwright` or `@axe-core/react` in CI/CD |
| Lighthouse | Automated | Chrome DevTools -> Accessibility score |
| WAVE | Manual | wave.webaim.org - page analysis |
| Screen reader | Manual | NVDA (Windows), VoiceOver (Mac), TalkBack (Android) |
| Keyboard | Manual | Use only Tab + Enter + Space + Escape |

### CI/CD Integration (Playwright + axe)
```typescript
import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

test('page should be accessible', async ({ page }) => {
  await page.goto('/');
  const results = await new AxeBuilder({ page }).analyze();
  expect(results.violations).toEqual([]);
});
```

---

## 4. Component-Based Guide

### Button
```html
<!-- Correct -->
<button type="button" aria-label="Close menu">
  <svg>...</svg>
</button>

<!-- Wrong -->
<div onclick="close()">X</div>
```

### Modal
```html
<div role="dialog" aria-modal="true" aria-labelledby="modal-title">
  <h2 id="modal-title">Title</h2>
  <!-- Inside focus trap -->
</div>
```

### Form
```html
<label for="email">Email *</label>
<input id="email" type="email" aria-required="true" aria-describedby="email-error" />
<span id="email-error" role="alert">Enter a valid email</span>
```
