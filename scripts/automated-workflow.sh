#!/bin/bash

# Voog Support Guides - Automated Workflow
# Complete pipeline: Check updates → Fetch → Extract → Validate

set -e

# Configuration
LOG_FILE="workflow-log.txt"
REPORT_DIR="workflow-reports"
BACKUP_DIR="backups"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Workflow state tracking
WORKFLOW_START_TIME=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
UPDATES_FOUND=0
EXTRACTION_SUCCESS=false
VALIDATION_SUCCESS=false

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
    log_info "Starting Voog Support Guides Automated Workflow"
    log_info "Start time: $WORKFLOW_START_TIME"
    
    # Create necessary directories
    mkdir -p "$REPORT_DIR"
    mkdir -p "$BACKUP_DIR"
    
    # Create backup of current markdown content
    if [ -d "markdown-content" ]; then
        local backup_name="backup-$(date +%Y%m%d-%H%M%S)"
        log_info "Creating backup of current markdown content: $backup_name"
        cp -r markdown-content "$BACKUP_DIR/$backup_name"
    fi
    
    # Initialize log
    echo "=== Voog Support Guides Workflow Log ===" > "$LOG_FILE"
    echo "Started: $WORKFLOW_START_TIME" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
}

# Step 1: Check for updates using smart fetch
check_for_updates() {
    log_info "Step 1: Checking for updates on Voog servers..."
    
    # Run update check
    if ./scripts/check-updates.sh all; then
        log_success "Update check completed"
        
        # Check if any files were updated
        local updated_count=$(grep -c "UPDATE:" "$LOG_FILE" 2>/dev/null || echo "0")
        if [ "$updated_count" -gt 0 ]; then
            UPDATES_FOUND=$updated_count
            log_info "Found $UPDATES_FOUND updated files"
        else
            log_info "No updates found - all content is current"
        fi
    else
        log_error "Update check failed"
        return 1
    fi
}

# Step 2: Fetch updated content
fetch_updates() {
    if [ "$UPDATES_FOUND" -eq 0 ]; then
        log_info "Step 2: Skipping fetch - no updates needed"
        return 0
    fi
    
    log_info "Step 2: Fetching updated content..."
    
    # Run smart fetch to download updates
    if ./scripts/smart-fetch-etag.sh fetch all; then
        log_success "Content fetch completed successfully"
    else
        log_error "Content fetch failed"
        return 1
    fi
}

# Step 3: Extract to markdown
extract_to_markdown() {
    log_info "Step 3: Extracting content to markdown format..."
    
    # Run the extraction script
    if ./scripts/extract-to-markdown.sh; then
        log_success "Markdown extraction completed successfully"
        EXTRACTION_SUCCESS=true
    else
        log_error "Markdown extraction failed"
        return 1
    fi
}

# Step 4: Validate extraction quality
validate_extraction() {
    log_info "Step 4: Validating extraction quality..."
    
    # Run validation script
    if ./scripts/validate-extraction.sh; then
        log_success "Validation completed successfully"
        VALIDATION_SUCCESS=true
    else
        log_warning "Validation found issues - check validation-report.md"
        return 1
    fi
}

# Step 5: Generate workflow report
generate_workflow_report() {
    local end_time=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
    local report_file="$REPORT_DIR/workflow-report-$(date +%Y%m%d-%H%M%S).md"
    
    log_info "Step 5: Generating workflow report..."
    
    cat > "$report_file" << EOF
# Voog Support Guides - Automated Workflow Report

**Workflow ID:** $(date +%Y%m%d-%H%M%S)
**Start Time:** $WORKFLOW_START_TIME
**End Time:** $end_time
**Duration:** $(($(date -d "$end_time" +%s) - $(date -d "$WORKFLOW_START_TIME" +%s))) seconds

## Workflow Summary

- **Updates Found:** $UPDATES_FOUND
- **Extraction Success:** $([ "$EXTRACTION_SUCCESS" = true ] && echo "✅ YES" || echo "❌ NO")
- **Validation Success:** $([ "$VALIDATION_SUCCESS" = true ] && echo "✅ YES" || echo "❌ NO")
- **Overall Status:** $([ "$EXTRACTION_SUCCESS" = true ] && [ "$VALIDATION_SUCCESS" = true ] && echo "✅ SUCCESS" || echo "❌ FAILED")

## Step Results

### Step 1: Update Check
- **Status:** ✅ Completed
- **Updates Found:** $UPDATES_FOUND files

### Step 2: Content Fetch
- **Status:** $([ "$UPDATES_FOUND" -gt 0 ] && echo "✅ Completed" || echo "⏭️ Skipped")
- **Files Updated:** $UPDATES_FOUND

### Step 3: Markdown Extraction
- **Status:** $([ "$EXTRACTION_SUCCESS" = true ] && echo "✅ Success" || echo "❌ Failed")
- **Output:** markdown-content/ directory

### Step 4: Quality Validation
- **Status:** $([ "$VALIDATION_SUCCESS" = true ] && echo "✅ Success" || echo "⚠️ Issues Found")
- **Report:** validation-report.md

## Recommendations

EOF
    
    if [ "$EXTRACTION_SUCCESS" = true ] && [ "$VALIDATION_SUCCESS" = true ]; then
        echo "✅ Workflow completed successfully. Content is ready for use." >> "$report_file"
    elif [ "$EXTRACTION_SUCCESS" = true ] && [ "$VALIDATION_SUCCESS" != true ]; then
        echo "⚠️ Extraction completed but validation found issues. Review validation-report.md" >> "$report_file"
    else
        echo "❌ Workflow failed. Check logs for details." >> "$report_file"
    fi
    
    if [ "$UPDATES_FOUND" -eq 0 ]; then
        echo "ℹ️ No updates were found - content is current." >> "$report_file"
    fi
    
    log_success "Workflow report generated: $report_file"
}

# Step 6: Cleanup and maintenance
cleanup() {
    log_info "Step 6: Performing cleanup and maintenance..."
    
    # Keep only last 5 backups
    local backup_count=$(ls -1 "$BACKUP_DIR" 2>/dev/null | wc -l)
    if [ "$backup_count" -gt 5 ]; then
        local to_remove=$((backup_count - 5))
        log_info "Removing $to_remove old backups"
        ls -1t "$BACKUP_DIR" | tail -n "$to_remove" | xargs -I {} rm -rf "$BACKUP_DIR/{}"
    fi
    
    # Keep only last 10 workflow reports
    local report_count=$(ls -1 "$REPORT_DIR" 2>/dev/null | wc -l)
    if [ "$report_count" -gt 10 ]; then
        local to_remove=$((report_count - 10))
        log_info "Removing $to_remove old workflow reports"
        ls -1t "$REPORT_DIR" | tail -n "$to_remove" | xargs -I {} rm -f "$REPORT_DIR/{}"
    fi
    
    log_success "Cleanup completed"
}

# Main workflow execution
main() {
    local workflow_start=$(date +%s)
    
    # Initialize
    init_workflow
    
    # Execute workflow steps
    if check_for_updates; then
        if fetch_updates; then
            if extract_to_markdown; then
                if validate_extraction; then
                    log_success "All workflow steps completed successfully!"
                else
                    log_warning "Validation found issues but workflow completed"
                fi
            else
                log_error "Extraction failed - workflow stopped"
                exit 1
            fi
        else
            log_error "Fetch failed - workflow stopped"
            exit 1
        fi
    else
        log_error "Update check failed - workflow stopped"
        exit 1
    fi
    
    # Generate report and cleanup
    generate_workflow_report
    cleanup
    
    # Final summary
    local workflow_end=$(date +%s)
    local duration=$((workflow_end - workflow_start))
    
    log_info "Workflow completed in ${duration} seconds"
    log_info "Final status: $([ "$EXTRACTION_SUCCESS" = true ] && [ "$VALIDATION_SUCCESS" = true ] && echo "SUCCESS" || echo "COMPLETED WITH ISSUES")"
    
    if [ "$EXTRACTION_SUCCESS" = true ] && [ "$VALIDATION_SUCCESS" = true ]; then
        log_success "🎉 Workflow completed successfully! Content is ready for AI processing."
        exit 0
    else
        log_warning "⚠️ Workflow completed with issues. Check reports for details."
        exit 1
    fi
}

# Handle command line arguments
case "${1:-run}" in
    "run")
        main
        ;;
    "check-only")
        init_workflow
        check_for_updates
        ;;
    "extract-only")
        init_workflow
        extract_to_markdown
        validate_extraction
        ;;
    "validate-only")
        init_workflow
        validate_extraction
        ;;
    "help"|"-h"|"--help")
        echo "Voog Support Guides - Automated Workflow"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  run          Run complete workflow (default)"
        echo "  check-only   Only check for updates"
        echo "  extract-only Only extract to markdown and validate"
        echo "  validate-only Only validate existing extraction"
        echo "  help         Show this help message"
        echo ""
        echo "The complete workflow:"
        echo "1. Check for updates on Voog servers"
        echo "2. Fetch updated content"
        echo "3. Extract HTML to markdown"
        echo "4. Validate extraction quality"
        echo "5. Generate workflow report"
        echo "6. Cleanup old backups and reports"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Use '$0 help' for usage information"
        exit 1
        ;;
esac 