#!/bin/bash

# Simple update checker for Voog support guides
# Checks for changes using HTTP headers

set -e

# Configuration
BASE_URL_EN="https://www.voog.com/support"
BASE_URL_ET="https://www.voog.com/tugi"
LOG_FILE="update-check-log.txt"
ETAG_FILE=".etags"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to get ETag from remote URL
get_remote_etag() {
    local url="$1"
    curl -sI "$url" 2>/dev/null | grep -i "etag:" | cut -d'"' -f2
}

# Function to get stored ETag for a local file
get_stored_etag() {
    local local_file="$1"
    local url_key=$(echo "$local_file" | sed 's|^en/||' | sed 's|^et/||' | sed 's|\.html$||')
    grep "^$url_key:" "$ETAG_FILE" 2>/dev/null | cut -d':' -f2
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

# Function to check a single article
check_article() {
    local remote_url="$1"
    local local_file="$2"
    local article_name="$3"
    
    if has_remote_changed "$remote_url" "$local_file"; then
        log_info "UPDATE: $article_name"
        return 0
    else
        log_info "CURRENT: $article_name"
        return 1
    fi
}

# Function to check English articles
check_english_articles() {
    log_info "Checking English articles..."
    
    local updated_count=0
    local current_count=0
    
    # Check a few key articles that are likely to be updated
    local test_articles=(
        "all-about-languages/configuring-the-flags-menu"
        "managing-your-blog/starting-your-first-blog-with-voog"
        "managing-your-content/creating-links"
        "your-websites-design/voog-design-editor"
        "seo/seo-optimization-in-voog"
    )
    
    for article in "${test_articles[@]}"; do
        local remote_url="$BASE_URL_EN/$article"
        local local_file="en/$article.html"
        
        if check_article "$remote_url" "$local_file" "$article"; then
            ((updated_count++))
        else
            ((current_count++))
        fi
        
        # Small delay to be respectful
        sleep 0.2
    done
    
    log_info "English check complete: $updated_count updated, $current_count current"
    return $updated_count
}

# Function to check Estonian articles
check_estonian_articles() {
    log_info "Checking Estonian articles..."
    
    local updated_count=0
    local current_count=0
    
    # Check a few key articles
    local test_articles=(
        "keeled/sinu-saidi-keelemenuu-seadistamine"
        "blogi/sinu-esimese-blogi-loomine-voos"
        "sisu-haldamine/linkide-loomine"
        "kujundus/voo-disainitooriist"
        "seo/seo-optimeerimine-voos"
    )
    
    for article in "${test_articles[@]}"; do
        local remote_url="$BASE_URL_ET/$article"
        local local_file="et/$article.html"
        
        if check_article "$remote_url" "$local_file" "$article"; then
            ((updated_count++))
        else
            ((current_count++))
        fi
        
        # Small delay to be respectful
        sleep 0.2
    done
    
    log_info "Estonian check complete: $updated_count updated, $current_count current"
    return $updated_count
}

# Main function
main() {
    local language="${1:-all}"
    
    # Initialize
    echo "=== Update Check Log - $(date) ===" > "$LOG_FILE"
    touch "$ETAG_FILE"
    
    log_info "Starting update check..."
    
    local total_updated=0
    
    case "$language" in
        "en"|"english")
            check_english_articles
            total_updated=$?
            ;;
        "et"|"estonian")
            check_estonian_articles
            total_updated=$?
            ;;
        "all")
            check_english_articles
            local en_updated=$?
            check_estonian_articles
            local et_updated=$?
            total_updated=$((en_updated + et_updated))
            ;;
        *)
            echo "Usage: $0 [en|et|all]"
            echo "  en/english  - Check only English articles"
            echo "  et/estonian - Check only Estonian articles"
            echo "  all         - Check both languages (default)"
            exit 1
            ;;
    esac
    
    log_info "Update check completed."
    
    echo ""
    echo "=== Update Check Summary ==="
    echo "Log file: $LOG_FILE"
    echo "Total updates found: $total_updated"
    
    if [ "$total_updated" -gt 0 ]; then
        log_success "Found $total_updated updated articles!"
        echo "Updated articles:"
        grep "UPDATE:" "$LOG_FILE" | sed 's/.*UPDATE: //'
    else
        log_info "No updates found - all content is current"
    fi
    
    exit $total_updated
}

# Run main function
main "$@" 