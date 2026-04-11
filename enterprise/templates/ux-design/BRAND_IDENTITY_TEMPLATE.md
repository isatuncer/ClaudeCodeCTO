# Brand Identity Document — [PROJECT_NAME]

> Generated from: [LOGO_FILE_NAME]
> Date: [YYYY-MM-DD]
> Pipeline: governance/standards/BRAND_IDENTITY_PIPELINE.md

---

## 1. Brand Overview

| Field | Value |
|-------|-------|
| Project Name | [PROJECT_NAME] |
| Tagline | [one-line description] |
| Brand Personality | [3-5 keywords: e.g., Modern, Trustworthy, Innovative] |
| Target Audience | [primary user persona] |
| Industry | [domain] |

---

## 2. Logo Analysis

### Extracted Elements
| Element | Value | Observation |
|---------|-------|------------|
| Dominant Color | #XXXXXX | [color name], [% of logo area] |
| Secondary Color | #XXXXXX | [color name], [% of logo area] |
| Accent Color | #XXXXXX | [color name], [% of logo area] |
| Shape Language | [geometric/organic/mixed] | [e.g., sharp angles = modern, curves = friendly] |
| Visual Weight | [light/medium/heavy] | [determines design density] |
| Style | [minimal/detailed/illustrative/abstract] | [informs component style] |

### Logo Usage Rules
- **Clear space:** Minimum [X]px around logo (equal to logo's "X" height)
- **Minimum size:** [X]px width for digital, [X]mm for print
- **Backgrounds:** Use on white, primary-900, or transparent only
- **Don'ts:** No rotation, no stretching, no color changes, no drop shadows

---

## 3. Color Palette

### Primary Color: [Color Name] (#XXXXXX)

| Attribute | Detail |
|-----------|--------|
| **Hex** | #XXXXXX |
| **RGB** | rgb(XX, XX, XX) |
| **HSL** | hsl(XX, XX%, XX%) |
| **Emotion** | [what this color evokes] |
| **Why chosen** | [extracted from logo dominant color because...] |
| **Industry fit** | [how it aligns with project domain] |
| **Cultural note** | [any cultural considerations] |
| **Contrast on white** | [X.XX:1] — [PASS/FAIL] WCAG AA |
| **Contrast on black** | [X.XX:1] — [PASS/FAIL] WCAG AA |

#### Shade Scale
| Token | Hex | Usage | Contrast on White |
|-------|-----|-------|--------------------|
| primary-50 | #XXXXXX | Subtle backgrounds | N/A (background) |
| primary-100 | #XXXXXX | Hover backgrounds | N/A |
| primary-200 | #XXXXXX | Borders, dividers | N/A |
| primary-300 | #XXXXXX | Disabled states | [X:1] |
| primary-400 | #XXXXXX | Icons (non-text) | [X:1] |
| primary-500 | #XXXXXX | **Base (from logo)** | [X:1] |
| primary-600 | #XXXXXX | Hover on buttons | [X:1] |
| primary-700 | #XXXXXX | Active/pressed | [X:1] |
| primary-800 | #XXXXXX | Dark mode primary | [X:1] |
| primary-900 | #XXXXXX | Headings on light | [X:1] |

### Secondary Color: [Color Name] (#XXXXXX)

| Attribute | Detail |
|-----------|--------|
| **Why chosen** | [relationship to primary — complementary/analogous/from logo] |
| **Color harmony** | [which color theory rule: complementary, split-complementary, triadic, analogous] |
| **Why this harmony** | [e.g., "Complementary chosen for maximum contrast between primary actions and secondary elements"] |

[Same shade scale as primary]

### Accent Color: [Color Name] (#XXXXXX)

| Attribute | Detail |
|-----------|--------|
| **Why chosen** | [purpose: call-to-action visibility, notification badges, etc.] |
| **Usage rule** | Used sparingly — max 10% of any screen |
| **Why limited** | Accent loses impact when overused; scarcity = attention |

### Semantic Colors

| Token | Hex | Usage | Why This Exact Color |
|-------|-----|-------|---------------------|
| success | #16A34A | Positive actions | Green is universally associated with "go/good." This specific green (600 weight) has 4.5:1 contrast on white |
| warning | #D97706 | Caution states | Amber signals caution without alarm. Darker than yellow for readability |
| error | #DC2626 | Error states | Red signals danger/stop. This red is vibrant enough to draw attention but not so bright it's jarring |
| info | #0891B2 | Information | Cyan is calm and non-urgent. Distinct from primary blue to avoid confusion |

### Palette Harmony Explanation
```
[Explain the overall color theory behind the palette]
[e.g., "This palette uses a split-complementary harmony with blue primary 
and orange/amber accents. This provides strong visual contrast while 
remaining more approachable than a direct complementary scheme."]
```

---

## 4. Typography

### Primary Font: [Font Name]

| Attribute | Detail |
|-----------|--------|
| **Category** | [Sans-Serif / Serif / Monospace] |
| **Usage** | [Headings / Body / Both] |
| **Why this font** | [detailed reason — personality, readability, brand match] |
| **Personality match** | [e.g., "Inter's neutral geometry projects professionalism and modernity, aligning with the brand's tech-forward personality"] |
| **Readability** | [e.g., "Large x-height improves screen readability; open apertures aid small-size legibility"] |
| **Performance** | [file size, variable font support, subsetting strategy] |
| **Language support** | [which scripts/languages supported] |
| **License** | [license type and URL] |
| **Alternative rejected** | [Font X] — rejected because [specific reason] |
| **Alternative rejected** | [Font Y] — rejected because [specific reason] |

### Secondary Font: [Font Name] (if applicable)

| Attribute | Detail |
|-----------|--------|
| **Why a second font** | [e.g., "Serif body text improves long-form readability while sans-serif headings maintain modern hierarchy"] |
| **Pairing rationale** | [e.g., "Contrasting category (serif vs sans) creates clear hierarchy. Similar x-height ensures visual harmony in mixed-use contexts"] |
| **When NOT to use second font** | [e.g., "Mobile screens < 375px use primary font only for consistency"] |

### Why NOT These Fonts

| Font Considered | Why Rejected |
|----------------|-------------|
| [Font A] | [too similar to primary — no hierarchy contrast] |
| [Font B] | [poor CJK/Cyrillic support — fails i18n requirement] |
| [Font C] | [400KB+ file — exceeds performance budget of 100KB for fonts] |
| [Font D] | [personality too playful — doesn't match corporate brand tone] |

### Type Scale

| Level | Size | Weight | Line Height | Letter Spacing | Rationale |
|-------|------|--------|-------------|---------------|-----------|
| Display | 56px | 700 | 1.1 | -0.02em | Tight tracking at large sizes reduces visual gaps |
| H1 | 40px | 700 | 1.2 | -0.01em | Page-level hierarchy, bold for scannability |
| H2 | 32px | 600 | 1.25 | 0 | Section breaks, semibold differentiates from H1 |
| H3 | 24px | 600 | 1.3 | 0 | Sub-section, size gap from H2 maintains hierarchy |
| H4 | 20px | 600 | 1.4 | 0 | Component-level heading |
| Body | 16px | 400 | 1.6 | 0 | WCAG minimum for comfortable reading |
| Small | 14px | 400 | 1.5 | 0.01em | Slight tracking improves small-size readability |
| Caption | 12px | 500 | 1.5 | 0.02em | Medium weight + tracking compensates for small size |

**Scale ratio: 1.25 (Major Third)**
**Why:** Provides clear visual hierarchy without excessive size jumps. More dramatic than Minor Third (1.125, too flat) but more practical than Golden Ratio (1.618, too extreme for UI).

---

## 5. Spacing System

| Token | Value | Usage | Rationale |
|-------|-------|-------|-----------|
| space-0.5 | 2px | Hairline gaps | Sub-pixel rounding on some screens — use sparingly |
| space-1 | 4px | Inline gaps, icon padding | Minimum perceivable spacing unit |
| space-2 | 8px | Compact elements | Standard button padding, form gaps |
| space-3 | 12px | Content gaps | Comfortable text-to-element spacing |
| space-4 | 16px | Card padding | Standard content container padding |
| space-6 | 24px | Section gaps | Clear boundary between related content |
| space-8 | 32px | Component separation | Distinct visual grouping |
| space-12 | 48px | Major sections | Clear section boundary |
| space-16 | 64px | Page sections | Full visual break |
| space-24 | 96px | Hero spacing | Dramatic white space for impact |

**Base unit: 4px**
**Why 4px:** Aligns with Material Design 4dp grid, iOS 4pt grid, and hardware pixel boundaries on 2x/3x screens. Prevents subpixel rendering artifacts.

---

## 6. Border Radius

| Token | Value | Usage | Rationale |
|-------|-------|-------|-----------|
| radius-none | 0px | Tables, dividers | Sharp edges for structural elements |
| radius-sm | 4px | Inputs, small buttons | Subtle softening without feeling "bubbly" |
| radius-md | 8px | Cards, modals | Friendly but professional feel |
| radius-lg | 16px | Feature cards, images | More playful, draws attention |
| radius-xl | 24px | Containers, hero sections | Statement pieces |
| radius-full | 9999px | Avatars, pills, badges | Perfect circles/capsules |

**Brand personality → Radius mapping:**
- Corporate/Serious → 2-4px (sharp, structured)
- Modern/Tech → 6-8px (balanced)
- Friendly/Consumer → 12-16px (soft, approachable)
- Playful → 16-24px (rounded, fun)

---

## 7. Shadows & Elevation

| Token | Value | Usage | Rationale |
|-------|-------|-------|-----------|
| shadow-xs | 0 1px 2px rgba(0,0,0,0.05) | Subtle lift | Cards resting on surface |
| shadow-sm | 0 2px 4px rgba(0,0,0,0.06) | Default cards | Clear but gentle elevation |
| shadow-md | 0 4px 8px rgba(0,0,0,0.08) | Hover states | Feedback on interaction |
| shadow-lg | 0 8px 16px rgba(0,0,0,0.1) | Dropdowns, popovers | Floating elements |
| shadow-xl | 0 16px 32px rgba(0,0,0,0.12) | Modals | Maximum elevation |

**Shadow color:** Uses neutral with brand primary tint (optional) for cohesion.
**Why these specific values:** Each level doubles the previous, creating a clear visual hierarchy. Opacity stays under 12% to avoid heavy/dated look.

---

## 8. Iconography

| Attribute | Decision | Rationale |
|-----------|----------|-----------|
| Style | [Outline / Solid / Duotone] | [e.g., "Outline matches the brand's minimal/clean personality"] |
| Library | [Lucide / Heroicons / Phosphor] | [e.g., "Lucide: MIT license, tree-shakeable, consistent stroke width"] |
| Size scale | 16/20/24/32/48px | Aligned with 4px grid and type scale |
| Stroke width | 1.5px (outline) | [e.g., "Balances visibility and elegance at 24px default"] |

---

## 9. Motion & Animation

| Property | Value | Rationale |
|----------|-------|-----------|
| Easing (enter) | cubic-bezier(0.0, 0.0, 0.2, 1.0) | Deceleration curve — elements "arrive" naturally |
| Easing (exit) | cubic-bezier(0.4, 0.0, 1.0, 1.0) | Acceleration curve — elements "depart" quickly |
| Easing (standard) | cubic-bezier(0.4, 0.0, 0.2, 1.0) | For property changes (color, size) |
| Duration (micro) | 100ms | Hover states, toggles — instant feedback |
| Duration (short) | 200ms | Button press, input focus — responsive |
| Duration (medium) | 300ms | Modals, drawers — smooth but not slow |
| Duration (long) | 500ms | Page transitions — dramatic but not sluggish |

**Why these curves:** Based on Material Design motion principles. Natural deceleration (enter) feels physical; sharp acceleration (exit) doesn't block user.

**Animation rules:**
- `prefers-reduced-motion: reduce` → disable all non-essential animations
- Never animate layout shifts (CLS penalty)
- Loading skeletons instead of spinners (less cognitive load)

---

## 10. Dark Mode

| Element | Light Mode | Dark Mode | Rationale |
|---------|-----------|-----------|-----------|
| Background | white (#FFFFFF) | gray-900 (#0F172A) | Not pure black (#000) — reduces eye strain on OLED |
| Surface | gray-50 (#F8FAFC) | gray-800 (#1E293B) | Subtle elevation above background |
| Text | gray-900 (#0F172A) | gray-100 (#F1F5F9) | Not pure white — reduces contrast strain |
| Primary | primary-500 | primary-400 | Lighter shade for visibility on dark bg |
| Border | gray-200 | gray-700 | Subtle separation, not harsh lines |
| Shadow | rgba(0,0,0,0.1) | rgba(0,0,0,0.4) | Darker shadows on dark mode for visibility |

---

## 11. Design Decision Log

| DDR# | Decision | Why | Alternatives Rejected |
|------|----------|-----|----------------------|
| DDR-001 | [Color choice] | [rationale] | [alternatives + why rejected] |
| DDR-002 | [Font choice] | [rationale] | [alternatives + why rejected] |
| DDR-003 | [Radius style] | [rationale] | [alternatives + why rejected] |
| DDR-004 | [Icon library] | [rationale] | [alternatives + why rejected] |
| DDR-005 | [Scale ratio] | [rationale] | [alternatives + why rejected] |

---

## Document Info
| Field | Value |
|-------|-------|
| Generated | [date] |
| Logo Source | knowledge/templates/[logo_file] |
| Status | [DRAFT/APPROVED/IMPLEMENTED] |
| Approved By | [user/client] |
