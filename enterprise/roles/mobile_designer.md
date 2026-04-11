# Mobile Designer Skill Definition

## Role
Native experience design for iOS and Android platforms, platform guidelines compliance, and mobile-specific UX patterns.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Platform Guidelines | iOS HIG (Human Interface Guidelines) + Material Design 3 compliance |
| Mobile Navigation | Tab bar, drawer, stack, bottom sheet, gesture-based |
| Touch Interaction | Swipe, long press, pinch, pull-to-refresh, haptic feedback |
| Adaptive Layout | Different screen sizes, orientation, Dynamic Type, Safe Area |
| Offline Design | Offline-first UI, sync indicator, cache strategy |
| Push Notification | Notification design, deep link, notification center |
| Onboarding | First-use experience, permission request, tutorial |
| App Store Asset | Icon, screenshot, feature graphic, store description |

---

## Platform Differences

### iOS vs Android Comparison
| Area | iOS (HIG) | Android (Material 3) |
|------|-----------|---------------------|
| Navigation | Tab Bar (bottom), Navigation Bar (top) | Bottom Navigation, Navigation Drawer |
| Going back | Top-left back button + swipe back | System back button + gesture |
| Button style | Rounded rect, system tint | FAB, filled/outlined/text |
| Typography | SF Pro (system) | Roboto (system) |
| Modal | Sheet (bottom to top) | Bottom Sheet, Dialog |
| Action menu | Action Sheet (from bottom) | Menu, Bottom Sheet |
| Date picker | Picker wheel / inline calendar | Date picker dialog |
| Alert | UIAlertController style | Material AlertDialog |
| Haptic | Taptic Engine (3 levels) | Vibration API |
| Safe area | Notch, Dynamic Island, Home Indicator | Status bar, navigation bar, cutout |

---

## Mobile Design Checklist

### Touch Target
- [ ] Minimum touch target: **44x44pt** (iOS) / **48x48dp** (Android)
- [ ] Minimum spacing between buttons: 8pt
- [ ] Interactive elements at least 16pt from edges

### Typography
- [ ] Minimum font: **11pt** (iOS) / **12sp** (Android)
- [ ] Body text: **17pt** (iOS) / **16sp** (Android)
- [ ] Dynamic Type support (iOS) / Font scale support (Android)
- [ ] Contrast ratio >= 4.5:1

### Navigation
- [ ] Return path from every screen exists
- [ ] Max 5 tabs (in tab bar)
- [ ] Breadcrumb or title chain in deep navigation
- [ ] Compatible with gesture navigation

### Form
- [ ] Correct input type (email keyboard, number pad, etc.)
- [ ] Auto-complete / autofill support
- [ ] Inline validation (not after submit)
- [ ] Form field visible when keyboard opens (scroll)
- [ ] Return/Next to move to next field
- [ ] Dismiss keyboard (tap outside or Done button)

### Performance Feel
- [ ] Skeleton loading (instead of blank page)
- [ ] Optimistic UI (instant response on button press)
- [ ] Pull-to-refresh
- [ ] Infinite scroll or pagination
- [ ] Image lazy loading + placeholder

### Offline
- [ ] Clear feedback in offline state ("No connection" banner)
- [ ] Pre-loaded data viewable offline
- [ ] Offline operations sent in sync order
- [ ] Sync status visible (syncing indicator)

---

## Screen Size Matrix

### iOS
| Device | Width | Height | Scale |
|--------|-------|--------|-------|
| iPhone SE 3 | 375pt | 667pt | 2x |
| iPhone 14 | 390pt | 844pt | 3x |
| iPhone 14 Pro Max | 430pt | 932pt | 3x |
| iPhone 15 Pro | 393pt | 852pt | 3x |
| iPad Mini | 744pt | 1133pt | 2x |
| iPad Pro 11" | 834pt | 1194pt | 2x |
| iPad Pro 12.9" | 1024pt | 1366pt | 2x |

### Android
| Category | Width | Example Device |
|----------|-------|----------------|
| Small | 320-360dp | Older devices |
| Normal | 360-400dp | Pixel 7, Galaxy S23 |
| Large | 400-480dp | Pixel 7 Pro, Galaxy S23 Ultra |
| Tablet | 600-840dp | Galaxy Tab, Pixel Tablet |
| Foldable (inner) | 674-841dp | Galaxy Z Fold |

---

## App Store Requirements

### iOS App Store
| Asset | Size | Format |
|-------|------|--------|
| App Icon | 1024x1024px | PNG (not transparent) |
| Screenshot (6.7") | 1290x2796px | PNG/JPG |
| Screenshot (6.5") | 1284x2778px | PNG/JPG |
| Screenshot (5.5") | 1242x2208px | PNG/JPG |
| iPad Screenshot | 2048x2732px | PNG/JPG |

### Google Play Store
| Asset | Size | Format |
|-------|------|--------|
| App Icon | 512x512px | PNG (32-bit) |
| Feature Graphic | 1024x500px | PNG/JPG |
| Screenshot | min 320px, max 3840px | PNG/JPG |
| Video | YouTube link | - |

---

## Notification Design

### Push Notification Anatomy
```
┌─────────────────────────────────┐
│ 📱 App Icon  App Name    now   │
│ Notification Title              │
│ Notification body text here...  │
│ [Action 1]  [Action 2]         │
└─────────────────────────────────┘
```

### Notification Rules
| Rule | Detail |
|------|--------|
| Title | Max 50 characters |
| Body | Max 150 characters |
| Deep link | Each notification directs to a screen |
| Action | Max 2 buttons (iOS) / 3 buttons (Android) |
| Silent | Non-critical notifications make no sound |
| Grouping | Same type notifications are grouped |
| Permission | Explain WHY we request permission on first time (pre-permission) |

---

## Widget / Lock Screen

### iOS Widget
| Size | Grid | Usage |
|------|------|-------|
| Small | 2x2 | Single info (weather, steps) |
| Medium | 4x2 | List or chart |
| Large | 4x4 | Detailed info |
| Lock Screen | Inline/Circular/Rect | Minimal info |

### Android Widget
| Size | Grid | Usage |
|------|------|-------|
| 1x1 - 4x1 | Horizontal strip | Quick action |
| 2x2 - 4x2 | Standard | Info + action |
| 4x3 - 4x4 | Large | List, chart |

---

## Deliverables
| Deliverable | Format | Phase |
|-------------|--------|-------|
| Platform compatibility report | Markdown | Phase 2 |
| Mobile wireframe (Lo-Fi) | Figma / Excalidraw | Phase 2 |
| Touch interaction spec | Markdown (gesture definitions) | Phase 2 |
| Mobile design system | Markdown + token definitions | Phase 2 |
| App Store asset list | Checklist | Phase 7 |
| Notification design spec | Markdown | Phase 6 |

---

## Related Documents
- `governance/standards/DESIGN_SYSTEM_GUIDE.md` - General design system
- `governance/standards/ACCESSIBILITY_GUIDELINES.md` - Accessibility
- `governance/standards/UI_UX_TESTING_STRATEGY.md` - UI testing
- `departments/01/.../ui_ux_designer.md` - General UI/UX role
- `departments/03/mobile/README.md` - Mobile development
