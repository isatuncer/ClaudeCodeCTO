# Design System Guide

> **Compliance References:**
> - Based on: Material Design 3, W3C WCAG 2.1
> - Spec: Material Design Specification
> - Controls: Color, typography, spacing
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
A shared design language to ensure visual consistency across all UI.

---

## 1. Color System

### Semantic Colors
| Token | Usage | Light Theme | Dark Theme |
|-------|-------|-------------|------------|
| `--color-primary` | Primary action, links | #2563EB | #3B82F6 |
| `--color-secondary` | Secondary action | #7C3AED | #8B5CF6 |
| `--color-success` | Success, confirmation | #16A34A | #22C55E |
| `--color-warning` | Warning, caution | #D97706 | #F59E0B |
| `--color-error` | Error, danger | #DC2626 | #EF4444 |
| `--color-info` | Informational | #0891B2 | #06B6D4 |
| `--color-bg` | Background | #FFFFFF | #0F172A |
| `--color-surface` | Card/panel background | #F8FAFC | #1E293B |
| `--color-text` | Primary text | #1E293B | #F1F5F9 |
| `--color-text-muted` | Secondary text | #64748B | #94A3B8 |
| `--color-border` | Border | #E2E8F0 | #334155 |

### Contrast Rule
- Normal text: >= 4.5:1
- Large text (18px+): >= 3:1
- Check at: https://webaim.org/resources/contrastchecker/

---

## 2. Typography

### Font Scales
| Token | Size | Line Height | Weight | Usage |
|-------|------|-------------|--------|-------|
| `--text-xs` | 12px | 16px | Regular | Caption, badge |
| `--text-sm` | 14px | 20px | Regular | Helper text |
| `--text-base` | 16px | 24px | Regular | Body text |
| `--text-lg` | 18px | 28px | Medium | Subtitle |
| `--text-xl` | 20px | 28px | Semibold | H3 |
| `--text-2xl` | 24px | 32px | Semibold | H2 |
| `--text-3xl` | 30px | 36px | Bold | H1 |
| `--text-4xl` | 36px | 40px | Bold | Hero title |

### Font Family
```css
--font-sans: 'Inter', system-ui, -apple-system, sans-serif;
--font-mono: 'JetBrains Mono', 'Fira Code', monospace;
```

---

## 3. Spacing

### 4px-Based Scale
| Token | Value | Usage |
|-------|-------|-------|
| `--space-1` | 4px | Icon-text gap |
| `--space-2` | 8px | Intra-group elements |
| `--space-3` | 12px | Form field gap |
| `--space-4` | 16px | Card inner padding |
| `--space-5` | 20px | Section gap |
| `--space-6` | 24px | Card gap |
| `--space-8` | 32px | Section divider |
| `--space-10` | 40px | Large section divider |
| `--space-12` | 48px | Page section divider |
| `--space-16` | 64px | Hero section |

---

## 4. Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 4px | Badge, tag |
| `--radius-md` | 8px | Input, button |
| `--radius-lg` | 12px | Card, dropdown |
| `--radius-xl` | 16px | Modal, dialog |
| `--radius-full` | 9999px | Avatar, pill |

---

## 5. Shadow

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0,0,0,0.05)` | Card, input |
| `--shadow-md` | `0 4px 6px rgba(0,0,0,0.1)` | Dropdown, popover |
| `--shadow-lg` | `0 10px 15px rgba(0,0,0,0.1)` | Modal, dialog |
| `--shadow-xl` | `0 20px 25px rgba(0,0,0,0.15)` | Toast, notification |

---

## 6. Component Standards

### Button
| Variant | Usage |
|---------|-------|
| Primary | Main action (1 per page) |
| Secondary | Secondary action |
| Outline | Tertiary action |
| Ghost | Icon-only, minimal |
| Danger | Delete, cancel |

| Size | Height | Font | Padding |
|------|--------|------|---------|
| sm | 32px | 14px | 12px 16px |
| md | 40px | 16px | 12px 20px |
| lg | 48px | 16px | 16px 24px |

### Input
| State | Border | Background |
|-------|--------|-----------|
| Default | `--color-border` | `--color-bg` |
| Focus | `--color-primary` | `--color-bg` |
| Error | `--color-error` | `--color-bg` |
| Disabled | `--color-border` | `--color-surface` |

### Responsive Breakpoints
| Token | Width | Usage |
|-------|-------|-------|
| `sm` | 640px | Mobile landscape |
| `md` | 768px | Tablet |
| `lg` | 1024px | Laptop |
| `xl` | 1280px | Desktop |
| `2xl` | 1536px | Large screen |

---

## 7. Icon Usage

### Standards
- Icon library: Lucide Icons / Heroicons / Phosphor
- Size: 16px (sm), 20px (md), 24px (lg)
- Color: Inherit text color (`currentColor`)
- Icon-only button: `aria-label` REQUIRED

---

## 8. Animation

| Type | Duration | Easing | Usage |
|------|----------|--------|-------|
| Hover | 150ms | ease-in-out | Button, link hover |
| Transition | 200ms | ease-in-out | Tab change, toggle |
| Modal open | 300ms | ease-out | Dialog, drawer |
| Toast | 300ms in / 200ms out | ease | Notification |

### Rules
- Respect `prefers-reduced-motion` media query
- Animation is for UI feedback only, NOT for decoration
