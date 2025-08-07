#!/bin/bash

# Voog Blog Articles - Fetch Script
# Discovers and downloads blog articles from Voog's public blog pages

set -e

# Configuration
BLOG_URLS=(
    "https://www.voog.com/blog/"
    "https://www.voog.com/blogi/"
)
OUTPUT_DIRS=("en" "et")
TEMP_DIR="temp-fetch"
LOG_FILE="fetch-log.txt"

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
    for dir in "${OUTPUT_DIRS[@]}"; do
        mkdir -p "$dir"
    done
    
    # Initialize log file
    echo "Voog Blog Fetch Log - $(date)" > "$LOG_FILE"
    echo "================================" >> "$LOG_FILE"
    
    log_success "Directories created"
}

# Extract article URLs from blog listing page
extract_article_urls() {
    local blog_url="$1"
    local temp_file="$2"
    
    log_info "Fetching blog listing page: $blog_url"
    
    # Download the blog listing page
    if curl -s -L "$blog_url" -o "$temp_file" --max-time 30; then
        log_success "Downloaded blog listing page"
    else
        log_error "Failed to download blog listing page: $blog_url"
        return 1
    fi
    
    # Extract article URLs using multiple strategies
    local article_urls=""
    
    # Strategy 1: Look for article links with common patterns
    article_urls=$(grep -o 'href="[^"]*blog[^"]*"' "$temp_file" | \
        sed 's/href="//g' | sed 's/"//g' | \
        grep -E '(\.html|/[0-9]{4}/|/[a-z-]+/)' | \
        sort -u)
    
    # Strategy 2: Look for links containing blog-related keywords
    if [ -z "$article_urls" ]; then
        article_urls=$(grep -o 'href="[^"]*"' "$temp_file" | \
            sed 's/href="//g' | sed 's/"//g' | \
            grep -E '(post|article|blog|news)' | \
            sort -u)
    fi
    
    # Strategy 3: Look for links with dates or slugs
    if [ -z "$article_urls" ]; then
        article_urls=$(grep -o 'href="[^"]*"' "$temp_file" | \
            sed 's/href="//g' | sed 's/"//g' | \
            grep -E '(/[0-9]{4}/|/[a-z-]+/[a-z-]+/)' | \
            sort -u)
    fi
    
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
    done | sort -u
}

# Check if URL is a blog article (not a listing page)
is_article_url() {
    local url="$1"
    
    # Skip listing pages and common non-article URLs
    if [[ "$url" == */blog/* ]] || [[ "$url" == */blogi/* ]]; then
        # Check if it looks like an article (has slug, date, or .html)
        if [[ "$url" =~ /[0-9]{4}/ ]] || \
           [[ "$url" =~ \.html$ ]] || \
           [[ "$url" =~ /[a-z-]+/[a-z-]+/ ]]; then
            return 0
        fi
    fi
    
    return 1
}

# Download individual article
download_article() {
    local url="$1"
    local output_dir="$2"
    local filename="$3"
    
    log_info "Downloading article: $url"
    
    # Create a safe filename
    local safe_filename=$(echo "$filename" | sed 's/[^a-zA-Z0-9._-]/-/g')
    local output_file="$output_dir/$safe_filename.html"
    
    # Download with proper headers and timeout
    if curl -s -L "$url" -o "$output_file" \
        -H "User-Agent: Mozilla/5.0 (compatible; VoogBlogFetcher/1.0)" \
        --max-time 30 \
        --retry 3; then
        
        # Check if file has content
        if [ -s "$output_file" ]; then
            log_success "Downloaded: $safe_filename"
            echo "$url|$output_file" >> "$TEMP_DIR/downloaded_articles.txt"
        else
            log_warning "Empty file downloaded: $url"
            rm -f "$output_file"
        fi
    else
        log_error "Failed to download: $url"
    fi
    
    # Be respectful - add delay between requests
    sleep 1
}

# Process blog for a specific language
process_blog() {
    local blog_url="$1"
    local output_dir="$2"
    local language="$3"
    
    log_info "Processing blog: $blog_url (Language: $language)"
    
    # Create temporary file for blog listing
    local temp_listing="$TEMP_DIR/blog_listing_${language}.html"
    
    # Extract article URLs
    local article_urls=$(extract_article_urls "$blog_url" "$temp_listing")
    
    if [ -z "$article_urls" ]; then
        log_warning "No article URLs found for: $blog_url"
        return 1
    fi
    
    log_info "Found $(echo "$article_urls" | wc -l) potential article URLs"
    
    # Download each article
    local downloaded_count=0
    while IFS= read -r url; do
        if [ -n "$url" ] && is_article_url "$url"; then
            # Extract filename from URL
            local filename=$(basename "$url" | sed 's/\?.*//')
            if [ "$filename" = "blog" ] || [ "$filename" = "blogi" ]; then
                # Extract from path instead
                filename=$(echo "$url" | sed 's/.*\///' | sed 's/\?.*//')
            fi
            
            # Add .html extension if missing
            if [[ "$filename" != *.html ]]; then
                filename="${filename}.html"
            fi
            
            download_article "$url" "$output_dir" "$filename"
            ((downloaded_count++))
        fi
    done <<< "$article_urls"
    
    log_success "Downloaded $downloaded_count articles for $language"
}

# Handle pagination (if needed)
handle_pagination() {
    local blog_url="$1"
    local output_dir="$2"
    local language="$3"
    
    log_info "Checking for pagination in: $blog_url"
    
    # Download first page to check for pagination
    local temp_page="$TEMP_DIR/pagination_check_${language}.html"
    
    if curl -s -L "$blog_url" -o "$temp_page" --max-time 30; then
        # Look for pagination links
        local next_pages=$(grep -o 'href="[^"]*page[^"]*"' "$temp_page" | \
            sed 's/href="//g' | sed 's/"//g' | \
            grep -E '(page|p=)' | sort -u)
        
        if [ -n "$next_pages" ]; then
            log_info "Found pagination links: $(echo "$next_pages" | wc -l) pages"
            
            # Process each page
            while IFS= read -r page_url; do
                if [ -n "$page_url" ]; then
                    # Convert relative URLs to absolute
                    local full_url="$page_url"
                    if [[ "$page_url" == /* ]]; then
                        local base_url=$(echo "$blog_url" | sed 's|/$||')
                        full_url="${base_url}${page_url}"
                    fi
                    
                    log_info "Processing paginated page: $full_url"
                    process_blog "$full_url" "$output_dir" "$language"
                    sleep 2  # Be extra respectful with pagination
                fi
            done <<< "$next_pages"
        else
            log_info "No pagination found, processing single page"
            process_blog "$blog_url" "$output_dir" "$language"
        fi
    else
        log_error "Failed to check pagination for: $blog_url"
        # Fallback to single page processing
        process_blog "$blog_url" "$output_dir" "$language"
    fi
}

# Main execution
main() {
    log_info "Starting Voog blog article fetch..."
    
    # Setup
    setup_directories
    
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
        
        log_info "Processing $language blog: $blog_url"
        
        # Handle pagination and download articles
        handle_pagination "$blog_url" "$output_dir" "$language"
        
        # Add delay between different blogs
        sleep 3
    done
    
    # Summary
    local total_downloaded=$(wc -l < "$TEMP_DIR/downloaded_articles.txt" 2>/dev/null || echo "0")
    log_success "Fetch completed! Total articles downloaded: $total_downloaded"
    
    # Show summary by language
    for dir in "${OUTPUT_DIRS[@]}"; do
        local count=$(find "$dir" -name "*.html" | wc -l)
        log_info "Articles in $dir/: $count"
    done
}

# Run main function
main "$@" 