#!/bin/bash

# Test script for content extraction
# Tests the extraction logic on a few sample files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Clean HTML and extract content (same as main script)
extract_content() {
    local html_file="$1"
    local temp_file="$2"
    
    # Extract title
    local title=$(grep -o '<title>[^<]*</title>' "$html_file" | sed 's/<title>\(.*\)<\/title>/\1/' | sed 's/ | Voog website builder//')
    
    # Extract main content using multiple strategies
    local content=""
    
    # Strategy 1: Look for ListingArticleContent div (most reliable)
    # Extract everything between the opening and closing tags, handling nested divs
    content=$(awk '
        /<div class="ListingArticleContent">/ {
            in_content = 1
            div_depth = 1
            next
        }
        in_content {
            if ($0 ~ /<div[^>]*>/) {
                div_depth++
            }
            if ($0 ~ /<\/div>/) {
                div_depth--
                if (div_depth == 0) {
                    in_content = 0
                    next
                }
            }
            print
        }
    ' "$html_file")
    
    # Strategy 2: Look for article tag
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '/<article/,/<\/article>/' "$html_file")
    fi
    
    # Strategy 3: Look for main content area with specific classes
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '/<div[^>]*class="[^"]*content[^"]*">/,/<\/div>/' "$html_file")
    fi
    
    # Strategy 4: Look for body content, excluding navigation and footer
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '/<body/,/<\/body>/' "$html_file" | sed 's/<body[^>]*>//' | sed 's/<\/body>//' | sed '/<nav/,/<\/nav>/d' | sed '/<footer/,/<\/footer>/d' | sed '/<header/,/<\/header>/d')
    fi
    
    # Strategy 5: If still no content, try a more aggressive approach
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        # Look for any div with content-like classes
        content=$(awk '/<div[^>]*class="[^"]*[Aa]rticle[^"]*">/,/<\/div>/' "$html_file")
    fi
    
    # Clean up HTML tags and formatting (simplified approach)
    local cleaned_content=$(echo "$content" | \
        # Remove script and style tags and their content
        sed '/<script/,/<\/script>/d' | \
        sed '/<style/,/<\/style>/d' | \
        # Remove picture and source tags (image containers)
        sed '/<picture/,/<\/picture>/d' | \
        sed '/<source/d' | \
        # Remove all remaining HTML tags but preserve text
        sed 's/<[^>]*>//g' | \
        # Decode HTML entities
        sed 's/&nbsp;/ /g' | \
        sed 's/&amp;/\&/g' | \
        sed 's/&lt;/</g' | \
        sed 's/&gt;/>/g' | \
        sed 's/&quot;/"/g' | \
        sed 's/&#39;/'\''/g' | \
        sed 's/&mdash;/—/g' | \
        sed 's/&ndash;/–/g' | \
        sed 's/&hellip;/…/g' | \
        sed 's/&ldquo;/"/g' | \
        sed 's/&rdquo;/"/g' | \
        sed 's/&lsquo;/'\''/g' | \
        sed 's/&rsquo;/'\''/g' | \
        # Clean up whitespace but preserve content
        sed '/^[[:space:]]*$/d' | \
        sed 's/[[:space:]]\+/ /g' | \
        sed 's/^[[:space:]]*//' | \
        sed 's/[[:space:]]*$//')
    
    # Write title and cleaned content
    echo "$title" > "$temp_file"
    echo "$cleaned_content" >> "$temp_file"
}

# Test files to process
TEST_FILES=(
    "en/managing-your-blog/starting-your-first-blog-with-voog.html"
    "en/managing-your-content/creating-links.html"
    "et/blogi/sinu-esimese-blogi-loomine-voos.html"
)

# Create test output directory
TEST_OUTPUT="test-extraction-output"
mkdir -p "$TEST_OUTPUT"

log_info "Testing content extraction on sample files..."

for html_file in "${TEST_FILES[@]}"; do
    if [ -f "$html_file" ]; then
        log_info "Processing: $html_file"
        
        # Extract content
        temp_file="$TEST_OUTPUT/$(basename "$html_file" .html).txt"
        extract_content "$html_file" "$temp_file"
        
        # Show results
        title=$(head -n 1 "$temp_file")
        content_length=$(tail -n +2 "$temp_file" | wc -w)
        
        log_success "Title: $title"
        log_info "Content length: $content_length words"
        
        # Show first 200 characters of content
        content_preview=$(tail -n +2 "$temp_file" | head -c 200)
        echo "Preview: $content_preview..."
        echo ""
        
    else
        log_warning "File not found: $html_file"
    fi
done

log_success "Test extraction completed. Check $TEST_OUTPUT/ for results." 