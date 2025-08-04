#!/bin/bash

# Generate a simple, practical index.html for all Voog support articles

OUTPUT_FILE="en/index.html"

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
        "all-about-languages") echo "Languages" ;;
        "content-areas") echo "Content Areas" ;;
        "creating-and-managing-forms") echo "Forms" ;;
        "managing-your-blog") echo "Blog" ;;
        "managing-your-content") echo "Content" ;;
        "managing-your-website-pages") echo "Pages" ;;
        "online-store") echo "Online Store" ;;
        "seo") echo "SEO" ;;
        "setting-up-your-account") echo "Account" ;;
        "stats-and-maintenance") echo "Stats & Maintenance" ;;
        "video-tutorials") echo "Video Tutorials" ;;
        "webinars") echo "Webinars" ;;
        "your-pictures-and-files") echo "Pictures & Files" ;;
        "your-subscriptions") echo "Subscriptions" ;;
        "your-website-addresses") echo "Addresses" ;;
        "your-websites-design") echo "Design" ;;
        "contact") echo "Contact" ;;
        *) echo "$section" ;;
    esac
}

# Function to get Estonian equivalent section
get_estonian_section() {
    local english_section="$1"
    case "$english_section" in
        "managing-your-blog") echo "blogi" ;;
        "your-website-addresses") echo "domeenid" ;;
        "online-store") echo "e-pood" ;;
        "all-about-languages") echo "keeled" ;;
        "contact") echo "kontakt" ;;
        "setting-up-your-account") echo "konto-loomine" ;;
        "your-websites-design") echo "kujundus" ;;
        "managing-your-website-pages") echo "lehed" ;;
        "your-pictures-and-files") echo "pildid-ja-failid" ;;
        "seo") echo "seo" ;;
        "managing-your-content") echo "sisu-haldamine" ;;
        "content-areas") echo "sisualad" ;;
        "stats-and-maintenance") echo "statistika-ja-saidi-haldamine" ;;
        "your-subscriptions") echo "tellimus" ;;
        "webinars") echo "veebiseminar" ;;
        "video-tutorials") echo "videojuhendid" ;;
        "creating-and-managing-forms") echo "vormid" ;;
        *) echo "" ;;
    esac
}

# Function to find equivalent Estonian article
find_equivalent_estonian_article() {
    local english_section="$1"
    local english_filename="$2"
    local estonian_section=$(get_estonian_section "$english_section")
    
    # Check if Estonian section exists
    if [[ -z "$estonian_section" ]] || [[ ! -d "et/$estonian_section" ]]; then
        echo ""
        return
    fi
    
    # Try to find a matching Estonian article by similar filename
    # This is a simple heuristic - we look for files with similar names
    local base_name=$(echo "$english_filename" | sed 's/\.html$//')
    
    # Common English to Estonian filename patterns
    case "$base_name" in
        "how-to-add-products-to-your-online-store") echo "kuidas-e-poodi-tooteid-lisada" ;;
        "add-a-shop-to-your-website") echo "lisa-saidile-pood" ;;
        "online-store-structure") echo "veebipoe-struktuur" ;;
        "how-to-add-delivery-methods-to-your-online-store") echo "kuidas-e-poodi-kohaletoimetamisviise-lisada" ;;
        "payment-methods") echo "makseviisid" ;;
        "shopping-cart-fields") echo "ostukorvi-valjad" ;;
        "discount-codes") echo "sooduskoodid" ;;
        "managing-orders") echo "tellimuste-haldamine" ;;
        "product-import") echo "toodete-import" ;;
        "video-tutorial-adding-payment-and-delivery-methods") echo "videojuhend-makse-ja-tarneviisi-lisamine" ;;
        "email-previews") echo "e-mailide-eelvaade" ;;
        "how-to-customize-blog-posts-for-social-media-sharing") echo "kuidas-kohandada-blogipostitusi-sotsiaalmeedias-jagamiseks" ;;
        "creating-your-first-blog-in-voog") echo "sinu-esimese-blogi-loomine-voos" ;;
        "adding-new-posts-and-deleting-old-ones") echo "uute-postituste-lisamine-ja-vanade-kustutamine" ;;
        "managing-blog-author-and-publication-date") echo "blogi-autori-ja-avaldamise-kuupaeva-haldamine" ;;
        "managing-blog-comments") echo "blogi-kommentaaride-haldamine" ;;
        "publishing-a-blog-post") echo "blogipostituse-avaldamine" ;;
        "managing-tags") echo "siltide-haldamine" ;;
        "use-an-already-existing-domain") echo "kasuta-juba-eelnevalt-eksisteerivat-domeeni" ;;
        "what-addresses-can-you-use-with-your-voog-website") echo "milliseid-aadresseid-saad-enda-voo-saidiga-kasutada" ;;
        "adding-ssl-certificate-to-domain") echo "ssl-sertifikaadi-lisamine-domeenile" ;;
        "domain-settings") echo "domeeni-seaded" ;;
        "domain-prices") echo "domeenide-hinnad" ;;
        "extending-domain-name") echo "domeeninime-pikendamine" ;;
        "does-voog-offer-email-service") echo "kas-voog-pakub-e-maili-teenust" ;;
        "add-more-free-addresses-to-your-website") echo "lisa-saidile-rohkem-tasuta-aadresse" ;;
        "buying-a-personal-domain") echo "personaalse-domeeni-ostmine" ;;
        "changing-the-interface-language") echo "kasutajaliidese-keele-muutmine" ;;
        "building-your-website-in-multiple-languages") echo "sinu-saidi-ehitamine-mitmes-keeles" ;;
        "choosing-a-default-language-for-your-website-visitors") echo "vaikekeele-valimine-sinu-saidi-kulastajatele" ;;
        "video-tutorial-making-your-website-multilingual") echo "videojuhend-veebilehe-mitmekeelseks-muutmine" ;;
        "language-menu-display") echo "keelemenuu-kuvamine" ;;
        "setting-up-your-website-language-menu") echo "sinu-saidi-keelemenuu-seadistamine" ;;
        "changing-password") echo "parooli-vahetamine" ;;
        "joining-voog") echo "vooga-liitumine" ;;
        "logging-into-your-website") echo "saidile-sisselogimine" ;;
        "adding-other-users-to-your-voog-website") echo "teiste-kasutajate-lisamine-sinu-voo-saidile" ;;
        "what-to-do-if-you-have-created-multiple-voog-websites-with-one-email-address") echo "mida-teha-kui-oled-loonud-mitu-voo-saiti-uhe-meiliaadressiga" ;;
        "complete-customization-of-design") echo "kujunduse-taielik-kohandamine" ;;
        "choosing-design-when-joining-voog") echo "kujunduse-valimine-vooga-liitumisel" ;;
        "changing-images-and-background-of-standard-designs") echo "standard-kujunduste-piltide-ja-tausta-muutmine" ;;
        "voog-design-tool") echo "voo-disainitooriist" ;;
        "changing-design") echo "kujunduse-vahetamine" ;;
        "voog-designs-on-mobile-devices") echo "voo-disainid-mobiilsetel-seadmetel" ;;
        "how-to-add-favicon-to-your-website") echo "kuidas-lisada-enda-saidile-ikoon" ;;
        "how-can-i-hide-the-voog-logo-in-the-website-footer") echo "kuidas-saan-lehe-jaluses-voo-logo-ara-peita" ;;
        "creating-new-or-removing-old-pages") echo "uute-lehtede-loomine-ja-vanade-kustutamine" ;;
        "hiding-pages-and-making-them-visible-again") echo "lehe-peitmine-ja-avalikustamine" ;;
        "changing-page-layout") echo "lehe-malli-vahetamine" ;;
        "changing-page-addresses") echo "lehe-aadressi-muutmine" ;;
        "creating-a-link-instead-of-subpage") echo "lehe-asemel-lingi-loomine" ;;
        "duplicating-content") echo "lehe-sisu-kopeerimine" ;;
        "changing-page-titles-and-descriptions") echo "lehtede-pealkirjade-ja-kirjelduste-muutmine" ;;
        "using-the-search-engine") echo "otsingumootori-kasutamine" ;;
        "reorganizing-the-structure-of-your-website") echo "saidi-struktuuri-korrastamine" ;;
        "password-protected-pages") echo "salasonaga-kaitstud-lehed" ;;
        "creating-a-custom-401-and-404-page") echo "isikuparaste-401-ja-404-lehtede-loomine" ;;
        "uploading-images-and-files") echo "piltide-ja-failide-uleslaadimine" ;;
        "adding-and-managing-images") echo "piltide-lisamine-ja-haldamine" ;;
        "creating-galleries") echo "galeriide-loomine" ;;
        "collections") echo "kollektsioonid" ;;
        "removing-multimedia-from-text-content-area") echo "multimeedia-kustutamine-teksti-sisualas" ;;
        "how-can-i-make-my-homepage-visible-for-search-engines") echo "kuidas-ma-saan-oma-kodulehe-otsingumootorite-jaoks-nahtavaks-muuta" ;;
        "titles-and-descriptions") echo "pealkirjad-ja-kirjeldused" ;;
        "what-is-seo") echo "seo-optimeerimine-voos" ;;
        "webinars-on-seo-topics") echo "seo-teemalised-veebiseminarid" ;;
        "video-tutorial-how-to-optimize-seo-for-search-engines") echo "videojuhend-seo-optimeerimine-otsingumootorile" ;;
        "creating-links") echo "linkide-loomine" ;;
        "managing-text") echo "teksti-haldamine" ;;
        "adding-external-application") echo "valise-rakenduse-lisamine" ;;
        "creating-buttons") echo "nuppude-loomine" ;;
        "using-undo-function") echo "taasta-funktsiooni-kasutamine" ;;
        "building-tables") echo "tabelite-ehitamine" ;;
        "adding-chat-window-to-website") echo "vestlusakna-lisamine-saidile" ;;
        "adding-video-or-google-map-to-content-area") echo "video-ja-google-kaardi-lisamine" ;;
        "adding-smaily-signup-form-to-voog-homepage") echo "voo-kodulehele-smaily-liitumisvormi-lisamine" ;;
        "adding-booklux-booking-form") echo "booklux-broneeringuvormi-lisamine" ;;
        "adding-google-calendar-to-website") echo "google-kalendri-lisamine-saidile" ;;
        "adding-mailchimp-pop-up-signup-form-to-website") echo "mailchimp-pop-up-registreeringu-vormi-lisamine-saidile" ;;
        "what-is-a-content-area") echo "mis-on-sisuala" ;;
        "adding-and-removing-content-areas") echo "sisualade-lisamine-ja-eemaldamine" ;;
        "how-to-move-content-areas") echo "sisualade-umber-tostmine" ;;
        "adding-facebook-pixel-to-your-website") echo "facebook-pixeli-lisamine-sinu-veebilehele" ;;
        "adding-google-analytics-to-your-website") echo "google-analyticsi-lisamine-sinu-veebilehele" ;;
        "overview-of-voog-statistics-menu") echo "ulevaade-voo-statistika-menuust" ;;
        "how-to-generate-api-key") echo "kuidas-genereerida-api-votit" ;;
        "cookie-usage-notice") echo "kupsiste-kasutamise-teavitus" ;;
        "which-web-browsers-does-voog-support") echo "milliseid-veebilehitsejaid-voog-toetab" ;;
        "backup-copy-from-website-and-downloading-it") echo "tagavara-koopia-saidist-ja-selle-allalaadimine" ;;
        "backup-and-service-availability") echo "varundamine-ja-teenuse-kattesaadavus" ;;
        "can-voog-website-be-used-on-personal-server") echo "kas-voo-veebilehte-saab-kasutada-isiklikus-serveris" ;;
        "online-store-commission-accounting") echo "e-poe-vahendustasu-arvestus" ;;
        "credit-card-payments") echo "krediitkaardi-maksed" ;;
        "how-and-why-to-become-a-voog-partner-developer") echo "kuidas-ja-miks-saada-voo-partnerarendajaks" ;;
        "how-to-use-voog-discount-code") echo "kuidas-kasutada-voo-sooduskoodi" ;;
        "where-can-you-find-paid-invoices") echo "kus-void-leida-tasutud-arved" ;;
        "choosing-suitable-subscription") echo "sobiva-tellimuse-valimine" ;;
        "recommend-and-earn") echo "soovita-ja-teeni" ;;
        "ending-subscription") echo "tellimuse-lopetamine" ;;
        "changing-subscription") echo "tellimuse-vahetamine" ;;
        "webinar-your-online-store-shopping-cart") echo "veebiseminar-sinu-e-poe-ostukorv" ;;
        "webinar-online-store-nuuk") echo "veebiseminar-veebipood-nuuk" ;;
        "voog-seminar-lets-start-creating-your-online-store-together") echo "voo-seminar-alustame-koos-sinu-veebipoe-loomisega" ;;
        "voog-seminar-seo") echo "voo-seminar-seo" ;;
        "voog-seo-seminar-special-edition") echo "voo-seo-seminari-erisaade" ;;
        "design-tool") echo "disainitooriist" ;;
        "adding-facebook-news-feed") echo "facebooki-uudisvoo-lisamine" ;;
        "text-tool") echo "tekstitooriist" ;;
        "adding-new-language") echo "uue-keele-lisamine" ;;
        "website-description-in-search-engine") echo "veebilehe-kirjeldus-otsingumootoris" ;;
        "creating-online-store-terms-page") echo "veebipoe-tingimuste-lehe-loomine" ;;
        "change-form-fields") echo "muuda-vormi-valju" ;;
        "say-hello-to-forms") echo "utle-tere-vormidele" ;;
        "creating-new-form") echo "uue-vormi-loomine" ;;
        "managing-information-entered-through-forms") echo "vormide-kaudu-sisestatud-info-haldamine" ;;
        *) echo "" ;;
    esac
}

generate_simple_index() {
    # Create output directory
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Count total articles
    local total_articles=$(find en -name "*.html" -not -name "index.html" | wc -l | tr -d ' ')
    
    # Generate HTML
    cat > "$OUTPUT_FILE" << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voog Support Guides - Complete Index</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            line-height: 1.6;
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: relative;
        }
        h1 {
            color: #333;
            border-bottom: 3px solid #007cba;
            padding-bottom: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        .stats {
            background: #e3f2fd;
            padding: 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            border-left: 4px solid #007cba;
            text-align: center;
        }
        .search-container {
            margin-bottom: 20px;
        }
        .search-input {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.2s ease;
        }
        .search-input:focus {
            outline: none;
            border-color: #007cba;
        }
        .controls {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 8px 16px;
            border: 1px solid #007cba;
            background: white;
            color: #007cba;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
        }
        .btn:hover {
            background: #007cba;
            color: white;
        }
        .btn.active {
            background: #007cba;
            color: white;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-size: 14px;
        }
        th {
            background: #f8f9fa;
            padding: 12px 8px;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            font-weight: 600;
            color: #495057;
        }
        td {
            padding: 12px 8px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: top;
        }
        tr:hover {
            background-color: #f8f9fa;
        }
        .title-link {
            color: #007cba;
            text-decoration: none;
            font-weight: 500;
        }
        .title-link:hover {
            text-decoration: underline;
        }
        .original-link {
            color: #6c757d;
            text-decoration: none;
            font-size: 12px;
        }
        .original-link:hover {
            text-decoration: underline;
        }
        .estonian-link {
            color: #ff6b35;
            text-decoration: none;
            font-weight: 500;
        }
        .estonian-link:hover {
            text-decoration: underline;
        }
        .section-badge {
            background: #e9ecef;
            color: #495057;
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 500;
        }
        .size {
            font-family: monospace;
            color: #6c757d;
            font-size: 12px;
        }
        .footer {
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
            text-align: center;
            color: #666;
            font-size: 14px;
        }
        .hidden {
            display: none;
        }
        .language-switch {
            position: absolute;
            top: 20px;
            right: 20px;
        }
        .language-switch a {
            color: #007cba;
            text-decoration: none;
            padding: 8px 16px;
            border: 1px solid #007cba;
            border-radius: 20px;
            font-size: 14px;
            transition: all 0.2s;
        }
        .language-switch a:hover {
            background: #007cba;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="language-switch">
            <a href="../et/index.html">Eesti</a>
        </div>
        <h1>Voog Support Guides - Complete Index</h1>
        
        <div class="stats">
            <strong>📊 Total: <span id="totalArticles">0</span> articles</strong> | 
            <strong>📁 Sections: <span id="totalSections">0</span></strong> | 
            <strong>📅 Last updated: <span id="lastUpdated"></span></strong>
        </div>

        <div class="search-container">
            <input type="text" class="search-input" id="searchInput" placeholder="Search articles by title or section...">
        </div>

        <div class="controls">
            <button class="btn active" data-filter="all">All Articles</button>
            <button class="btn" data-filter="all-about-languages">Languages</button>
            <button class="btn" data-filter="content-areas">Content Areas</button>
            <button class="btn" data-filter="creating-and-managing-forms">Forms</button>
            <button class="btn" data-filter="managing-your-blog">Blog</button>
            <button class="btn" data-filter="managing-your-content">Content</button>
            <button class="btn" data-filter="managing-your-website-pages">Pages</button>
            <button class="btn" data-filter="online-store">Online Store</button>
            <button class="btn" data-filter="seo">SEO</button>
            <button class="btn" data-filter="setting-up-your-account">Account</button>
            <button class="btn" data-filter="stats-and-maintenance">Stats & Maintenance</button>
            <button class="btn" data-filter="video-tutorials">Video Tutorials</button>
            <button class="btn" data-filter="webinars">Webinars</button>
            <button class="btn" data-filter="your-pictures-and-files">Pictures & Files</button>
            <button class="btn" data-filter="your-subscriptions">Subscriptions</button>
            <button class="btn" data-filter="your-website-addresses">Addresses</button>
            <button class="btn" data-filter="your-websites-design">Design</button>
        </div>

        <table id="articlesTable">
            <thead>
                <tr>
                    <th>Title</th>
                    <th>Section</th>
                    <th>Original URL</th>
                    <th>Estonian</th>
                    <th>Size</th>
                </tr>
            </thead>
            <tbody>
EOF

    # Generate table rows
    for section in all-about-languages content-areas creating-and-managing-forms managing-your-blog managing-your-content managing-your-website-pages online-store seo setting-up-your-account stats-and-maintenance video-tutorials webinars your-pictures-and-files your-subscriptions your-website-addresses your-websites-design contact; do
        local display_name=$(get_section_name "$section")
        
        # Find all HTML files in this section
        for html_file in en/$section/*.html; do
            if [[ -f "$html_file" ]]; then
                local filename=$(basename "$html_file")
                local title=$(extract_title "$html_file")
                local size=$(get_file_size "$html_file")
                local original_url="https://www.voog.com/support/$section/${filename%.html}"
                local estonian_equivalent=$(find_equivalent_estonian_article "$section" "$filename")
                
                # Create Estonian link if equivalent found
                local estonian_link=""
                if [[ -n "$estonian_equivalent" ]]; then
                    local estonian_section=$(get_estonian_section "$section")
                    estonian_link="<a href=\"../et/$estonian_section/$estonian_equivalent.html\" target=\"_blank\" class=\"estonian-link\">Eesti</a>"
                else
                    estonian_link="<span style=\"color: #ccc;\">—</span>"
                fi
                
                cat >> "$OUTPUT_FILE" << EOF
                <tr data-section="$section">
                    <td><a href="$section/$filename" class="title-link">$title</a></td>
                    <td><span class="section-badge">$display_name</span></td>
                    <td><a href="$original_url" target="_blank" class="original-link">Original</a></td>
                    <td>$estonian_link</td>
                    <td class="size">$size</td>
                </tr>
EOF
            fi
        done
    done

    cat >> "$OUTPUT_FILE" << 'EOF'
            </tbody>
        </table>
        
        <div class="footer">
            <p>📚 Complete Voog support documentation with cross-language navigation</p>
            <p>🔗 <a href="https://www.voog.com/support" target="_blank">Original Support</a> | 
               <a href="../et/index.html">Estonian Version</a></p>
        </div>
    </div>

    <script>
        // Update statistics
        function updateStats() {
            const totalArticles = document.querySelectorAll('#articlesTable tbody tr').length;
            const totalSections = new Set(Array.from(document.querySelectorAll('#articlesTable tbody tr')).map(row => row.dataset.section)).size;
            
            document.getElementById('totalArticles').textContent = totalArticles;
            document.getElementById('totalSections').textContent = totalSections;
            document.getElementById('lastUpdated').textContent = new Date().toLocaleDateString();
        }

        // Search functionality
        function setupSearch() {
            const searchInput = document.getElementById('searchInput');
            const rows = document.querySelectorAll('#articlesTable tbody tr');
            
            searchInput.addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                
                rows.forEach(row => {
                    const title = row.querySelector('.title-link').textContent.toLowerCase();
                    const section = row.querySelector('.section-badge').textContent.toLowerCase();
                    const isVisible = title.includes(searchTerm) || section.includes(searchTerm);
                    
                    row.style.display = isVisible ? '' : 'none';
                });
            });
        }

        // Filter functionality
        function setupFilters() {
            const filterButtons = document.querySelectorAll('.controls .btn');
            const rows = document.querySelectorAll('#articlesTable tbody tr');
            
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

    echo "English index generated: $OUTPUT_FILE"
    echo "Total articles: $total_articles"
}

generate_simple_index 