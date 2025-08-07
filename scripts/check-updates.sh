#!/bin/bash

# Voog Blog Articles - Update Detection Script
# Checks for new or updated blog articles on Voog's blog pages

set -e

# Configuration
BLOG_URLS=(
    "https://www.voog.com/blog/"
    "https://www.voog.com/blogi/"
)
OUTPUT_DIRS=("en" "et")
TEMP_DIR="temp-updates"
LOG_FILE="update-check.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

# Clean up function
cleanup() {
    log_info "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
}

# Set up trap for cleanup
trap cleanup EXIT

# Create necessary directories
setup_directories() {
    log_info "Setting up directories..."
    
    mkdir -p "$TEMP_DIR"
    
    # Initialize log file
    echo "Voog Blog Update Check Log - $(date)" > "$LOG_FILE"
    echo "=====================================" >> "$LOG_FILE"
    
    log_success "Directories created"
}

# Get current article URLs from local files
get_local_articles() {
    local language="$1"
    local output_file="$2"
    
    # Find all HTML files and extract their URLs
    find "$language" -name "*.html" -exec basename {} .html \; | \
    while read -r filename; do
        # Reconstruct the URL based on language
        if [ "$language" = "en" ]; then
            echo "https://www.voog.com/blog/$filename"
        else
            echo "https://www.voog.com/blogi/$filename"
        fi
    done > "$output_file"
}

# Get current article URLs from blog pages
get_remote_articles() {
    local blog_url="$1"
    local output_file="$2"
    local language="$3"
    
    log_info "Fetching current article list from: $blog_url"
    
    # Download the blog listing page
    local temp_page="$TEMP_DIR/remote_listing_${language}.html"
    
    if curl -s -L "$blog_url" -o "$temp_page" --max-time 30; then
        # Extract article URLs using the same strategy as fetch script
        local article_urls=$(grep -o 'href="[^"]*blog[^"]*"' "$temp_page" | \
            sed 's/href="//g' | sed 's/"//g' | \
            grep -E '(\.html|/[0-9]{4}/|/[a-z-]+/)' | \
            sort -u)
        
        # Convert relative URLs to absolute URLs
        local base_url=$(echo "$blog_url" | sed 's|/$||')
        echo "$article_urls" | while read -r url; do
            if [[ "$url" == /* ]]; then
                echo "${base_url}${url}"
            elif [[ "$url" == http* ]]; then
                echo "$url"
            else
                echo "${base_url}/${url}"
            fi
        done | sort -u > "$output_file"
        
        log_success "Found $(wc -l < "$output_file") remote articles"
    else
        log_error "Failed to fetch remote article list from: $blog_url"
        return 1
    fi
}

# Check for new articles
check_new_articles() {
    local local_file="$1"
    local remote_file="$2"
    local language="$3"
    
    log_info "Checking for new articles in $language..."
    
    # Find new articles (in remote but not in local)
    local new_articles_file="$TEMP_DIR/new_articles_${language}.txt"
    comm -23 "$remote_file" "$local_file" > "$new_articles_file"
    
    local new_count=$(wc -l < "$new_articles_file")
    
    if [ "$new_count" -gt 0 ]; then
        log_success "Found $new_count new articles in $language"
        echo "New articles in $language:" >> "$LOG_FILE"
        cat "$new_articles_file" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
        
        # Show new articles
        while IFS= read -r url; do
            if [ -n "$url" ]; then
                log_info "  New: $url"
            fi
        done < "$new_articles_file"
    else
        log_success "No new articles found in $language"
    fi
    
    return $new_count
}

# Check for updated articles using HTTP headers
check_updated_articles() {
    local local_file="$1"
    local language="$2"
    
    log_info "Checking for updated articles in $language..."
    
    local updated_count=0
    local updated_articles_file="$TEMP_DIR/updated_articles_${language}.txt"
    
    # Clear the file
    > "$updated_articles_file"
    
    # Check each local article
    while IFS= read -r url; do
        if [ -n "$url" ]; then
            # Get the local file path
            local filename=$(basename "$url" | sed 's/\?.*//')
            if [ "$filename" = "blog" ] || [ "$filename" = "blogi" ]; then
                filename=$(echo "$url" | sed 's/.*\///' | sed 's/\?.*//')
            fi
            
            local local_file_path="$language/${filename}.html"
            
            if [ -f "$local_file_path" ]; then
                # Get local file modification time
                local local_mtime=$(stat -f %m "$local_file_path" 2>/dev/null || stat -c %Y "$local_file_path" 2>/dev/null)
                
                # Get remote file headers
                local remote_headers="$TEMP_DIR/headers_${filename}.txt"
                
                if curl -s -I "$url" -o "$remote_headers" --max-time 10; then
                    # Extract Last-Modified header
                    local last_modified=$(grep -i "last-modified:" "$remote_headers" | sed 's/.*: //' | tr -d '\r')
                    
                    if [ -n "$last_modified" ]; then
                        # Convert to timestamp for comparison
                        local remote_timestamp=$(date -d "$last_modified" +%s 2>/dev/null || echo "0")
                        
                        if [ "$remote_timestamp" -gt "$local_mtime" ]; then
                            log_info "  Updated: $url"
                            echo "$url" >> "$updated_articles_file"
                            ((updated_count++))
                        fi
                    fi
                fi
                
                # Be respectful - add small delay
                sleep 0.5
            fi
        fi
    done < "$local_file"
    
    if [ "$updated_count" -gt 0 ]; then
        log_success "Found $updated_count updated articles in $language"
        echo "Updated articles in $language:" >> "$LOG_FILE"
        cat "$updated_articles_file" >> "$LOG_FILE"
        echo "" >> "$LOG_FILE"
    else
        log_success "No updated articles found in $language"
    fi
    
    return $updated_count
}

# Generate summary report
generate_summary() {
    local total_new=0
    local total_updated=0
    
    log_info "Generating summary report..."
    
    # Count total new and updated articles
    for language in "${OUTPUT_DIRS[@]}"; do
        local new_count=$(wc -l < "$TEMP_DIR/new_articles_${language}.txt" 2>/dev/null || echo "0")
        local updated_count=$(wc -l < "$TEMP_DIR/updated_articles_${language}.txt" 2>/dev/null || echo "0")
        
        total_new=$((total_new + new_count))
        total_updated=$((total_updated + updated_count))
    done
    
    # Create summary
    {
        echo ""
        echo "=== UPDATE SUMMARY ==="
        echo "Total new articles: $total_new"
        echo "Total updated articles: $total_updated"
        echo "Total changes: $((total_new + total_updated))"
        echo ""
        
        if [ $((total_new + total_updated)) -gt 0 ]; then
            echo "To fetch new/updated content, run:"
            echo "  ./scripts/fetch-blog-articles.sh"
            echo "  ./scripts/extract-to-markdown.sh"
        else
            echo "No updates found. Content is up to date."
        fi
    } | tee -a "$LOG_FILE"
    
    log_success "Update check completed!"
    log_info "Summary: $total_new new, $total_updated updated articles"
}

# Main execution
main() {
    log_info "Starting Voog blog update check..."
    
    # Setup
    setup_directories
    
    local total_changes=0
    
    # Process each blog
    for i in "${!BLOG_URLS[@]}"; do
        local blog_url="${BLOG_URLS[$i]}"
        local output_dir="${OUTPUT_DIRS[$i]}"
        local language=""
        
        # Determine language from URL
        if [[ "$blog_url" == *"/blog/" ]]; then
            language="en"
        elif [[ "$blog_url" == *"/blogi/" ]]; then
            language="et"
        else
            language="unknown"
        fi
        
        log_info "Checking $language blog: $blog_url"
        
        # Get local and remote article lists
        local local_articles="$TEMP_DIR/local_articles_${language}.txt"
        local remote_articles="$TEMP_DIR/remote_articles_${language}.txt"
        
        get_local_articles "$language" "$local_articles"
        get_remote_articles "$blog_url" "$remote_articles" "$language"
        
        # Check for new articles
        check_new_articles "$local_articles" "$remote_articles" "$language"
        local new_count=$?
        
        # Check for updated articles
        check_updated_articles "$local_articles" "$language"
        local updated_count=$?
        
        total_changes=$((total_changes + new_count + updated_count))
        
        # Add delay between different blogs
        sleep 2
    done
    
    # Generate summary
    generate_summary
    
    # Exit with appropriate code
    if [ "$total_changes" -gt 0 ]; then
        exit 0  # Changes found
    else
        exit 1  # No changes
    fi
}

# Run main function
main "$@" 