<p align="center">
  <img src="https://snapapi.pics/assets/logo.png" alt="SnapAPI Logo" width="120" height="120">
</p>

<h1 align="center">SnapAPI Official SDKs</h1>

<p align="center">
  <strong>Lightning-fast screenshot API for developers</strong><br>
  Capture any website in milliseconds with our powerful, easy-to-use API
</p>

<p align="center">
  <a href="https://snapapi.pics"><img src="https://img.shields.io/badge/Website-snapapi.pics-6366f1?style=for-the-badge" alt="Website"></a>
  <a href="https://snapapi.pics/docs.html"><img src="https://img.shields.io/badge/Docs-API%20Reference-ec4899?style=for-the-badge" alt="Documentation"></a>
  <a href="https://github.com/Sleywill/snapapi/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-10b981?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> •
  <a href="#-sdks">SDKs</a> •
  <a href="#-features">Features</a> •
  <a href="#-api-reference">API Reference</a> •
  <a href="#-examples">Examples</a> •
  <a href="#-support">Support</a>
</p>

---

## Overview

This monorepo contains all official SnapAPI client libraries for various programming languages. Each SDK provides a simple, idiomatic interface to interact with the SnapAPI screenshot service.

| SDK | Version | Install | Status |
|-----|---------|---------|--------|
| [JavaScript/TypeScript](./javascript) | 1.0.0 | `npm install @snapapi/sdk` | ![Stable](https://img.shields.io/badge/status-stable-10b981) |
| [Python](./python) | 1.0.0 | `pip install snapapi` | ![Stable](https://img.shields.io/badge/status-stable-10b981) |
| [PHP](./php) | 1.0.0 | `composer require snapapi/sdk` | ![Stable](https://img.shields.io/badge/status-stable-10b981) |
| [Go](./go) | 1.0.0 | `go get github.com/Sleywill/snapapi/go` | ![Stable](https://img.shields.io/badge/status-stable-10b981) |
| [Kotlin/Android](./kotlin) | 1.0.0 | Gradle/Maven | ![Stable](https://img.shields.io/badge/status-stable-10b981) |
| [Swift/iOS](./swift) | 1.0.0 | Swift Package Manager | ![Stable](https://img.shields.io/badge/status-stable-10b981) |

---

## Quick Start

### 1. Get Your API Key

Sign up at [snapapi.pics](https://snapapi.pics/register.html) to get your free API key. The free tier includes **100 screenshots per month**.

### 2. Install Your Preferred SDK

<details>
<summary><strong>JavaScript / TypeScript</strong></summary>

```bash
npm install @snapapi/sdk
# or
yarn add @snapapi/sdk
# or
pnpm add @snapapi/sdk
```

```typescript
import { SnapAPI } from '@snapapi/sdk';

const client = new SnapAPI('sk_live_your_api_key');

const screenshot = await client.screenshot({
  url: 'https://example.com',
  format: 'png',
  width: 1920,
  height: 1080
});

// Save to file
await fs.writeFile('screenshot.png', screenshot);
```
</details>

<details>
<summary><strong>Python</strong></summary>

```bash
pip install snapapi
```

```python
from snapapi import SnapAPI

client = SnapAPI(api_key='sk_live_your_api_key')

screenshot = client.screenshot(
    url='https://example.com',
    format='png',
    width=1920,
    height=1080
)

# Save to file
with open('screenshot.png', 'wb') as f:
    f.write(screenshot)
```
</details>

<details>
<summary><strong>PHP</strong></summary>

```bash
composer require snapapi/sdk
```

```php
<?php
use SnapAPI\Client;

$client = new Client('sk_live_your_api_key');

$screenshot = $client->screenshot([
    'url' => 'https://example.com',
    'format' => 'png',
    'width' => 1920,
    'height' => 1080
]);

// Save to file
file_put_contents('screenshot.png', $screenshot);
```
</details>

<details>
<summary><strong>Go</strong></summary>

```bash
go get github.com/Sleywill/snapapi/go
```

```go
package main

import (
    "os"
    snapapi "github.com/Sleywill/snapapi/go"
)

func main() {
    client := snapapi.NewClient("sk_live_your_api_key")

    data, err := client.Screenshot(snapapi.ScreenshotOptions{
        URL:    "https://example.com",
        Format: "png",
        Width:  1920,
        Height: 1080,
    })
    if err != nil {
        panic(err)
    }

    os.WriteFile("screenshot.png", data, 0644)
}
```
</details>

<details>
<summary><strong>Kotlin / Android</strong></summary>

```kotlin
// build.gradle.kts
dependencies {
    implementation("dev.snapapi:sdk:1.0.0")
}
```

```kotlin
import dev.snapapi.SnapAPI
import dev.snapapi.ScreenshotOptions

val client = SnapAPI("sk_live_your_api_key")

val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        format = "png",
        width = 1920,
        height = 1080
    )
)

// Save to file
File("screenshot.png").writeBytes(screenshot)
```
</details>

<details>
<summary><strong>Swift / iOS</strong></summary>

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Sleywill/snapapi", from: "1.0.0")
]
```

```swift
import SnapAPI

let client = SnapAPI(apiKey: "sk_live_your_api_key")

let screenshot = try await client.screenshot(
    url: "https://example.com",
    format: .png,
    width: 1920,
    height: 1080
)

// Save to file
try screenshot.write(to: URL(fileURLWithPath: "screenshot.png"))
```
</details>

---

## Features

### Core Features

| Feature | Free | Starter | Pro | Enterprise |
|---------|------|---------|-----|------------|
| Screenshots/month | 100 | 5,000 | 50,000 | Unlimited |
| PNG/JPEG/WebP | ✅ | ✅ | ✅ | ✅ |
| Full Page Capture | ✅ | ✅ | ✅ | ✅ |
| Mobile Viewports | ✅ | ✅ | ✅ | ✅ |
| PDF Export | ❌ | ✅ | ✅ | ✅ |
| Ad Blocking | ❌ | ✅ | ✅ | ✅ |
| Dark Mode | ❌ | ✅ | ✅ | ✅ |
| Custom CSS | ❌ | ✅ | ✅ | ✅ |
| Custom JavaScript | ❌ | ❌ | ✅ | ✅ |
| Webhooks | ❌ | ❌ | ✅ | ✅ |
| Response Caching | ❌ | ❌ | ✅ | ✅ |
| Priority Support | ❌ | ❌ | ✅ | ✅ |
| Dedicated Infrastructure | ❌ | ❌ | ❌ | ✅ |
| SLA | ❌ | ❌ | ❌ | ✅ |

### Screenshot Options

```typescript
interface ScreenshotOptions {
  url: string;              // Required: URL to capture
  format?: 'png' | 'jpeg' | 'webp' | 'pdf';  // Default: 'png'
  width?: number;           // Viewport width (default: 1280)
  height?: number;          // Viewport height (default: 800)
  fullPage?: boolean;       // Capture full scrollable page
  darkMode?: boolean;       // Force dark mode (Starter+)
  blockAds?: boolean;       // Block ads and popups (Starter+)
  delay?: number;           // Wait ms before capture (max: 10000)
  selector?: string;        // CSS selector to capture specific element
  customCss?: string;       // Inject custom CSS (Starter+)
  customJs?: string;        // Inject custom JavaScript (Pro+)
  quality?: number;         // JPEG/WebP quality 1-100 (default: 80)
  scale?: number;           // Device scale factor (default: 1)
  timeout?: number;         // Page load timeout in ms (default: 30000)
  failIfContentMissing?: string[];  // Fail if text not found on page
  failIfContentContains?: string[]; // Fail if text found on page
}
```

### Video Options (New!)

Capture scroll videos of webpages with smooth animations:

```typescript
interface VideoOptions {
  url: string;                    // Required: URL to capture
  format?: 'mp4' | 'webm' | 'gif'; // Video format (default: 'mp4')
  width?: number;                 // Viewport width (default: 1280)
  height?: number;                // Viewport height (default: 720)
  duration?: number;              // Video duration in ms (default: 5000)
  fps?: number;                   // Frames per second (default: 24)
  scroll?: boolean;               // Enable scroll animation
  scrollDelay?: number;           // Delay between scroll steps in ms (0-5000)
  scrollDuration?: number;        // Duration of each scroll animation (100-5000)
  scrollBy?: number;              // Pixels to scroll per step (100-2000)
  scrollEasing?: 'linear' | 'ease_in' | 'ease_out' | 'ease_in_out' | 'ease_in_out_quint';
  scrollBack?: boolean;           // Scroll back to top at end
  scrollComplete?: boolean;       // Ensure entire page is scrolled
  darkMode?: boolean;             // Force dark mode
  blockAds?: boolean;             // Block ads
  blockCookieBanners?: boolean;   // Hide cookie consent banners
}

// Example: Capture a smooth scroll video
const video = await client.video({
  url: 'https://example.com',
  format: 'mp4',
  scroll: true,
  scrollDuration: 1500,
  scrollEasing: 'ease_in_out',
  scrollBack: true
});

await fs.writeFile('scroll-video.mp4', video);
```

### Content Validation (New!)

Fail screenshot capture based on page content:

```typescript
// Fail if login page is shown (content you don't want)
const screenshot = await client.screenshot({
  url: 'https://example.com/dashboard',
  failIfContentContains: ['Please log in', 'Session expired']
});

// Fail if expected content is missing
const screenshot = await client.screenshot({
  url: 'https://example.com/product',
  failIfContentMissing: ['Add to Cart', 'In Stock']
});
```

---

## API Reference

### Base URL
```
https://api.snapapi.pics
```

### Authentication
All requests require an API key in the `X-Api-Key` header:
```
X-Api-Key: sk_live_your_api_key
```

### Endpoints

#### Take Screenshot
```http
POST /v1/screenshot
Content-Type: application/json
X-Api-Key: sk_live_your_api_key

{
  "url": "https://example.com",
  "format": "png",
  "width": 1920,
  "height": 1080
}
```

**Response:**
- `200 OK` - Returns binary image data
- `400 Bad Request` - Invalid parameters
- `401 Unauthorized` - Invalid API key
- `402 Payment Required` - Quota exceeded
- `429 Too Many Requests` - Rate limit exceeded
- `500 Internal Server Error` - Screenshot failed

### Rate Limits

| Plan | Requests/second |
|------|-----------------|
| Free | 1 |
| Starter | 5 |
| Pro | 20 |
| Enterprise | Custom |

---

## Examples

### Capture Full Page
```typescript
const screenshot = await client.screenshot({
  url: 'https://example.com',
  fullPage: true
});
```

### Mobile Screenshot
```typescript
const screenshot = await client.screenshot({
  url: 'https://example.com',
  width: 375,
  height: 812,
  scale: 2  // Retina display
});
```

### Dark Mode with Ad Blocking
```typescript
const screenshot = await client.screenshot({
  url: 'https://example.com',
  darkMode: true,
  blockAds: true
});
```

### Capture Specific Element
```typescript
const screenshot = await client.screenshot({
  url: 'https://example.com',
  selector: '#main-content'
});
```

### Inject Custom CSS
```typescript
const screenshot = await client.screenshot({
  url: 'https://example.com',
  customCss: `
    .cookie-banner { display: none !important; }
    body { font-family: 'Inter', sans-serif; }
  `
});
```

### Generate PDF
```typescript
const pdf = await client.screenshot({
  url: 'https://example.com',
  format: 'pdf',
  fullPage: true
});
```

### Wait for Dynamic Content
```typescript
const screenshot = await client.screenshot({
  url: 'https://example.com',
  delay: 2000  // Wait 2 seconds for JS to load
});
```

---

## Repository Structure

```
snapapi/
├── README.md           # This file
├── javascript/         # JavaScript/TypeScript SDK
│   ├── src/
│   │   └── index.ts
│   ├── package.json
│   └── README.md
├── python/             # Python SDK
│   ├── snapapi/
│   │   ├── __init__.py
│   │   ├── client.py
│   │   └── types.py
│   ├── pyproject.toml
│   └── README.md
├── php/                # PHP SDK
│   ├── src/
│   │   ├── Client.php
│   │   └── Exception/
│   ├── composer.json
│   └── README.md
├── go/                 # Go SDK
│   ├── client.go
│   ├── types.go
│   ├── errors.go
│   ├── go.mod
│   └── README.md
├── kotlin/             # Kotlin/Android SDK
│   ├── src/
│   │   └── main/kotlin/
│   ├── build.gradle.kts
│   └── README.md
└── swift/              # Swift/iOS SDK
    ├── Sources/
    │   └── SnapAPI/
    ├── Tests/
    ├── Package.swift
    └── README.md
```

---

## Error Handling

All SDKs throw/raise consistent errors:

| Error Code | Description | Resolution |
|------------|-------------|------------|
| `INVALID_URL` | The provided URL is malformed | Check URL format |
| `INVALID_API_KEY` | API key is invalid or missing | Verify your API key |
| `QUOTA_EXCEEDED` | Monthly quota exceeded | Upgrade your plan |
| `RATE_LIMITED` | Too many requests | Implement backoff |
| `TIMEOUT` | Page load timed out | Increase timeout or check URL |
| `SCREENSHOT_FAILED` | Failed to capture screenshot | Check URL accessibility |

### Example Error Handling

```typescript
import { SnapAPI, SnapAPIError } from '@snapapi/sdk';

const client = new SnapAPI('sk_live_your_api_key');

try {
  const screenshot = await client.screenshot({ url: 'https://example.com' });
} catch (error) {
  if (error instanceof SnapAPIError) {
    switch (error.code) {
      case 'QUOTA_EXCEEDED':
        console.log('Please upgrade your plan');
        break;
      case 'RATE_LIMITED':
        console.log('Too many requests, retrying...');
        await sleep(1000);
        // retry
        break;
      default:
        console.error(`Screenshot failed: ${error.message}`);
    }
  }
}
```

---

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup

1. Clone the repository:
```bash
git clone https://github.com/Sleywill/snapapi.git
cd snapapi
```

2. Choose the SDK you want to work on:
```bash
cd javascript  # or python, php, go, kotlin, swift
```

3. Install dependencies and run tests (varies by SDK)

### Pull Request Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## Support

- **Documentation:** [snapapi.pics/docs](https://snapapi.pics/docs.html)
- **Email:** slwv.dev@gmail.com
- **GitHub Issues:** [Open an issue](https://github.com/Sleywill/snapapi/issues)
- **Twitter:** [@snapapi](https://twitter.com/snapapi)

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <sub>Built with ❤️ by the SnapAPI team</sub>
</p>

<p align="center">
  <a href="https://snapapi.pics">Website</a> •
  <a href="https://snapapi.pics/docs.html">Documentation</a> •
  <a href="https://snapapi.pics/blog.html">Blog</a> •
  <a href="https://twitter.com/snapapi">Twitter</a>
</p>

## Extract API (All SDKs)

All SDKs support the Extract API for extracting clean content from webpages - perfect for LLM/RAG workflows.

### Swift
```swift
let result = try await client.extractMarkdown("https://example.com")
let article = try await client.extractArticle("https://blog.example.com")
let structured = try await client.extractStructured("https://example.com")
```

### Kotlin
```kotlin
val result = client.extractMarkdown("https://example.com")
val article = client.extractArticle("https://blog.example.com")
val structured = client.extractStructured("https://example.com")
```

Available extract types: `markdown`, `text`, `html`, `article`, `structured`, `links`, `images`, `metadata`
