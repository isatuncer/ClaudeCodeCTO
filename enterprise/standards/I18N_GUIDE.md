# Internationalization (i18n) & Localization (l10n) Guide

> **Compliance References:**
> - Based on: Unicode CLDR, ICU MessageFormat
> - Spec: W3C i18n Best Practices, BCP 47
> - Controls: Language tag format
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Standard approach for projects requiring multi-language support.

---

## 1. Core Rules

| Rule | Description |
|------|-------------|
| Hardcoded text FORBIDDEN | All UI texts must come from translation files |
| Key naming | `namespace.context.key` format: `auth.login.title` |
| Default language | `tr` (Turkish) or `en` (English) - depending on project |
| Fallback | If translation missing, fall back to default language |
| RTL support | If Arabic/Hebrew support needed, use CSS logical properties |

---

## 2. File Structure

```
src/
├── locales/
│   ├── tr/
│   │   ├── common.json        # Common texts (buttons, nav)
│   │   ├── auth.json           # Login/register
│   │   ├── dashboard.json      # Dashboard
│   │   └── errors.json         # Error messages
│   ├── en/
│   │   ├── common.json
│   │   ├── auth.json
│   │   ├── dashboard.json
│   │   └── errors.json
│   └── index.ts                # i18n configuration
```

---

## 3. Translation File Format

```json
{
  "auth": {
    "login": {
      "title": "Log In",
      "email": "Email Address",
      "password": "Password",
      "submit": "Sign In",
      "forgot_password": "Forgot my password",
      "no_account": "Don't have an account? {{link}}",
      "error": {
        "invalid": "Email or password is incorrect",
        "locked": "Your account is locked. Try again in {{minutes}} minutes."
      }
    }
  }
}
```

---

## 4. Things to Watch Out For

### Do Not Concatenate Strings
```
// WRONG
t('welcome') + ' ' + userName

// CORRECT
t('welcome_user', { name: userName })
// "Welcome, {{name}}!"
```

### Plural Forms
```json
{
  "items": {
    "zero": "No products",
    "one": "{{count}} product",
    "other": "{{count}} products"
  }
}
```

### Date/Time Formatting
```typescript
// WRONG
`${day}/${month}/${year}`

// CORRECT
new Intl.DateTimeFormat(locale, { dateStyle: 'medium' }).format(date)
// tr: "15 Oca 2026"
// en: "Jan 15, 2026"
```

### Currency
```typescript
new Intl.NumberFormat(locale, {
  style: 'currency',
  currency: 'TRY'
}).format(1234.56)
// tr: "₺1.234,56"
// en: "$1,234.56"
```

### Number Formatting
```typescript
new Intl.NumberFormat(locale).format(1234567)
// tr: "1.234.567"
// en: "1,234,567"
```

---

## 5. Framework-Specific Tools

| Framework | Tool | Installation |
|-----------|------|-------------|
| React/Next.js | next-intl / react-i18next | `npm i next-intl` |
| Vue/Nuxt | vue-i18n / @nuxtjs/i18n | `npm i vue-i18n` |
| Angular | @angular/localize / ngx-translate | Built-in |
| React Native | react-native-localize + i18next | `npm i react-native-localize` |
| Flutter | flutter_localizations | Built-in |
| Django | django.utils.translation | Built-in |
| Go | go-i18n | `go get github.com/nicksnyder/go-i18n` |

---

## 6. Testing

### Translation Completeness Check
```bash
# Check if all languages have the same keys
# Run in CI/CD
node scripts/check-translations.js
```

### Pseudo-localization
Test whether the UI breaks with translations without actual translations:
```
"Login" -> "[Ŀöĝíñ______]"  # Long text test
```
