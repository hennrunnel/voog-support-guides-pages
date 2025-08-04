# Voog Support Guides - Multilingual Documentation

Complete multilingual support documentation for Voog website builder, featuring both English and Estonian articles with cross-language navigation.

## 📊 Overview

This repository contains a complete mirror of Voog's support documentation in two languages:
- **English**: 109 articles across 17 sections
- **Estonian**: 115 articles across 17 sections

## 🚀 Quick Start

- **Main Index**: [index.html](index.html) - Multilingual overview
- **English Articles**: [en/index.html](en/index.html) - Browse English guides
- **Estonian Articles**: [et/index.html](et/index.html) - Vaata eestikeelseid juhendeid
- **Text Indexes**: [en/index.txt](en/index.txt) | [et/index.txt](et/index.txt)

📖 **Complete Usage Guide**: [USAGE.md](USAGE.md) - How to use with AI assistance and independently

## 📁 Repository Structure

```
voog-support-guides-pages/
├── index.html                 # Main multilingual index
├── update-articles.sh         # Smart article updater
├── fetch-log.txt             # Update logs
├── en/                       # English articles (109 files)
│   ├── index.html           # English index with search
│   ├── index.txt            # Plain text index
│   └── [17 sections]/       # Organized by topic
├── et/                       # Estonian articles (115 files)
│   ├── index.html           # Estonian index with search
│   ├── index.txt            # Plain text index
│   └── [17 sections]/       # Organized by topic
└── scripts/                  # Automation scripts
    ├── smart-fetch.sh       # Smart updater (respects server load)
    ├── fetch-all-support.sh # Full English fetcher
    ├── fetch-estonian.sh    # Full Estonian fetcher
    └── [index generators]   # Index creation scripts
```

## ✨ Features

- **Smart Updates**: Only downloads articles that have been updated on Voog's servers
- **Cross-Language Navigation**: Links between equivalent English and Estonian articles
- **Search & Filter**: Find articles quickly with built-in search functionality
- **Server-Friendly**: Respects Voog's servers with intelligent delays and update checking
- **Complete Coverage**: All support sections and articles from both languages
- **Image Support**: Properly displays images with absolute URLs

## 🔄 Smart Article Updates

The repository includes a smart updating system that respects Voog's servers:

### Easy Update (Recommended)
```bash
./update-articles.sh
```
Interactive script that lets you choose what to update.

### Manual Update
```bash
# Update all articles (English + Estonian)
./scripts/smart-fetch.sh all

# Update only English articles
./scripts/smart-fetch.sh en

# Update only Estonian articles
./scripts/smart-fetch.sh et
```

### Smart Features
- **Update Detection**: Uses HTTP `Last-Modified` headers to check for changes
- **Server Respect**: 0.5-second delays between requests
- **Selective Downloads**: Only fetches articles that have been updated
- **Automatic Indexing**: Regenerates indexes when articles are updated
- **Detailed Logging**: Complete log of all operations in `fetch-log.txt`

## 📋 Section Mapping

| Estonian | English |
|----------|---------|
| Blogi | managing-your-blog |
| Domeenid | your-website-addresses |
| E-pood | online-store |
| Keeled | all-about-languages |
| Kontakt | contact |
| Konto loomine | setting-up-your-account |
| Kujundus | your-websites-design |
| Lehed | managing-your-website-pages |
| Pildid ja failid | your-pictures-and-files |
| SEO | seo |
| Sisu haldamine | managing-your-content |
| Sisualad | content-areas |
| Statistika ja saidi haldamine | stats-and-maintenance |
| Tellimus | your-subscriptions |
| Veebiseminar | webinars |
| Videojuhendid | video-tutorials |
| Vormid | creating-and-managing-forms |

## 🛠 Development

### Prerequisites
- Bash shell
- `curl` for HTTP requests
- `sed`, `awk`, `grep` for text processing

### Testing
Run the comprehensive test suite to verify repository integrity:
```bash
./test.sh
```

The test suite checks:
- ✅ Directory structure and file validity
- ✅ HTML structure and title extraction
- ✅ Cross-language link integrity
- ✅ Index file completeness
- ✅ Script permissions and executability
- ✅ ETag file format and integrity
- ✅ Image URL fixes
- ✅ Article count validation
- ✅ Recent activity detection

### Script Usage Examples

```bash
# Initial fetch (full download)
./scripts/fetch-all-support.sh
./scripts/fetch-estonian.sh

# Smart updates (incremental)
./scripts/smart-fetch.sh all

# Generate indexes
./scripts/generate-simple-index.sh
./scripts/generate-estonian-index.sh
./scripts/generate-text-index.sh
./scripts/generate-estonian-text-index.sh
```

### Update Process
1. **Check for Updates**: Script checks HTTP headers for `Last-Modified` timestamps
2. **Compare with Local**: Compares remote timestamps with local file modification times
3. **Selective Download**: Only downloads articles that are newer on the server
4. **Apply Fixes**: Automatically applies image and URL fixes to downloaded content
5. **Regenerate Indexes**: Updates all index files when articles are modified

## 📚 Original Sources

- **English Support**: https://www.voog.com/support
- **Estonian Support**: https://www.voog.com/tugi

## 📝 Notes

- All articles are stored as HTML files with embedded CSS for proper image display
- Cross-language links are verified and tested to ensure they work correctly
- The smart fetcher respects server load and only downloads when necessary
- Indexes are automatically regenerated when articles are updated

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Quick Start for Contributors
```bash
git clone <repository-url>
cd voog-support-guides-pages
chmod +x scripts/*.sh *.sh
./test.sh
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Note**: This repository contains content from Voog's support documentation. The original content belongs to Voog and is used for educational and reference purposes.

## 🚀 GitHub Features

- **Automated Testing**: GitHub Actions run tests on every PR and weekly
- **Issue Tracking**: Report bugs and suggest improvements
- **Pull Requests**: Contribute code and documentation
- **Discussions**: Ask questions and share ideas

## 📊 Repository Status

![Tests](https://github.com/[username]/voog-support-guides-pages/workflows/Test%20Repository%20Integrity/badge.svg)
![Last Updated](https://img.shields.io/github/last-commit/[username]/voog-support-guides-pages)
![Repository Size](https://img.shields.io/github/repo-size/[username]/voog-support-guides-pages)
