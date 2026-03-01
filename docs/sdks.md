# SDKs Reference

SnapAPI has official client libraries for 6 languages. All SDKs are open source and maintained by the SnapAPI team.

---

## SDK Comparison

| SDK | Language | Install | Source | Version | License |
|-----|----------|---------|--------|---------|---------|
| [@snapapi/sdk](https://www.npmjs.com/package/@snapapi/sdk) | JavaScript / TypeScript | `npm install @snapapi/sdk` | [/javascript](../javascript) | 1.3.1 | MIT |
| [snapapi](https://pypi.org/project/snapapi/) | Python | `pip install snapapi` | [/python](../python) | 1.3.1 | MIT |
| [snapapi/sdk](https://packagist.org/packages/snapapi/sdk) | PHP | `composer require snapapi/sdk` | [/php](../php) | 1.3.1 | MIT |
| [snapapi-go](https://pkg.go.dev/github.com/Sleywill/snapapi-go) | Go | `go get github.com/Sleywill/snapapi-go` | [/go](../go) | 1.3.1 | MIT |
| [dev.snapapi:sdk](https://central.sonatype.com/artifact/dev.snapapi/sdk) | Kotlin / Android | Gradle | [/kotlin](../kotlin) | 1.3.1 | MIT |
| Swift Package | Swift / iOS | Swift Package Manager | [/swift](../swift) | 1.3.1 | MIT |

---

## JavaScript / TypeScript

**Supports:** Node.js 18+, Bun, Deno, Edge Runtime (Vercel/Cloudflare)

### Installation

```bash
npm install @snapapi/sdk
# or
yarn add @snapapi/sdk
# or
pnpm add @snapapi/sdk
```

### Setup

```typescript
import { SnapAPI } from '@snapapi/sdk';

const client = new SnapAPI({
  apiKey: process.env.SNAPAPI_KEY!,
  timeout: 60000  // optional, default 60s
});
```

### All methods

```typescript
// Screenshots
client.screenshot(options)
client.screenshotFromHtml(html, options)
client.screenshotFromMarkdown(markdown, options)
client.screenshotDevice(url, device, options)

// PDF
client.pdf(options)

// Video
client.video(options)

// Extract
client.extract(options)
client.extractMarkdown(url)
client.extractArticle(url)
client.extractText(url)
client.extractLinks(url)
client.extractImages(url)
client.extractMetadata(url)
client.extractStructured(url)

// Analyze
client.analyze(options)

// Batch
client.batch(options)
client.getBatchStatus(jobId)

// Utilities
client.getDevices()
client.getCapabilities()
client.getUsage()
```

---

## Python

**Supports:** Python 3.8+

### Installation

```bash
pip install snapapi
```

### Setup

```python
from snapapi import SnapAPI

client = SnapAPI(
    api_key='YOUR_API_KEY',
    timeout=60  # seconds
)
```

### Usage

```python
# Screenshot
screenshot = client.screenshot(url='https://example.com', format='png')
with open('screenshot.png', 'wb') as f:
    f.write(screenshot)

# PDF
pdf = client.pdf(url='https://example.com')
with open('doc.pdf', 'wb') as f:
    f.write(pdf)

# Extract
result = client.extract(url='https://example.com', extract_type='article')
print(result['content'])

# Convenience shortcuts
article = client.extract_article('https://blog.example.com')
links   = client.extract_links('https://example.com')
md      = client.extract_markdown('https://example.com')

# Analyze
result = client.analyze(
    url='https://example.com',
    prompt='Summarize this page',
    provider='openai',
    api_key='sk-openai-key'
)
print(result['result'])

# Usage stats
usage = client.get_usage()
print(f"{usage['used']}/{usage['limit']} used")
```

---

## PHP

**Supports:** PHP 7.4+, Composer

### Installation

```bash
composer require snapapi/sdk
```

### Setup

```php
<?php
require 'vendor/autoload.php';
use SnapAPI\Client;

$client = new Client('YOUR_API_KEY');
```

### Usage

```php
// Screenshot
$screenshot = $client->screenshot([
    'url'    => 'https://example.com',
    'format' => 'png',
    'width'  => 1920,
    'height' => 1080
]);
file_put_contents('screenshot.png', $screenshot);

// PDF
$pdf = $client->pdf([
    'url'        => 'https://example.com',
    'pdfOptions' => ['pageSize' => 'a4', 'printBackground' => true]
]);
file_put_contents('doc.pdf', $pdf);

// Extract
$result = $client->extract([
    'url'  => 'https://example.com',
    'type' => 'article'
]);
echo $result['content'];
```

---

## Go

**Supports:** Go 1.20+

### Installation

```bash
go get github.com/Sleywill/snapapi-go
```

### Setup

```go
import snapapi "github.com/Sleywill/snapapi/go"

client := snapapi.NewClient("YOUR_API_KEY")
```

### Usage

```go
package main

import (
    "log"
    "os"
    snapapi "github.com/Sleywill/snapapi/go"
)

func main() {
    client := snapapi.NewClient("YOUR_API_KEY")

    // Screenshot
    data, err := client.Screenshot(snapapi.ScreenshotOptions{
        URL:      "https://example.com",
        Format:   "png",
        FullPage: true,
    })
    if err != nil {
        log.Fatal(err)
    }
    os.WriteFile("screenshot.png", data, 0644)

    // Extract
    result, err := client.Extract(snapapi.ExtractOptions{
        URL:  "https://example.com",
        Type: "article",
    })
    if err != nil {
        log.Fatal(err)
    }
    log.Println(result.Content)
}
```

---

## Kotlin / Android

**Supports:** Android API 24+, Kotlin 1.8+, Coroutines

### Installation

```kotlin
// build.gradle.kts
dependencies {
    implementation("dev.snapapi:sdk:1.3.1")
}
```

### Setup

```kotlin
import dev.snapapi.SnapAPI

val client = SnapAPI("YOUR_API_KEY")
```

### Usage

```kotlin
import dev.snapapi.SnapAPI
import dev.snapapi.ScreenshotOptions
import java.io.File

// Screenshot (suspend function — call from coroutine)
viewModelScope.launch {
    val screenshot = client.screenshot(
        ScreenshotOptions(
            url = "https://example.com",
            format = "png",
            width = 1920,
            height = 1080
        )
    )
    File("screenshot.png").writeBytes(screenshot)
}

// Extract
val result = client.extractArticle("https://blog.example.com")
println(result.content)
```

---

## Swift / iOS

**Supports:** iOS 15+, macOS 12+, Swift 5.7+

### Installation

Add to your `Package.swift`:
```swift
dependencies: [
    .package(url: "https://github.com/Sleywill/snapapi", from: "1.3.1")
]
```

Or in Xcode: **File** → **Add Package Dependencies** → paste `https://github.com/Sleywill/snapapi`

### Setup

```swift
import SnapAPI

let client = SnapAPI(apiKey: "YOUR_API_KEY")
```

### Usage

```swift
// Screenshot
let screenshot = try await client.screenshot(
    url: "https://example.com",
    format: .png,
    width: 1920,
    height: 1080
)
try screenshot.write(to: URL(fileURLWithPath: "screenshot.png"))

// Mobile screenshot with device preset
let mobile = try await client.screenshotDevice(
    url: "https://example.com",
    device: .iPhone15Pro
)

// Extract article for display
let article = try await client.extractArticle("https://news.example.com/story")
print(article.content)

// AI analysis
let result = try await client.analyze(
    url: "https://product.example.com",
    prompt: "Extract product details",
    provider: .openai,
    apiKey: "sk-openai-key"
)
```

---

## Missing Your Language?

The SnapAPI REST API works with any HTTP client. See the [Authentication docs](authentication.md) for the header format and the main [README](../README.md) for all endpoint details.

Want to contribute a new SDK? Open an issue on [GitHub](https://github.com/Sleywill/snapapi/issues).
