# Voog Support Guides - AI-Ready Content Extraction

A comprehensive system for extracting and converting Voog blog articles into AI-friendly formats for content analysis, marketing strategy, and content generation.

## 🎯 Overview

This repository contains tools to extract Voog support guides from their public support pages and convert them into multiple AI-friendly formats:
- **Individual Markdown files** with rich metadata (author, date, tags, categories)
- **Aggregated Markdown files** for broad analysis
- **JSON structure** for programmatic access
- **Marketing analysis** (in excluded `analysis/` directory)

## 📁 Repository Structure

```
voog-support-guides/
├── en/                          # English support HTML source files
├── et/                          # Estonian support HTML source files
├── markdown-content/            # Extracted markdown files
│   ├── en/                      # English support markdown files
│   ├── et/                      # Estonian support markdown files
│   └── aggregated/              # Combined content files
├── json-content/                # Machine-readable JSON structure
├── scripts/                     # Automation scripts
│   ├── fetch-all-support.sh     # Main fetching script
│   ├── extract_support_to_markdown.py # HTML to markdown conversion (Python)
│   ├── check-updates.sh         # Update detection
│   └── automated-workflow.sh    # Complete workflow
├── local-content/               # AI-generated content (excluded from GitHub)
├── analysis/                    # Marketing analysis (excluded from GitHub)
└── README.md                    # This file
```

## 🚀 Quick Start

### Fetch Support Guides
```bash
# Fetch all support guides from Voog
./scripts/fetch-all-support.sh
```

### Extract Content to Markdown (Python)
```bash
# Create venv, install deps, rebuild markdown and indexes
python3 -m venv "Support Guides/.venv"
source "Support Guides/.venv/bin/activate"
pip install beautifulsoup4 lxml markdownify
python scripts/extract_support_to_markdown.py
```

### Check for Updates
```bash
# Check if any blog articles have been updated
./scripts/check-updates.sh
```

### Run Complete Workflow
```bash
# Fetch, extract, and validate all content
./scripts/automated-workflow.sh
```

## 📊 Content Statistics

- **Blog Sources**: 
  - English: https://www.voog.com/blog/
  - Estonian: https://www.voog.com/blogi/
- **Output Formats**: 3 (Individual MD, Aggregated MD, JSON)
- **Metadata**: Author, date, tags, categories, publication info

## 🛠️ Scripts Overview

### Core Scripts
- **`fetch-blog-articles.sh`**: Discovers and downloads blog articles from Voog
- **`extract-to-markdown.sh`**: Converts HTML to clean markdown with metadata
- **`check-updates.sh`**: Detects new or updated blog articles
- **`automated-workflow.sh`**: Complete pipeline with backup and validation

### Output Formats
1. **Individual Files**: `markdown-content/en/article-name.md`
2. **Aggregated Files**: `markdown-content/aggregated/all-blog-content-en.md`
3. **JSON Index**: `json-content/blog-index.json` with metadata

## 📋 Usage Examples

### For Content Analysis
```bash
# Use individual files for targeted analysis
cat markdown-content/en/article-name.md

# Use aggregated files for broad analysis
cat markdown-content/aggregated/all-blog-content-en.md

# Use JSON for programmatic access
cat json-content/blog-index.json
```

### For Marketing Strategy
```bash
# Combine with support guides for comprehensive analysis
# (Analysis files stored in excluded analysis/ directory)
```

## 🔧 Configuration

The system supports:
- **Multiple languages**: English and Estonian blogs
- **Incremental updates**: Only fetches new/changed articles
- **Rich metadata**: Author, date, tags, categories
- **Respectful crawling**: Proper delays and error handling

## 📈 Output Quality

Each extracted markdown file includes:
- **Title**: Article title
- **Author**: Article author
- **Published Date**: Publication date
- **Tags**: Article tags
- **Categories**: Article categories
- **Original URL**: Source location
- **Extraction timestamp**: When content was processed
- **Clean content**: HTML-free, AI-ready text

## 🎯 Use Cases

- **Content Strategy**: Analyze Voog's blog topics and trends
- **Marketing Analysis**: Identify content gaps and opportunities
- **AI Content Generation**: Create marketing materials based on actual content
- **Competitive Analysis**: Understand Voog's content strategy
- **SEO Insights**: Analyze blog structure and optimization

## 📝 Notes

- Content is extracted from Voog's public blog pages
- All scripts are designed to be respectful to Voog's servers
- The system includes error handling and validation
- Output is optimized for AI processing and analysis
- Marketing analysis is stored in excluded `analysis/` directory

---

**Ready for AI-powered content analysis and marketing strategy!** 🚀
