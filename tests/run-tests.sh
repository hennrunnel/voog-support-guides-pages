#!/bin/bash

# Comprehensive test suite for Voog Support Guides repository

TEST_DIR="tests"
LOG_FILE="test-results.log"
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
increment_test() {
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
}

pass_test() {
    PASSED_TESTS=$((PASSED_TESTS + 1))
    echo -e "${GREEN}✅ PASS${NC}: $1"
}

fail_test() {
    FAILED_TESTS=$((FAILED_TESTS + 1))
    echo -e "${RED}❌ FAIL${NC}: $1"
    echo "   $2"
}

warn_test() {
    echo -e "${YELLOW}⚠️  WARN${NC}: $1"
}

# Initialize test log
echo "=== Test Results - $(date) ===" > "$LOG_FILE"

echo "🧪 Running Voog Support Guides Test Suite"
echo "=========================================="

# Test 1: Check if all required directories exist
echo ""
echo "${BLUE}📁 Testing Directory Structure${NC}"
increment_test
if [[ -d "en" && -d "et" && -d "scripts" ]]; then
    pass_test "Required directories exist (en/, et/, scripts/)"
else
    fail_test "Required directories missing" "en/, et/, or scripts/ directory not found"
fi

# Test 2: Check if all HTML files are valid
echo ""
echo "${BLUE}📄 Testing HTML File Validity${NC}"
html_files=$(find en et -name "*.html" 2>/dev/null)
html_count=$(echo "$html_files" | wc -l | tr -d ' ')

increment_test
if [[ $html_count -gt 0 ]]; then
    pass_test "Found $html_count HTML files"
    
    # Check for basic HTML structure
    invalid_files=0
    for file in $html_files; do
        if ! grep -q "<html" "$file" 2>/dev/null; then
            invalid_files=$((invalid_files + 1))
            warn_test "File $file may not be valid HTML"
        fi
    done
    
    if [[ $invalid_files -eq 0 ]]; then
        pass_test "All HTML files have basic structure"
    else
        fail_test "$invalid_files files may have invalid HTML structure" "Check files for missing <html> tags"
    fi
else
    fail_test "No HTML files found" "Repository appears to be empty"
fi

# Test 3: Check if all HTML files have titles
echo ""
echo "${BLUE}📝 Testing Title Extraction${NC}"
files_without_titles=0
for file in $html_files; do
    if ! grep -q "<title>" "$file" 2>/dev/null; then
        files_without_titles=$((files_without_titles + 1))
        warn_test "File $file has no title tag"
    fi
done

increment_test
if [[ $files_without_titles -eq 0 ]]; then
    pass_test "All HTML files have title tags"
else
    fail_test "$files_without_titles files missing title tags" "Some articles may not display properly"
fi

# Test 4: Check cross-language links
echo ""
echo "${BLUE}🔗 Testing Cross-Language Links${NC}"
broken_et_links=0
broken_en_links=0

# Check Estonian to English links
for file in et/*/*.html; do
    if [[ -f "$file" ]]; then
        grep -o 'href="\.\./en/[^"]*"' "$file" | while read link; do
            target=$(echo "$link" | sed 's|href="\.\./en/||' | sed 's|"||')
            if [[ ! -f "en/$target" ]]; then
                broken_et_links=$((broken_et_links + 1))
                warn_test "Broken ET→EN link in $file: $target"
            fi
        done
    fi
done

# Check English to Estonian links
for file in en/*/*.html; do
    if [[ -f "$file" ]]; then
        grep -o 'href="\.\./et/[^"]*"' "$file" | while read link; do
            target=$(echo "$link" | sed 's|href="\.\./et/||' | sed 's|"||')
            if [[ ! -f "et/$target" ]]; then
                broken_en_links=$((broken_en_links + 1))
                warn_test "Broken EN→ET link in $file: $target"
            fi
        done
    fi
done

increment_test
total_broken=$((broken_et_links + broken_en_links))
if [[ $total_broken -eq 0 ]]; then
    pass_test "All cross-language links are valid"
else
    fail_test "$total_broken broken cross-language links found" "ET→EN: $broken_et_links, EN→ET: $broken_en_links"
fi

# Test 5: Check if indexes exist and are up to date
echo ""
echo "${BLUE}📋 Testing Index Files${NC}"
index_files=("en/index.html" "et/index.html" "en/index.txt" "et/index.txt" "index.html")
missing_indexes=0

for index in "${index_files[@]}"; do
    if [[ ! -f "$index" ]]; then
        missing_indexes=$((missing_indexes + 1))
        warn_test "Missing index file: $index"
    fi
done

increment_test
if [[ $missing_indexes -eq 0 ]]; then
    pass_test "All index files exist"
else
    fail_test "$missing_indexes index files missing" "Run index generation scripts"
fi

# Test 6: Check if scripts are executable
echo ""
echo "${BLUE}🔧 Testing Scripts${NC}"
scripts=("scripts/smart-fetch-etag.sh" "scripts/fetch-all-support.sh" "scripts/fetch-estonian.sh" 
         "scripts/generate-simple-index.sh" "scripts/generate-estonian-index.sh" 
         "scripts/generate-text-index.sh" "scripts/generate-estonian-text-index.sh" "update-articles.sh")
non_executable=0

for script in "${scripts[@]}"; do
    if [[ ! -x "$script" ]]; then
        non_executable=$((non_executable + 1))
        warn_test "Script not executable: $script"
    fi
done

increment_test
if [[ $non_executable -eq 0 ]]; then
    pass_test "All scripts are executable"
else
    fail_test "$non_executable scripts not executable" "Run: chmod +x scripts/*.sh update-articles.sh"
fi

# Test 7: Check ETag file integrity
echo ""
echo "${BLUE}🏷️  Testing ETag File${NC}"
if [[ -f ".etags" ]]; then
    etag_count=$(wc -l < .etags | tr -d ' ')
    increment_test
    if [[ $etag_count -gt 0 ]]; then
        pass_test "ETag file exists with $etag_count entries"
        
        # Check for malformed entries
        malformed_entries=$(grep -v "^[^:]*:[a-f0-9]*$" .etags 2>/dev/null | wc -l | tr -d ' ')
        if [[ $malformed_entries -eq 0 ]]; then
            pass_test "All ETag entries are properly formatted"
        else
            fail_test "$malformed_entries malformed ETag entries" "Check .etags file format"
        fi
    else
        fail_test "ETag file is empty" "No ETags stored for change detection"
    fi
else
    increment_test
    warn_test "No .etags file found" "Will be created on first smart fetch"
fi

# Test 8: Check for image URL fixes
echo ""
echo "${BLUE}🖼️  Testing Image URL Fixes${NC}"
files_with_protocol_relative=0
files_with_double_https=0

for file in $html_files; do
    if grep -q 'src="//media.voog.com' "$file" 2>/dev/null; then
        files_with_protocol_relative=$((files_with_protocol_relative + 1))
        warn_test "File $file has protocol-relative image URLs"
    fi
    
    if grep -q 'https:https://' "$file" 2>/dev/null; then
        files_with_double_https=$((files_with_double_https + 1))
        warn_test "File $file has double https URLs"
    fi
done

increment_test
if [[ $files_with_protocol_relative -eq 0 && $files_with_double_https -eq 0 ]]; then
    pass_test "All image URLs are properly fixed"
else
    fail_test "Image URL issues found" "Protocol-relative: $files_with_protocol_relative, Double https: $files_with_double_https"
fi

# Test 9: Check article counts match expectations
echo ""
echo "${BLUE}📊 Testing Article Counts${NC}"
en_count=$(find en -name "*.html" | wc -l | tr -d ' ')
et_count=$(find et -name "*.html" | wc -l | tr -d ' ')

increment_test
if [[ $en_count -ge 100 && $et_count -ge 100 ]]; then
    pass_test "Article counts are reasonable (EN: $en_count, ET: $et_count)"
else
    fail_test "Article counts seem low" "EN: $en_count, ET: $et_count (expected ~100+ each)"
fi

# Test 10: Check for recent activity
echo ""
echo "${BLUE}⏰ Testing Recent Activity${NC}"
recent_files=$(find en et -name "*.html" -mtime -7 2>/dev/null | wc -l | tr -d ' ')
increment_test

if [[ $recent_files -gt 0 ]]; then
    pass_test "Found $recent_files files modified in the last 7 days"
else
    warn_test "No files modified recently" "Consider running smart fetch to check for updates"
fi

# Summary
echo ""
echo "=========================================="
echo "📊 Test Summary"
echo "=========================================="
echo "Total tests: $TOTAL_TESTS"
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
echo -e "Success rate: $((PASSED_TESTS * 100 / TOTAL_TESTS))%"

# Log results
echo "Test Summary: $PASSED_TESTS/$TOTAL_TESTS passed" >> "$LOG_FILE"

if [[ $FAILED_TESTS -eq 0 ]]; then
    echo -e "${GREEN}🎉 All tests passed! Repository is in good condition.${NC}"
    exit 0
else
    echo -e "${RED}⚠️  $FAILED_TESTS tests failed. Please review the issues above.${NC}"
    exit 1
fi 