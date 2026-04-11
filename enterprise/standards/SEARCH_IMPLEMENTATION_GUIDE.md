# Search Implementation Guide

> **Compliance References:**
> - Based on: PostgreSQL Full-Text Search, Elasticsearch
> - Spec: Inverted index, BM25 scoring
> - Controls: Autocomplete, faceted search
> - See also: [governance/STANDARDS_COMPLIANCE_MATRIX.md](../STANDARDS_COMPLIANCE_MATRIX.md)

## Purpose
Standards for full-text search, filtering, and autocomplete.

---

## 1. Search Strategy Selection

| Approach | Data Size | Complexity | Usage |
|----------|-----------|-----------|-------|
| **DB LIKE/ILIKE** | < 10K records | Low | MVP, small projects |
| **DB Full-Text** (tsvector) | < 1M records | Medium | PostgreSQL projects |
| **Elasticsearch/OpenSearch** | > 1M records | High | Big data, advanced search |
| **Meilisearch/Typesense** | < 10M records | Medium | Quick setup, typo tolerance |
| **Algolia** | Any | Low (SaaS) | If you don't want to host |

---

## 2. API Design

### Simple Search
```
GET /api/v1/products?search=blue+shoes&page=1&limit=20
```

### Advanced Filtering
```
GET /api/v1/products?search=shoes&category=sports&price_min=100&price_max=500&brand=nike,adidas&sort=price&order=asc
```

### Autocomplete
```
GET /api/v1/search/suggest?q=sho&limit=5

Response:
{
  "suggestions": [
    { "text": "shoes", "category": "Products", "count": 145 },
    { "text": "shoe care", "category": "Products", "count": 23 },
    { "text": "shoe maintenance", "category": "Blog", "count": 5 }
  ]
}
```

---

## 3. PostgreSQL Full-Text Search

### Table Preparation
```sql
-- Add tsvector column
ALTER TABLE products ADD COLUMN search_vector tsvector;

-- Auto-update trigger
CREATE FUNCTION products_search_update() RETURNS trigger AS $$
BEGIN
  NEW.search_vector :=
    setweight(to_tsvector('turkish', coalesce(NEW.name, '')), 'A') ||
    setweight(to_tsvector('turkish', coalesce(NEW.description, '')), 'B') ||
    setweight(to_tsvector('turkish', coalesce(NEW.brand, '')), 'C');
  RETURN NEW;
END $$ LANGUAGE plpgsql;

CREATE TRIGGER products_search_trigger
  BEFORE INSERT OR UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION products_search_update();

-- GIN index
CREATE INDEX idx_products_search ON products USING GIN(search_vector);
```

### Query
```sql
SELECT id, name, ts_rank(search_vector, query) AS relevance
FROM products, plainto_tsquery('turkish', 'blue shoes') query
WHERE search_vector @@ query
ORDER BY relevance DESC
LIMIT 20;
```

---

## 4. Frontend Autocomplete

### UX Rules
| Rule | Detail |
|------|--------|
| Debounce | 300ms (not on every keystroke, when idle) |
| Min characters | Start searching after 2 characters |
| Max results | 5-8 suggestions |
| Keyboard navigation | Arrow keys + Enter |
| Highlight | Highlight the search term in results |
| Recent searches | Show last 5 searches |
| Loading | Spinner during search |
| No results | "No results found" + suggestions |

---

## 5. Performance Targets

| Metric | Target |
|--------|--------|
| Autocomplete response | < 100ms |
| Full search response | < 300ms |
| Indexing (single record) | < 50ms |
| Bulk indexing (1000 records) | < 5s |

---

## Related Documents
- `governance/standards/API_STYLE_GUIDE.md` - API design
- `governance/standards/CACHING_STRATEGY.md` - Search result caching
- `governance/standards/PERFORMANCE_BUDGET.md` - Performance targets
