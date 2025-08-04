#!/bin/bash

# Generate a simple text file index for all Voog support articles

OUTPUT_FILE="en/index.txt"

# Function to extract title from HTML file
extract_title() {
    local html_file="$1"
    grep -o '<title>.*</title>' "$html_file" | sed 's/<title>\(.*\) | Voog.*<\/title>/\1/' | head -1
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
    local base_name=$(echo "$english_filename" | sed 's/\.html$//')
    
    # Common English to Estonian filename patterns (simplified version)
    case "$base_name" in
        "how-to-add-products-to-your-online-store") echo "kuidas-e-poodi-tooteid-lisada" ;;
        "add-a-shop-to-your-website") echo "lisa-saidile-pood" ;;
        "online-store-structure") echo "veebipoe-struktuur" ;;
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
        "changing-the-interface-language") echo "kasutajaliidese-keele-muutmine" ;;
        "building-your-website-in-multiple-languages") echo "sinu-saidi-ehitamine-mitmes-keeles" ;;
        "choosing-a-default-language-for-your-website-visitors") echo "vaikekeele-valimine-sinu-saidi-kulastajatele" ;;
        "video-tutorial-making-your-website-multilingual") echo "videojuhend-veebilehe-mitmekeelseks-muutmine" ;;
        "changing-password") echo "parooli-vahetamine" ;;
        "joining-voog") echo "vooga-liitumine" ;;
        "logging-into-your-website") echo "saidile-sisselogimine" ;;
        "adding-other-users-to-your-voog-website") echo "teiste-kasutajate-lisamine-sinu-voo-saidile" ;;
        "complete-customization-of-design") echo "kujunduse-taielik-kohandamine" ;;
        "choosing-design-when-joining-voog") echo "kujunduse-valimine-vooga-liitumisel" ;;
        "changing-images-and-background-of-standard-designs") echo "standard-kujunduste-piltide-ja-tausta-muutmine" ;;
        "voog-design-tool") echo "voo-disainitooriist" ;;
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

generate_text_index() {
    # Create output directory
    mkdir -p "$(dirname "$OUTPUT_FILE")"
    
    # Count total articles
    local total_articles=$(find en -name "*.html" -not -name "index.html" | wc -l | tr -d ' ')
    
    # Write header
    cat > "$OUTPUT_FILE" << EOF
Voog Support Guides - English
============================

Total articles: $total_articles
Sections: 17

EOF

    # Write sections and articles
    for section in all-about-languages content-areas creating-and-managing-forms managing-your-blog managing-your-content managing-your-website-pages online-store seo setting-up-your-account stats-and-maintenance video-tutorials webinars your-pictures-and-files your-subscriptions your-website-addresses your-websites-design contact; do
        local display_name=$(get_section_name "$section")
        local article_count=$(find en/$section -name "*.html" 2>/dev/null | wc -l | tr -d ' ')
        local estonian_section=$(get_estonian_section "$section")
        
        echo "$display_name ($article_count articles)" >> "$OUTPUT_FILE"
        echo "=" * 50 | tr ' ' '=' >> "$OUTPUT_FILE"
        if [[ -n "$estonian_section" ]]; then
            echo "Maps to Estonian section: $estonian_section" >> "$OUTPUT_FILE"
            echo "" >> "$OUTPUT_FILE"
        fi
        
        # Find all HTML files in this section
        for html_file in en/$section/*.html; do
            if [[ -f "$html_file" ]]; then
                local filename=$(basename "$html_file")
                local title=$(extract_title "$html_file")
                local original_url="https://www.voog.com/support/$section/${filename%.html}"
                local estonian_equivalent=$(find_equivalent_estonian_article "$section" "$filename")
                
                echo "  • $title" >> "$OUTPUT_FILE"
                echo "    Local: $section/$filename" >> "$OUTPUT_FILE"
                echo "    Original: $original_url" >> "$OUTPUT_FILE"
                if [[ -n "$estonian_equivalent" ]]; then
                    echo "    Estonian: ../et/$estonian_section/$estonian_equivalent.html" >> "$OUTPUT_FILE"
                else
                    echo "    Estonian: —" >> "$OUTPUT_FILE"
                fi
                echo "" >> "$OUTPUT_FILE"
            fi
        done
        
        echo "" >> "$OUTPUT_FILE"
    done
    
    # Write footer
    cat >> "$OUTPUT_FILE" << 'EOF'

Quick Reference:
---------------
• HTML Index: index.html
• Estonian Version: ../et/index.html
• Estonian Text: ../et/index.txt

Section Mapping to Estonian:
---------------------------
Languages → keeled
Content Areas → sisualad
Forms → vormid
Blog → blogi
Content → sisu-haldamine
Pages → lehed
Online Store → e-pood
SEO → seo
Account → konto-loomine
Stats & Maintenance → statistika-ja-saidi-haldamine
Video Tutorials → videojuhendid
Webinars → veebiseminar
Pictures & Files → pildid-ja-failid
Subscriptions → tellimus
Addresses → domeenid
Design → kujundus
Contact → kontakt

Notes:
------
• Estonian links are available only for articles with direct equivalents
• Some articles may be available only in English or only in Estonian
• All links open in new window/tab
EOF

    echo "English text index generated: $OUTPUT_FILE"
    echo "Total articles: $total_articles"
}

generate_text_index 