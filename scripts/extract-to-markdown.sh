#!/bin/bash

# Voog Blog Articles - HTML to Markdown Converter
# Extracts content from blog HTML files and converts to multiple AI-friendly formats

set -e

# Configuration
SOURCE_DIRS=("en" "et")
OUTPUT_DIR="markdown-content"
JSON_DIR="json-content"
TEMP_DIR="temp-extraction"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
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

# Extract metadata from HTML
extract_metadata() {
    local html_file="$1"
    local temp_file="$2"
    
    # Extract title
    local title=$(grep -o '<title>[^<]*</title>' "$html_file" | sed 's/<title>\(.*\)<\/title>/\1/' | sed 's/ | Voog//')
    
    # Extract author
    local author=$(grep -o '<meta[^>]*name="author"[^>]*content="[^"]*"' "$html_file" | sed 's/.*content="\([^"]*\)".*/\1/')
    if [ -z "$author" ]; then
        author=$(grep -o '<span[^>]*class="[^"]*author[^"]*"[^>]*>[^<]*</span>' "$html_file" | sed 's/<[^>]*>//g')
    fi
    if [ -z "$author" ]; then
        author="Unknown"
    fi
    
    # Extract publication date
    local pub_date=$(grep -o '<meta[^>]*property="article:published_time"[^>]*content="[^"]*"' "$html_file" | sed 's/.*content="\([^"]*\)".*/\1/')
    if [ -z "$pub_date" ]; then
        pub_date=$(grep -o '<time[^>]*datetime="[^"]*"' "$html_file" | sed 's/.*datetime="\([^"]*\)".*/\1/')
    fi
    if [ -z "$pub_date" ]; then
        pub_date=$(grep -o '<meta[^>]*name="date"[^>]*content="[^"]*"' "$html_file" | sed 's/.*content="\([^"]*\)".*/\1/')
    fi
    if [ -z "$pub_date" ]; then
        pub_date="Unknown"
    fi
    
    # Extract tags
    local tags=$(grep -o '<meta[^>]*property="article:tag"[^>]*content="[^"]*"' "$html_file" | sed 's/.*content="\([^"]*\)".*/\1/' | tr '\n' ',' | sed 's/,$//')
    if [ -z "$tags" ]; then
        tags=$(grep -o '<a[^>]*class="[^"]*tag[^"]*"[^>]*>[^<]*</a>' "$html_file" | sed 's/<[^>]*>//g' | tr '\n' ',' | sed 's/,$//')
    fi
    if [ -z "$tags" ]; then
        tags="None"
    fi
    
    # Extract categories
    local categories=$(grep -o '<meta[^>]*property="article:section"[^>]*content="[^"]*"' "$html_file" | sed 's/.*content="\([^"]*\)".*/\1/' | tr '\n' ',' | sed 's/,$//')
    if [ -z "$categories" ]; then
        categories=$(grep -o '<a[^>]*class="[^"]*category[^"]*"[^>]*>[^<]*</a>' "$html_file" | sed 's/<[^>]*>//g' | tr '\n' ',' | sed 's/,$//')
    fi
    if [ -z "$categories" ]; then
        categories="Blog"
    fi
    
    # Write metadata
    echo "$title" > "$temp_file"
    echo "$author" >> "$temp_file"
    echo "$pub_date" >> "$temp_file"
    echo "$tags" >> "$temp_file"
    echo "$categories" >> "$temp_file"
}

# Clean HTML and extract content
extract_content() {
    local html_file="$1"
    local temp_file="$2"
    
    # Extract main content using multiple strategies
    local content=""
    
    # Strategy 1: Look for article content div
    content=$(awk '
        /<article[^>]*>/,/<\/article>/ {
            print
        }
    ' "$html_file")
    
    # Strategy 2: Look for main content area
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '
            /<div[^>]*class="[^"]*content[^"]*">/,/<\/div>/ {
                print
            }
        ' "$html_file")
    fi
    
    # Strategy 3: Look for post content
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '
            /<div[^>]*class="[^"]*post[^"]*">/,/<\/div>/ {
                print
            }
        ' "$html_file")
    fi
    
    # Strategy 4: Look for entry content
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '
            /<div[^>]*class="[^"]*entry[^"]*">/,/<\/div>/ {
                print
            }
        ' "$html_file")
    fi
    
    # Strategy 5: Look for main content, excluding navigation and footer
    if [ -z "$content" ] || [ "$(echo "$content" | wc -w)" -lt 10 ]; then
        content=$(awk '
            /<main[^>]*>/,/<\/main>/ {
                print
            }
        ' "$html_file")
    fi
    
    # Clean up HTML tags and formatting
    local cleaned_content=$(echo "$content" | \
        # Remove script and style tags and their content
        sed '/<script/,/<\/script>/d' | \
        sed '/<style/,/<\/style>/d' | \
        # Remove navigation and footer
        sed '/<nav/,/<\/nav>/d' | \
        sed '/<footer/,/<\/footer>/d' | \
        sed '/<header/,/<\/header>/d' | \
        # Remove social sharing and related content
        sed '/<div[^>]*class="[^"]*share[^"]*"/,/<\/div>/d' | \
        sed '/<div[^>]*class="[^"]*related[^"]*"/,/<\/div>/d' | \
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
    
    # Append cleaned content to temp file
    echo "$cleaned_content" >> "$temp_file"
}

# Convert to Markdown
convert_to_markdown() {
    local temp_file="$1"
    local markdown_file="$2"
    local original_url="$3"
    local language="$4"
    
    # Read metadata and content
    local title=$(head -n 1 "$temp_file")
    local author=$(head -n 2 "$temp_file" | tail -n 1)
    local pub_date=$(head -n 3 "$temp_file" | tail -n 1)
    local tags=$(head -n 4 "$temp_file" | tail -n 1)
    local categories=$(head -n 5 "$temp_file" | tail -n 1)
    local content=$(tail -n +6 "$temp_file")
    
    # Format publication date
    local formatted_date="$pub_date"
    if [[ "$pub_date" != "Unknown" ]] && [[ "$pub_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
        formatted_date=$(date -d "$pub_date" +"%Y-%m-%d" 2>/dev/null || echo "$pub_date")
    fi
    
    # Create Markdown file
    cat > "$markdown_file" << EOF
# $title

**Section:** Blog  
**Language:** $language  
**Original URL:** $original_url  
**Author:** $author  
**Published:** $formatted_date  
**Tags:** $tags  
**Categories:** $categories  
**Extracted:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")

---

$content

---

*This content was extracted from Voog's blog for AI-friendly processing.*
EOF
}

# Create directory structure
setup_directories() {
    log_info "Setting up directory structure..."
    
    # Create main output directories
    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$JSON_DIR"
    mkdir -p "$TEMP_DIR"
    
    # Create language-specific directories
    for lang in "${SOURCE_DIRS[@]}"; do
        mkdir -p "$OUTPUT_DIR/$lang"
        mkdir -p "$JSON_DIR/$lang"
    done
    
    # Create aggregated files directory
    mkdir -p "$OUTPUT_DIR/aggregated"
    
    log_success "Directory structure created"
}

# Process individual files
process_files() {
    local language="$1"
    local processed_count=0
    local error_count=0
    
    log_info "Processing $language blog files..."
    
    # Find all HTML files in the language directory
    while IFS= read -r -d '' html_file; do
        # Extract file path components
        local relative_path="${html_file#$language/}"
        local base_name=$(basename "$relative_path" .html)
        
        # Create temp file for extraction
        local temp_file="$TEMP_DIR/${language}_${base_name}.tmp"
        
        # Extract metadata and content
        if extract_metadata "$html_file" "$temp_file" && extract_content "$html_file" "$temp_file"; then
            # Convert to Markdown
            local markdown_file="$OUTPUT_DIR/$language/${base_name}.md"
            local original_url="https://www.voog.com/${language == "en" ? "blog" : "blogi"}/$relative_path"
            
            convert_to_markdown "$temp_file" "$markdown_file" "$original_url" "$language"
            
            ((processed_count++))
            log_success "Processed: $relative_path"
        else
            ((error_count++))
            log_error "Failed to process: $relative_path"
        fi
        
        # Clean up temp file
        rm -f "$temp_file"
        
    done < <(find "$language" -name "*.html" -print0)
    
    log_success "Processed $processed_count files for $language (errors: $error_count)"
}

# Create aggregated files
create_aggregated_files() {
    log_info "Creating aggregated files..."
    
    # All English content
    log_info "Creating all-blog-content-en.md..."
    {
        echo "# Voog Blog Articles - All English Content"
        echo ""
        echo "**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
        echo "**Total Articles:** $(find "$OUTPUT_DIR/en" -name "*.md" | wc -l)"
        echo ""
        echo "---"
        echo ""
        
        # Process each article
        for article_file in "$OUTPUT_DIR/en"/*.md; do
            if [ -f "$article_file" ]; then
                cat "$article_file"
                echo ""
                echo "---"
                echo ""
            fi
        done
    } > "$OUTPUT_DIR/aggregated/all-blog-content-en.md"
    
    # All Estonian content
    log_info "Creating all-blog-content-et.md..."
    {
        echo "# Voog Blog Articles - All Estonian Content"
        echo ""
        echo "**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
        echo "**Total Articles:** $(find "$OUTPUT_DIR/et" -name "*.md" | wc -l)"
        echo ""
        echo "---"
        echo ""
        
        # Process each article
        for article_file in "$OUTPUT_DIR/et"/*.md; do
            if [ -f "$article_file" ]; then
                cat "$article_file"
                echo ""
                echo "---"
                echo ""
            fi
        done
    } > "$OUTPUT_DIR/aggregated/all-blog-content-et.md"
    
    log_success "Aggregated files created"
}

# Create JSON structure
create_json_structure() {
    log_info "Creating JSON structure..."
    
    # Create blog index
    {
        echo "{"
        echo "  \"metadata\": {"
        echo "    \"generated\": \"$(date -u +"%Y-%m-%d %H:%M:%S UTC")\","
        echo "    \"total_articles\": {"
        echo "      \"en\": $(find "$OUTPUT_DIR/en" -name "*.md" | wc -l),"
        echo "      \"et\": $(find "$OUTPUT_DIR/et" -name "*.md" | wc -l)"
        echo "    },"
        echo "    \"source\": \"Voog Blog Articles\""
        echo "  },"
        echo "  \"articles\": {"
        
        # Process English articles
        echo "    \"en\": {"
        local first_en=true
        for article_file in "$OUTPUT_DIR/en"/*.md; do
            if [ -f "$article_file" ]; then
                if [ "$first_en" = true ]; then
                    first_en=false
                else
                    echo ","
                fi
                
                local base_name=$(basename "$article_file" .md)
                local title=$(grep "^# " "$article_file" | head -1 | sed 's/^# //')
                local author=$(grep "**Author:**" "$article_file" | sed 's/.*\*\*Author:\*\* //')
                local pub_date=$(grep "**Published:**" "$article_file" | sed 's/.*\*\*Published:\*\* //')
                local tags=$(grep "**Tags:**" "$article_file" | sed 's/.*\*\*Tags:\*\* //')
                local categories=$(grep "**Categories:**" "$article_file" | sed 's/.*\*\*Categories:\*\* //')
                local content=$(awk '/^---$/{p=!p;next}p' "$article_file" | head -n -3 | tr '\n' ' ' | sed 's/"/\\"/g')
                
                echo "      \"$base_name\": {"
                echo "        \"title\": \"$title\","
                echo "        \"author\": \"$author\","
                echo "        \"published\": \"$pub_date\","
                echo "        \"tags\": \"$tags\","
                echo "        \"categories\": \"$categories\","
                echo "        \"content\": \"$content\","
                echo "        \"file\": \"$article_file\""
                echo "      }"
            fi
        done
        echo "    },"
        
        # Process Estonian articles
        echo "    \"et\": {"
        local first_et=true
        for article_file in "$OUTPUT_DIR/et"/*.md; do
            if [ -f "$article_file" ]; then
                if [ "$first_et" = true ]; then
                    first_et=false
                else
                    echo ","
                fi
                
                local base_name=$(basename "$article_file" .md)
                local title=$(grep "^# " "$article_file" | head -1 | sed 's/^# //')
                local author=$(grep "**Author:**" "$article_file" | sed 's/.*\*\*Author:\*\* //')
                local pub_date=$(grep "**Published:**" "$article_file" | sed 's/.*\*\*Published:\*\* //')
                local tags=$(grep "**Tags:**" "$article_file" | sed 's/.*\*\*Tags:\*\* //')
                local categories=$(grep "**Categories:**" "$article_file" | sed 's/.*\*\*Categories:\*\* //')
                local content=$(awk '/^---$/{p=!p;next}p' "$article_file" | head -n -3 | tr '\n' ' ' | sed 's/"/\\"/g')
                
                echo "      \"$base_name\": {"
                echo "        \"title\": \"$title\","
                echo "        \"author\": \"$author\","
                echo "        \"published\": \"$pub_date\","
                echo "        \"tags\": \"$tags\","
                echo "        \"categories\": \"$categories\","
                echo "        \"content\": \"$content\","
                echo "        \"file\": \"$article_file\""
                echo "      }"
            fi
        done
        echo "    }"
        echo "  }"
        echo "}"
    } > "$JSON_DIR/blog-index.json"
    
    log_success "JSON structure created"
}

# Create README for markdown content
create_markdown_readme() {
    log_info "Creating README for markdown content..."
    
    cat > "$OUTPUT_DIR/README.md" << 'EOF'
# Voog Blog Articles - AI-Friendly Markdown Content

This directory contains Voog blog articles converted to AI-friendly Markdown format.

## Structure

```
markdown-content/
├── en/                          # English blog articles
├── et/                          # Estonian blog articles
├── aggregated/                  # Combined content files
│   ├── all-blog-content-en.md   # All English blog content
│   └── all-blog-content-et.md   # All Estonian blog content
└── README.md                    # This file
```

## Usage

### Individual Files
- Use individual `.md` files for targeted analysis
- Each file contains rich metadata (author, date, tags, categories)
- Clean content without HTML markup

### Aggregated Files
- `all-blog-content-en.md` / `all-blog-content-et.md`: Complete blog content for broad analysis
- Useful for content strategy and marketing analysis

### JSON Structure
- See `../json-content/blog-index.json` for programmatic access
- Machine-readable format with full metadata

## Content Statistics

- **English Articles**: [COUNT]
- **Estonian Articles**: [COUNT]
- **Last Updated**: [DATE]

## AI-Friendly Features

- Clean Markdown format
- Rich metadata (author, date, tags, categories)
- Cross-language linking maintained
- No HTML markup or navigation clutter
- Consistent formatting across all files

## Regeneration

To regenerate this content, run:
```bash
./scripts/extract-to-markdown.sh
```

EOF
    
    # Update statistics in README
    local en_count=$(find "$OUTPUT_DIR/en" -name "*.md" | wc -l)
    local et_count=$(find "$OUTPUT_DIR/et" -name "*.md" | wc -l)
    local current_date=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    
    sed -i.bak "s/\[COUNT\]/$en_count/g; s/\[DATE\]/$current_date/g" "$OUTPUT_DIR/README.md"
    sed -i.bak "s/Estonian Articles.*\[COUNT\]/Estonian Articles: $et_count/g" "$OUTPUT_DIR/README.md"
    rm -f "$OUTPUT_DIR/README.md.bak"
    
    log_success "README created"
}

# Main execution
main() {
    log_info "Starting HTML to Markdown conversion for blog articles..."
    
    # Check if source directories exist
    for dir in "${SOURCE_DIRS[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Source directory '$dir' not found"
            exit 1
        fi
    done
    
    # Setup
    setup_directories
    
    # Process each language
    for language in "${SOURCE_DIRS[@]}"; do
        process_files "$language"
    done
    
    # Create aggregated files
    create_aggregated_files
    
    # Create JSON structure
    create_json_structure
    
    # Create README
    create_markdown_readme
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    log_success "Conversion completed successfully!"
    log_info "Output locations:"
    log_info "  - Individual files: $OUTPUT_DIR/"
    log_info "  - Aggregated files: $OUTPUT_DIR/aggregated/"
    log_info "  - JSON structure: $JSON_DIR/"
}

# Run main function
main "$@" 