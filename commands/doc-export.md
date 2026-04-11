---
description: "Export a markdown document to PDF and/or DOCX with professional formatting, headers, footers, and table of contents. Usage: /doc-export docs/v1.0/requirements/SRS_v1.0.md"
---

# Document Export

Convert markdown documents to professionally formatted PDF and DOCX files.

## Arguments

`$ARGUMENTS` is the path to the markdown file, optionally followed by format flags.

Examples:
- `/doc-export docs/v1.0/requirements/SRS_v1.0.md` — export to both PDF and DOCX
- `/doc-export docs/v1.0/architecture/HLD_v1.0.md --pdf` — PDF only
- `/doc-export docs/v1.0/testing/TEST_PLAN_v1.0.md --docx` — DOCX only
- `/doc-export docs/latest/ --all` — export all docs in latest version

## Steps

1. **Check prerequisites** — verify pandoc is installed:
   ```bash
   command -v pandoc &>/dev/null || echo "pandoc not found"
   ```
   If not installed, provide install instructions:
   - macOS: `brew install pandoc`
   - Linux: `sudo apt install pandoc`
   - Windows: `choco install pandoc` or `winget install pandoc`

2. **Parse the input file** — read the markdown and extract metadata from YAML frontmatter

3. **Generate PDF**:
   ```bash
   pandoc "$INPUT" -o "${INPUT%.md}.pdf" \
     --pdf-engine=wkhtmltopdf \
     --toc --toc-depth=3 \
     --metadata-file="$INPUT" \
     -V geometry:margin=2.5cm \
     -V fontsize=11pt \
     -V colorlinks=true \
     -V linkcolor=blue \
     --highlight-style=tango
   ```

   If wkhtmltopdf is not available, try:
   ```bash
   pandoc "$INPUT" -o "${INPUT%.md}.pdf" \
     --pdf-engine=xelatex \
     --toc --toc-depth=3 \
     -V geometry:margin=2.5cm
   ```

   If neither is available, try the built-in:
   ```bash
   pandoc "$INPUT" -o "${INPUT%.md}.html" --toc --standalone --self-contained
   ```

4. **Generate DOCX**:
   ```bash
   pandoc "$INPUT" -o "${INPUT%.md}.docx" \
     --toc --toc-depth=3 \
     --highlight-style=tango
   ```

5. **Report results** — show file paths and sizes of generated files

## Batch Export

When `--all` is specified with a directory:
```bash
find "$DIR" -name "*.md" -type f | while read -r f; do
    pandoc "$f" -o "${f%.md}.pdf" --toc 2>/dev/null
    pandoc "$f" -o "${f%.md}.docx" --toc 2>/dev/null
done
```

## Output Structure

```
docs/v1.0/requirements/
├── SRS_v1.0.md        ← source
├── SRS_v1.0.pdf       ← exported
└── SRS_v1.0.docx      ← exported
```
