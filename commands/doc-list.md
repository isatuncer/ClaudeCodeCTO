---
description: "List all project documents with version, status, and category. Shows document coverage against the 197-document enterprise standard. Usage: /doc-list"
---

# Document List

Show all project documents, their versions, and identify missing documents.

## Steps

1. **Scan the docs/ directory**:
   ```bash
   find docs/ -name "*.md" -type f 2>/dev/null | sort
   ```

2. **Parse metadata** from each document's YAML frontmatter (title, version, status, category)

3. **Display document inventory** as a table:
   ```
   | Category          | Document              | Version | Status   | PDF | DOCX |
   |-------------------|-----------------------|---------|----------|-----|------|
   | Requirements      | SRS                   | v1.0    | Approved | ✓   | ✓    |
   | Requirements      | BRD                   | v1.0    | Draft    | ✗   | ✗    |
   | Architecture      | HLD                   | —       | MISSING  | —   | —    |
   ```

4. **Show coverage stats**:
   - Total documents created vs 197 standard types
   - Per-category completion percentage
   - Missing critical documents (HIGH priority)

5. **Recommend next documents** based on project phase and what's missing

6. **Show version history** if `--history` flag is passed:
   ```
   SRS: v1.0 (2026-04-10, Draft) → v1.1 (2026-04-12, Review) → v1.2 (2026-04-15, Approved)
   ```
