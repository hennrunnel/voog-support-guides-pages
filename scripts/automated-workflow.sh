#!/bin/bash

# Voog Blog Articles - Automated Workflow Script
# Complete pipeline for fetching, extracting, and validating blog content

set -e

# Configuration
LOG_FILE="workflow.log"
BACKUP_DIR="backup-$(date +%Y%m%d-%H%M%S)"

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

# Initialize workflow
init_workflow() {
    log_info "Starting Voog Blog Articles automated workflow..."
    
    # Initialize log file
    echo "Voog Blog Articles Workflow Log - $(date)" > "$LOG_FILE"
    echo "==========================================" >> "$LOG_FILE"
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    log_success "Workflow initialized"
}

# Create backup of existing content
create_backup() {
    log_info "Creating backup of existing content..."
    
    # Backup HTML files
    if [ -d "en" ] && [ "$(ls -A en)" ]; then
        cp -r en "$BACKUP_DIR/"
        log_success "Backed up English HTML files"
    fi
    
    if [ -d "et" ] && [ "$(ls -A et)" ]; then
        cp -r et "$BACKUP_DIR/"
        log_success "Backed up Estonian HTML files"
    fi
    
    # Backup markdown files
    if [ -d "markdown-content" ] && [ "$(ls -A markdown-content)" ]; then
        cp -r markdown-content "$BACKUP_DIR/"
        log_success "Backed up markdown content"
    fi
    
    # Backup JSON files
    if [ -d "json-content" ] && [ "$(ls -A json-content)" ]; then
        cp -r json-content "$BACKUP_DIR/"
        log_success "Backed up JSON content"
    fi
    
    log_success "Backup completed: $BACKUP_DIR"
}

# Check for updates
check_updates() {
    log_info "Checking for updates..."
    
    if ./scripts/check-updates.sh; then
        log_success "Updates found - proceeding with fetch"
        return 0
    else
        log_info "No updates found - content is current"
        return 1
    fi
}

# Fetch blog articles
fetch_articles() {
    log_info "Fetching blog articles..."
    
    if ./scripts/fetch-blog-articles.sh; then
        log_success "Blog articles fetched successfully"
        return 0
    else
        log_error "Failed to fetch blog articles"
        return 1
    fi
}

# Extract to markdown
extract_markdown() {
    log_info "Extracting content to markdown..."
    
    if ./scripts/extract-to-markdown.sh; then
        log_success "Markdown extraction completed"
        return 0
    else
        log_error "Failed to extract markdown"
        return 1
    fi
}

# Validate extraction quality
validate_extraction() {
    log_info "Validating extraction quality..."
    
    local validation_errors=0
    
    # Check if markdown files were created
    local en_count=$(find "markdown-content/en" -name "*.md" 2>/dev/null | wc -l)
    local et_count=$(find "markdown-content/et" -name "*.md" 2>/dev/null | wc -l)
    
    if [ "$en_count" -eq 0 ] && [ "$et_count" -eq 0 ]; then
        log_error "No markdown files found - extraction may have failed"
        ((validation_errors++))
    else
        log_success "Found $en_count English and $et_count Estonian markdown files"
    fi
    
    # Check for empty content
    local empty_files=0
    for file in markdown-content/en/*.md markdown-content/et/*.md 2>/dev/null; do
        if [ -f "$file" ]; then
            local content_length=$(awk '/^---$/{p=!p;next}p' "$file" | wc -w)
            if [ "$content_length" -lt 10 ]; then
                log_warning "Potentially empty content in: $file"
                ((empty_files++))
            fi
        fi
    done
    
    if [ "$empty_files" -gt 0 ]; then
        log_warning "Found $empty_files files with potentially empty content"
    fi
    
    # Check JSON structure
    if [ -f "json-content/blog-index.json" ]; then
        if python3 -m json.tool "json-content/blog-index.json" >/dev/null 2>&1; then
            log_success "JSON structure is valid"
        else
            log_error "JSON structure is invalid"
            ((validation_errors++))
        fi
    else
        log_error "JSON index file not found"
        ((validation_errors++))
    fi
    
    # Check aggregated files
    if [ -f "markdown-content/aggregated/all-blog-content-en.md" ] && \
       [ -f "markdown-content/aggregated/all-blog-content-et.md" ]; then
        log_success "Aggregated files created"
    else
        log_error "Aggregated files missing"
        ((validation_errors++))
    fi
    
    if [ "$validation_errors" -eq 0 ]; then
        log_success "Validation completed successfully"
        return 0
    else
        log_error "Validation found $validation_errors errors"
        return 1
    fi
}

# Generate statistics
generate_stats() {
    log_info "Generating content statistics..."
    
    local en_html=$(find "en" -name "*.html" 2>/dev/null | wc -l)
    local et_html=$(find "et" -name "*.html" 2>/dev/null | wc -l)
    local en_md=$(find "markdown-content/en" -name "*.md" 2>/dev/null | wc -l)
    local et_md=$(find "markdown-content/et" -name "*.md" 2>/dev/null | wc -l)
    
    {
        echo ""
        echo "=== CONTENT STATISTICS ==="
        echo "HTML Files:"
        echo "  English: $en_html"
        echo "  Estonian: $et_html"
        echo "  Total: $((en_html + et_html))"
        echo ""
        echo "Markdown Files:"
        echo "  English: $en_md"
        echo "  Estonian: $et_md"
        echo "  Total: $((en_md + et_md))"
        echo ""
        echo "Output Files:"
        echo "  JSON Index: $(ls -1 json-content/ 2>/dev/null | wc -l)"
        echo "  Aggregated: $(ls -1 markdown-content/aggregated/ 2>/dev/null | wc -l)"
        echo ""
    } | tee -a "$LOG_FILE"
    
    log_success "Statistics generated"
}

# Cleanup temporary files
cleanup() {
    log_info "Cleaning up temporary files..."
    
    # Remove temporary directories
    rm -rf temp-* 2>/dev/null || true
    
    # Remove log files from scripts
    rm -f fetch-log.txt update-check.log 2>/dev/null || true
    
    log_success "Cleanup completed"
}

# Main workflow
main() {
    local force_update="${1:-false}"
    
    # Initialize
    init_workflow
    
    # Create backup
    create_backup
    
    # Check for updates (unless forced)
    if [ "$force_update" != "force" ]; then
        if ! check_updates; then
            log_info "No updates needed - workflow completed"
            cleanup
            exit 0
        fi
    else
        log_info "Force update mode - skipping update check"
    fi
    
    # Fetch articles
    if ! fetch_articles; then
        log_error "Workflow failed at fetch stage"
        exit 1
    fi
    
    # Extract to markdown
    if ! extract_markdown; then
        log_error "Workflow failed at extraction stage"
        exit 1
    fi
    
    # Validate extraction
    if ! validate_extraction; then
        log_warning "Validation found issues - check log for details"
    fi
    
    # Generate statistics
    generate_stats
    
    # Cleanup
    cleanup
    
    log_success "Workflow completed successfully!"
    log_info "Log file: $LOG_FILE"
    log_info "Backup: $BACKUP_DIR"
}

# Show usage
show_usage() {
    echo "Usage: $0 [force]"
    echo ""
    echo "Options:"
    echo "  force    - Force update even if no changes detected"
    echo ""
    echo "Examples:"
    echo "  $0        - Normal workflow with update check"
    echo "  $0 force  - Force complete refresh"
}

# Check arguments
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_usage
    exit 0
fi

# Run main workflow
main "$@" 