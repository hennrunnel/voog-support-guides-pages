#!/bin/bash

# Generate a simple text file index for all Estonian Voog support articles

OUTPUT_FILE="et/index.txt"

# Function to extract title from HTML file
extract_title() {
    local html_file="$1"
    grep -o '<title>.*</title>' "$html_file" | sed 's/<title>\(.*\) | Voog.*<\/title>/\1/' | head -1
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

generate_text_index() {
    # Create output directory
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Count total articles
    local total_articles=$(find et -name "*.html" -not -name "index.html" | wc -l | tr -d ' ')
    
    # Write header
    cat > "$OUTPUT_FILE" << EOF
Voog Tugiartiklid - Eesti Keeles
================================

Kokku artikleid: $total_articles
Sektsioone: 17

EOF

    # Write sections and articles
    for section in blogi domeenid e-pood keeled kontakt konto-loomine kujundus lehed pildid-ja-failid seo sisu-haldamine sisualad statistika-ja-saidi-haldamine tellimus veebiseminar videojuhendid vormid; do
        local display_name=$(get_section_name "$section")
        local article_count=$(find et/$section -name "*.html" 2>/dev/null | wc -l | tr -d ' ')
        local english_section=$(get_english_section "$section")
        
        echo "$display_name ($article_count artiklit)" >> "$OUTPUT_FILE"
        echo "=" * 50 | tr ' ' '=' >> "$OUTPUT_FILE"
        if [[ -n "$english_section" ]]; then
            echo "Vastab inglise keele sektsioonile: $english_section" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        fi
        
        # Find all HTML files in this section
        for html_file in et/$section/*.html; do
            if [[ -f "$html_file" ]]; then
                local filename=$(basename "$html_file")
                local title=$(extract_title "$html_file")
                local original_url="https://www.voog.com/tugi/$section/${filename%.html}"
                local english_equivalent=$(find_equivalent_english_article "$section" "$filename")
                
                echo "  • $title" >> "$OUTPUT_FILE"
                echo "    Kohalik: $section/$filename" >> "$OUTPUT_FILE"
                echo "    Originaal: $original_url" >> "$OUTPUT_FILE"
                if [[ -n "$english_equivalent" ]]; then
                    echo "    Inglise: ../en/$english_section/$english_equivalent.html" >> "$OUTPUT_FILE"
                else
                    echo "    Inglise: —" >> "$OUTPUT_FILE"
                fi
                echo "" >> "$OUTPUT_FILE"
            fi
        done
        
        echo "" >> "$OUTPUT_FILE"
    done
    
    # Write footer
    cat >> "$OUTPUT_FILE" << 'EOF'

Kiire viide:
-----------
• HTML indeks: index.html
• Inglise keeles: ../en/index.html
• Inglise tekst: ../en/index.txt

Sektsioonide vastavused inglise keelele:
----------------------------------------
Blogi → managing-your-blog
Domeenid → your-website-addresses
E-pood → online-store
Keeled → all-about-languages
Kontakt → contact
Konto Loomine → setting-up-your-account
Kujundus → your-websites-design
Lehed → managing-your-website-pages
Pildid ja Failid → your-pictures-and-files
SEO → seo
Sisu Haldamine → managing-your-content
Sisualad → content-areas
Statistika ja Saidi Haldamine → stats-and-maintenance
Tellimus → your-subscriptions
Veebiseminar → webinars
Videojuhendid → video-tutorials
Vormid → creating-and-managing-forms

Märkused:
---------
• Inglise keele lingid on saadaval ainult artiklitele, millel on otsene vastavus
• Mõned artiklid võivad olla ainult eesti keeles või ainult inglise keeles
• Kõik lingid avanevad uues aknas/tab-is
EOF

    echo "Estonian text index generated: $OUTPUT_FILE"
    echo "Total articles: $total_articles"
}

generate_text_index 