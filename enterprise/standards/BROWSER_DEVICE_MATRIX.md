# Browser and Device Support Matrix

> **Compliance References:**
> - Based on: BrowserStack testing methodology
> - Spec: Can I Use compatibility data
> - Controls: Browser/device/OS support tiers
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Officially supported browser/device/operating system combinations.

---

## 1. Desktop Browsers

| Browser | Minimum Version | Engine | Priority | Testing |
|---------|----------------|--------|----------|---------|
| Chrome | Last 2 major | Chromium | P1 | Automation + Manual |
| Firefox | Last 2 major | Gecko | P1 | Automation + Manual |
| Safari | Last 2 major | WebKit | P1 | Automation + Manual |
| Edge | Last 2 major | Chromium | P2 | Automation |
| Opera | Last 1 major | Chromium | P3 | Manual (spot) |

## 2. Mobile Browsers

| Browser | Platform | Priority | Testing |
|---------|----------|----------|---------|
| Safari | iOS 16+ | P1 | Manual + Playwright |
| Chrome | Android 10+ | P1 | Manual + Playwright |
| Samsung Internet | Android | P2 | Manual (spot) |
| Firefox | Android | P3 | Reported bugs only |

## 3. Operating Systems

| OS | Minimum | Priority |
|----|---------|----------|
| Windows | 10+ | P1 |
| macOS | 13+ (Ventura) | P1 |
| Linux | Ubuntu 22.04+ | P3 |
| iOS | 16+ | P1 |
| Android | 10+ (API 29) | P1 |

## 4. Screen Resolutions

| Category | Width | Testing |
|----------|-------|---------|
| Mobile S | 320px | Yes |
| Mobile M | 375px | Yes |
| Mobile L | 425px | Yes |
| Tablet | 768px | Yes |
| Laptop | 1024px | Yes |
| Desktop | 1440px | Yes |
| Large Desktop | 1920px | Yes |
| 4K | 2560px | Spot test |

## 5. Support Level Definitions

| Level | Meaning | Action |
|-------|---------|--------|
| **P1 - Full Support** | All features must work | Test every sprint, bug = P1/P2 |
| **P2 - Good Support** | Core features must work, minor differences acceptable | Test before release |
| **P3 - Minimal** | Pages must render, some features may be missing | Reported bugs only |
| **Not Supported** | No guarantee | Bug reports closed (won't fix) |

## 6. Not Supported

- Internet Explorer (all versions)
- Chrome < 90
- Firefox < 90
- Safari < 15
- Android < 10
- iOS < 16
