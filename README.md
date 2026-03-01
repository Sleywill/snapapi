<p align="center">
  <img src="https://snapapi.pics/logo-translucent-128.png" alt="SnapAPI Logo" width="120" height="120">
</p>

<h1 align="center">SnapAPI — Screenshot, PDF & Web Extraction API</h1>

<p align="center">
  <strong>One API call. Screenshot any URL, generate PDFs, capture videos, extract content, or run AI analysis.</strong>
</p>

<p align="center">
  <a href="https://snapapi.pics"><img src="https://img.shields.io/badge/Website-snapapi.pics-6366f1?style=for-the-badge" alt="Website"></a>
  <a href="https://snapapi.pics/docs.html"><img src="https://img.shields.io/badge/Docs-API%20Reference-ec4899?style=for-the-badge" alt="Documentation"></a>
  <a href="https://snapapi.pics/dashboard.html"><img src="https://img.shields.io/badge/Dashboard-Get%20Key-10b981?style=for-the-badge" alt="Dashboard"></a>
  <a href="https://github.com/Sleywill/snapapi/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-f59e0b?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/@snapapi/sdk"><img src="https://img.shields.io/npm/v/@snapapi/sdk?label=npm&color=cb3837" alt="npm"></a>
  <a href="https://pypi.org/project/snapapi/"><img src="https://img.shields.io/pypi/v/snapapi?label=pypi&color=3776ab" alt="PyPI"></a>
  <a href="https://pkg.go.dev/github.com/Sleywill/snapapi-go"><img src="https://img.shields.io/badge/go-pkg-00add8" alt="Go"></a>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-sdks">SDKs</a> •
  <a href="#-api-reference">API Reference</a> •
  <a href="#-pricing">Pricing</a> •
  <a href="docs/">Full Docs</a>
</p>

---

## Quick Start

```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com", "format": "png"}' \
  --output screenshot.png
```

**Free tier: 200 calls/month. No credit card required.** → [Get your API key](https://snapapi.pics/register.html)

---

## What Is SnapAPI?

SnapAPI is a headless-browser API that turns any URL into:

| What | Endpoint | Description |
|------|----------|-------------|
| 📸 **Screenshot** | `POST /v1/screenshot` | PNG, JPEG, WebP, AVIF — full page, element, or clip |
| 📄 **PDF** | `POST /v1/pdf` | Server-side PDF from any URL or HTML |
| 🎥 **Video** | `POST /v1/video` | Scroll-capture MP4/WebM/GIF of any page |
| 🔍 **Extract** | `POST /v1/extract` | Markdown, article text, links, images, metadata |
| 🤖 **Analyze** | `POST /v1/analyze` | AI analysis (BYOK: OpenAI or Anthropic) |
| 📦 **Batch** | `POST /v1/screenshot/batch` | Capture hundreds of URLs async |

---

## SDKs

| Language | Install | Version |
|----------|---------|---------|
| **JavaScript / TypeScript** | `npm install @snapapi/sdk` | [![npm](https://img.shields.io/npm/v/@snapapi/sdk?color=cb3837)](https://www.npmjs.com/package/@snapapi/sdk) |
| **Python** | `pip install snapapi` | [![PyPI](https://img.shields.io/pypi/v/snapapi?color=3776ab)](https://pypi.org/project/snapapi/) |
| **PHP** | `composer require snapapi/sdk` | 1.3.1 |
| **Go** | `go get github.com/Sleywill/snapapi-go` | 1.3.1 |
| **Kotlin / Android** | Gradle: `dev.snapapi:sdk:1.3.1` | 1.3.1 |
| **Swift / iOS** | Swift Package Manager | 1.3.1 |

See [docs/sdks.md](docs/sdks.md) for installation details and code examples for every SDK.

---

## API Reference

### Base URL
```
https://api.snapapi.pics
```

### Authentication

Include your API key in every request:

```http
X-Api-Key: YOUR_API_KEY
```

Or as a query parameter: `?access_key=YOUR_API_KEY`

---

### Screenshot API `POST /v1/screenshot`

Capture any URL, HTML string, or Markdown as an image.

**Minimal request:**
```json
{
  "url": "https://example.com",
  "format": "png"
}
```

**All parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to capture *(required unless `html` or `markdown` provided)* |
| `html` | string | — | Raw HTML to render instead of a URL |
| `markdown` | string | — | Markdown to render instead of a URL |
| `format` | string | `png` | Output format: `png`, `jpeg`, `webp`, `avif`, `pdf` |
| `quality` | integer | `80` | Image quality 1–100 (JPEG/WebP only) |
| `device` | string | — | Device preset (see [device presets](docs/screenshot.md#device-presets)) |
| `width` | integer | `1280` | Viewport width in pixels (100–3840) |
| `height` | integer | `800` | Viewport height in pixels (100–2160) |
| `deviceScaleFactor` | number | `1` | Device pixel ratio (1–3) |
| `isMobile` | boolean | `false` | Emulate mobile device |
| `hasTouch` | boolean | `false` | Enable touch events |
| `isLandscape` | boolean | `false` | Landscape orientation |
| `fullPage` | boolean | `false` | Capture full scrollable page |
| `fullPageScrollDelay` | integer | — | Delay between scroll steps (ms) |
| `fullPageMaxHeight` | integer | — | Max height for full-page capture (px) |
| `selector` | string | — | CSS selector — capture only this element |
| `selectorScrollIntoView` | boolean | `false` | Scroll element into view before capture |
| `clipX` | integer | — | Clip region X position |
| `clipY` | integer | — | Clip region Y position |
| `clipWidth` | integer | — | Clip region width |
| `clipHeight` | integer | — | Clip region height |
| `delay` | integer | `0` | Wait before capture in ms (0–30000) |
| `timeout` | integer | `30000` | Max page-load wait in ms (1000–60000) |
| `waitUntil` | string | `load` | `load`, `domcontentloaded`, or `networkidle` |
| `waitForSelector` | string | — | Wait for CSS selector before capture |
| `waitForSelectorTimeout` | integer | — | Timeout for selector wait (ms) |
| `darkMode` | boolean | `false` | Force dark color scheme |
| `reducedMotion` | boolean | `false` | Prefer reduced motion |
| `css` | string | — | Custom CSS to inject |
| `javascript` | string | — | JavaScript to execute before capture |
| `hideSelectors` | array | — | CSS selectors to hide |
| `clickSelector` | string | — | CSS selector to click before capture |
| `clickDelay` | integer | — | Delay after click (ms) |
| `blockAds` | boolean | `false` | Block ads and popups |
| `blockTrackers` | boolean | `false` | Block tracking scripts |
| `blockCookieBanners` | boolean | `false` | Hide cookie consent banners |
| `blockChatWidgets` | boolean | `false` | Hide Intercom, Drift, Zendesk widgets |
| `blockResources` | array | — | Resource types to block: `stylesheet`, `image`, `font`, `script`, etc. |
| `userAgent` | string | — | Custom User-Agent string |
| `extraHeaders` | object | — | Additional HTTP request headers |
| `cookies` | array | — | Cookies to set before navigation |
| `httpAuth` | object | — | HTTP Basic Auth `{username, password}` |
| `proxy` | object | — | Proxy config `{server, username, password}` |
| `geolocation` | object | — | `{latitude, longitude, accuracy}` |
| `timezone` | string | — | Timezone (e.g., `America/New_York`) |
| `locale` | string | — | Locale (e.g., `en-US`) |
| `pdfOptions` | object | — | PDF settings (when `format: "pdf"`) |
| `thumbnail` | object | — | Generate a thumbnail alongside the screenshot |
| `failOnHttpError` | boolean | `false` | Fail on 4xx/5xx HTTP responses |
| `cache` | boolean | `false` | Enable response caching |
| `cacheTtl` | integer | — | Cache TTL in seconds (60–2592000) |
| `responseType` | string | `binary` | `binary`, `base64`, or `json` |
| `includeMetadata` | boolean | `false` | Include page metadata in JSON response |
| `extractMetadata` | object | — | `{fonts, colors, links, httpStatusCode}` |
| `failIfContentMissing` | array | — | Fail if these strings are NOT found on the page |
| `failIfContentContains` | array | — | Fail if these strings ARE found on the page |

**Full example:**
```bash
curl -X POST "https://api.snapapi.pics/v1/screenshot" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "format": "webp",
    "fullPage": true,
    "blockAds": true,
    "blockCookieBanners": true,
    "darkMode": true,
    "quality": 90,
    "responseType": "json",
    "includeMetadata": true
  }'
```

→ Full parameter docs: [docs/screenshot.md](docs/screenshot.md)

---

### PDF API `POST /v1/pdf`

Generate a PDF from any URL or HTML content.

```bash
curl -X POST "https://api.snapapi.pics/v1/pdf" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "pdfOptions": {
      "pageSize": "a4",
      "landscape": false,
      "marginTop": "20mm",
      "marginBottom": "20mm",
      "printBackground": true
    }
  }' \
  --output document.pdf
```

PDF options: `pageSize` (`a4`, `a3`, `a5`, `letter`, `legal`, `tabloid`, `custom`), `landscape`, `marginTop/Right/Bottom/Left`, `printBackground`, `headerTemplate`, `footerTemplate`, `displayHeaderFooter`, `scale`, `pageRanges`, `preferCSSPageSize`.

→ Full docs: [docs/screenshot.md#pdf](docs/screenshot.md#pdf-generation)

---

### Video API `POST /v1/video`

Record scroll videos of any webpage.

```bash
curl -X POST "https://api.snapapi.pics/v1/video" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com",
    "format": "mp4",
    "scroll": true,
    "scrollDuration": 1500,
    "scrollEasing": "ease_in_out",
    "scrollBack": true
  }' \
  --output video.mp4
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to capture *(required)* |
| `format` | string | `mp4` | `mp4`, `webm`, or `gif` |
| `width` | integer | `1280` | Viewport width |
| `height` | integer | `720` | Viewport height |
| `duration` | integer | `5000` | Video duration in ms (1000–30000) |
| `fps` | integer | `24` | Frames per second (1–30) |
| `scroll` | boolean | `false` | Enable scroll animation |
| `scrollDelay` | integer | — | Delay between scroll steps in ms (0–5000) |
| `scrollDuration` | integer | — | Duration per scroll animation in ms (100–5000) |
| `scrollBy` | integer | — | Pixels to scroll per step (100–2000) |
| `scrollEasing` | string | — | `linear`, `ease_in`, `ease_out`, `ease_in_out`, `ease_in_out_quint` |
| `scrollBack` | boolean | `false` | Scroll back to top at the end |
| `scrollComplete` | boolean | `false` | Ensure entire page is scrolled |

---

### Extract API `POST /v1/extract`

Extract clean content from any webpage — perfect for LLM / RAG workflows.

```bash
curl -X POST "https://api.snapapi.pics/v1/extract" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://example.com/blog/post", "type": "article"}'
```

**Extract types:**

| Type | Description |
|------|-------------|
| `markdown` | Full page content as clean Markdown |
| `text` | Plain text, no formatting |
| `html` | Cleaned HTML |
| `article` | Main article body, stripped of nav/ads/sidebars |
| `structured` | JSON-LD, microdata, Open Graph structured data |
| `links` | All links with their anchor text |
| `images` | All images with src, alt, and dimensions |
| `metadata` | Title, description, Open Graph tags, etc. |

→ Full docs: [docs/extract.md](docs/extract.md)

---

### Analyze API `POST /v1/analyze`

AI-powered page analysis using your own AI API key (BYOK).

```bash
curl -X POST "https://api.snapapi.pics/v1/analyze" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "url": "https://example.com/product",
    "prompt": "Extract product name, price, and availability",
    "provider": "openai",
    "apiKey": "sk-your-openai-key",
    "jsonSchema": {
      "name": "string",
      "price": "number",
      "inStock": "boolean"
    }
  }'
```

Supports `openai` and `anthropic` as providers. BYOK means SnapAPI never charges for AI tokens — you pay your provider directly.

→ Full docs: [docs/analyze.md](docs/analyze.md)

---

### Batch API `POST /v1/screenshot/batch`

Capture hundreds of screenshots asynchronously.

```bash
# Start batch job
curl -X POST "https://api.snapapi.pics/v1/screenshot/batch" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": ["https://example.com", "https://example.org"],
    "format": "png",
    "webhookUrl": "https://your-server.com/webhook"
  }'

# Poll for status
curl "https://api.snapapi.pics/v1/screenshot/batch/{jobId}" \
  -H "X-Api-Key: YOUR_API_KEY"
```

→ Full async/webhook docs: [docs/webhooks.md](docs/webhooks.md)

---

## Pricing

| Plan | Price | Screenshots/month | Rate limit |
|------|-------|-------------------|------------|
| **Free** | $0 | 200 | 1 req/s |
| **Starter** | $19/mo | 5,000 | 5 req/s |
| **Pro** | $79/mo | 50,000 | 20 req/s |
| **Enterprise** | Custom | Unlimited | Custom |

Pay-as-you-go: **$0.002 per screenshot** above plan quota.

Key feature differences:
- **Free:** PNG/JPEG/WebP, full page, mobile viewports
- **Starter+:** PDF, AVIF, ad blocking, dark mode, custom CSS
- **Pro+:** Custom JS injection, webhooks, response caching, priority support
- **Enterprise:** Dedicated infrastructure, SLA, custom rate limits

[View full pricing →](https://snapapi.pics/#pricing)

---

## Error Codes

| HTTP Status | Code | Description |
|-------------|------|-------------|
| 400 | `INVALID_REQUEST` | Missing or invalid parameters |
| 400 | `INVALID_URL` | Malformed URL |
| 401 | `INVALID_API_KEY` | Missing or invalid API key |
| 402 | `QUOTA_EXCEEDED` | Monthly quota exceeded — upgrade plan |
| 404 | `NOT_FOUND` | Resource not found |
| 422 | `CONTENT_CHECK_FAILED` | `failIfContentMissing` or `failIfContentContains` triggered |
| 429 | `RATE_LIMITED` | Too many requests — back off and retry |
| 500 | `SCREENSHOT_FAILED` | Capture failed (check URL accessibility) |
| 504 | `TIMEOUT` | Page load timed out — increase `timeout` |

→ Full error reference: [docs/errors.md](docs/errors.md)

---

## SDK Quick Examples

<details>
<summary><strong>JavaScript / TypeScript</strong></summary>

```typescript
import { SnapAPI } from '@snapapi/sdk';

const client = new SnapAPI({ apiKey: 'YOUR_API_KEY' });

// Screenshot
const img = await client.screenshot({ url: 'https://example.com', format: 'png' });
fs.writeFileSync('screenshot.png', img as Buffer);

// PDF
const pdf = await client.pdf({ url: 'https://example.com' });
fs.writeFileSync('doc.pdf', pdf);

// Extract article text for LLM
const article = await client.extractArticle('https://blog.example.com/post');
console.log(article.content);

// AI analysis with structured output
const result = await client.analyze({
  url: 'https://shop.example.com/product',
  prompt: 'Extract product details',
  provider: 'openai',
  apiKey: process.env.OPENAI_API_KEY!,
  jsonSchema: { name: 'string', price: 'number' }
});
```
</details>

<details>
<summary><strong>Python</strong></summary>

```python
from snapapi import SnapAPI

client = SnapAPI(api_key='YOUR_API_KEY')

# Screenshot
screenshot = client.screenshot(url='https://example.com', format='png')
with open('screenshot.png', 'wb') as f:
    f.write(screenshot)

# Extract article
article = client.extract_article('https://blog.example.com/post')
print(article['content'])
```
</details>

<details>
<summary><strong>Go</strong></summary>

```go
client := snapapi.NewClient("YOUR_API_KEY")

data, err := client.Screenshot(snapapi.ScreenshotOptions{
    URL:    "https://example.com",
    Format: "png",
})
if err != nil {
    log.Fatal(err)
}
os.WriteFile("screenshot.png", data, 0644)
```
</details>

<details>
<summary><strong>PHP</strong></summary>

```php
$client = new \SnapAPI\Client('YOUR_API_KEY');

$screenshot = $client->screenshot([
    'url'    => 'https://example.com',
    'format' => 'png',
]);
file_put_contents('screenshot.png', $screenshot);
```
</details>

<details>
<summary><strong>Swift</strong></summary>

```swift
let client = SnapAPI(apiKey: "YOUR_API_KEY")
let screenshot = try await client.screenshot(url: "https://example.com", format: .png)
try screenshot.write(to: URL(fileURLWithPath: "screenshot.png"))
```
</details>

<details>
<summary><strong>Kotlin</strong></summary>

```kotlin
val client = SnapAPI("YOUR_API_KEY")
val screenshot = client.screenshot(ScreenshotOptions(url = "https://example.com", format = "png"))
File("screenshot.png").writeBytes(screenshot)
```
</details>

---

## Documentation

| Guide | Description |
|-------|-------------|
| [Getting Started](docs/getting-started.md) | 5-minute quickstart |
| [Screenshot API](docs/screenshot.md) | All parameters, device presets, PDF options |
| [Extract API](docs/extract.md) | Web scraping & content extraction |
| [Analyze API](docs/analyze.md) | AI analysis, BYOK guide |
| [Proxy Guide](docs/proxy.md) | Proxies, residential IPs, Bing support |
| [Webhooks](docs/webhooks.md) | Async jobs, HMAC verification |
| [Scheduled Screenshots](docs/scheduled.md) | Cron-based capture |
| [Storage](docs/storage.md) | SnapAPI storage & custom S3 |
| [SDKs](docs/sdks.md) | All SDKs compared |
| [Rate Limits](docs/rate-limits.md) | Limits by plan, 429 handling |
| [Authentication](docs/authentication.md) | API keys, headers, query params |
| [Error Reference](docs/errors.md) | All error codes & retry logic |

---

## Repository Structure

```
snapapi/
├── README.md           # This file
├── docs/               # Full documentation
│   ├── getting-started.md
│   ├── screenshot.md
│   ├── extract.md
│   ├── analyze.md
│   ├── proxy.md
│   ├── webhooks.md
│   ├── scheduled.md
│   ├── storage.md
│   ├── sdks.md
│   ├── errors.md
│   ├── rate-limits.md
│   └── authentication.md
├── javascript/         # JavaScript/TypeScript SDK
├── python/             # Python SDK
├── php/                # PHP SDK
├── go/                 # Go SDK
├── kotlin/             # Kotlin/Android SDK
└── swift/              # Swift/iOS SDK
```

---

## Support

- **Documentation:** [snapapi.pics/docs.html](https://snapapi.pics/docs.html)
- **Dashboard:** [snapapi.pics/dashboard.html](https://snapapi.pics/dashboard.html)
- **Email:** [support@snapapi.pics](mailto:support@snapapi.pics)
- **GitHub Issues:** [Open an issue](https://github.com/Sleywill/snapapi/issues)

---

## License

MIT — see [LICENSE](LICENSE)

---

<p align="center">Built with ❤️ by the SnapAPI team</p>
