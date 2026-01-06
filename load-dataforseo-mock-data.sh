#!/bin/bash
# Load comprehensive DataForSEO mock data into the mock tools server
#
# Usage: ./load-dataforseo-mock-data.sh [base_url]
# Default base_url: http://localhost:3000

set -e

BASE_URL="${1:-http://localhost:3000}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="$SCRIPT_DIR/dataforseo-mock-data.json"

if [ ! -f "$DATA_FILE" ]; then
    echo "Error: Mock data file not found at $DATA_FILE"
    exit 1
fi

echo "Loading DataForSEO mock data from $DATA_FILE"
echo "Target server: $BASE_URL"
echo ""

# Function to load mock response for a tool
load_mock_response() {
    local tool_name="$1"
    local response="$2"

    echo "Loading mock response for: $tool_name"

    curl -s -X POST "$BASE_URL/mock/update-response" \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"$tool_name\", \"mockResponse\": $response}" > /dev/null

    if [ $? -eq 0 ]; then
        echo "  ✓ Done"
    else
        echo "  ✗ Failed!"
    fi
}

# Function to add a fixture
add_fixture() {
    local tool_name="$1"
    local match="$2"
    local response="$3"

    echo "Adding fixture for: $tool_name (match: $match)"

    curl -s -X POST "$BASE_URL/mock/add-fixture" \
        -H "Content-Type: application/json" \
        -d "{\"name\": \"$tool_name\", \"match\": $match, \"response\": $response}" > /dev/null

    if [ $? -eq 0 ]; then
        echo "  ✓ Done"
    else
        echo "  ✗ Failed!"
    fi
}

echo "=========================================="
echo "Loading default mock responses..."
echo "=========================================="

# Load default mock responses using jq
for tool in $(jq -r '.mockResponses | keys[]' "$DATA_FILE"); do
    response=$(jq -c ".mockResponses.\"$tool\".defaultResponse" "$DATA_FILE")
    if [ "$response" != "null" ]; then
        load_mock_response "$tool" "$response"
    fi
done

echo ""
echo "=========================================="
echo "Loading fixtures..."
echo "=========================================="

# Load fixtures for each tool
for tool in $(jq -r '.fixtures | keys[]' "$DATA_FILE"); do
    fixture_count=$(jq -r ".fixtures.\"$tool\" | length" "$DATA_FILE")

    for i in $(seq 0 $((fixture_count - 1))); do
        match=$(jq -c ".fixtures.\"$tool\"[$i].match" "$DATA_FILE")
        response=$(jq -c ".fixtures.\"$tool\"[$i].response" "$DATA_FILE")
        add_fixture "$tool" "$match" "$response"
    done
done

echo ""
echo "=========================================="
echo "Mock data loaded successfully!"
echo "=========================================="
echo ""
echo "Test commands:"
echo ""
echo "# AI Optimization - Get search volume for keywords"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"ai_optimization_keyword_data_search_volume\", \"arguments\": {\"keywords\": [\"machine learning\"], \"language_code\": \"en\"}}'"
echo ""
echo "# SERP - Search for 'python programming'"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"serp_organic_live_advanced\", \"arguments\": {\"keyword\": \"python programming\", \"location_name\": \"United States\", \"language_code\": \"en\"}}'"
echo ""
echo "# DataForSEO Labs - Get ranked keywords for moz.com"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"dataforseo_labs_google_ranked_keywords\", \"arguments\": {\"target\": \"moz.com\", \"location_name\": \"United States\", \"language_code\": \"en\"}}'"
echo ""
echo "# Backlinks - Get backlinks for moz.com"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"backlinks_backlinks\", \"arguments\": {\"target\": \"moz.com\", \"mode\": \"as_is\"}}'"
echo ""
echo "# Keywords Data - Get Google Trends data"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"keywords_data_google_trends_explore\", \"arguments\": {\"keywords\": [\"seo tools\"], \"location_name\": \"United States\", \"language_code\": \"en\", \"type\": \"web\"}}'"
echo ""
echo "# On-Page - Parse page content"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"on_page_content_parsing\", \"arguments\": {\"url\": \"https://example.com\"}}'"
echo ""
echo "# Business Data - Search for coffee shops"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"business_data_business_listings_search\", \"arguments\": {\"description\": \"coffee shop\", \"location_coordinate\": \"40.7589,-73.9851,5\"}}'"
echo ""
echo "# Content Analysis - Search for 'artificial intelligence' mentions (positive sentiment)"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"content_analysis_search\", \"arguments\": {\"keyword\": \"artificial intelligence\"}}'"
echo ""
echo "# Content Analysis - Get summary for 'climate change' (negative sentiment)"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"content_analysis_summary\", \"arguments\": {\"keyword\": \"climate change\"}}'"
echo ""
echo "# Content Analysis - Get phrase trends for AI over time"
echo "curl -X POST $BASE_URL/mock/execute -H 'Content-Type: application/json' \\"
echo "  -d '{\"name\": \"content_analysis_phrase_trends\", \"arguments\": {\"keyword\": \"artificial intelligence\", \"date_from\": \"2024-10-01\", \"date_to\": \"2024-12-01\"}}'"
echo ""
echo "Available mock scenarios:"
echo "  AI Optimization:"
echo "    - Keywords: 'machine learning', 'seo optimization', 'keyword research'"
echo "    - LLM platforms: Claude, ChatGPT, Gemini, Perplexity"
echo ""
echo "  SERP:"
echo "    - Search: 'python programming' (includes organic results + People Also Ask)"
echo "    - YouTube videos with views, likes, comments"
echo ""
echo "  DataForSEO Labs:"
echo "    - Domain: moz.com (ranked keywords, backlinks, domain authority)"
echo "    - Keyword research, competitor analysis, traffic estimation"
echo ""
echo "  Backlinks:"
echo "    - Domain analysis with referring domains, anchors, spam scores"
echo "    - Time series data for backlink growth"
echo ""
echo "  Business Data:"
echo "    - Google Maps listings with ratings, hours, categories"
echo "    - Location-based search with coordinates"
echo ""
echo "  Content Analysis:"
echo "    - 'artificial intelligence': 1,847 citations, 81% positive sentiment (IBM, MIT, Nature)"
echo "    - 'climate change': 2,345 citations, 48% negative sentiment (NASA, IPCC, NOAA)"
echo "    - Phrase trends showing sentiment evolution over time"
echo ""
