# Mobile Testing Strategy

> **Compliance References:**
> - Based on: ISTQB Mobile Testing Syllabus
> - Spec: Device matrix testing
> - Controls: Gesture, rotation, offline, performance
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Device matrix, test types, and automation for systematic testing on iOS and Android platforms.

---

## 1. Device Test Matrix

### iOS (Minimum)
| Device | iOS Version | Screen | Priority |
|--------|------------|--------|----------|
| iPhone SE 3 | iOS 16+ | 4.7" | P1 (small screen) |
| iPhone 14 | iOS 16+ | 6.1" | P1 (standard) |
| iPhone 15 Pro Max | iOS 17+ | 6.7" | P1 (large screen) |
| iPad Mini | iPadOS 16+ | 8.3" | P2 (tablet) |
| iPad Pro 11" | iPadOS 16+ | 11" | P3 (large tablet) |

### Android (Minimum)
| Device | Android | Screen | Priority |
|--------|---------|--------|----------|
| Pixel 6 | Android 12+ | 6.4" | P1 (stock Android) |
| Samsung Galaxy S23 | Android 13+ | 6.1" | P1 (Samsung UI) |
| Samsung Galaxy A54 | Android 13+ | 6.4" | P1 (mid-range, common) |
| Xiaomi Redmi Note 12 | Android 13+ | 6.67" | P2 (budget, common in TR) |
| Samsung Galaxy Tab S9 | Android 13+ | 11" | P3 (tablet) |

---

## 2. Mobile Test Types

| Test | Automation | Tool | When |
|------|-----------|------|------|
| Functional | Yes | Detox (RN) / XCTest / Espresso | Every PR |
| UI/visual | Partial | Screenshot test | Every PR |
| Performance | Manual + automation | Xcode Instruments / Android Profiler | End of sprint |
| Offline | Manual | Airplane mode | End of sprint |
| Push notification | Manual | Physical device | End of sprint |
| Deep link | Automation | Detox / Appium | Every PR |
| Permission | Manual | Physical device | Before release |
| Background/foreground | Manual | Physical device | Before release |
| Low network | Manual | Network conditioner | Before release |
| Battery consumption | Manual | Battery profiler | Before release |
| Memory leak | Automation | Leak Canary (Android) / Instruments (iOS) | End of sprint |

---

## 3. Mobile-Specific Test Scenarios

### Lifecycle
- [ ] No data loss when app is sent to background
- [ ] Session is valid when returning from background
- [ ] No crash in low memory conditions
- [ ] App state is preserved when phone call arrives
- [ ] No data loss on screen rotation

### Network Conditions
- [ ] Offline: Clear error message, previous data visible
- [ ] Slow network (3G): Appropriate timeout, skeleton loading
- [ ] Network switch (WiFi -> 4G): Connection not dropped
- [ ] When network returns: Pending operations complete

### Platform Specific
- [ ] iOS: Compatible with Notch/Dynamic Island
- [ ] iOS: Safe area correct
- [ ] iOS: Swipe-back gesture works
- [ ] Android: System back button works correctly
- [ ] Android: Soft keyboard doesn't cover input
- [ ] Android: Display correct at different DPIs

---

## Related Documents
- `departments/01/.../mobile_designer.md`
- `departments/03/mobile/README.md`
- `governance/standards/UI_UX_TESTING_STRATEGY.md`
