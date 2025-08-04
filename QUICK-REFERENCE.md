# Quick Reference Card

## 🚀 Essential Commands

| Task | Command |
|------|---------|
| **Update Articles** | `./update-articles.sh` |
| **Run Tests** | `./test.sh` |
| **Browse English** | Open `en/index.html` |
| **Browse Estonian** | Open `et/index.html` |
| **Main Overview** | Open `index.html` |

## 📊 Status Check

```bash
# Article counts
echo "English: $(find en -name "*.html" | wc -l)"
echo "Estonian: $(find et -name "*.html" | wc -l)"

# Cross-language links
echo "ET→EN links: $(grep -r "href=\"\.\./en/" et/ | wc -l)"
echo "EN→ET links: $(grep -r "href=\"\.\./et/" en/ | wc -l)"

# Repository health
./test.sh
```

## 🔧 Common Operations

### Update Content
```bash
# Interactive update (recommended)
./update-articles.sh

# Manual update
./scripts/smart-fetch-etag.sh all    # Both languages
./scripts/smart-fetch-etag.sh en     # English only
./scripts/smart-fetch-etag.sh et     # Estonian only
```

### Regenerate Indexes
```bash
./scripts/generate-simple-index.sh
./scripts/generate-estonian-index.sh
./scripts/generate-text-index.sh
./scripts/generate-estonian-text-index.sh
```

### Troubleshooting
```bash
# Check logs
tail -20 fetch-log.txt

# Check ETags
cat .etags

# Fix image URLs
find en et -name "*.html" -exec sed -i '' 's|src="//media.voog.com|src="https://media.voog.com|g' {} \;
```

## 🔍 Content Search

```bash
# Search English articles
grep -r "your search term" en/ --include="*.html"

# Search Estonian articles
grep -r "your search term" et/ --include="*.html"

# Find by filename
find en et -name "*keyword*"
```

## 📁 Key Files

| File | Purpose |
|------|---------|
| `index.html` | Main multilingual index |
| `en/index.html` | English article index |
| `et/index.html` | Estonian article index |
| `.etags` | Smart update tracking |
| `fetch-log.txt` | Update activity log |
| `test-results.log` | Test results |

## 🆘 Emergency Commands

```bash
# Reset to last known good state
git checkout HEAD -- en/ et/

# Rebuild from scratch
rm .etags
./scripts/fetch-all-support.sh
./scripts/fetch-estonian.sh

# Fix permissions
chmod +x scripts/*.sh *.sh
```

## 📞 When to Use AI vs Independent

### Use AI For:
- Complex content analysis
- Cross-language translation
- Technical troubleshooting
- Repository optimization
- Finding specific content

### Work Independently For:
- Routine updates (`./update-articles.sh`)
- Running tests (`./test.sh`)
- Basic file operations
- Simple content browsing

## 🎯 Health Checklist

- [ ] All tests pass (`./test.sh`)
- [ ] Article counts are reasonable (~100+ each)
- [ ] Cross-language links work
- [ ] Images display correctly
- [ ] Indexes are up to date
- [ ] ETag file is properly formatted

---

📖 **Full Documentation**: [USAGE.md](USAGE.md) | [README.md](README.md) 