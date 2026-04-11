# SEO Specialist Skill Definition

## Role
Search engine optimization, technical SEO, content SEO, and performance improvement.

---

## Responsibilities

| Area | Detail |
|------|--------|
| Technical SEO | Meta tags, sitemap, robots.txt, canonical, hreflang |
| Structured Data | JSON-LD schema markup (Product, Article, FAQ, etc.) |
| Core Web Vitals | LCP, INP, CLS optimization |
| Page Speed | Image optimization, lazy loading, code splitting, CDN |
| Crawlability | Render strategy (SSR/SSG), internal linking |
| Mobile SEO | Mobile-first indexing compliance |
| Analytics | Search Console, GA4 integration |
| Content SEO | Heading structure, meta description, keywords |

---

## Technical SEO Checklist

### For Every Page (MANDATORY)
- [ ] `<title>` unique, 50-60 characters
- [ ] `<meta name="description">` unique, 150-160 characters
- [ ] `<h1>` ONE per page, containing keyword
- [ ] `<h2>-<h6>` hierarchical (no skipping)
- [ ] `<img alt="">` descriptive alt text on all images
- [ ] `<a>` with meaningful anchor text (NOT "click here")
- [ ] Canonical URL: `<link rel="canonical" href="...">`
- [ ] Open Graph meta (Facebook/LinkedIn sharing)
- [ ] Twitter Card meta
- [ ] Mobile viewport: `<meta name="viewport" content="width=device-width, initial-scale=1">`

### Site-Wide
- [ ] `robots.txt` correct (not blocking important pages)
- [ ] XML Sitemap (`/sitemap.xml`) created and up to date
- [ ] SSL/HTTPS (on all pages)
- [ ] Custom designed 404 page (with navigation)
- [ ] 301 redirects correct (old URL -> new URL)
- [ ] Hreflang (if multi-language)
- [ ] Internal linking strategy (no orphan pages)

---

## Structured Data (JSON-LD)

### Organization
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "name": "[COMPANY_NAME]",
  "url": "https://[DOMAIN]",
  "logo": "https://[DOMAIN]/logo.png",
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+90-XXX-XXX-XXXX",
    "contactType": "customer service"
  }
}
</script>
```

### BreadcrumbList
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    { "@type": "ListItem", "position": 1, "name": "Home", "item": "https://example.com" },
    { "@type": "ListItem", "position": 2, "name": "Products", "item": "https://example.com/products" },
    { "@type": "ListItem", "position": 3, "name": "Product Name" }
  ]
}
</script>
```

### Other Schema Types
| Type | Usage |
|------|-------|
| Product | E-commerce product page |
| Article / BlogPosting | Blog/news |
| FAQ | FAQ page |
| LocalBusiness | Physical store |
| Event | Event |
| Review | User reviews |
| HowTo | Step-by-step guide |
| JobPosting | Job listing |

---

## Render Strategy

| Strategy | SEO | Performance | Usage |
|----------|-----|-----------|-------|
| **SSG** (Static) | Excellent | Excellent | Blog, documentation, landing |
| **SSR** (Server) | Excellent | Good | E-commerce, dynamic content |
| **ISR** (Incremental) | Excellent | Excellent | Frequently updated static |
| **CSR** (Client) | POOR | Good | Dashboard, admin panel (SEO not needed) |

> **Rule:** Pages that need to appear in search engines MUST be SSG or SSR.

---

## Image Optimization

| Rule | Detail |
|------|--------|
| Format | WebP (fallback: JPEG), AVIF (modern browsers) |
| Size | Max width 1920px, quality 80% |
| Responsive | Different sizes with `srcset` |
| Lazy loading | `loading="lazy"` (EXCEPT above-fold) |
| Alt text | Descriptive, max 125 characters |
| File name | `blue-sport-shoes.webp` (SEO friendly) |
| CDN | All images served from CDN |

---

## Analytics Integration

### Google Search Console
- Site verification (DNS or HTML tag)
- Submit sitemap
- Monitor Core Web Vitals
- Monitor Coverage (index status)
- Search performance (query, impression, click)

### Google Analytics 4 (GA4)
```typescript
// GDPR/KVKK compliant - load AFTER cookie consent
if (cookieConsent.analytics) {
  gtag('config', 'G-XXXXXXXXXX', {
    anonymize_ip: true,          // IP anonymization
    cookie_flags: 'SameSite=None;Secure',
    send_page_view: true,
  });
}
```

---

## SEO Performance Targets

| Metric | Target | Measurement |
|--------|--------|-------------|
| LCP | < 2.5s | PageSpeed Insights |
| INP | < 200ms | Chrome UX Report |
| CLS | < 0.1 | PageSpeed Insights |
| Mobile Usability | 0 errors | Search Console |
| Index Coverage | > 95% valid | Search Console |
| Lighthouse SEO | > 90 | Lighthouse CI |

---

## Related Documents
- `governance/standards/ACCESSIBILITY_GUIDELINES.md`
- `governance/standards/UI_UX_TESTING_STRATEGY.md` (Core Web Vitals)
- `governance/standards/I18N_GUIDE.md` (hreflang)
- `governance/templates/COOKIE_POLICY_TEMPLATE.md` (analytics consent)
