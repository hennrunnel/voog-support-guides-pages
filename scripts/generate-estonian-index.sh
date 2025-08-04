#!/bin/bash

# Generate a simple, practical index.html for all Estonian Voog support articles

OUTPUT_FILE="et/index.html"

# Function to extract title from HTML file
extract_title() {
    local html_file="$1"
    grep -o '<title>.*</title>' "$html_file" | sed 's/<title>\(.*\) | Voog.*<\/title>/\1/' | head -1
}

# Function to get file size
get_file_size() {
    local file="$1"
    if [[ -f "$file" ]]; then
        local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        if [[ $size -gt 1024 ]]; then
            echo "$((size / 1024))KB"
        else
            echo "${size}B"
        fi
    else
        echo "0B"
    fi
}

# Function to get section display name
get_section_name() {
    local section="$1"
    case "$section" in
        "blogi") echo "Blogi" ;;
        "domeenid") echo "Domeenid" ;;
        "e-pood") echo "E-pood" ;;
        "keeled") echo "Keeled" ;;
        "kontakt") echo "Kontakt" ;;
        "konto-loomine") echo "Konto Loomine" ;;
        "kujundus") echo "Kujundus" ;;
        "lehed") echo "Lehed" ;;
        "pildid-ja-failid") echo "Pildid ja Failid" ;;
        "seo") echo "SEO" ;;
        "sisu-haldamine") echo "Sisu Haldamine" ;;
        "sisualad") echo "Sisualad" ;;
        "statistika-ja-saidi-haldamine") echo "Statistika ja Saidi Haldamine" ;;
        "tellimus") echo "Tellimus" ;;
        "veebiseminar") echo "Veebiseminar" ;;
        "videojuhendid") echo "Videojuhendid" ;;
        "vormid") echo "Vormid" ;;
        *) echo "$section" ;;
    esac
}

# Function to get English equivalent section
get_english_section() {
    local estonian_section="$1"
    case "$estonian_section" in
        "blogi") echo "managing-your-blog" ;;
        "domeenid") echo "your-website-addresses" ;;
        "e-pood") echo "online-store" ;;
        "keeled") echo "all-about-languages" ;;
        "kontakt") echo "contact" ;;
        "konto-loomine") echo "setting-up-your-account" ;;
        "kujundus") echo "your-websites-design" ;;
        "lehed") echo "managing-your-website-pages" ;;
        "pildid-ja-failid") echo "your-pictures-and-files" ;;
        "seo") echo "seo" ;;
        "sisu-haldamine") echo "managing-your-content" ;;
        "sisualad") echo "content-areas" ;;
        "statistika-ja-saidi-haldamine") echo "stats-and-maintenance" ;;
        "tellimus") echo "your-subscriptions" ;;
        "veebiseminar") echo "webinars" ;;
        "videojuhendid") echo "video-tutorials" ;;
        "vormid") echo "creating-and-managing-forms" ;;
        *) echo "" ;;
    esac
}

# Function to find equivalent English article
find_equivalent_english_article() {
    local estonian_section="$1"
    local estonian_filename="$2"
    local english_section=$(get_english_section "$estonian_section")
    
    # Check if English section exists
    if [[ -z "$english_section" ]] || [[ ! -d "en/$english_section" ]]; then
        echo ""
        return
    fi
    
    # Try to find a matching English article by similar filename
    # This is a simple heuristic - we look for files with similar names
    local base_name=$(echo "$estonian_filename" | sed 's/\.html$//')
    
    # ONLY include mappings that actually work - verified by testing
    case "$base_name" in
        # Original working mappings (30)
        "blogi-kommentaaride-haldamine") echo "managing-blog-comments" ;;
        "domeeni-seaded") echo "domain-settings" ;;
        "domeenide-hinnad") echo "domain-prices" ;;
        "makseviisid") echo "payment-methods" ;;
        "sooduskoodid") echo "discount-codes" ;;
        "kasutajaliidese-keele-muutmine") echo "changing-the-interface-language" ;;
        "sinu-saidi-ehitamine-mitmes-keeles") echo "building-your-website-in-multiple-languages" ;;
        "saidile-sisselogimine") echo "logging-into-your-website" ;;
        "isikuparaste-401-ja-404-lehtede-loomine") echo "creating-a-custom-401-and-404-page" ;;
        "lehe-aadressi-muutmine") echo "changing-page-addresses" ;;
        "lehe-asemel-lingi-loomine") echo "creating-a-link-instead-of-subpage" ;;
        "lehe-peitmine-ja-avalikustamine") echo "hiding-pages-and-making-them-visible-again" ;;
        "lehe-sisu-kopeerimine") echo "duplicating-content" ;;
        "lehtede-pealkirjade-ja-kirjelduste-muutmine") echo "changing-page-titles-and-descriptions" ;;
        "otsingumootori-kasutamine") echo "using-the-search-engine" ;;
        "saidi-struktuuri-korrastamine") echo "reorganizing-the-structure-of-your-website" ;;
        "salasonaga-kaitstud-lehed") echo "password-protected-pages" ;;
        "uute-lehtede-loomine-ja-vanade-kustutamine") echo "creating-new-or-removing-old-pages" ;;
        "kollektsioonid") echo "collections" ;;
        "pealkirjad-ja-kirjeldused") echo "titles-and-descriptions" ;;
        "linkide-loomine") echo "creating-links" ;;
        "nuppude-loomine") echo "creating-buttons" ;;
        "tabelite-ehitamine") echo "building-tables" ;;
        "mis-on-sisuala") echo "what-is-a-content-area" ;;
        "sisualade-lisamine-ja-eemaldamine") echo "adding-and-removing-content-areas" ;;
        "facebook-pixeli-lisamine-sinu-veebilehele") echo "adding-facebook-pixel-to-your-website" ;;
        "google-analyticsi-lisamine-sinu-veebilehele") echo "adding-google-analytics-to-your-website" ;;
        "krediitkaardi-maksed") echo "credit-card-payments" ;;
        "utle-tere-vormidele") echo "say-hello-to-forms" ;;
        
        # New working mappings (34 additional)
        "blogipostituse-avaldamine") echo "going-live-with-your-blog-post" ;;
        "kuidas-kohandada-blogipostitusi-sotsiaalmeedias-jagamiseks") echo "how-to-modify-your-post-for-social-media" ;;
        "siltide-haldamine") echo "using-tags-with-your-blog" ;;
        "sinu-esimese-blogi-loomine-voos") echo "starting-your-first-blog-with-voog" ;;
        "uute-postituste-lisamine-ja-vanade-kustutamine") echo "adding-new-or-removing-old-posts" ;;
        "kas-voog-pakub-e-maili-teenust") echo "does-voog-offer-an-e-mail-service" ;;
        "lisa-saidile-rohkem-tasuta-aadresse") echo "adding-more-free-addresses" ;;
        "personaalse-domeeni-ostmine") echo "buying-personal-domain-names" ;;
        "kuidas-e-poodi-kohaletoimetamisviise-lisada") echo "add-shipping-methods" ;;
        "lisa-saidile-pood") echo "add-online-store" ;;
        "ostukorvi-valjad") echo "checkout-fields" ;;
        "parooli-vahetamine") echo "resetting-your-password" ;;
        "teiste-kasutajate-lisamine-sinu-voo-saidile") echo "other-people-who-can-edit-your-website" ;;
        "kuidas-lisada-enda-saidile-ikoon") echo "adding-a-favicon" ;;
        "kujunduse-taielik-kohandamine") echo "getting-a-fully-customized-design" ;;
        "kujunduse-valimine-vooga-liitumisel") echo "choosing-a-design-upon-signup" ;;
        "lehe-malli-vahetamine") echo "changing-your-pages-layout" ;;
        "galeriide-loomine") echo "picture-galleries" ;;
        "piltide-lisamine-ja-haldamine") echo "adding-and-managing-pictures" ;;
        "kuidas-ma-saan-oma-kodulehe-otsingumootorite-jaoks-nahtavaks-muuta") echo "getting-your-website-to-appear-in-google-and-bing" ;;
        "seo-optimeerimine-voos") echo "seo-optimization-in-voog" ;;
        "booklux-broneeringuvormi-lisamine") echo "add-booklux-booking-widget-to-your-website" ;;
        "mailchimp-pop-up-registreeringu-vormi-lisamine-saidile") echo "adding-smaily-newsletter-subscription-form-to-voog-website" ;;
        "vestlusakna-lisamine-saidile") echo "adding-a-live-chat-to-your-site" ;;
        "voo-kodulehele-smaily-liitumisvormi-lisamine") echo "adding-smaily-newsletter-subscription-form-to-voog-website" ;;
        "sisualade-umber-tostmine") echo "rearranging-content-areas" ;;
        "varundamine-ja-teenuse-kattesaadavus") echo "about-backups-and-service-uptime" ;;
        "sobiva-tellimuse-valimine") echo "choosing-an-appropriate-subscription-plan" ;;
        "tellimuse-lopetamine") echo "cancelling-your-subscriptions" ;;
        "tellimuse-vahetamine") echo "changing-your-subscriptions" ;;
        "disainitooriist") echo "design-editor-tool" ;;
        "muuda-vormi-valju") echo "editing-your-form-fields" ;;
        "uue-vormi-loomine") echo "creating-a-new-form" ;;
        "vormide-kaudu-sisestatud-info-haldamine") echo "managing-submitted-form-entries" ;;
        *) echo "" ;;
    esac
}

generate_estonian_index() {
    # Create output directory
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Count total articles
    local total_articles=$(find et -name "*.html" -not -name "index.html" | wc -l | tr -d ' ')
    
    # Generate HTML
    cat > "$OUTPUT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="et">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voog Tugiartiklid - Eesti</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.1em;
        }
        .stats {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #e9ecef;
        }
        .stats span {
            display: inline-block;
            margin: 0 20px;
            font-size: 1.1em;
        }
        .controls {
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
        .search-box {
            width: 100%;
            max-width: 400px;
            padding: 12px 16px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            margin-bottom: 15px;
        }
        .search-box:focus {
            outline: none;
            border-color: #667eea;
        }
        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 20px;
            background: #e9ecef;
            color: #495057;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
        }
        .btn:hover {
            background: #667eea;
            color: white;
        }
        .btn.active {
            background: #667eea;
            color: white;
        }
        .table-container {
            overflow-x: auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        th {
            background: #f8f9fa;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }
        td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .title-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .title-link:hover {
            text-decoration: underline;
        }
        .section-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        .original-link {
            color: #28a745;
            text-decoration: none;
            font-weight: 500;
        }
        .original-link:hover {
            text-decoration: underline;
        }
        .english-link {
            color: #ff6b35;
            text-decoration: none;
            font-weight: 500;
        }
        .english-link:hover {
            text-decoration: underline;
        }
        .size {
            color: #6c757d;
            font-size: 14px;
        }
        .no-results {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-style: italic;
        }
        .language-switch {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        .language-switch a {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 20px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .language-switch a:hover {
            background: rgba(255,255,255,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="language-switch">
                <a href="../en/index.html">English</a>
            </div>
            <h1>Voog Tugiartiklid</h1>
            <p>Kõik Voog tugiartiklid eesti keeles</p>
        </div>
        
        <div class="stats">
            <span><strong id="total-articles">0</strong> artiklit</span>
            <span><strong id="visible-articles">0</strong> nähtaval</span>
            <span><strong id="total-sections">0</strong> sektsiooni</span>
        </div>
        
        <div class="controls">
            <input type="text" id="search" class="search-box" placeholder="Otsi artikleid...">
            <div class="filter-buttons" id="filter-buttons">
                <button class="btn active" data-filter="all">Kõik</button>
EOF

    # Add filter buttons for each section
    for section in blogi domeenid e-pood keeled kontakt konto-loomine kujundus lehed pildid-ja-failid seo sisu-haldamine sisualad statistika-ja-saidi-haldamine tellimus veebiseminar videojuhendid vormid; do
        local display_name=$(get_section_name "$section")
        echo "                <button class=\"btn\" data-filter=\"$section\">$display_name</button>" >> "$OUTPUT_FILE"
    done

    cat >> "$OUTPUT_FILE" << 'EOF'
            </div>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Pealkiri</th>
                        <th>Sektsioon</th>
                        <th>Originaal</th>
                        <th>English</th>
                        <th>Suurus</th>
                    </tr>
                </thead>
                <tbody id="articles-table">
EOF

    # Generate table rows
    for section in blogi domeenid e-pood keeled kontakt konto-loomine kujundus lehed pildid-ja-failid seo sisu-haldamine sisualad statistika-ja-saidi-haldamine tellimus veebiseminar videojuhendid vormid; do
        local display_name=$(get_section_name "$section")
        local en_section=$(get_english_section "$section")
        
        # Find all HTML files in this section
        for html_file in et/$section/*.html; do
            if [[ -f "$html_file" ]]; then
                local filename=$(basename "$html_file")
                local title=$(extract_title "$html_file")
                local size=$(get_file_size "$html_file")
                local original_url="https://www.voog.com/tugi/$section/${filename%.html}"
                local english_equivalent=$(find_equivalent_english_article "$section" "$filename")
                
                # Create English link if equivalent found
                local english_link=""
                if [[ -n "$english_equivalent" ]]; then
                    local english_section=$(get_english_section "$section")
                    english_link="<a href=\"../en/$english_section/$english_equivalent.html\" target=\"_blank\" class=\"english-link\">English</a>"
                else
                    english_link="<span style=\"color: #ccc;\">—</span>"
                fi
                
                cat >> "$OUTPUT_FILE" << EOF
                    <tr data-section="$section" data-title="$title">
                        <td><a href="$section/$filename" class="title-link">$title</a></td>
                        <td><span class="section-badge">$display_name</span></td>
                        <td><a href="$original_url" target="_blank" class="original-link">Originaal</a></td>
                        <td>$english_link</td>
                        <td class="size">$size</td>
                    </tr>
EOF
            fi
        done
    done

    cat >> "$OUTPUT_FILE" << 'EOF'
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function updateStats() {
            const totalArticles = document.querySelectorAll('#articles-table tr').length;
            const visibleArticles = document.querySelectorAll('#articles-table tr:not([style*="display: none"])').length;
            const totalSections = new Set(Array.from(document.querySelectorAll('#articles-table tr')).map(row => row.dataset.section)).size;
            
            document.getElementById('total-articles').textContent = totalArticles;
            document.getElementById('visible-articles').textContent = visibleArticles;
            document.getElementById('total-sections').textContent = totalSections;
        }

        function setupSearch() {
            const searchInput = document.getElementById('search');
            const rows = document.querySelectorAll('#articles-table tr');
            
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                
                rows.forEach(row => {
                    const title = row.dataset.title.toLowerCase();
                    const section = row.querySelector('.section-badge').textContent.toLowerCase();
                    const isVisible = title.includes(searchTerm) || section.includes(searchTerm);
                    
                    row.style.display = isVisible ? '' : 'none';
                });
                
                updateStats();
            });
        }

        function setupFilters() {
            const filterButtons = document.querySelectorAll('.filter-buttons .btn');
            const rows = document.querySelectorAll('#articles-table tr');
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const filter = this.dataset.filter;
                    
                    // Update active button
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    this.classList.add('active');
                    
                    // Filter rows
                    rows.forEach(row => {
                        const section = row.dataset.section;
                        const isVisible = filter === 'all' || section === filter;
                        row.style.display = isVisible ? '' : 'none';
                    });
                    
                    updateStats();
                });
            });
        }

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            updateStats();
            setupSearch();
            setupFilters();
        });
    </script>
</body>
</html>
EOF

    echo "Estonian index generated: $OUTPUT_FILE"
    echo "Total articles: $total_articles"
}

generate_estonian_index 