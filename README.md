# Voog Support Guides - AI-Ready Content Extraction

A comprehensive system for extracting and converting Voog support documentation into AI-friendly formats for content generation, analysis, and automation.

## 🎯 Overview

This repository contains tools to extract Voog support guides from HTML format and convert them into multiple AI-friendly formats:
- **Individual Markdown files** with rich metadata
- **Aggregated Markdown files** for broad analysis
- **JSON structure** for programmatic access

## 📁 Repository Structure

```
voog-support-guides-pages/
├── en/                          # English HTML source files
├── et/                          # Estonian HTML source files
├── markdown-content/            # Extracted markdown files
│   ├── en/                      # English markdown files
│   ├── et/                      # Estonian markdown files
│   └── aggregated/              # Combined content files
├── json-content/                # Machine-readable JSON structure
├── scripts/                     # Automation scripts
│   ├── extract-to-markdown.sh   # Main extraction script
│   ├── check-updates.sh         # Update detection
│   ├── automated-workflow.sh    # Complete workflow
│   └── validate-extraction.sh   # Quality validation
└── README.md                    # This file
```

## 🚀 Quick Start

### Extract Content to Markdown
```bash
# Extract all HTML content to markdown
./scripts/extract-to-markdown.sh
```

### Check for Updates
```bash
# Check if any content has been updated on Voog servers
./scripts/check-updates.sh all
```

### Run Complete Workflow
```bash
# Check for updates, extract, and validate
./scripts/automated-workflow.sh
```

## 📊 Content Statistics

- **Total Articles**: 224 (109 English + 115 Estonian)
- **Sections**: 18 per language
- **Output Formats**: 3 (Individual MD, Aggregated MD, JSON)
- **Total Content**: ~400KB of clean markdown

## 🛠️ Scripts Overview

### Core Scripts
- **`extract-to-markdown.sh`**: Converts HTML to clean markdown with metadata
- **`check-updates.sh`**: Detects changes using HTTP headers
- **`automated-workflow.sh`**: Complete pipeline with backup and validation
- **`validate-extraction.sh`**: Quality assurance and validation

### Output Formats
1. **Individual Files**: `markdown-content/en/section/article.md`
2. **Aggregated Files**: `markdown-content/aggregated/all-content-en.md`
3. **JSON Index**: `json-content/content-index.json`

## 📋 Usage Examples

### For AI Content Generation
```bash
# Use individual files for targeted content
cat markdown-content/en/managing-your-blog/starting-your-first-blog-with-voog.md

# Use aggregated files for broad analysis
cat markdown-content/aggregated/all-content-en.md

# Use JSON for programmatic access
cat json-content/content-index.json
```

### For Content Updates
```bash
# Check for updates
./scripts/check-updates.sh all

# Extract updated content
./scripts/extract-to-markdown.sh

# Run complete workflow
./scripts/automated-workflow.sh
```

## 🔧 Configuration

The system supports:
- **Multiple languages**: English and Estonian
- **Incremental updates**: Only processes changed content
- **Quality validation**: Ensures extraction quality
- **Backup system**: Automatic backups before changes

## 📈 Output Quality

Each extracted markdown file includes:
- **Title**: Article title
- **Section**: Content category
- **Language**: Source language
- **Original URL**: Source location
- **Extraction timestamp**: When content was processed
- **Clean content**: HTML-free, AI-ready text

## 🎯 Use Cases

- **AI Content Generation**: Blog posts, tutorials, documentation
- **Content Analysis**: SEO optimization, content gaps
- **Automation**: Automated content updates and monitoring
- **Research**: Content structure and organization analysis

## 📝 Notes

- Content is extracted from Voog's public support documentation
- All scripts are designed to be respectful to Voog's servers
- The system includes error handling and validation
- Output is optimized for AI processing and analysis

---

**Ready for AI-powered content generation and analysis!** 🚀
