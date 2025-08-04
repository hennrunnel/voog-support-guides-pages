#!/bin/bash

# Simple test runner for Voog Support Guides

echo "🧪 Running Voog Support Guides Tests"
echo "===================================="

# Check if test suite exists
if [[ ! -f "tests/run-tests.sh" ]]; then
    echo "❌ Error: tests/run-tests.sh not found!"
    echo "Please make sure you're running this from the repository root."
    exit 1
fi

# Run the test suite
./tests/run-tests.sh

# Show test results
if [[ $? -eq 0 ]]; then
    echo ""
    echo "✅ All tests passed! Your repository is in good condition."
else
    echo ""
    echo "⚠️  Some tests failed. Check the output above for details."
    echo "📋 Full test log: test-results.log"
fi 