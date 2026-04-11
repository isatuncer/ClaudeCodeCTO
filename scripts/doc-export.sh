#!/usr/bin/env bash
# ============================================================
# ClaudeCodeCTO — Document Export
# Converts MD to PDF and/or DOCX with professional formatting
#
# Usage:
#   bash scripts/doc-export.sh <file.md>              # Both PDF + DOCX
#   bash scripts/doc-export.sh <file.md> --pdf         # PDF only
#   bash scripts/doc-export.sh <file.md> --docx        # DOCX only
#   bash scripts/doc-export.sh docs/latest/ --all      # Export all in dir
# ============================================================

set -uo pipefail

INPUT="${1:-}"
FORMAT_PDF=true
FORMAT_DOCX=true
EXPORT_ALL=false

# Parse flags
shift || true
while [[ $# -gt 0 ]]; do
    case "$1" in
        --pdf)  FORMAT_DOCX=false ;;
        --docx) FORMAT_PDF=false ;;
        --all)  EXPORT_ALL=true ;;
    esac
    shift
done

if [ -z "$INPUT" ]; then
    echo "Usage: bash scripts/doc-export.sh <file.md> [--pdf] [--docx] [--all]"
    exit 1
fi

# Check pandoc
if ! command -v pandoc &>/dev/null; then
    echo "ERROR: pandoc is required but not installed."
    echo ""
    echo "Install:"
    echo "  macOS:   brew install pandoc"
    echo "  Linux:   sudo apt install pandoc"
    echo "  Windows: choco install pandoc  OR  winget install JohnMacFarlane.Pandoc"
    exit 1
fi

export_file() {
    local md_file="$1"
    local base="${md_file%.md}"
    local name=$(basename "$base")

    echo "  Exporting: $name"

    if [ "$FORMAT_PDF" = true ]; then
        # Try wkhtmltopdf first, then xelatex, then HTML fallback
        if command -v wkhtmltopdf &>/dev/null; then
            pandoc "$md_file" -o "${base}.pdf" \
                --pdf-engine=wkhtmltopdf \
                --toc --toc-depth=3 \
                -V margin-top=20mm -V margin-bottom=20mm \
                -V margin-left=25mm -V margin-right=25mm \
                2>/dev/null && echo "    ✓ PDF (wkhtmltopdf)" || echo "    ✗ PDF failed"
        elif pandoc --list-output-formats 2>/dev/null | grep -q pdf; then
            pandoc "$md_file" -o "${base}.pdf" \
                --toc --toc-depth=3 \
                -V geometry:margin=2.5cm \
                -V fontsize=11pt \
                2>/dev/null && echo "    ✓ PDF" || echo "    ✗ PDF failed (install wkhtmltopdf or texlive)"
        else
            # HTML fallback
            pandoc "$md_file" -o "${base}.html" \
                --toc --toc-depth=3 \
                --standalone --self-contained \
                2>/dev/null && echo "    ✓ HTML (PDF engine not available)" || echo "    ✗ Export failed"
        fi
    fi

    if [ "$FORMAT_DOCX" = true ]; then
        pandoc "$md_file" -o "${base}.docx" \
            --toc --toc-depth=3 \
            --highlight-style=tango \
            2>/dev/null && echo "    ✓ DOCX" || echo "    ✗ DOCX failed"
    fi
}

echo "=== ClaudeCodeCTO Document Export ==="
echo ""

if [ "$EXPORT_ALL" = true ] && [ -d "$INPUT" ]; then
    count=0
    find "$INPUT" -name "*.md" -type f | sort | while read -r f; do
        export_file "$f"
        count=$((count + 1))
    done
    echo ""
    echo "Exported from: $INPUT"
elif [ -f "$INPUT" ]; then
    export_file "$INPUT"
else
    echo "ERROR: File or directory not found: $INPUT"
    exit 1
fi

echo ""
echo "Done."
