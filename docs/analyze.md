# Analyze API Reference

`POST https://api.snapapi.pics/v1/analyze`

AI-powered webpage analysis using your own AI API key (BYOK — Bring Your Own Key). SnapAPI handles the browser rendering; you pay your AI provider directly for tokens.

---

## How It Works

1. SnapAPI loads the URL in a real browser
2. Page content is extracted and cleaned
3. Content (+ optional screenshot) is sent to your AI provider
4. The AI response is returned to you

**You need:** A SnapAPI API key + an OpenAI or Anthropic API key.

---

## Authentication

```http
X-Api-Key: YOUR_API_KEY
```

---

## Request Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to analyze *(required)* |
| `prompt` | string | — | What to analyze or extract *(required)* |
| `provider` | string | — | AI provider: `openai` or `anthropic` *(required)* |
| `apiKey` | string | — | Your AI provider's API key *(required)* |
| `model` | string | — | Model to use (optional — uses provider default) |
| `jsonSchema` | object | — | JSON schema for structured output |
| `timeout` | integer | `30000` | Max page load time in ms |
| `waitFor` | string | — | Wait for CSS selector before analyzing |
| `blockAds` | boolean | `false` | Block ads before analyzing |
| `blockCookieBanners` | boolean | `false` | Hide cookie banners |
| `includeScreenshot` | boolean | `false` | Include a screenshot in the AI context (vision) |
| `includeMetadata` | boolean | `false` | Include page metadata (title, OG tags) |
| `maxContentLength` | integer | — | Truncate page content at this many characters |

---

## Provider Comparison

| Feature | OpenAI | Anthropic |
|---------|--------|-----------|
| Default model | `gpt-4o-mini` | `claude-3-5-haiku-20241022` |
| Vision (screenshot) | ✅ GPT-4o | ✅ Claude 3.5 |
| JSON output | ✅ | ✅ |
| Context window | 128K | 200K |
| Best for | General tasks, structured output | Long documents, nuanced analysis |

### OpenAI Models

| Model | Context | Best For |
|-------|---------|----------|
| `gpt-4o` | 128K | Best quality, vision |
| `gpt-4o-mini` | 128K | Fast, affordable (default) |
| `gpt-4-turbo` | 128K | High quality |
| `o1-mini` | 128K | Reasoning tasks |

### Anthropic Models

| Model | Context | Best For |
|-------|---------|----------|
| `claude-3-5-sonnet-20241022` | 200K | Best quality |
| `claude-3-5-haiku-20241022` | 200K | Fast, affordable (default) |
| `claude-3-opus-20240229` | 200K | Complex analysis |

---

## Examples

### Basic analysis

```bash
curl -X POST "https://api.snapapi.pics/v1/analyze" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "prompt": "Summarize the main purpose of this website in 2-3 sentences.",
    "provider": "openai",
    "apiKey": "sk-your-openai-key"
  }'
```

**Response:**
```json
{
  "success": true,
  "result": "Example.com is a placeholder website maintained by IANA for use in documentation and examples. It serves no commercial purpose and exists to provide a safe, stable domain for testing.",
  "provider": "openai",
  "model": "gpt-4o-mini",
  "url": "https://example.com",
  "took": 2840,
  "usage": {
    "promptTokens": 412,
    "completionTokens": 48,
    "totalTokens": 460
  }
}
```

---

### Structured JSON output

Use `jsonSchema` to get structured data back:

```bash
curl -X POST "https://api.snapapi.pics/v1/analyze" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://shop.example.com/product/widget-pro",
    "prompt": "Extract product details from this page",
    "provider": "openai",
    "apiKey": "sk-your-openai-key",
    "jsonSchema": {
      "type": "object",
      "properties": {
        "name": { "type": "string" },
        "price": { "type": "number" },
        "currency": { "type": "string" },
        "inStock": { "type": "boolean" },
        "rating": { "type": "number" },
        "reviewCount": { "type": "integer" },
        "description": { "type": "string" }
      }
    }
  }'
```

**Response:**
```json
{
  "success": true,
  "result": "{\"name\":\"Widget Pro\",\"price\":29.99,\"currency\":\"USD\",\"inStock\":true,\"rating\":4.7,\"reviewCount\":1284,\"description\":\"Professional-grade widget...\"}",
  "structured": {
    "name": "Widget Pro",
    "price": 29.99,
    "currency": "USD",
    "inStock": true,
    "rating": 4.7,
    "reviewCount": 1284,
    "description": "Professional-grade widget..."
  }
}
```

---

### Visual analysis with screenshot

Use `includeScreenshot: true` to give the AI visual context (requires a vision-capable model):

```bash
curl -X POST "https://api.snapapi.pics/v1/analyze" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "prompt": "Describe the layout, color scheme, and UI design of this page.",
    "provider": "anthropic",
    "apiKey": "sk-ant-your-anthropic-key",
    "model": "claude-3-5-sonnet-20241022",
    "includeScreenshot": true
  }'
```

---

### Content moderation

```bash
curl -X POST "https://api.snapapi.pics/v1/analyze" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://user-submitted.example.com/page",
    "prompt": "Does this page contain any harmful, illegal, or adult content? Answer with a JSON object: {safe: boolean, reason: string}",
    "provider": "openai",
    "apiKey": "sk-your-openai-key",
    "jsonSchema": {
      "type": "object",
      "properties": {
        "safe": { "type": "boolean" },
        "reason": { "type": "string" }
      }
    }
  }'
```

---

## SDK Examples

### JavaScript

```typescript
import { SnapAPI } from '@snapapi/sdk';

const client = new SnapAPI({ apiKey: 'YOUR_API_KEY' });

// Basic analysis
const result = await client.analyze({
  url: 'https://example.com',
  prompt: 'What is the main call to action on this page?',
  provider: 'openai',
  apiKey: process.env.OPENAI_API_KEY!
});
console.log(result.result);

// Structured product extraction
const product = await client.analyze({
  url: 'https://shop.example.com/product/123',
  prompt: 'Extract product details',
  provider: 'openai',
  apiKey: process.env.OPENAI_API_KEY!,
  model: 'gpt-4o',
  jsonSchema: {
    type: 'object',
    properties: {
      name: { type: 'string' },
      price: { type: 'number' },
      inStock: { type: 'boolean' }
    }
  }
});
console.log(product.structured);
```

### Python

```python
from snapapi import SnapAPI
import os

client = SnapAPI(api_key='YOUR_API_KEY')

result = client.analyze(
    url='https://example.com',
    prompt='Summarize the main content',
    provider='anthropic',
    api_key=os.environ['ANTHROPIC_API_KEY'],
    model='claude-3-5-sonnet-20241022',
    include_metadata=True
)
print(result['result'])
```

---

## Use Cases

| Use Case | Prompt Example |
|----------|----------------|
| **Content summarization** | "Summarize this article in 3 bullet points" |
| **Product extraction** | "Extract product name, price, and availability" |
| **Sentiment analysis** | "What is the overall sentiment of reviews on this page?" |
| **SEO audit** | "List all SEO issues on this page" |
| **Competitor analysis** | "What are the key differentiators highlighted on this page?" |
| **Lead qualification** | "Does this company match our ICP: B2B SaaS, 50-500 employees?" |
| **Content moderation** | "Does this page contain adult or harmful content?" |
| **Accessibility audit** | "What accessibility issues can you identify on this page?" |

---

## Pricing Note

SnapAPI does not charge extra for AI analysis beyond your normal API call cost. Token costs go directly to your AI provider:

- OpenAI: ~$0.15–$15 per 1M input tokens (model dependent)
- Anthropic: ~$0.25–$15 per 1M input tokens (model dependent)

Use `maxContentLength` to limit the content sent to AI and control token costs.
