#!/bin/bash

# Smart fetcher that uses ETags to detect changes on Voog's servers

# Configuration
BASE_URL_EN="https://www.voog.com/support"
BASE_URL_ET="https://www.voog.com/tugi"
OUTPUT_DIR_EN="en"
OUTPUT_DIR_ET="et"
LOG_FILE="fetch-log.txt"
ETAG_FILE=".etags"

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Function to get ETag from remote URL
get_remote_etag() {
    local url="$1"
    curl -sI "$url" | grep -i "etag:" | cut -d'"' -f2
}

# Function to get stored ETag for a local file
get_stored_etag() {
    local local_file="$1"
    local url_key=$(echo "$local_file" | sed 's|^en/||' | sed 's|^et/||' | sed 's|\.html$||')
    grep "^$url_key:" "$ETAG_FILE" 2>/dev/null | cut -d':' -f2
}

# Function to store ETag for a local file
store_etag() {
    local local_file="$1"
    local etag="$2"
    local url_key=$(echo "$local_file" | sed 's|^en/||' | sed 's|^et/||' | sed 's|\.html$||')
    
    # Remove old entry if exists
    sed -i.bak "/^$url_key:/d" "$ETAG_FILE" 2>/dev/null
    # Add new entry
    echo "$url_key:$etag" >> "$ETAG_FILE"
}

# Function to check if remote file has changed
has_remote_changed() {
    local remote_url="$1"
    local local_file="$2"
    
    # If local file doesn't exist, remote has changed
    if [[ ! -f "$local_file" ]]; then
        return 0
    fi
    
    # Get remote ETag
    local remote_etag=$(get_remote_etag "$remote_url")
    
    if [[ -z "$remote_etag" ]]; then
        # If no ETag, assume remote has changed
        return 0
    fi
    
    # Get stored ETag
    local stored_etag=$(get_stored_etag "$local_file")
    
    # Compare ETags
    if [[ "$remote_etag" != "$stored_etag" ]]; then
        return 0  # Remote has changed
    else
        return 1  # Remote is the same
    fi
}

# Function to check if remote file exists and is accessible
check_remote_exists() {
    local url="$1"
    local http_code=$(curl -sI "$url" | head -1 | cut -d' ' -f2)
    [[ "$http_code" == "200" ]]
}

# Function to fetch a single article with ETag check
fetch_article_smart() {
    local url="$1"
    local output_file="$2"
    local article_name="$3"
    
    # Check if remote file exists
    if ! check_remote_exists "$url"; then
        log_message "WARNING: Remote file not accessible: $url"
        return 1
    fi
    
    # Check if remote has changed
    if has_remote_changed "$url" "$output_file"; then
        log_message "UPDATE: Fetching updated article: $article_name"
        
        # Create output directory
        mkdir -p "$(dirname "$output_file")"
        
        # Fetch the article
        if curl -s "$url" > "$output_file"; then
            log_message "SUCCESS: Downloaded: $article_name"
            
            # Store the new ETag
            local new_etag=$(get_remote_etag "$url")
            if [[ -n "$new_etag" ]]; then
                store_etag "$output_file" "$new_etag"
            fi
            
            # Apply image fixes if it's an HTML file
            if [[ "$output_file" == *.html ]]; then
                apply_image_fixes "$output_file"
            fi
            
            return 0
        else
            log_message "ERROR: Failed to download: $article_name"
            return 1
        fi
    else
        log_message "SKIP: No update needed: $article_name"
        return 0
    fi
}

# Function to apply image fixes (same as in original fetcher)
apply_image_fixes() {
    local html_file="$1"
    
    # Inject CSS for better image display
    awk -v css='<style>
        /* Fix for image display - More aggressive overrides */
        .edy-texteditor-container.image-container {
            position: relative !important;
            width: 100% !important;
            max-width: 800px !important;
            margin: 20px auto !important;
            overflow: visible !important;
            height: auto !important;
            min-height: 200px !important;
        }
        .edy-texteditor-container.image-container img {
            max-width: 100% !important;
            height: auto !important;
            display: block !important;
            margin: 0 auto !important;
        }
        .edy-texteditor-container.image-container picture {
            display: block !important;
            width: 100% !important;
        }
        .edy-texteditor-container.image-container source {
            display: none !important;
        }
        /* Improve content readability */
        .edy-texteditor-container {
            max-width: 800px !important;
            margin: 0 auto !important;
            line-height: 1.6 !important;
        }
        .edy-texteditor-container p {
            margin-bottom: 1em !important;
        }
        .edy-texteditor-container h1, .edy-texteditor-container h2, .edy-texteditor-container h3 {
            margin-top: 1.5em !important;
            margin-bottom: 0.5em !important;
        }
    </style>' '
    /<head>/ {
        print $0
        print css
        next
    }
    { print }
    ' "$html_file" > "${html_file}.tmp" && mv "${html_file}.tmp" "$html_file"
    
    # Fix protocol-relative URLs
    sed -i '' 's|src="//media.voog.com|src="https://media.voog.com|g' "$html_file"
    sed -i '' 's|srcset="//media.voog.com|srcset="https://media.voog.com|g' "$html_file"
    sed -i '' 's|background-image: url("//media.voog.com|background-image: url("https://media.voog.com|g' "$html_file"
    
    # Fix double https: issues
    sed -i '' 's|https:https://|https://|g' "$html_file"
}

# Function to discover articles from a section page
discover_articles() {
    local section_url="$1"
    local temp_file=$(mktemp)
    
    # Fetch section page
    if curl -s "$section_url" > "$temp_file"; then
        # Extract article URLs
        grep -o 'href="[^"]*"' "$temp_file" | grep -E "(support|tugi)/[^/]+/[^"]*" | sed 's/href="//' | sed 's/"$//' | sort -u
    fi
    
    rm -f "$temp_file"
}

# Function to fetch English articles
fetch_english_articles() {
    log_message "Starting smart fetch for English articles..."
    
    local sections=(
        "all-about-languages"
        "content-areas"
        "creating-and-managing-forms"
        "managing-your-blog"
        "managing-your-content"
        "managing-your-website-pages"
        "online-store"
        "seo"
        "setting-up-your-account"
        "stats-and-maintenance"
        "video-tutorials"
        "webinars"
        "your-pictures-and-files"
        "your-subscriptions"
        "your-website-addresses"
        "your-websites-design"
        "contact"
    )
    
    local total_articles=0
    local updated_articles=0
    local skipped_articles=0
    local failed_articles=0
    
    for section in "${sections[@]}"; do
        log_message "Processing English section: $section"
        
        # Discover articles in this section
        local section_url="$BASE_URL_EN/$section"
        local article_urls=$(discover_articles "$section_url")
        
        for article_url in $article_urls; do
            # Extract article filename
            local filename=$(basename "$article_url")
            local output_file="$OUTPUT_DIR_EN/$section/$filename"
            
            total_articles=$((total_articles + 1))
            
            if fetch_article_smart "$article_url" "$output_file" "$section/$filename"; then
                if [[ -f "$output_file" ]] && [[ $(stat -f%m "$output_file" 2>/dev/null || stat -c%Y "$output_file" 2>/dev/null) -gt $(date -d "1 minute ago" +%s) ]]; then
                    updated_articles=$((updated_articles + 1))
                else
                    skipped_articles=$((skipped_articles + 1))
                fi
            else
                failed_articles=$((failed_articles + 1))
            fi
            
            # Add a small delay to be respectful to the server
            sleep 0.5
        done
    done
    
    log_message "English fetch complete: $total_articles total, $updated_articles updated, $skipped_articles skipped, $failed_articles failed"
}

# Function to fetch Estonian articles
fetch_estonian_articles() {
    log_message "Starting smart fetch for Estonian articles..."
    
    local sections=(
        "blogi"
        "domeenid"
        "e-pood"
        "keeled"
        "kontakt"
        "konto-loomine"
        "kujundus"
        "lehed"
        "pildid-ja-failid"
        "seo"
        "sisu-haldamine"
        "sisualad"
        "statistika-ja-saidi-haldamine"
        "tellimus"
        "veebiseminar"
        "videojuhendid"
        "vormid"
    )
    
    local total_articles=0
    local updated_articles=0
    local skipped_articles=0
    local failed_articles=0
    
    for section in "${sections[@]}"; do
        log_message "Processing Estonian section: $section"
        
        # Discover articles in this section
        local section_url="$BASE_URL_ET/$section"
        local article_urls=$(discover_articles "$section_url")
        
        for article_url in $article_urls; do
            # Extract article filename
            local filename=$(basename "$article_url")
            local output_file="$OUTPUT_DIR_ET/$section/$filename"
            
            total_articles=$((total_articles + 1))
            
            if fetch_article_smart "$article_url" "$output_file" "$section/$filename"; then
                if [[ -f "$output_file" ]] && [[ $(stat -f%m "$output_file" 2>/dev/null || stat -c%Y "$output_file" 2>/dev/null) -gt $(date -d "1 minute ago" +%s) ]]; then
                    updated_articles=$((updated_articles + 1))
                else
                    skipped_articles=$((skipped_articles + 1))
                fi
            else
                failed_articles=$((failed_articles + 1))
            fi
            
            # Add a small delay to be respectful to the server
            sleep 0.5
        done
    done
    
    log_message "Estonian fetch complete: $total_articles total, $updated_articles updated, $skipped_articles skipped, $failed_articles failed"
}

# Main function
main() {
    local language="${1:-all}"
    
    # Initialize log file
    echo "=== Smart Fetch Log - $(date) ===" > "$LOG_FILE"
    
    # Initialize ETag file if it doesn't exist
    touch "$ETAG_FILE"
    
    log_message "Starting smart fetch process using ETags..."
    
    case "$language" in
        "en"|"english")
            fetch_english_articles
            ;;
        "et"|"estonian")
            fetch_estonian_articles
            ;;
        "all")
            fetch_english_articles
            fetch_estonian_articles
            ;;
        *)
            echo "Usage: $0 [en|et|all]"
            echo "  en/english  - Fetch only English articles"
            echo "  et/estonian - Fetch only Estonian articles"
            echo "  all         - Fetch both languages default"
            exit 1
            ;;
    esac
    
    log_message "Smart fetch process completed."
    
    # Regenerate indexes if any articles were updated
    if grep -q "UPDATE:" "$LOG_FILE"; then
        log_message "Regenerating indexes due to updates..."
        ./scripts/generate-simple-index.sh
        ./scripts/generate-estonian-index.sh
        ./scripts/generate-text-index.sh
        ./scripts/generate-estonian-text-index.sh
        log_message "Indexes regenerated."
    fi
    
    echo ""
    echo "=== Fetch Summary ==="
    echo "Log file: $LOG_FILE"
    echo "ETag file: $ETAG_FILE"
    echo "Updated articles: $(grep -c "UPDATE:" "$LOG_FILE")"
    echo "Skipped articles: $(grep -c "SKIP:" "$LOG_FILE")"
    echo "Failed articles: $(grep -c "ERROR:" "$LOG_FILE")"
}

# Run main function with arguments
main "$@" 