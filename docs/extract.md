# Extract API Reference

`POST https://api.snapapi.pics/v1/extract`

Extract clean, structured content from any webpage. Perfect for LLM pipelines, RAG systems, content processing, and web data extraction.

---

## Authentication

```http
X-Api-Key: YOUR_API_KEY
```

---

## Request Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to extract content from *(required)* |
| `type` | string | — | Extraction type *(required)* — see below |
| `selector` | string | — | CSS selector — extract from this element only |
| `waitFor` | string | — | Wait for this CSS selector before extracting |
| `timeout` | integer | `30000` | Max wait time in ms |
| `darkMode` | boolean | `false` | Emulate dark mode |
| `blockAds` | boolean | `false` | Block ads before extracting |
| `blockCookieBanners` | boolean | `false` | Hide cookie banners |
| `includeImages` | boolean | `false` | Include image URLs in extracted Markdown |
| `maxLength` | integer | — | Maximum content length in characters |
| `cleanOutput` | boolean | `false` | Remove boilerplate (navigation, headers, footers, ads) |

---

## Extract Types

### `markdown` — Full page as Markdown

Converts the entire page to clean Markdown. Best for general content, wikis, documentation.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://en.wikipedia.org/wiki/API", "type": "markdown"}'
```

**Response:**
```json
{
  "success": true,
  "type": "markdown",
  "content": "# API\n\nAn **application programming interface** (API) ...",
  "url": "https://en.wikipedia.org/wiki/API",
  "title": "API - Wikipedia",
  "took": 1240,
  "contentLength": 8432
}
```

---

### `article` — Main article body

Extracts only the primary article content — strips navigation, ads, sidebars, headers, footers. Best for news articles, blog posts, documentation pages.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://blog.example.com/my-post", "type": "article", "cleanOutput": true}'
```

**Use case:** Feed to an LLM for summarization, translation, or Q&A.

---

### `text` — Plain text

Raw text, no Markdown formatting. Best when you need pure content without symbols.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "type": "text"}'
```

---

### `html` — Cleaned HTML

Cleaned and sanitized HTML — removes scripts, tracking pixels, and other noise while preserving structure.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "type": "html"}'
```

---

### `structured` — Structured data (JSON-LD, microdata, Open Graph)

Extracts machine-readable structured data embedded in the page.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://shop.example.com/product", "type": "structured"}'
```

**Response:**
```json
{
  "success": true,
  "type": "structured",
  "content": "{}",
  "structured": {
    "@context": "https://schema.org",
    "@type": "Product",
    "name": "Widget Pro",
    "price": "29.99",
    "availability": "InStock"
  },
  "took": 980
}
```

**Use case:** E-commerce price monitoring, product catalog building.

---

### `links` — All links on the page

Extracts all hyperlinks with their anchor text and href values.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "type": "links"}'
```

**Response:**
```json
{
  "success": true,
  "type": "links",
  "content": "",
  "links": [
    { "href": "https://example.com/about", "text": "About Us" },
    { "href": "https://example.com/pricing", "text": "Pricing" }
  ],
  "took": 760
}
```

**Use case:** Sitemap building, broken link detection, web crawling.

---

### `images` — All images on the page

Extracts all images with their source URLs, alt text, and dimensions.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "type": "images"}'
```

**Response:**
```json
{
  "success": true,
  "type": "images",
  "content": "",
  "images": [
    { "src": "https://example.com/logo.png", "alt": "Company Logo", "width": 200, "height": 60 },
    { "src": "https://example.com/hero.jpg", "alt": "Hero Image", "width": 1920, "height": 1080 }
  ],
  "took": 820
}
```

---

### `metadata` — Page metadata

Extracts title, description, Open Graph tags, Twitter Card tags, canonical URL, and other `<meta>` tags.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "type": "metadata"}'
```

**Response:**
```json
{
  "success": true,
  "type": "metadata",
  "content": "",
  "metadata": {
    "title": "Example Domain",
    "description": "This domain is for illustrative examples.",
    "canonical": "https://example.com/",
    "ogTitle": "Example Domain",
    "ogDescription": "For illustrative examples.",
    "ogImage": "https://example.com/og.png",
    "twitterCard": "summary_large_image",
    "author": "IANA",
    "robots": "index, follow"
  },
  "took": 640
}
```

---

## SDK Examples

### JavaScript

```typescript
import { SnapAPI } from '@snapapi/sdk';

const client = new SnapAPI({ apiKey: 'YOUR_API_KEY' });

// Quick shortcuts
const article = await client.extractArticle('https://blog.example.com/post');
const links   = await client.extractLinks('https://example.com');
const images  = await client.extractImages('https://example.com');
const meta    = await client.extractMetadata('https://example.com');
const text    = await client.extractText('https://example.com');
const md      = await client.extractMarkdown('https://example.com');
const data    = await client.extractStructured('https://shop.example.com');

// Full options
const result = await client.extract({
  url: 'https://example.com',
  type: 'article',
  cleanOutput: true,
  maxLength: 50000,
  blockAds: true,
  blockCookieBanners: true
});

console.log(result.content);
```

### Python

```python
from snapapi import SnapAPI

client = SnapAPI(api_key='YOUR_API_KEY')

# Extract article for LLM
result = client.extract(
    url='https://blog.example.com/post',
    extract_type='article',
    clean_output=True,
    max_length=50000
)
print(result['content'])
```

---

## Real-World Use Cases

### Build a RAG pipeline

```typescript
const article = await client.extractArticle(url);
// Feed article.content to OpenAI embeddings / vector DB
await openai.embeddings.create({ input: article.content, model: 'text-embedding-3-small' });
```

### Monitor competitor pricing

```typescript
const structured = await client.extractStructured('https://competitor.com/product/123');
const price = structured.structured?.offers?.price;
```

### Build a sitemap crawler

```typescript
const links = await client.extractLinks('https://example.com');
for (const link of links.links ?? []) {
  if (link.href.startsWith('https://example.com')) {
    // Add to crawl queue
  }
}
```

---

## Tips

- Use `type: "article"` + `cleanOutput: true` for the best LLM input
- Use `type: "markdown"` with `includeImages: true` to preserve image context
- Use `selector` to extract content from a specific part of the page (e.g., `"#product-description"`)
- Use `waitFor` for SPAs where content loads asynchronously
- Set `maxLength` to control token costs when feeding to LLMs
