#!/bin/bash

# Voog Support Guides - HTML to Markdown Converter
# Extracts content from HTML files and converts to multiple AI-friendly formats

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

# Section mapping function
get_section_name() {
    local dir_name="$1"
    local language="$2"
    
    case "$language" in
        "en")
            case "$dir_name" in
                "all-about-languages") echo "Languages" ;;
                "contact") echo "Contact" ;;
                "content-areas") echo "Content Areas" ;;
                "creating-and-managing-forms") echo "Forms" ;;
                "managing-your-blog") echo "Blog" ;;
                "managing-your-content") echo "Content Management" ;;
                "managing-your-website-pages") echo "Pages" ;;
                "online-store") echo "Online Store" ;;
                "seo") echo "SEO" ;;
                "setting-up-your-account") echo "Account Setup" ;;
                "stats-and-maintenance") echo "Stats & Maintenance" ;;
                "video-tutorials") echo "Video Tutorials" ;;
                "webinars") echo "Webinars" ;;
                "your-pictures-and-files") echo "Media" ;;
                "your-subscriptions") echo "Subscriptions" ;;
                "your-website-addresses") echo "Domains" ;;
                "your-websites-design") echo "Design" ;;
                *) echo "$dir_name" ;;
            esac
            ;;
        "et")
            case "$dir_name" in
                "blogi") echo "Blogi" ;;
                "domeenid") echo "Domeenid" ;;
                "e-pood") echo "E-pood" ;;
                "keeled") echo "Keeled" ;;
                "kontakt") echo "Kontakt" ;;
                "konto-loomine") echo "Konto loomine" ;;
                "kujundus") echo "Kujundus" ;;
                "lehed") echo "Lehed" ;;
                "pildid-ja-failid") echo "Pildid ja failid" ;;
                "seo") echo "SEO" ;;
                "sisu-haldamine") echo "Sisu haldamine" ;;
                "sisualad") echo "Sisualad" ;;
                "statistika-ja-saidi-haldamine") echo "Statistika ja saidi haldamine" ;;
                "tellimus") echo "Tellimus" ;;
                "veebiseminar") echo "Veebiseminar" ;;
                "videojuhendid") echo "Videojuhendid" ;;
                "vormid") echo "Vormid" ;;
                *) echo "$dir_name" ;;
            esac
            ;;
        *) echo "$dir_name" ;;
    esac
}

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

# Clean HTML and extract content
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

# Convert to Markdown
convert_to_markdown() {
    local temp_file="$1"
    local markdown_file="$2"
    local original_url="$3"
    local section="$4"
    local language="$5"
    
    # Read title and content
    local title=$(head -n 1 "$temp_file")
    local content=$(tail -n +2 "$temp_file")
    
    # Create Markdown file
    cat > "$markdown_file" << EOF
# $title

**Section:** $section  
**Language:** $language  
**Original URL:** $original_url  
**Extracted:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")

---

$content

---

*This content was extracted from Voog's support documentation for AI-friendly processing.*
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
    
    log_info "Processing $language files..."
    
    # Find all HTML files in the language directory
    while IFS= read -r -d '' html_file; do
        # Skip index files
        if [[ "$html_file" == *"index.html" ]]; then
            continue
        fi
        
        # Extract file path components
        local relative_path="${html_file#$language/}"
        local dir_name=$(dirname "$relative_path")
        local base_name=$(basename "$relative_path" .html)
        
        # Create output directory
        mkdir -p "$OUTPUT_DIR/$language/$dir_name"
        
        # Determine section name
        local section_name=$(get_section_name "$dir_name" "$language")
        
        # Create temp file for extraction
        local temp_file="$TEMP_DIR/${language}_${base_name}.tmp"
        
        # Extract content
        if extract_content "$html_file" "$temp_file"; then
            # Convert to Markdown
            local markdown_file="$OUTPUT_DIR/$language/$dir_name/${base_name}.md"
            local original_url="https://www.voog.com/support/$relative_path"
            
            convert_to_markdown "$temp_file" "$markdown_file" "$original_url" "$section_name" "$language"
            
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
    log_info "Creating all-content-en.md..."
    {
        echo "# Voog Support Guides - All English Content"
        echo ""
        echo "**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
        echo "**Total Articles:** $(find "$OUTPUT_DIR/en" -name "*.md" | wc -l)"
        echo ""
        echo "---"
        echo ""
        
        # Process each section
        for section_dir in "$OUTPUT_DIR/en"/*/; do
            if [ -d "$section_dir" ]; then
                section_name=$(basename "$section_dir")
                echo "## Section: $section_name"
                echo ""
                
                # Process each article in the section
                for article_file in "$section_dir"/*.md; do
                    if [ -f "$article_file" ]; then
                        cat "$article_file"
                        echo ""
                        echo "---"
                        echo ""
                    fi
                done
            fi
        done
    } > "$OUTPUT_DIR/aggregated/all-content-en.md"
    
    # All Estonian content
    log_info "Creating all-content-et.md..."
    {
        echo "# Voog Support Guides - All Estonian Content"
        echo ""
        echo "**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
        echo "**Total Articles:** $(find "$OUTPUT_DIR/et" -name "*.md" | wc -l)"
        echo ""
        echo "---"
        echo ""
        
        # Process each section
        for section_dir in "$OUTPUT_DIR/et"/*/; do
            if [ -d "$section_dir" ]; then
                section_name=$(basename "$section_dir")
                echo "## Section: $section_name"
                echo ""
                
                # Process each article in the section
                for article_file in "$section_dir"/*.md; do
                    if [ -f "$article_file" ]; then
                        cat "$article_file"
                        echo ""
                        echo "---"
                        echo ""
                    fi
                done
            fi
        done
    } > "$OUTPUT_DIR/aggregated/all-content-et.md"
    
    # Content by section (English)
    log_info "Creating content-by-section-en.md..."
    {
        echo "# Voog Support Guides - English Content by Section"
        echo ""
        echo "**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
        echo ""
        
        for section_dir in "$OUTPUT_DIR/en"/*/; do
            if [ -d "$section_dir" ]; then
                section_name=$(basename "$section_dir")
                echo "## $section_name"
                echo ""
                
                for article_file in "$section_dir"/*.md; do
                    if [ -f "$article_file" ]; then
                        # Extract just the title and content (skip metadata)
                        local title=$(grep "^# " "$article_file" | head -1 | sed 's/^# //')
                        local content=$(awk '/^---$/{p=!p;next}p' "$article_file" | head -n -3)
                        
                        echo "### $title"
                        echo ""
                        echo "$content"
                        echo ""
                    fi
                done
                echo "---"
                echo ""
            fi
        done
    } > "$OUTPUT_DIR/aggregated/content-by-section-en.md"
    
    # Content by section (Estonian)
    log_info "Creating content-by-section-et.md..."
    {
        echo "# Voog Support Guides - Estonian Content by Section"
        echo ""
        echo "**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
        echo ""
        
        for section_dir in "$OUTPUT_DIR/et"/*/; do
            if [ -d "$section_dir" ]; then
                section_name=$(basename "$section_dir")
                echo "## $section_name"
                echo ""
                
                for article_file in "$section_dir"/*.md; do
                    if [ -f "$article_file" ]; then
                        # Extract just the title and content (skip metadata)
                        local title=$(grep "^# " "$article_file" | head -1 | sed 's/^# //')
                        local content=$(awk '/^---$/{p=!p;next}p' "$article_file" | head -n -3)
                        
                        echo "### $title"
                        echo ""
                        echo "$content"
                        echo ""
                    fi
                done
                echo "---"
                echo ""
            fi
        done
    } > "$OUTPUT_DIR/aggregated/content-by-section-et.md"
    
    log_success "Aggregated files created"
}

# Create JSON structure
create_json_structure() {
    log_info "Creating JSON structure..."
    
    # Create content index
    {
        echo "{"
        echo "  \"metadata\": {"
        echo "    \"generated\": \"$(date -u +"%Y-%m-%d %H:%M:%S UTC")\","
        echo "    \"total_articles\": {"
        echo "      \"en\": $(find "$OUTPUT_DIR/en" -name "*.md" | wc -l),"
        echo "      \"et\": $(find "$OUTPUT_DIR/et" -name "*.md" | wc -l)"
        echo "    },"
        echo "    \"sections\": {"
        echo "      \"en\": $(find "$OUTPUT_DIR/en" -maxdepth 1 -type d | wc -l),"
        echo "      \"et\": $(find "$OUTPUT_DIR/et" -maxdepth 1 -type d | wc -l)"
        echo "    }"
        echo "  },"
        echo "  \"articles\": {"
        
        # Process English articles
        echo "    \"en\": {"
        for section_dir in "$OUTPUT_DIR/en"/*/; do
            if [ -d "$section_dir" ]; then
                section_name=$(basename "$section_dir")
                echo "      \"$section_name\": {"
                
                for article_file in "$section_dir"/*.md; do
                    if [ -f "$article_file" ]; then
                        local base_name=$(basename "$article_file" .md)
                        local title=$(grep "^# " "$article_file" | head -1 | sed 's/^# //')
                        local content=$(awk '/^---$/{p=!p;next}p' "$article_file" | head -n -3 | tr '\n' ' ' | sed 's/"/\\"/g')
                        
                        echo "        \"$base_name\": {"
                        echo "          \"title\": \"$title\","
                        echo "          \"content\": \"$content\","
                        echo "          \"file\": \"$article_file\""
                        echo "        }"
                        
                        # Add comma if not last article
                        if [ "$(ls "$section_dir"/*.md | wc -l)" -gt 1 ]; then
                            echo ","
                        fi
                    fi
                done
                echo "      }"
                
                # Add comma if not last section
                if [ "$(find "$OUTPUT_DIR/en" -maxdepth 1 -type d | wc -l)" -gt 1 ]; then
                    echo ","
                fi
            fi
        done
        echo "    },"
        
        # Process Estonian articles
        echo "    \"et\": {"
        for section_dir in "$OUTPUT_DIR/et"/*/; do
            if [ -d "$section_dir" ]; then
                section_name=$(basename "$section_dir")
                echo "      \"$section_name\": {"
                
                for article_file in "$section_dir"/*.md; do
                    if [ -f "$article_file" ]; then
                        local base_name=$(basename "$article_file" .md)
                        local title=$(grep "^# " "$article_file" | head -1 | sed 's/^# //')
                        local content=$(awk '/^---$/{p=!p;next}p' "$article_file" | head -n -3 | tr '\n' ' ' | sed 's/"/\\"/g')
                        
                        echo "        \"$base_name\": {"
                        echo "          \"title\": \"$title\","
                        echo "          \"content\": \"$content\","
                        echo "          \"file\": \"$article_file\""
                        echo "        }"
                        
                        # Add comma if not last article
                        if [ "$(ls "$section_dir"/*.md | wc -l)" -gt 1 ]; then
                            echo ","
                        fi
                    fi
                done
                echo "      }"
                
                # Add comma if not last section
                if [ "$(find "$OUTPUT_DIR/et" -maxdepth 1 -type d | wc -l)" -gt 1 ]; then
                    echo ","
                fi
            fi
        done
        echo "    }"
        echo "  }"
        echo "}"
    } > "$JSON_DIR/content-index.json"
    
    log_success "JSON structure created"
}

# Create README for markdown content
create_markdown_readme() {
    log_info "Creating README for markdown content..."
    
    cat > "$OUTPUT_DIR/README.md" << 'EOF'
# Voog Support Guides - AI-Friendly Markdown Content

This directory contains Voog support documentation converted to AI-friendly Markdown format.

## Structure

```
markdown-content/
├── en/                          # English articles by section
│   ├── all-about-languages/
│   ├── managing-your-blog/
│   └── ...
├── et/                          # Estonian articles by section
│   ├── keeled/
│   ├── blogi/
│   └── ...
├── aggregated/                  # Combined content files
│   ├── all-content-en.md       # All English content
│   ├── all-content-et.md       # All Estonian content
│   ├── content-by-section-en.md
│   └── content-by-section-et.md
└── README.md                    # This file
```

## Usage

### Individual Files
- Use individual `.md` files for targeted analysis
- Each file contains metadata (section, language, original URL)
- Clean content without HTML markup

### Aggregated Files
- `all-content-en.md` / `all-content-et.md`: Complete content for broad analysis
- `content-by-section-en.md` / `content-by-section-et.md`: Organized by topic

### JSON Structure
- See `../json-content/content-index.json` for programmatic access
- Machine-readable format with metadata

## Content Statistics

- **English Articles**: [COUNT] across [SECTIONS] sections
- **Estonian Articles**: [COUNT] across [SECTIONS] sections
- **Last Updated**: [DATE]

## AI-Friendly Features

- Clean Markdown format
- Preserved structure and metadata
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
    local en_sections=$(find "$OUTPUT_DIR/en" -maxdepth 1 -type d | wc -l)
    local et_sections=$(find "$OUTPUT_DIR/et" -maxdepth 1 -type d | wc -l)
    local current_date=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    
    sed -i.bak "s/\[COUNT\]/$en_count/g; s/\[SECTIONS\]/$en_sections/g; s/\[DATE\]/$current_date/g" "$OUTPUT_DIR/README.md"
    sed -i.bak "s/Estonian Articles.*\[COUNT\]/Estonian Articles: $et_count across $et_sections sections/g" "$OUTPUT_DIR/README.md"
    rm -f "$OUTPUT_DIR/README.md.bak"
    
    log_success "README created"
}

# Main execution
main() {
    log_info "Starting HTML to Markdown conversion..."
    
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