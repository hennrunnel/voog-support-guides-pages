# Contributing to Voog Support Guides

Thank you for your interest in contributing to the Voog Support Guides repository! This document provides guidelines for contributing.

## 🤝 How to Contribute

### Reporting Issues
- Use the GitHub Issues page to report bugs or suggest improvements
- Include detailed information about the problem
- Attach relevant log files if available

### Suggesting Enhancements
- Open an issue with the "enhancement" label
- Describe the proposed feature clearly
- Explain the benefits and use cases

### Code Contributions
- Fork the repository
- Create a feature branch
- Make your changes
- Run tests: `./test.sh`
- Submit a pull request

## 🧪 Testing

Before submitting any changes, please ensure:

1. **Run the test suite**:
   ```bash
   ./test.sh
   ```

2. **Verify repository health**:
   - All tests pass
   - Cross-language links work
   - Images display correctly
   - Indexes are up to date

3. **Check for regressions**:
   - No broken links
   - HTML structure is valid
   - Scripts are executable

## 📋 Pull Request Guidelines

### Before Submitting
- [ ] Run `./test.sh` and ensure all tests pass
- [ ] Update documentation if needed
- [ ] Test your changes thoroughly
- [ ] Follow the existing code style

### PR Description
Include:
- Summary of changes
- Motivation for the change
- Any breaking changes
- Test results

## 🛠️ Development Setup

### Prerequisites
- Bash shell
- `curl` for HTTP requests
- `sed`, `awk`, `grep` for text processing

### Local Development
1. Clone the repository
2. Make scripts executable: `chmod +x scripts/*.sh *.sh`
3. Run tests: `./test.sh`
4. Make your changes
5. Test again: `./test.sh`

## 📚 Documentation

### Updating Documentation
- Keep `README.md` up to date
- Update `USAGE.md` for new features
- Maintain `QUICK-REFERENCE.md`
- Update `PROGRESS.md` for significant changes

### Code Comments
- Add comments to complex scripts
- Document function purposes
- Explain non-obvious logic

## 🔄 Workflow

### For Content Updates
1. Use `./update-articles.sh` to fetch latest content
2. Run tests to ensure integrity
3. Commit changes with descriptive messages

### For Script Improvements
1. Test changes thoroughly
2. Update related documentation
3. Ensure backward compatibility
4. Add tests if applicable

## 🚨 Emergency Procedures

If you encounter issues:

1. **Repository corruption**:
   ```bash
   git checkout HEAD -- en/ et/
   ./test.sh
   ```

2. **Smart fetch failure**:
   ```bash
   rm .etags
   ./scripts/fetch-all-support.sh
   ./scripts/fetch-estonian.sh
   ```

3. **Broken indexes**:
   ```bash
   ./scripts/generate-simple-index.sh
   ./scripts/generate-estonian-index.sh
   ```

## 📞 Getting Help

- Check existing issues and discussions
- Review the documentation in `USAGE.md`
- Run the test suite for diagnostics
- Open an issue for complex problems

## 🎯 Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and contribute
- Follow the project's coding standards

Thank you for contributing to making this repository better! 🎉 