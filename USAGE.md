# Voog Support Guides - Usage Guide

This guide explains how to use the Voog Support Guides repository effectively, whether you're working with AI assistance or independently.

## 🚀 Quick Start

### Browse Documentation
- **Main Index**: Open `index.html` in your browser for a multilingual overview
- **English Articles**: Browse `en/index.html` for English support guides
- **Estonian Articles**: Browse `et/index.html` for Estonian support guides
- **Text Indexes**: Use `en/index.txt` or `et/index.txt` for plain text lists

### Update Articles
```bash
./update-articles.sh
```

### Run Tests
```bash
./test.sh
```

## 📚 Using the Repository with AI Assistance

### What AI Can Help With

#### 1. **Content Discovery & Navigation**
```
"Find all articles about SEO optimization"
"Show me Estonian articles about blog management"
"What's the difference between the English and Estonian versions of the domain settings article?"
```

#### 2. **Cross-Language Translation**
```
"Translate this English article title to Estonian"
"What's the Estonian equivalent of 'managing-your-blog'?"
"Find the English version of this Estonian article"
```

#### 3. **Technical Issues**
```
"Why aren't images displaying in this article?"
"Check if all cross-language links are working"
"Validate the HTML structure of these files"
```

#### 4. **Repository Maintenance**
```
"Update all articles from Voog's servers"
"Regenerate the indexes after changes"
"Run the test suite to check for issues"
```

### Effective AI Prompts

#### For Content Research
```
"Search through the English articles for content about [topic]"
"Find articles in both languages that discuss [feature]"
"Compare the coverage of [topic] between English and Estonian"
```

#### For Technical Support
```
"Check the repository structure and identify any missing files"
"Validate that all HTML files have proper titles and structure"
"Test the smart fetching system with a specific article"
```

#### For Maintenance Tasks
```
"Update the repository with the latest articles from Voog"
"Fix any broken cross-language links"
"Regenerate all index files"
```

## 🛠️ Independent Usage (Without AI)

### Daily Operations

#### 1. **Check for Updates**
```bash
# Interactive update (recommended)
./update-articles.sh

# Manual update
./scripts/smart-fetch-etag.sh all    # Both languages
./scripts/smart-fetch-etag.sh en     # English only
./scripts/smart-fetch-etag.sh et     # Estonian only
```

#### 2. **Verify Repository Health**
```bash
# Run comprehensive tests
./test.sh

# Check specific areas
grep -r "href=\"\.\./en/" et/ | wc -l  # Count ET→EN links
grep -r "href=\"\.\./et/" en/ | wc -l  # Count EN→ET links
```

#### 3. **Regenerate Indexes**
```bash
# After making changes
./scripts/generate-simple-index.sh
./scripts/generate-estonian-index.sh
./scripts/generate-text-index.sh
./scripts/generate-estonian-text-index.sh
```

### File Organization

#### Directory Structure
```
voog-support-guides-pages/
├── en/                          # English articles (111 files)
│   ├── index.html              # English index with search
│   ├── index.txt               # Plain text index
│   └── [17 sections]/          # Organized by topic
├── et/                          # Estonian articles (116 files)
│   ├── index.html              # Estonian index with search
│   ├── index.txt               # Plain text index
│   └── [17 sections]/          # Organized by topic
├── scripts/                     # Automation scripts
├── tests/                       # Test suite
├── .etags                       # ETag storage for smart updates
├── update-articles.sh           # Main update script
├── test.sh                      # Test runner
└── index.html                   # Main multilingual index
```

#### Section Mapping
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

### Troubleshooting

#### Common Issues

**1. Images Not Displaying**
```bash
# Check for protocol-relative URLs
grep -r 'src="//media.voog.com' en/ et/

# Fix if found
find en et -name "*.html" -exec sed -i '' 's|src="//media.voog.com|src="https://media.voog.com|g' {} \;
```

**2. Broken Cross-Language Links**
```bash
# Test all cross-links
./test.sh

# Check specific links
grep -o 'href="\.\./en/[^"]*"' et/*/*.html | while read link; do
    target=$(echo "$link" | sed 's|href="\.\./en/||' | sed 's|"||')
    if [[ ! -f "en/$target" ]]; then
        echo "BROKEN: $link"
    fi
done
```

**3. Smart Fetch Not Working**
```bash
# Check ETag file
cat .etags

# Check log file
tail -20 fetch-log.txt

# Test single article
curl -sI "https://www.voog.com/support/managing-your-website-pages/changing-page-addresses" | grep -i etag
```

**4. Indexes Out of Sync**
```bash
# Regenerate all indexes
./scripts/generate-simple-index.sh
./scripts/generate-estonian-index.sh
./scripts/generate-text-index.sh
./scripts/generate-estonian-text-index.sh
```

### Advanced Usage

#### Custom Scripts

**Find Articles by Content**
```bash
# Search for specific text in English articles
grep -r "SEO optimization" en/ --include="*.html"

# Search in Estonian articles
grep -r "SEO optimeerimine" et/ --include="*.html"
```

**Compare Article Sizes**
```bash
# Find largest articles
find en et -name "*.html" -exec stat -f "%z %N" {} \; | sort -n | tail -10
```

**Check for Duplicates**
```bash
# Find potential duplicate content
find en et -name "*.html" -exec shasum {} \; | sort | uniq -d
```

#### Batch Operations

**Update Specific Sections**
```bash
# Update only blog articles
./scripts/smart-fetch-etag.sh en
# Then manually copy only blog files from the updated content
```

**Backup Before Updates**
```bash
# Create backup
cp -r en en-backup-$(date +%Y%m%d)
cp -r et et-backup-$(date +%Y%m%d)
```

## 🔄 Workflow Examples

### Daily Maintenance
```bash
# 1. Check for updates
./update-articles.sh

# 2. Run tests
./test.sh

# 3. Check logs
tail -10 fetch-log.txt
```

### Weekly Review
```bash
# 1. Full repository health check
./test.sh

# 2. Check for broken links
grep -r "href=" en/ et/ | grep -v "voog.com" | grep -v "media.voog.com"

# 3. Verify article counts
echo "English: $(find en -name "*.html" | wc -l)"
echo "Estonian: $(find et -name "*.html" | wc -l)"
```

### Before Making Changes
```bash
# 1. Create backup
cp -r en en-backup-$(date +%Y%m%d)
cp -r et et-backup-$(date +%Y%m%d)

# 2. Run tests
./test.sh

# 3. Make changes...

# 4. Test again
./test.sh

# 5. Regenerate indexes if needed
./scripts/generate-simple-index.sh
./scripts/generate-estonian-index.sh
```

## 📊 Monitoring & Analytics

### Key Metrics to Track
- **Article Count**: Should be ~100+ per language
- **Cross-Language Links**: 64 ET→EN, 31 EN→ET
- **Test Results**: Should pass all 10 tests
- **Update Frequency**: Check `fetch-log.txt` for activity

### Health Indicators
- ✅ All tests pass
- ✅ No broken cross-language links
- ✅ Images display correctly
- ✅ Indexes are up to date
- ✅ ETag file is properly formatted

## 🆘 Getting Help

### When to Use AI
- Complex content analysis
- Cross-language translation
- Technical troubleshooting
- Repository optimization

### When to Work Independently
- Routine updates
- Basic file operations
- Running tests
- Simple content browsing

### Emergency Procedures
```bash
# If repository is corrupted
git checkout HEAD -- en/ et/
./test.sh

# If smart fetch fails
rm .etags
./scripts/fetch-all-support.sh
./scripts/fetch-estonian.sh

# If indexes are broken
./scripts/generate-simple-index.sh
./scripts/generate-estonian-index.sh
```

This repository is designed to be both AI-friendly and independently usable. The comprehensive test suite ensures reliability, while the smart fetching system minimizes server load and keeps content up to date. 