#!/bin/bash

# Voog Support Guides - Universal Fetcher
# Fetches all support articles from all sections

# Configuration
BASE_URL="https://www.voog.com/support"
OUTPUT_DIR="en"

# All support sections with their article counts
SECTIONS="all-about-languages content-areas creating-and-managing-forms managing-your-blog managing-your-content managing-your-website-pages online-store seo setting-up-your-account stats-and-maintenance video-tutorials webinars your-pictures-and-files your-subscriptions your-website-addresses your-websites-design contact"

# Function to extract title from HTML
extract_title() {
    local html_file="$1"
    grep -o '<title>.*</title>' "$html_file" | sed 's/<title>\(.*\) | Voog website builder<\/title>/\1/'
}

# Function to extract description from HTML
extract_description() {
    local html_file="$1"
    grep -o '<div class="ListingArticleDescription">.*</div>' "$html_file" | sed 's/<div class="ListingArticleDescription">\(.*\)<\/div>/\1/' | sed 's/<[^>]*>//g'
}

# Function to discover articles in a section
discover_articles() {
    local section="$1"
    local section_url="$BASE_URL/$section"
    
    # Fetch the section page and extract article URLs
    local temp_file=$(mktemp)
    curl -s "$section_url" > "$temp_file"
    
    # Extract article URLs
    local articles=($(grep -o "href=\"/support/$section/[^\"]*\"" "$temp_file" | sed 's/href="//g' | sed 's/"//g' | sort | uniq))
    
    rm "$temp_file"
    
    # Return the articles array
    printf '%s\n' "${articles[@]}"
}

# Function to fetch a single article
fetch_article() {
    local article_url="$1"
    local output_file="$2"
    
    echo "  Fetching: $article_url"
    
    # Create temp file for the HTML
    local temp_html=$(mktemp)
    
    # Fetch the page
    if curl -s "$article_url" > "$temp_html"; then
        # Extract title
        local title=$(extract_title "$temp_html")
        if [[ -z "$title" ]]; then
            title="Untitled Article"
        fi
        
        echo "  ✓ Extracted title: $title"
        
        # Save the HTML content directly
        cp "$temp_html" "$output_file"
        
        # Clean up temp file
        rm "$temp_html"
        
        return 0
    else
        echo "  ✗ Failed to fetch: $article_url"
        rm -f "$temp_html"
        return 1
    fi
}

# Function to fetch all articles in a section
fetch_section() {
    local section="$1"
    local section_dir="$OUTPUT_DIR/$section"
    
    echo "Processing section: $section"
    echo "Output directory: $section_dir"
    echo ""
    
    # Create section directory
    mkdir -p "$section_dir"
    
    # Discover articles in this section
    local articles=($(discover_articles "$section"))
    
    if [[ ${#articles[@]} -eq 0 ]]; then
        echo "No articles found in section: $section"
        return
    fi
    
    echo "Found ${#articles[@]} articles in $section"
    
    local success_count=0
    local total_count=${#articles[@]}
    
    # Fetch each article
    for article_url in "${articles[@]}"; do
        # Construct full URL
        local full_url="https://www.voog.com$article_url"
        
        # Extract filename from URL
        local filename=$(basename "$article_url")
        local output_file="$section_dir/$filename.html"
        
        if fetch_article "$full_url" "$output_file"; then
            success_count=$((success_count + 1))
        fi
    done
    
    echo ""
    echo "Section $section completed: $success_count/$total_count articles fetched"
    echo "----------------------------------------"
}

# Function to apply image fixes to all HTML files
apply_image_fixes() {
    echo "Applying image fixes to all HTML files..."
    
    # Find all HTML files
    local html_files=($(find "$OUTPUT_DIR" -name "*.html" -not -name "index.html"))
    
    for file in "${html_files[@]}"; do
        echo "Processing: $file"
        
        # Check if CSS is already added
        if ! grep -q "Fix for image display" "$file"; then
            echo "  ✓ Adding CSS..."
            
            # Create a temporary file with the CSS content
            cat > /tmp/css_fix.css << 'EOF'
<style>
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

.edy-texteditor-container.image-container .edy-padding-resizer-wrapper {
    position: relative !important;
    padding-bottom: 0 !important;
    overflow: visible !important;
    height: auto !important;
    min-height: 200px !important;
}

.edy-texteditor-container.image-container picture {
    position: relative !important;
    display: block !important;
    width: 100% !important;
    height: auto !important;
    left: 0 !important;
    top: 0 !important;
    min-height: 200px !important;
}

.edy-texteditor-container.image-container img {
    position: relative !important;
    max-width: 100% !important;
    width: 100% !important;
    height: auto !important;
    display: block !important;
    min-height: 200px !important;
}

/* Hide the complex responsive elements that might be causing issues */
.edy-texteditor-container.image-container source {
    display: none !important;
}

/* Ensure the content is readable */
.ListingArticleContent {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
    line-height: 1.6;
}

.ListingArticleContent h1,
.ListingArticleContent h2,
.ListingArticleContent h3 {
    color: #333;
    margin-top: 30px;
    margin-bottom: 15px;
}

.ListingArticleContent p {
    margin-bottom: 15px;
    color: #333;
}

.ListingArticleContent b,
.ListingArticleContent strong {
    font-weight: bold;
}

/* Additional fixes for image containers */
div[data-image-id] {
    position: relative !important;
    width: 100% !important;
    max-width: 800px !important;
    margin: 20px auto !important;
    overflow: visible !important;
    height: auto !important;
    min-height: 200px !important;
}

div[data-image-id] img {
    position: relative !important;
    max-width: 100% !important;
    width: 100% !important;
    height: auto !important;
    display: block !important;
    min-height: 200px !important;
}
</style>
EOF
            
            # Insert CSS after the first script tag
            awk '/<\/script>/ { print; system("cat /tmp/css_fix.css"); next } { print }' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
        else
            echo "  ✓ CSS already present"
        fi
        
        # Fix double https: issue first
        sed -i '' 's|https:https://|https://|g' "$file"
        echo "  ✓ Fixed double https: URLs"
        
        # Convert remaining protocol-relative URLs to HTTPS
        sed -i '' 's|//media.voog.com|https://media.voog.com|g' "$file"
        echo "  ✓ Converted URLs to HTTPS"
    done
    
    # Clean up
    rm -f /tmp/css_fix.css
    
    echo "Image fixes applied to all files!"
}

# Main execution
main() {
    echo "Voog Support Guides - Universal Fetcher"
    echo "======================================"
    echo "Base URL: $BASE_URL"
    echo "Output directory: $OUTPUT_DIR"
    echo "Total sections: $(echo $SECTIONS | wc -w)"
    echo ""
    
    # Create output directory
    mkdir -p "$OUTPUT_DIR"
    
    # Check if we should fetch all sections or just one
    if [[ $# -eq 1 ]]; then
        local section="$1"
        if echo "$SECTIONS" | grep -q "$section"; then
            fetch_section "$section"
        else
            echo "Error: Unknown section '$section'"
            echo "Available sections: $SECTIONS"
            exit 1
        fi
    else
        # Fetch all sections
        for section in $SECTIONS; do
            fetch_section "$section"
        done
    fi
    
    # Apply image fixes
    apply_image_fixes
    
    echo ""
    echo "All done! 🎉"
    echo "Check the $OUTPUT_DIR directory for the fetched articles."
}

# Run main function with all arguments
main "$@" 