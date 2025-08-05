# Voog Support Guides - AI-Friendly Markdown Content

This directory contains Voog support documentation converted to AI-friendly Markdown format.

## Structure

```
markdown-content/
├── en/                          # English articles by section
│   ├── all-about-languages/
│   ├── managing-your-blog/
│   └── ...
├── et/                          # Estonian articles by section
│   ├── keeled/
│   ├── blogi/
│   └── ...
├── aggregated/                  # Combined content files
│   ├── all-content-en.md       # All English content
│   ├── all-content-et.md       # All Estonian content
│   ├── content-by-section-en.md
│   └── content-by-section-et.md
└── README.md                    # This file
```

## Usage

### Individual Files
- Use individual `.md` files for targeted analysis
- Each file contains metadata (section, language, original URL)
- Clean content without HTML markup

### Aggregated Files
- `all-content-en.md` / `all-content-et.md`: Complete content for broad analysis
- `content-by-section-en.md` / `content-by-section-et.md`: Organized by topic

### JSON Structure
- See `../json-content/content-index.json` for programmatic access
- Machine-readable format with metadata

## Content Statistics

- **English Articles**:      109 across       17 sections
- **Estonian Articles**:      109 across       17 sections
- **Last Updated**: 2025-08-05 07:49:10 UTC

## AI-Friendly Features

- Clean Markdown format
- Preserved structure and metadata
- Cross-language linking maintained
- No HTML markup or navigation clutter
- Consistent formatting across all files

## Regeneration

To regenerate this content, run:
```bash
./scripts/extract-to-markdown.sh
```

