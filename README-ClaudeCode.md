# DataForSEO Mock Data

Comprehensive mock data for testing DataForSEO MCP server integration with deepfabric spin tools.

## Overview

This mock data provides realistic responses for 67+ DataForSEO API endpoints across 9 major categories:

- **AI Optimization** (11 tools) - LLM mentions, AI keyword data, responses from Claude/ChatGPT/Gemini
- **SERP** (9 tools) - Google/YouTube search results, video info, comments, subtitles
- **Keywords Data** (9 tools) - Google Ads search volume, Google Trends, demographic data
- **On-Page Analysis** (4 tools) - Content parsing, page optimization, Lighthouse metrics
- **DataForSEO Labs** (25 tools) - Keyword research, competitor analysis, domain metrics
- **Backlinks** (23 tools) - Backlink profiles, referring domains, spam scores, time series
- **Business Data** (1 tool) - Google Maps business listings
- **Domain Analytics** (6 tools) - WHOIS data, technology detection
- **Content Analysis** (3 tools) - Citation data, sentiment analysis, phrase trends

## Files

- `dataforseo-mock-data.json` - Mock response data (86KB)
- `dataforseo-schema.json` - DataForSEO API schema in JSON format (178KB)
- `dataforseo-schema.yaml` - DataForSEO API schema in YAML format (156KB)
- `load-dataforseo-mock-data.sh` - Shell script to load data into mock server
- `spin-dataforseo.yaml` - DeepFabric configuration for dataset generation (12KB)
- `README.md` - This file

## Usage

### Prerequisites

- `jq` for JSON processing: `brew install jq` (macOS) or `apt-get install jq` (Linux)
- Mock tools server running (default: http://localhost:3000)

### Loading Mock Data

```bash
# Load with default server URL (localhost:3000)
./load-dataforseo-mock-data.sh

# Load with custom server URL
./load-dataforseo-mock-data.sh http://localhost:8080
```

The script will:
1. Load all default mock responses for 67+ tools
2. Load specific fixtures for common scenarios
3. Display test commands for verification

### Testing the Mock Data

After loading, test with curl commands:

```bash
# AI Optimization - Search volume for "machine learning"
curl -X POST http://localhost:3000/mock/execute \
  -H 'Content-Type: application/json' \
  -d '{"name": "ai_optimization_keyword_data_search_volume", "arguments": {"keywords": ["machine learning"], "language_code": "en"}}'

# SERP - Search results for "python programming"
curl -X POST http://localhost:3000/mock/execute \
  -H 'Content-Type: application/json' \
  -d '{"name": "serp_organic_live_advanced", "arguments": {"keyword": "python programming", "location_name": "United States", "language_code": "en"}}'

# DataForSEO Labs - Ranked keywords for moz.com
curl -X POST http://localhost:3000/mock/execute \
  -H 'Content-Type: application/json' \
  -d '{"name": "dataforseo_labs_google_ranked_keywords", "arguments": {"target": "moz.com", "location_name": "United States", "language_code": "en"}}'

# Backlinks - Get backlinks for moz.com
curl -X POST http://localhost:3000/mock/execute \
  -H 'Content-Type: application/json' \
  -d '{"name": "backlinks_backlinks", "arguments": {"target": "moz.com", "mode": "as_is"}}'
```

## Mock Data Structure

### Default Responses

Each tool has a `defaultResponse` that uses template variables for dynamic substitution:

```json
{
  "mockResponses": {
    "ai_optimization_keyword_data_search_volume": {
      "defaultResponse": {
        "keyword": "{{keywords[0]}}",
        "ai_search_volume": 15420,
        "monthly_searches": [...]
      }
    }
  }
}
```

### Fixtures

Specific scenarios with predefined responses:

```json
{
  "fixtures": {
    "ai_optimization_keyword_data_search_volume": [
      {
        "match": {"keywords": ["machine learning"]},
        "response": {
          "keyword": "machine learning",
          "ai_search_volume": 245600,
          ...
        }
      }
    ]
  }
}
```

## Available Mock Scenarios

### AI Optimization
- Keywords: "machine learning", "seo optimization", "keyword research"
- LLM platforms: Claude, ChatGPT, Gemini, Perplexity
- Search volume tracking and sentiment analysis

### SERP
- Search: "python programming" (organic results + People Also Ask)
- YouTube videos with metadata, views, likes, comments
- Multi-device support (desktop/mobile)

### DataForSEO Labs
- Domain: moz.com (ranked keywords, competitors, domain authority)
- Keyword ideas, suggestions, and related keywords
- Historical data and traffic estimation

### Backlinks
- Domain analysis with referring domains and anchors
- Spam scores and rank metrics
- Time series data for backlink growth

### Business Data
- Google Maps listings with ratings and hours
- Location-based search with coordinates
- Categories and claimed status

### Content Analysis
- Keywords: "artificial intelligence" (positive sentiment, high citations), "climate change" (negative sentiment, high volume)
- Citation tracking with sentiment scores from authoritative sources (NASA, MIT, Nature, IBM)
- Phrase trends over time showing sentiment evolution
- Domain and content type distribution across articles, news, research papers

## Schema Reference

The mock data is based on the DataForSEO API schema (`dataforseo-schema.json`).

For full API documentation, see: https://docs.dataforseo.com/v3/

## Integration with DeepFabric

### Quick Start

Generate a complete SEO assistant training dataset:

```bash
# 1. Start the Spin service
cd tools-sdk
spin build && spin up

# 2. Import DataForSEO tools (in a new terminal)
deepfabric import-tools --transport stdio \
  --command "uvx dataforseo-mcp" \
  --spin http://localhost:3000

# 3. Load mock data
cd examples/tools-sdk-examples/dataforseo
./load-dataforseo-mock-data.sh

# 4. Generate dataset
deepfabric start spin-dataforseo.yaml
```

### Configuration Details

The `spin-dataforseo.yaml` configuration generates:

**Topics** (5 levels deep, 5 branches per level):
- SEO strategy tasks
- Keyword research scenarios
- Competitor analysis workflows
- Backlink monitoring tasks
- Content optimization examples

**Generation Settings**:
- Model: `gemini-2.5-flash` (fast, cost-effective)
- Agent mode: Single-turn with up to 8 ReAct steps
- Max 5 tools per query for comprehensive analysis
- 3 samples per topic with batch size of 2

**Tool Categories** (67+ tools):
- AI Optimization (11 tools)
- SERP Analysis (9 tools)
- Keyword Research (9 tools)
- Competitor Analysis (25 tools)
- Backlink Analysis (23 tools)
- On-Page SEO (4 tools)
- Content Analysis (3 tools)
- Business Data (1 tool)
- Domain Analytics (6 tools)

### Output Files

After running the configuration, you'll get:

- `dataforseo-topics.jsonl` - Generated SEO topic tree
- `dataforseo-dataset.jsonl` - Complete training dataset with tool calls

### Customization

Modify `spin-dataforseo.yaml` to:
- Change the model (e.g., to `gpt-4` for higher quality)
- Adjust topic depth/degree for more/fewer examples
- Increase `num_samples` for larger datasets
- Modify system prompts for different use cases
