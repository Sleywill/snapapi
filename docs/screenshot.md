# Screenshot API Reference

`POST https://api.snapapi.pics/v1/screenshot`

Capture any URL, HTML, or Markdown as a pixel-perfect image.

---

## Authentication

```http
X-Api-Key: YOUR_API_KEY
```

---

## Parameters

### Source

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `url` | string | — | URL to capture. Required unless `html` or `markdown` is provided. Must be a valid http/https URL. |
| `html` | string | — | Raw HTML string to render. Use instead of `url` to render custom HTML. |
| `markdown` | string | — | Markdown string to render. Converted to HTML, then captured. |

**Example — Capture a URL:**
```json
{ "url": "https://example.com" }
```

**Example — Render custom HTML:**
```json
{ "html": "<h1 style='color:red'>Hello World</h1>" }
```

**Example — Render Markdown:**
```json
{ "markdown": "# Hello\n\nThis is **bold**." }
```

---

### Output Format

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `format` | string | `png` | Output format: `png`, `jpeg`, `webp`, `avif`, `pdf` |
| `quality` | integer | `80` | Image quality 1–100. Only applies to `jpeg` and `webp`. |
| `responseType` | string | `binary` | How to return the image: `binary` (raw bytes), `base64` (base64 string), `json` (JSON object with metadata) |

**Example — JPEG with quality:**
```json
{ "url": "https://example.com", "format": "jpeg", "quality": 95 }
```

**Example — Get JSON response with metadata:**
```json
{
  "url": "https://example.com",
  "format": "png",
  "responseType": "json",
  "includeMetadata": true
}
```

---

### Viewport & Device

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `device` | string | — | Device preset name. Overrides `width`, `height`, `deviceScaleFactor`, `isMobile`, and `hasTouch`. See [Device Presets](#device-presets). |
| `width` | integer | `1280` | Viewport width in pixels. Range: 100–3840. |
| `height` | integer | `800` | Viewport height in pixels. Range: 100–2160. |
| `deviceScaleFactor` | number | `1` | Device pixel ratio. Use `2` for Retina/HiDPI. Range: 1–3. |
| `isMobile` | boolean | `false` | Emulate a mobile device (affects meta viewport handling). |
| `hasTouch` | boolean | `false` | Enable touch events (useful for mobile-optimized sites). |
| `isLandscape` | boolean | `false` | Landscape orientation (only relevant when `device` is set). |

**Example — 4K desktop:**
```json
{ "url": "https://example.com", "width": 3840, "height": 2160 }
```

**Example — iPhone 15 Pro using device preset:**
```json
{ "url": "https://example.com", "device": "iphone-15-pro" }
```

---

### Device Presets

Use the `device` parameter with any of these preset names:

#### Desktop

| Preset | Width | Height | Scale | Mobile |
|--------|-------|--------|-------|--------|
| `desktop-1080p` | 1920 | 1080 | 1 | No |
| `desktop-1440p` | 2560 | 1440 | 1 | No |
| `desktop-4k` | 3840 | 2160 | 1 | No |

#### Mac

| Preset | Width | Height | Scale | Mobile |
|--------|-------|--------|-------|--------|
| `macbook-pro-13` | 1280 | 800 | 2 | No |
| `macbook-pro-16` | 1728 | 1117 | 2 | No |
| `imac-24` | 2240 | 1260 | 2 | No |

#### iPhone

| Preset | Width | Height | Scale | Mobile |
|--------|-------|--------|-------|--------|
| `iphone-se` | 375 | 667 | 2 | Yes |
| `iphone-12` | 390 | 844 | 3 | Yes |
| `iphone-13` | 390 | 844 | 3 | Yes |
| `iphone-14` | 390 | 844 | 3 | Yes |
| `iphone-14-pro` | 393 | 852 | 3 | Yes |
| `iphone-15` | 393 | 852 | 3 | Yes |
| `iphone-15-pro` | 393 | 852 | 3 | Yes |
| `iphone-15-pro-max` | 430 | 932 | 3 | Yes |

#### iPad

| Preset | Width | Height | Scale | Mobile |
|--------|-------|--------|-------|--------|
| `ipad` | 768 | 1024 | 2 | Yes |
| `ipad-mini` | 744 | 1133 | 2 | Yes |
| `ipad-air` | 820 | 1180 | 2 | Yes |
| `ipad-pro-11` | 834 | 1194 | 2 | Yes |
| `ipad-pro-12.9` | 1024 | 1366 | 2 | Yes |

#### Android

| Preset | Width | Height | Scale | Mobile |
|--------|-------|--------|-------|--------|
| `pixel-7` | 412 | 915 | 2.6 | Yes |
| `pixel-8` | 412 | 915 | 2.6 | Yes |
| `pixel-8-pro` | 448 | 998 | 2.6 | Yes |
| `samsung-galaxy-s23` | 393 | 873 | 2.8 | Yes |
| `samsung-galaxy-s24` | 393 | 873 | 2.8 | Yes |
| `samsung-galaxy-tab-s9` | 800 | 1280 | 2 | Yes |

You can also fetch the full list dynamically:
```bash
curl "https://api.snapapi.pics/v1/devices" -H "X-Api-Key: YOUR_API_KEY"
```

---

### Capture Region

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `fullPage` | boolean | `false` | Capture the full scrollable page, not just the visible viewport. |
| `fullPageScrollDelay` | integer | — | Delay in ms between scroll steps during full-page capture. |
| `fullPageMaxHeight` | integer | — | Maximum height in pixels for full-page captures (prevents enormous images). |
| `selector` | string | — | CSS selector — capture only this element. Example: `"#main-content"` |
| `selectorScrollIntoView` | boolean | `false` | Scroll the selected element into view before capturing. |
| `clipX` | integer | — | Clip region — X coordinate (pixels from left). |
| `clipY` | integer | — | Clip region — Y coordinate (pixels from top). |
| `clipWidth` | integer | — | Clip region width in pixels. |
| `clipHeight` | integer | — | Clip region height in pixels. |

**Example — Full page:**
```json
{ "url": "https://example.com", "fullPage": true }
```

**Example — Capture specific element:**
```json
{ "url": "https://example.com", "selector": ".hero-section" }
```

**Example — Clip a region:**
```json
{ "url": "https://example.com", "clipX": 0, "clipY": 0, "clipWidth": 800, "clipHeight": 400 }
```

---

### Timing & Wait

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `delay` | integer | `0` | Wait this many ms after page load before capturing. Range: 0–30000. Useful for animations or lazy-loaded content. |
| `timeout` | integer | `30000` | Maximum ms to wait for page load. Range: 1000–60000. |
| `waitUntil` | string | `load` | When to consider navigation complete: `load` (default), `domcontentloaded`, or `networkidle` (waits for no network activity for 500ms). |
| `waitForSelector` | string | — | Wait for a CSS selector to appear before capturing. |
| `waitForSelectorTimeout` | integer | — | Timeout for `waitForSelector` in ms. |

**Example — Wait for SPA content:**
```json
{
  "url": "https://spa-app.example.com",
  "waitUntil": "networkidle",
  "delay": 1000
}
```

**Example — Wait for modal to appear:**
```json
{
  "url": "https://example.com",
  "waitForSelector": ".modal-content",
  "waitForSelectorTimeout": 5000
}
```

---

### Visual & Rendering

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `darkMode` | boolean | `false` | Emulate dark color scheme (`prefers-color-scheme: dark`). |
| `reducedMotion` | boolean | `false` | Emulate `prefers-reduced-motion: reduce`. Stops CSS animations. |
| `css` | string | — | Custom CSS to inject before capture. Use to hide elements, change fonts, etc. |
| `javascript` | string | — | JavaScript code to execute before capture. |
| `hideSelectors` | array | — | Array of CSS selectors to hide via `display: none`. |
| `clickSelector` | string | — | CSS selector to click before capture (e.g., to open a dropdown). |
| `clickDelay` | integer | — | Delay in ms after clicking before capturing. |

**Example — Dark mode + custom CSS:**
```json
{
  "url": "https://example.com",
  "darkMode": true,
  "css": ".cookie-banner, .chat-widget { display: none !important; }"
}
```

**Example — Click to expand, then capture:**
```json
{
  "url": "https://example.com/faq",
  "clickSelector": ".faq-item:first-child .toggle",
  "clickDelay": 500
}
```

---

### Blocking & Privacy

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `blockAds` | boolean | `false` | Block ads, pop-ups, and interstitials. |
| `blockTrackers` | boolean | `false` | Block analytics and tracking scripts. |
| `blockCookieBanners` | boolean | `false` | Hide GDPR cookie consent banners. |
| `blockChatWidgets` | boolean | `false` | Hide Intercom, Drift, Zendesk, and similar chat widgets. |
| `blockResources` | array | — | Block specific resource types: `stylesheet`, `image`, `media`, `font`, `script`, `xhr`, `fetch`, `websocket`. |

**Example — Clean, uncluttered screenshot:**
```json
{
  "url": "https://news-site.example.com",
  "blockAds": true,
  "blockTrackers": true,
  "blockCookieBanners": true,
  "blockChatWidgets": true
}
```

**Example — Skip loading images (faster):**
```json
{
  "url": "https://example.com",
  "blockResources": ["image", "media"]
}
```

---

### Headers, Auth & Browser Context

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `userAgent` | string | — | Custom User-Agent string. |
| `extraHeaders` | object | — | Additional HTTP headers to send with the page request. |
| `cookies` | array | — | Array of cookie objects to set before navigation. |
| `httpAuth` | object | — | HTTP Basic Auth credentials: `{username, password}`. |
| `proxy` | object | — | Proxy config: `{server, username, password, bypass}`. See [proxy.md](proxy.md). |
| `geolocation` | object | — | GPS coordinates: `{latitude, longitude, accuracy}`. |
| `timezone` | string | — | IANA timezone (e.g., `America/New_York`, `Europe/London`). |
| `locale` | string | — | Browser locale (e.g., `en-US`, `fr-FR`, `de-DE`). |

**Example — Authenticated page:**
```json
{
  "url": "https://app.example.com/dashboard",
  "cookies": [
    { "name": "session", "value": "abc123", "domain": "app.example.com" }
  ]
}
```

**Example — Custom locale and timezone:**
```json
{
  "url": "https://example.com",
  "locale": "de-DE",
  "timezone": "Europe/Berlin"
}
```

---

### Content Validation

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `failIfContentMissing` | array | — | Fail (422) if any of these strings are NOT found on the page. Max 10 items, 200 chars each. |
| `failIfContentContains` | array | — | Fail (422) if any of these strings ARE found on the page. Max 10 items, 200 chars each. |
| `failOnHttpError` | boolean | `false` | Fail if the page returns a 4xx or 5xx HTTP status code. |

**Example — Detect login redirect:**
```json
{
  "url": "https://app.example.com/dashboard",
  "cookies": [{ "name": "session", "value": "..." }],
  "failIfContentContains": ["Please log in", "Session expired"],
  "failIfContentMissing": ["Dashboard", "Welcome back"]
}
```

---

### Caching

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cache` | boolean | `false` | Enable response caching. Subsequent identical requests return cached result. |
| `cacheTtl` | integer | — | Cache time-to-live in seconds. Range: 60–2592000 (30 days). |

**Example — Cache for 1 hour:**
```json
{
  "url": "https://example.com",
  "cache": true,
  "cacheTtl": 3600
}
```

---

### Metadata Extraction

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `includeMetadata` | boolean | `false` | Include page metadata in JSON response (requires `responseType: "json"`). |
| `extractMetadata` | object | — | Fine-tune what metadata to extract: `{fonts, colors, links, httpStatusCode}`. |
| `thumbnail` | object | — | Generate a thumbnail: `{enabled: true, width, height, fit}`. |

**Example — Rich metadata response:**
```json
{
  "url": "https://example.com",
  "responseType": "json",
  "includeMetadata": true,
  "extractMetadata": {
    "fonts": true,
    "colors": true,
    "links": true,
    "httpStatusCode": true
  }
}
```

---

## PDF Generation

Use `format: "pdf"` or the dedicated `/v1/pdf` endpoint.

### PDF Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `pageSize` | string | `a4` | Paper size: `a3`, `a4`, `a5`, `letter`, `legal`, `tabloid`, `custom` |
| `width` | string | — | Custom page width (e.g., `"210mm"`, `"8.5in"`). Only when `pageSize: "custom"`. |
| `height` | string | — | Custom page height. Only when `pageSize: "custom"`. |
| `landscape` | boolean | `false` | Landscape orientation. |
| `marginTop` | string | — | Top margin (e.g., `"20mm"`, `"1in"`). |
| `marginRight` | string | — | Right margin. |
| `marginBottom` | string | — | Bottom margin. |
| `marginLeft` | string | — | Left margin. |
| `printBackground` | boolean | `false` | Print CSS backgrounds (colors, images). |
| `headerTemplate` | string | — | HTML template for page header. |
| `footerTemplate` | string | — | HTML template for page footer. |
| `displayHeaderFooter` | boolean | `false` | Show header and footer. |
| `scale` | number | `1` | Page scale factor (0.1–2). |
| `pageRanges` | string | — | Pages to include (e.g., `"1-5"`, `"1,3,5-10"`). |
| `preferCSSPageSize` | boolean | `false` | Use page size defined in CSS (`@page` rule). |

**Example — Styled A4 PDF with footer:**
```json
{
  "url": "https://example.com",
  "pdfOptions": {
    "pageSize": "a4",
    "landscape": false,
    "marginTop": "25mm",
    "marginRight": "20mm",
    "marginBottom": "25mm",
    "marginLeft": "20mm",
    "printBackground": true,
    "displayHeaderFooter": true,
    "footerTemplate": "<div style='font-size:10px;text-align:center;width:100%'>Page <span class='pageNumber'></span> of <span class='totalPages'></span></div>"
  }
}
```

---

## Async Capture with Batch API

For high-volume or long-running captures, use the Batch API:

```bash
# 1. Submit batch job
curl -X POST "https://api.snapapi.pics/v1/screenshot/batch" \
  -H "X-Api-Key: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "urls": ["https://site1.com", "https://site2.com", "https://site3.com"],
    "format": "png",
    "webhookUrl": "https://your-server.com/webhook"
  }'

# Response:
# { "jobId": "job_abc123", "status": "pending", "total": 3 }

# 2. Poll for status
curl "https://api.snapapi.pics/v1/screenshot/batch/job_abc123" \
  -H "X-Api-Key: YOUR_API_KEY"
```

When complete, results are delivered to your webhook URL. See [webhooks.md](webhooks.md) for the full event format and HMAC verification.

---

## Response Format

**Binary (default):** Raw image bytes with `Content-Type: image/png` (or jpeg/webp/avif).

**JSON (`responseType: "json"`):**
```json
{
  "success": true,
  "format": "png",
  "width": 1280,
  "height": 800,
  "fileSize": 245632,
  "took": 1842,
  "cached": false,
  "metadata": {
    "title": "Example Domain",
    "description": "This domain is for use in examples.",
    "favicon": "https://example.com/favicon.ico",
    "httpStatusCode": 200
  }
}
```

---

## Useful Examples

### Social media preview (Open Graph image)

```json
{
  "url": "https://example.com",
  "width": 1200,
  "height": 630,
  "css": "body { margin: 0; }",
  "delay": 500
}
```

### Thumbnail strip for an e-commerce catalog

```json
{
  "url": "https://shop.example.com/product/123",
  "selector": ".product-image",
  "format": "webp",
  "quality": 75,
  "thumbnail": { "enabled": true, "width": 300, "height": 200, "fit": "cover" }
}
```

### Screenshot behind a paywall

```json
{
  "url": "https://app.example.com/report",
  "cookies": [{ "name": "auth_token", "value": "Bearer ..." }],
  "waitUntil": "networkidle",
  "failIfContentContains": ["Sign In", "Subscribe"]
}
```
