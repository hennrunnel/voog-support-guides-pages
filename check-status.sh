#!/bin/bash

# Final status check for GitHub readiness

echo "🔍 Final GitHub Readiness Check"
echo "================================"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Check counter
TOTAL_CHECKS=0
PASSED_CHECKS=0

check_item() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if eval "$2"; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        echo -e "${GREEN}✅ PASS${NC}: $1"
    else
        echo -e "${RED}❌ FAIL${NC}: $1"
    fi
}

warn_item() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
}

echo ""
echo "${BLUE}📁 Essential Files${NC}"
check_item "README.md exists" "[[ -f README.md ]]"
check_item "LICENSE exists" "[[ -f LICENSE ]]"
check_item ".gitignore exists" "[[ -f .gitignore ]]"
check_item "CONTRIBUTING.md exists" "[[ -f CONTRIBUTING.md ]]"

echo ""
echo "${BLUE}📚 Documentation${NC}"
check_item "USAGE.md exists" "[[ -f USAGE.md ]]"
check_item "QUICK-REFERENCE.md exists" "[[ -f QUICK-REFERENCE.md ]]"
check_item "PROGRESS.md exists" "[[ -f PROGRESS.md ]]"

echo ""
echo "${BLUE}🔧 Scripts${NC}"
check_item "update-articles.sh exists" "[[ -f update-articles.sh ]]"
check_item "test.sh exists" "[[ -f test.sh ]]"
check_item "All scripts are executable" "[[ -x update-articles.sh && -x test.sh ]]"

echo ""
echo "${BLUE}🧪 Testing${NC}"
check_item "tests/run-tests.sh exists" "[[ -f tests/run-tests.sh ]]"
check_item "Test script is executable" "[[ -x tests/run-tests.sh ]]"
check_item "GitHub Actions workflow exists" "[[ -f .github/workflows/test.yml ]]"

echo ""
echo "${BLUE}📊 Content${NC}"
en_count=$(find en -name "*.html" | wc -l | tr -d ' ')
et_count=$(find et -name "*.html" | wc -l | tr -d ' ')
check_item "English articles exist ($en_count files)" "[[ $en_count -gt 100 ]]"
check_item "Estonian articles exist ($et_count files)" "[[ $et_count -gt 100 ]]"
check_item "Main index.html exists" "[[ -f index.html ]]"

echo ""
echo "${BLUE}🔗 Cross-Language Links${NC}"
et_en_links=$(grep -r "href=\"\.\./en/" et/ | wc -l | tr -d ' ')
en_et_links=$(grep -r "href=\"\.\./et/" en/ | wc -l | tr -d ' ')
check_item "ET→EN links exist ($et_en_links)" "[[ $et_en_links -gt 50 ]]"
check_item "EN→ET links exist ($en_et_links)" "[[ $en_et_links -gt 20 ]]"

echo ""
echo "${BLUE}🏷️ Smart Features${NC}"
check_item ".etags file exists" "[[ -f .etags ]]"
check_item "ETag file has content" "[[ -s .etags ]]"

echo ""
echo "${BLUE}🧪 Final Test Run${NC}"
if ./test.sh > /dev/null 2>&1; then
    check_item "All tests pass" "true"
else
    check_item "All tests pass" "false"
fi

echo ""
echo "=========================================="
echo "📊 GitHub Readiness Summary"
echo "=========================================="
echo "Total checks: $TOTAL_CHECKS"
echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
echo -e "Failed: ${RED}$((TOTAL_CHECKS - PASSED_CHECKS))${NC}"
echo -e "Success rate: $((PASSED_CHECKS * 100 / TOTAL_CHECKS))%"

echo ""
if [[ $PASSED_CHECKS -eq $TOTAL_CHECKS ]]; then
    echo -e "${GREEN}🎉 Repository is ready for GitHub!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Initialize git repository: git init"
    echo "2. Add all files: git add ."
    echo "3. Initial commit: git commit -m 'Initial commit'"
    echo "4. Create GitHub repository"
    echo "5. Push to GitHub: git push origin main"
    echo ""
    echo "Remember to update the badge URLs in README.md with your actual GitHub username!"
else
    echo -e "${RED}⚠️  Some checks failed. Please review the issues above.${NC}"
fi

echo ""
echo "📋 Files to review before pushing:"
echo "- README.md (update badge URLs with your username)"
echo "- .gitignore (ensure it covers all necessary exclusions)"
echo "- LICENSE (verify it's appropriate for your use case)" 