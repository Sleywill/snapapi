<p align="center">
  <img src="https://snapapi.pics/logo-translucent-128.png" alt="SnapAPI Logo" width="120" height="120">
</p>

<h1 align="center">SnapAPI — Screenshot, PDF & Web Extraction API</h1>

<p align="center">
  <strong>One API call. Screenshot any URL, generate PDFs, capture videos, extract content, or run AI analysis.</strong>
</p>

<p align="center">
  <a href="https://snapapi.pics"><img src="https://img.shields.io/badge/Website-snapapi.pics-6366f1?style=for-the-badge" alt="Website"></a>
  <a href="https://snapapi.pics/docs"><img src="https://img.shields.io/badge/Docs-API%20Reference-ec4899?style=for-the-badge" alt="Documentation"></a>
  <a href="https://snapapi.pics/dashboard"><img src="https://img.shields.io/badge/Dashboard-Get%20Key-10b981?style=for-the-badge" alt="Dashboard"></a>
  <a href="https://github.com/Sleywill/snapapi/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-f59e0b?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <a href="https://www.npmjs.com/package/snapapi-js"><img src="https://img.shields.io/npm/v/snapapi-js?label=npm&color=cb3837" alt="npm"></a>
  <a href="https://pypi.org/project/snapapi-client/"><img src="https://img.shields.io/pypi/v/snapapi-client?label=pypi&color=3776ab" alt="PyPI"></a>
  <a href="https://pkg.go.dev/github.com/Sleywill/snapapi-go"><img src="https://img.shields.io/badge/go-pkg-00add8" alt="Go"></a>
  <a href="https://rubygems.org/gems/snapapi"><img src="https://img.shields.io/gem/v/snapapi?label=gem&color=cc3429" alt="RubyGems"></a>
  <a href="https://packagist.org/packages/snapapi/snapapi-php"><img src="https://img.shields.io/packagist/v/snapapi/snapapi-php?color=8892BF" alt="Packagist"></a>
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

**Free tier: 200 calls/month. No credit card required.** → [Get your API key](https://snapapi.pics/register)

---

## What Is SnapAPI?

SnapAPI is a headless-browser API that turns any URL into:

| What | Endpoint | Description |
|------|----------|-------------|
| Screenshot | `POST /v1/screenshot` | PNG, JPEG, WebP, AVIF — full page, element, or clip |
| PDF | `POST /v1/pdf` | Server-side PDF from any URL or HTML |
| Video | `POST /v1/video` | Scroll-capture MP4/WebM/GIF of any page |
| Scrape | `POST /v1/scrape` | Extract HTML, text, or links with a stealth browser |
| Extract | `POST /v1/extract` | Markdown, article text, links, images, metadata |
| Analyze | `POST /v1/analyze` | AI analysis (BYOK: OpenAI or Anthropic) |
| OG Image | `POST /v1/og-image` | Open Graph social preview images at 1200x630 |

---

## SDKs

| Language | Install | Version |
|----------|---------|---------|
| **JavaScript / TypeScript** | `npm install snapapi-js` | [![npm](https://img.shields.io/npm/v/snapapi-js?color=cb3837)](https://www.npmjs.com/package/snapapi-js) |
| **Python** | `pip install snapapi-client` | [![PyPI](https://img.shields.io/pypi/v/snapapi-client?color=3776ab)](https://pypi.org/project/snapapi-client/) |
| **PHP** | `composer require snapapi/snapapi-php` | [![Packagist](https://img.shields.io/packagist/v/snapapi/snapapi-php?color=8892BF)](https://packagist.org/packages/snapapi/snapapi-php) |
| **Go** | `go get github.com/Sleywill/snapapi-go` | [![Go Reference](https://pkg.go.dev/badge/github.com/Sleywill/snapapi-go.svg)](https://pkg.go.dev/github.com/Sleywill/snapapi-go) |
| **Kotlin / Android** | JitPack: `com.github.Sleywill:snapapi-kotlin:3.1.0` | 3.1.0 |
| **Swift / iOS** | Swift Package Manager | 3.1.0 |
| **Ruby** | `gem install snapapi` | [![Gem](https://img.shields.io/gem/v/snapapi?color=cc3429)](https://rubygems.org/gems/snapapi) |
| **Java** | Maven: `pics.snapapi:snapapi-java:3.1.0` | 3.1.0 |

See [docs/sdks.md](docs/sdks.md) for installation details and code examples for all 8 SDKs.

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
| `device` | string | — | Device preset (see device presets docs) |
| `width` | integer | `1280` | Viewport width in pixels (100–3840) |
| `height` | integer | `800` | Viewport height in pixels (100–2160) |
| `deviceScaleFactor` | number | `1` | Device pixel ratio (1–3) |
| `isMobile` | boolean | `false` | Emulate mobile device |
| `hasTouch` | boolean | `false` | Enable touch events |
| `fullPage` | boolean | `false` | Capture full scrollable page |
| `fullPageScrollDelay` | integer | — | Delay between scroll steps (ms) |
| `fullPageMaxHeight` | integer | — | Max height for full-page capture (px) |
| `selector` | string | — | CSS selector — capture only this element |
| `delay` | integer | `0` | Wait before capture in ms (0–30000) |
| `timeout` | integer | `30000` | Max page-load wait in ms (1000–60000) |
| `waitUntil` | string | `load` | `load`, `domcontentloaded`, or `networkidle` |
| `waitForSelector` | string | — | Wait for CSS selector before capture |
| `darkMode` | boolean | `false` | Force dark color scheme |
| `reducedMotion` | boolean | `false` | Prefer reduced motion |
| `css` | string | — | Custom CSS to inject |
| `javascript` | string | — | JavaScript to execute before capture |
| `hideSelectors` | array | — | CSS selectors to hide |
| `clickSelector` | string | — | CSS selector to click before capture |
| `blockAds` | boolean | `false` | Block ads and popups |
| `blockTrackers` | boolean | `false` | Block tracking scripts |
| `blockCookieBanners` | boolean | `false` | Hide cookie consent banners |
| `blockChatWidgets` | boolean | `false` | Hide Intercom, Drift, Zendesk widgets |
| `userAgent` | string | — | Custom User-Agent string |
| `extraHeaders` | object | — | Additional HTTP request headers |
| `cookies` | array | — | Cookies to set before navigation |
| `httpAuth` | object | — | HTTP Basic Auth `{username, password}` |
| `proxy` | object | — | Proxy config `{server, username, password}` |
| `premiumProxy` | boolean | `false` | Use SnapAPI rotating residential proxy |
| `geolocation` | object | — | `{latitude, longitude, accuracy}` |
| `timezone` | string | — | IANA timezone (e.g., `America/New_York`) |
| `locale` | string | — | Locale (e.g., `en-US`) |
| `cache` | boolean | `false` | Enable response caching |
| `cacheTtl` | integer | — | Cache TTL in seconds |
| `storage` | object | — | Store result in cloud storage |
| `webhookUrl` | string | — | Deliver result to this URL asynchronously |

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
    "quality": 90
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
    "pageSize": "a4",
    "landscape": false,
    "marginTop": "20mm",
    "marginBottom": "20mm",
    "printBackground": true
  }' \
  --output document.pdf
```

PDF options: `pageSize` (`a4`, `a3`, `a5`, `letter`, `legal`, `tabloid`), `landscape`, `marginTop/Right/Bottom/Left`, `printBackground`, `headerTemplate`, `footerTemplate`, `displayHeaderFooter`, `scale`.

→ Full docs: [docs/screenshot.md](docs/screenshot.md)

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
    "scrolling": true,
    "duration": 10,
    "fps": 30
  }' \
  --output video.mp4
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to record *(required)* |
| `format` | string | `mp4` | `mp4`, `webm`, or `gif` |
| `width` | integer | `1280` | Viewport width |
| `height` | integer | `720` | Viewport height |
| `duration` | integer | `5` | Video duration in seconds (1–30) |
| `fps` | integer | `25` | Frames per second (10–30) |
| `scrolling` | boolean | `false` | Enable scroll animation |
| `scrollSpeed` | integer | `100` | Scroll speed px/s (50–500) |
| `scrollDelay` | integer | — | Delay before scroll starts (ms) |
| `darkMode` | boolean | `false` | Enable dark mode |
| `blockAds` | boolean | `false` | Block ad networks |

---

### Scrape API `POST /v1/scrape`

Scrape text, HTML, or links using a stealth browser (bypasses bot detection).

```bash
curl -X POST "https://api.snapapi.pics/v1/scrape" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"url": "https://news.ycombinator.com", "type": "links", "pages": 1}'
```

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
      "type": "object",
      "properties": {
        "name":    { "type": "string" },
        "price":   { "type": "number" },
        "inStock": { "type": "boolean" }
      }
    }
  }'
```

Supports `openai` and `anthropic` as providers. BYOK means SnapAPI never charges for AI tokens.

→ Full docs: [docs/analyze.md](docs/analyze.md)

---

## Pricing

| Plan | Price | API Calls/month | Rate limit |
|------|-------|-----------------|------------|
| **Free** | $0 | 200 | 1 req/s |
| **Starter** | $19/mo | 5,000 | 5 req/s |
| **Pro** | $79/mo | 50,000 | 20 req/s |
| **Enterprise** | Custom | Unlimited | Custom |

[View full pricing →](https://snapapi.pics/#pricing)

---

## Error Codes

| HTTP Status | Code | Description |
|-------------|------|-------------|
| 400 | `INVALID_REQUEST` | Missing or invalid parameters |
| 401 | `INVALID_API_KEY` | Missing or invalid API key |
| 402 | `QUOTA_EXCEEDED` | Monthly quota exceeded — upgrade plan |
| 429 | `RATE_LIMITED` | Too many requests — back off and retry |
| 500 | `SCREENSHOT_FAILED` | Capture failed (check URL accessibility) |
| 504 | `TIMEOUT` | Page load timed out — increase `timeout` |

→ Full error reference: [docs/errors.md](docs/errors.md)

---

## SDK Quick Examples

<details>
<summary><strong>JavaScript / TypeScript</strong></summary>

```typescript
import { SnapAPI } from 'snapapi-js';
import fs from 'node:fs';

const client = new SnapAPI({ apiKey: 'YOUR_API_KEY' });

// Screenshot
const img = await client.screenshot({ url: 'https://example.com', format: 'png' });
fs.writeFileSync('screenshot.png', img as Buffer);

// PDF
const pdf = await client.pdf({ url: 'https://example.com' });
fs.writeFileSync('doc.pdf', pdf);

// Extract article text for LLM
const { data: markdown } = await client.extract({
  url: 'https://blog.example.com/post',
  type: 'article',
  cleanOutput: true,
});
console.log(markdown);
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
print(article.content)
```
</details>

<details>
<summary><strong>Go</strong></summary>

```go
import snapapi "github.com/Sleywill/snapapi-go"

client := snapapi.New("YOUR_API_KEY")

data, err := client.Screenshot(ctx, snapapi.ScreenshotParams{
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
import SnapAPI

let client = SnapAPIClient(apiKey: "YOUR_API_KEY")
let png = try await client.screenshot(ScreenshotOptions(url: "https://example.com"))
try png.write(to: URL(fileURLWithPath: "screenshot.png"))
```
</details>

<details>
<summary><strong>Kotlin</strong></summary>

```kotlin
import pics.snapapi.SnapAPIClient
import pics.snapapi.models.*
import java.io.File

val client = SnapAPIClient(apiKey = "YOUR_API_KEY")
val png = client.screenshot(ScreenshotOptions(url = "https://example.com"))
File("screenshot.png").writeBytes(png)
```
</details>

<details>
<summary><strong>Ruby</strong></summary>

```ruby
require 'snapapi'

client = SnapAPI::Client.new(api_key: 'YOUR_API_KEY')

screenshot = client.screenshot(url: 'https://example.com', format: 'png')
File.binwrite('screenshot.png', screenshot)

pdf = client.pdf(url: 'https://example.com')
File.binwrite('document.pdf', pdf)
```
</details>

<details>
<summary><strong>Java</strong></summary>

```java
import pics.snapapi.SnapAPI;
import pics.snapapi.ScreenshotOptions;
import java.nio.file.Files;
import java.nio.file.Path;

SnapAPI client = new SnapAPI("YOUR_API_KEY");

byte[] screenshot = client.screenshot(
    ScreenshotOptions.builder()
        .url("https://example.com")
        .format("png")
        .build()
);
Files.write(Path.of("screenshot.png"), screenshot);
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

## Related Repos

| Repo | Description |
|------|-------------|
| [snapapi-js](https://github.com/Sleywill/snapapi-js) | JavaScript / TypeScript SDK |
| [snapapi-python](https://github.com/Sleywill/snapapi-python) | Python SDK |
| [snapapi-go](https://github.com/Sleywill/snapapi-go) | Go SDK |
| [snapapi-php](https://github.com/Sleywill/snapapi-php) | PHP SDK |
| [snapapi-swift](https://github.com/Sleywill/snapapi-swift) | Swift / iOS SDK |
| [snapapi-kotlin](https://github.com/Sleywill/snapapi-kotlin) | Kotlin / Android SDK |
| [snapapi-ruby](https://github.com/Sleywill/snapapi-ruby) | Ruby SDK |
| [snapapi-java](https://github.com/Sleywill/snapapi-java) | Java SDK |
| [snapapi-cli](https://github.com/Sleywill/snapapi-cli) | CLI tool |
| [snapapi-mcp](https://github.com/Sleywill/snapapi-mcp) | MCP server for AI tools |
| [n8n-nodes-snapapi](https://github.com/Sleywill/n8n-nodes-snapapi) | n8n integration |

---

## Support

- **Documentation:** [snapapi.pics/docs](https://snapapi.pics/docs)
- **Dashboard:** [snapapi.pics/dashboard](https://snapapi.pics/dashboard)
- **Email:** [support@snapapi.pics](mailto:support@snapapi.pics)
- **GitHub Issues:** [Open an issue](https://github.com/Sleywill/snapapi/issues)

---

## License

MIT — see [LICENSE](LICENSE)

---

<p align="center">Built with care by the SnapAPI team</p>
