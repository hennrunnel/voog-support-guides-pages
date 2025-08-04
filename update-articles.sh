#!/bin/bash

# Simple wrapper script for smart article updates
# This script provides an easy way to update articles from Voog's servers

echo "🔄 Voog Support Articles Smart Updater"
echo "======================================"
echo ""

# Check if smart-fetch-etag.sh exists
if [[ ! -f "scripts/smart-fetch-etag.sh" ]]; then
    echo "❌ Error: scripts/smart-fetch-etag.sh not found!"
    echo "Please make sure you're running this from the repository root."
    exit 1
fi

# Show current status
echo "📊 Current Status:"
echo "  English articles: $(find en -name "*.html" | wc -l | tr -d ' ')"
echo "  Estonian articles: $(find et -name "*.html" | wc -l | tr -d ' ')"
echo ""

# Ask user what to update
echo "What would you like to update?"
echo "  1) All articles (English + Estonian)"
echo "  2) English articles only"
echo "  3) Estonian articles only"
echo "  4) Show help"
echo ""

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "🔄 Updating all articles..."
        ./scripts/smart-fetch-etag.sh all
        ;;
    2)
        echo ""
        echo "🔄 Updating English articles..."
        ./scripts/smart-fetch-etag.sh en
        ;;
    3)
        echo ""
        echo "🔄 Updating Estonian articles..."
        ./scripts/smart-fetch-etag.sh et
        ;;
    4)
        echo ""
        echo "📖 Help:"
        echo "  This script checks for updates on Voog's servers and only downloads"
        echo "  articles that have been modified since your last fetch."
        echo ""
        echo "  Features:"
        echo "  • Respects server load with delays between requests"
        echo "  • Only downloads updated articles"
        echo "  • Automatically regenerates indexes when needed"
        echo "  • Detailed logging of all operations"
        echo "  • Cross-platform compatibility"
        echo ""
        echo "  Log file: fetch-log.txt"
        echo "  Manual usage: ./scripts/smart-fetch-etag.sh [en|et|all]"
        ;;
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "✅ Update process completed!"
echo "📋 Check fetch-log.txt for detailed information." 