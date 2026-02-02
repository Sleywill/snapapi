# SnapAPI Swift SDK

Official Swift SDK for [SnapAPI](https://snapapi.pics) - Lightning-fast screenshot API for developers.

## Installation

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Sleywill/snapapi.git", from: "1.1.0")
]
```

Or add it through Xcode:
1. File → Add Packages...
2. Enter: `https://github.com/Sleywill/snapapi.git`
3. Select version: `1.1.0`

### CocoaPods

```ruby
pod 'SnapAPI', '~> 1.1.0'
```

## Quick Start

```swift
import SnapAPI

let client = SnapAPI(apiKey: "sk_live_xxx")

// Capture a screenshot
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        format: "png",
        width: 1920,
        height: 1080
    )
)

// Save to file
try screenshot.write(to: URL(fileURLWithPath: "screenshot.png"))
```

## Usage Examples

### Basic Screenshot

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(url: "https://example.com")
)
```

### Full Page Screenshot

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        fullPage: true,
        format: "png"
    )
)
```

### Device Presets

Capture screenshots using pre-configured device settings:

```swift
// Using device preset
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        device: DevicePreset.iPhone15Pro.rawValue
    )
)

// Or use the convenience method
let screenshot = try await client.screenshotDevice(
    url: "https://example.com",
    device: .iPadPro129
)

// Get all available device presets
let devices = try await client.getDevices()
print("Total devices: \(devices.total)")
```

Available device presets:
- **Desktop**: `.desktop1080p`, `.desktop1440p`, `.desktop4K`
- **Mac**: `.macBookPro13`, `.macBookPro16`, `.iMac24`
- **iPhone**: `.iPhoneSE`, `.iPhone12`, `.iPhone13`, `.iPhone14`, `.iPhone14Pro`, `.iPhone15`, `.iPhone15Pro`, `.iPhone15ProMax`
- **iPad**: `.iPad`, `.iPadMini`, `.iPadAir`, `.iPadPro11`, `.iPadPro129`
- **Android**: `.pixel7`, `.pixel8`, `.pixel8Pro`, `.samsungGalaxyS23`, `.samsungGalaxyS24`, `.samsungGalaxyTabS9`

### Dark Mode

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        darkMode: true
    )
)
```

### Screenshot from HTML

```swift
let html = "<html><body><h1>Hello World</h1></body></html>"
let screenshot = try await client.screenshotFromHtml(
    html,
    options: ScreenshotOptions(width: 800, height: 600)
)
```

### PDF Export

```swift
let pdf = try await client.pdf(
    ScreenshotOptions(
        url: "https://example.com",
        pdfOptions: PdfOptions(
            pageSize: "a4",
            landscape: false,
            marginTop: "20mm",
            marginBottom: "20mm",
            marginLeft: "15mm",
            marginRight: "15mm",
            printBackground: true,
            displayHeaderFooter: true,
            headerTemplate: "<div style=\"font-size:10px;text-align:center;width:100%;\">Header</div>",
            footerTemplate: "<div style=\"font-size:10px;text-align:center;width:100%;\">Page <span class=\"pageNumber\"></span></div>"
        )
    )
)

try pdf.write(to: URL(fileURLWithPath: "document.pdf"))
```

### Geolocation Emulation

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://maps.google.com",
        geolocation: Geolocation(
            latitude: 48.8566,
            longitude: 2.3522,
            accuracy: 100
        )
    )
)
```

### Timezone & Locale

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        timezone: "America/New_York",
        locale: "en-US"
    )
)
```

### Proxy Support

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        proxy: ProxyConfig(
            server: "http://proxy.example.com:8080",
            username: "user",
            password: "pass"
        )
    )
)
```

### Hide Elements

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        hideSelectors: [
            ".cookie-banner",
            "#popup-modal",
            ".advertisement"
        ]
    )
)
```

### Click Before Screenshot

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        clickSelector: ".accept-cookies-button",
        clickDelay: 500,
        delay: 1000
    )
)
```

### Block Ads, Trackers, Chat Widgets

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        blockAds: true,
        blockTrackers: true,
        blockCookieBanners: true,
        blockChatWidgets: true // Blocks Intercom, Drift, Zendesk, etc.
    )
)
```

### Thumbnail Generation

```swift
let result = try await client.screenshotWithMetadata(
    ScreenshotOptions(
        url: "https://example.com",
        thumbnail: ThumbnailOptions(
            enabled: true,
            width: 300,
            height: 200,
            fit: "cover" // "cover", "contain", or "fill"
        )
    )
)

// Access both full image and thumbnail
if let fullImage = result.imageData {
    // Use full image data
}
if let thumbnail = result.thumbnailData {
    // Use thumbnail data
}
```

### Fail on HTTP Errors

```swift
do {
    let screenshot = try await client.screenshot(
        ScreenshotOptions(
            url: "https://example.com/404-page",
            failOnHttpError: true
        )
    )
} catch let error as SnapAPIError {
    print("Page returned HTTP error: \(error.message)")
}
```

### Custom JavaScript Execution

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        javascript: """
            document.querySelector('.popup')?.remove();
            document.body.style.background = 'white';
        """,
        delay: 1000
    )
)
```

### Custom CSS

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        css: """
            body { background: #f0f0f0 !important; }
            .ads, .banner { display: none !important; }
        """
    )
)
```

### With Cookies (Authenticated Pages)

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com/dashboard",
        cookies: [
            Cookie(
                name: "session",
                value: "abc123",
                domain: "example.com"
            )
        ]
    )
)
```

### HTTP Basic Authentication

```swift
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com/protected",
        httpAuth: HttpAuth(
            username: "user",
            password: "pass"
        )
    )
)
```

### Element Screenshot with Clipping

```swift
// Capture specific element
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        selector: ".hero-section"
    )
)

// Or use manual clipping
let screenshot = try await client.screenshot(
    ScreenshotOptions(
        url: "https://example.com",
        clipX: 100,
        clipY: 100,
        clipWidth: 500,
        clipHeight: 300
    )
)
```

### Extract Metadata

```swift
let result = try await client.screenshotWithMetadata(
    ScreenshotOptions(
        url: "https://example.com",
        includeMetadata: true,
        extractMetadata: ExtractMetadata(
            fonts: true,
            colors: true,
            links: true,
            httpStatusCode: true
        )
    )
)

print("Title: \(result.metadata?.title ?? "")")
print("HTTP Status: \(result.metadata?.httpStatusCode ?? 0)")
print("Fonts: \(result.metadata?.fonts ?? [])")
print("Colors: \(result.metadata?.colors ?? [])")
print("Links: \(result.metadata?.links ?? [])")
```

### Get Screenshot with Metadata

```swift
let result = try await client.screenshotWithMetadata(
    ScreenshotOptions(
        url: "https://example.com",
        includeMetadata: true
    )
)

print("Width: \(result.width)")
print("Height: \(result.height)")
print("File Size: \(result.fileSize)")
print("Duration: \(result.took)ms")
print("Cached: \(result.cached)")
// result.data contains base64 encoded image
```

### Batch Screenshots

```swift
let batch = try await client.batch(
    BatchOptions(
        urls: [
            "https://example.com",
            "https://example.org",
            "https://example.net"
        ],
        format: "png",
        webhookUrl: "https://your-server.com/webhook"
    )
)

print("Job ID: \(batch.jobId)")

// Check status later
let status = try await client.getBatchStatus(batch.jobId)
if status.status == "completed" {
    for result in status.results ?? [] {
        print("\(result.url): \(result.status)")
    }
}
```

### Get API Capabilities

```swift
let capabilities = try await client.getCapabilities()
print("API Version: \(capabilities.version)")
```

### Get API Usage

```swift
let usage = try await client.getUsage()
print("Used: \(usage.used)")
print("Limit: \(usage.limit)")
print("Remaining: \(usage.remaining)")
print("Resets at: \(usage.resetAt)")
```

## SwiftUI Usage

```swift
import SwiftUI
import SnapAPI

struct ScreenshotView: View {
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var error: String?

    let client = SnapAPI(apiKey: "sk_live_xxx")

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if isLoading {
                ProgressView()
            } else if let error = error {
                Text(error)
                    .foregroundColor(.red)
            }

            Button("Capture Screenshot") {
                captureScreenshot()
            }
            .disabled(isLoading)
        }
        .padding()
    }

    func captureScreenshot() {
        isLoading = true
        error = nil

        Task {
            do {
                let result = try await client.screenshotWithMetadata(
                    ScreenshotOptions(
                        url: "https://example.com",
                        device: DevicePreset.iPhone15Pro.rawValue
                    )
                )
                await MainActor.run {
                    self.image = result.uiImage
                    self.isLoading = false
                }
            } catch let apiError as SnapAPIError {
                await MainActor.run {
                    self.error = apiError.message
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
```

## UIKit Usage

```swift
import UIKit
import SnapAPI

class ScreenshotViewController: UIViewController {
    private let client = SnapAPI(apiKey: "sk_live_xxx")
    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        captureScreenshot()
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(activityIndicator)

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func captureScreenshot() {
        activityIndicator.startAnimating()

        Task {
            do {
                let result = try await client.screenshotWithMetadata(
                    ScreenshotOptions(url: "https://example.com")
                )

                await MainActor.run {
                    self.imageView.image = result.uiImage
                    self.activityIndicator.stopAnimating()
                }
            } catch let error as SnapAPIError {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.showError(error.message)
                }
            } catch {
                await MainActor.run {
                    self.activityIndicator.stopAnimating()
                    self.showError(error.localizedDescription)
                }
            }
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
```

## Configuration Options

### Client Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `apiKey` | String | *required* | Your API key |
| `baseURL` | String | `https://api.snapapi.pics` | API base URL |
| `timeout` | TimeInterval | `60` | Request timeout in seconds |

### Screenshot Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `url` | String? | - | URL to capture (required if no html) |
| `html` | String? | - | HTML content to render (required if no url) |
| `format` | String? | `"png"` | `"png"`, `"jpeg"`, `"webp"`, `"pdf"` |
| `quality` | Int? | `80` | Image quality 1-100 (JPEG/WebP) |
| `device` | String? | - | Device preset name |
| `width` | Int? | `1280` | Viewport width (100-3840) |
| `height` | Int? | `800` | Viewport height (100-2160) |
| `deviceScaleFactor` | Double? | `1.0` | Device pixel ratio (1-3) |
| `isMobile` | Bool? | `false` | Emulate mobile device |
| `hasTouch` | Bool? | `false` | Enable touch events |
| `isLandscape` | Bool? | `false` | Landscape orientation |
| `fullPage` | Bool? | `false` | Capture full scrollable page |
| `fullPageScrollDelay` | Int? | `400` | Delay between scroll steps (ms) |
| `fullPageMaxHeight` | Int? | - | Max height for full page (px) |
| `selector` | String? | - | CSS selector for element capture |
| `clipX`, `clipY` | Int? | - | Clip region position |
| `clipWidth`, `clipHeight` | Int? | - | Clip region size |
| `delay` | Int? | `0` | Delay before capture (0-30000ms) |
| `timeout` | Int? | `30000` | Max wait time (1000-60000ms) |
| `waitUntil` | String? | `"load"` | `"load"`, `"domcontentloaded"`, `"networkidle"` |
| `waitForSelector` | String? | - | Wait for element before capture |
| `darkMode` | Bool? | `false` | Emulate dark mode |
| `reducedMotion` | Bool? | `false` | Reduce animations |
| `css` | String? | - | Custom CSS to inject |
| `javascript` | String? | - | JS to execute before capture |
| `hideSelectors` | [String]? | - | CSS selectors to hide |
| `clickSelector` | String? | - | Element to click before capture |
| `clickDelay` | Int? | - | Delay after click (ms) |
| `blockAds` | Bool? | `false` | Block ads |
| `blockTrackers` | Bool? | `false` | Block trackers |
| `blockCookieBanners` | Bool? | `false` | Hide cookie banners |
| `blockChatWidgets` | Bool? | `false` | Block chat widgets |
| `blockResources` | [String]? | - | Resource types to block |
| `userAgent` | String? | - | Custom User-Agent |
| `extraHeaders` | [String: String]? | - | Custom HTTP headers |
| `cookies` | [Cookie]? | - | Cookies to set |
| `httpAuth` | HttpAuth? | - | HTTP basic auth credentials |
| `proxy` | ProxyConfig? | - | Proxy configuration |
| `geolocation` | Geolocation? | - | Geolocation coordinates |
| `timezone` | String? | - | Timezone (e.g., "America/New_York") |
| `locale` | String? | - | Locale (e.g., "en-US") |
| `pdfOptions` | PdfOptions? | - | PDF generation options |
| `thumbnail` | ThumbnailOptions? | - | Thumbnail generation options |
| `failOnHttpError` | Bool? | `false` | Fail on 4xx/5xx responses |
| `cache` | Bool? | `false` | Enable caching |
| `cacheTtl` | Int? | `86400` | Cache TTL in seconds |
| `responseType` | String? | `"binary"` | `"binary"`, `"base64"`, `"json"` |
| `includeMetadata` | Bool? | `false` | Include page metadata |
| `extractMetadata` | ExtractMetadata? | - | Additional metadata to extract |

## Error Handling

```swift
do {
    let screenshot = try await client.screenshot(
        ScreenshotOptions(url: "invalid-url")
    )
} catch let error as SnapAPIError {
    print("Code: \(error.code)")           // "INVALID_URL"
    print("Status: \(error.statusCode)")   // 400
    print("Message: \(error.message)")     // "The provided URL is not valid"
    print("Details: \(error.details ?? [:])")

    // Check if error is retryable
    if error.isRetryable {
        // Implement retry logic
    }
}
```

### Error Codes

| Code | Status | Description |
|------|--------|-------------|
| `INVALID_URL` | 400 | URL is malformed or not accessible |
| `INVALID_PARAMS` | 400 | One or more parameters are invalid |
| `UNAUTHORIZED` | 401 | Missing or invalid API key |
| `FORBIDDEN` | 403 | API key doesn't have permission |
| `QUOTA_EXCEEDED` | 429 | Monthly quota exceeded |
| `RATE_LIMITED` | 429 | Too many requests |
| `TIMEOUT` | 504 | Page took too long to load |
| `CAPTURE_FAILED` | 500 | Screenshot capture failed |
| `HTTP_ERROR` | varies | Page returned HTTP error (with failOnHttpError) |

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
- Swift 5.9+
- Xcode 15.0+

## License

MIT
