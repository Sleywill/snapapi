# SnapAPI Kotlin SDK

Official Kotlin/Android SDK for [SnapAPI](https://snapapi.pics) - Lightning-fast screenshot API for developers.

## Installation

### JitPack (Recommended)

Add JitPack repository to your root `build.gradle.kts`:

```kotlin
repositories {
    mavenCentral()
    maven { url = uri("https://jitpack.io") }
}
```

Add the dependency:

```kotlin
dependencies {
    implementation("com.github.Sleywill.snapapi:kotlin:1.1.0")
}
```

### Gradle (Groovy)

```groovy
repositories {
    mavenCentral()
    maven { url 'https://jitpack.io' }
}

dependencies {
    implementation 'com.github.Sleywill.snapapi:kotlin:1.1.0'
}
```

### Maven

```xml
<repositories>
    <repository>
        <id>jitpack.io</id>
        <url>https://jitpack.io</url>
    </repository>
</repositories>

<dependency>
    <groupId>com.github.Sleywill.snapapi</groupId>
    <artifactId>kotlin</artifactId>
    <version>1.1.0</version>
</dependency>
```

## Quick Start

```kotlin
import dev.snapapi.SnapAPI
import dev.snapapi.ScreenshotOptions
import java.io.File

suspend fun main() {
    val client = SnapAPI("sk_live_xxx")

    // Capture a screenshot
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
}
```

## Usage Examples

### Basic Screenshot

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(url = "https://example.com")
)
```

### Full Page Screenshot

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        fullPage = true,
        format = "png"
    )
)
```

### Device Presets

Capture screenshots using pre-configured device settings:

```kotlin
import dev.snapapi.DevicePresets

// Using device preset
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        device = DevicePresets.IPHONE_15_PRO
    )
)

// Or use the convenience method
val screenshot = client.screenshotDevice(
    url = "https://example.com",
    device = DevicePresets.IPAD_PRO_12_9
)

// Get all available device presets
val devices = client.getDevices()
println("Total devices: ${devices.total}")
```

Available device presets:
- **Desktop**: `DESKTOP_1080P`, `DESKTOP_1440P`, `DESKTOP_4K`
- **Mac**: `MACBOOK_PRO_13`, `MACBOOK_PRO_16`, `IMAC_24`
- **iPhone**: `IPHONE_SE`, `IPHONE_12`, `IPHONE_13`, `IPHONE_14`, `IPHONE_14_PRO`, `IPHONE_15`, `IPHONE_15_PRO`, `IPHONE_15_PRO_MAX`
- **iPad**: `IPAD`, `IPAD_MINI`, `IPAD_AIR`, `IPAD_PRO_11`, `IPAD_PRO_12_9`
- **Android**: `PIXEL_7`, `PIXEL_8`, `PIXEL_8_PRO`, `SAMSUNG_GALAXY_S23`, `SAMSUNG_GALAXY_S24`, `SAMSUNG_GALAXY_TAB_S9`

### Dark Mode

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        darkMode = true
    )
)
```

### Screenshot from HTML

```kotlin
val html = "<html><body><h1>Hello World</h1></body></html>"
val screenshot = client.screenshotFromHtml(
    html = html,
    options = ScreenshotOptions(width = 800, height = 600)
)
```

### PDF Export

```kotlin
import dev.snapapi.PdfOptions

val pdf = client.pdf(
    ScreenshotOptions(
        url = "https://example.com",
        pdfOptions = PdfOptions(
            pageSize = "a4",
            landscape = false,
            marginTop = "20mm",
            marginBottom = "20mm",
            marginLeft = "15mm",
            marginRight = "15mm",
            printBackground = true,
            displayHeaderFooter = true,
            headerTemplate = """<div style="font-size:10px;text-align:center;width:100%;">Header</div>""",
            footerTemplate = """<div style="font-size:10px;text-align:center;width:100%;">Page <span class="pageNumber"></span></div>"""
        )
    )
)

File("document.pdf").writeBytes(pdf)
```

### Geolocation Emulation

```kotlin
import dev.snapapi.Geolocation

val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://maps.google.com",
        geolocation = Geolocation(
            latitude = 48.8566,
            longitude = 2.3522,
            accuracy = 100.0
        )
    )
)
```

### Timezone & Locale

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        timezone = "America/New_York",
        locale = "en-US"
    )
)
```

### Proxy Support

```kotlin
import dev.snapapi.ProxyConfig

val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        proxy = ProxyConfig(
            server = "http://proxy.example.com:8080",
            username = "user",
            password = "pass"
        )
    )
)
```

### Hide Elements

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        hideSelectors = listOf(
            ".cookie-banner",
            "#popup-modal",
            ".advertisement"
        )
    )
)
```

### Click Before Screenshot

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        clickSelector = ".accept-cookies-button",
        clickDelay = 500,
        delay = 1000
    )
)
```

### Block Ads, Trackers, Chat Widgets

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        blockAds = true,
        blockTrackers = true,
        blockCookieBanners = true,
        blockChatWidgets = true // Blocks Intercom, Drift, Zendesk, etc.
    )
)
```

### Thumbnail Generation

```kotlin
import dev.snapapi.ThumbnailOptions

val result = client.screenshotWithMetadata(
    ScreenshotOptions(
        url = "https://example.com",
        thumbnail = ThumbnailOptions(
            enabled = true,
            width = 300,
            height = 200,
            fit = "cover" // "cover", "contain", or "fill"
        )
    )
)

// Access both full image and thumbnail
val fullImage = result.data.decodeBase64()
val thumbnail = result.thumbnail?.decodeBase64()
```

### Fail on HTTP Errors

```kotlin
try {
    val screenshot = client.screenshot(
        ScreenshotOptions(
            url = "https://example.com/404-page",
            failOnHttpError = true
        )
    )
} catch (e: SnapAPIException) {
    println("Page returned HTTP error: ${e.message}")
}
```

### Custom JavaScript Execution

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        javascript = """
            document.querySelector('.popup')?.remove();
            document.body.style.background = 'white';
        """.trimIndent(),
        delay = 1000
    )
)
```

### Custom CSS

```kotlin
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        css = """
            body { background: #f0f0f0 !important; }
            .ads, .banner { display: none !important; }
        """.trimIndent()
    )
)
```

### With Cookies (Authenticated Pages)

```kotlin
import dev.snapapi.Cookie

val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com/dashboard",
        cookies = listOf(
            Cookie(
                name = "session",
                value = "abc123",
                domain = "example.com"
            )
        )
    )
)
```

### HTTP Basic Authentication

```kotlin
import dev.snapapi.HttpAuth

val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com/protected",
        httpAuth = HttpAuth(
            username = "user",
            password = "pass"
        )
    )
)
```

### Element Screenshot with Clipping

```kotlin
// Capture specific element
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        selector = ".hero-section"
    )
)

// Or use manual clipping
val screenshot = client.screenshot(
    ScreenshotOptions(
        url = "https://example.com",
        clipX = 100,
        clipY = 100,
        clipWidth = 500,
        clipHeight = 300
    )
)
```

### Extract Metadata

```kotlin
import dev.snapapi.ExtractMetadata

val result = client.screenshotWithMetadata(
    ScreenshotOptions(
        url = "https://example.com",
        includeMetadata = true,
        extractMetadata = ExtractMetadata(
            fonts = true,
            colors = true,
            links = true,
            httpStatusCode = true
        )
    )
)

println("Title: ${result.metadata?.title}")
println("HTTP Status: ${result.metadata?.httpStatusCode}")
println("Fonts: ${result.metadata?.fonts}")
println("Colors: ${result.metadata?.colors}")
println("Links: ${result.metadata?.links}")
```

### Get Screenshot with Metadata

```kotlin
val result = client.screenshotWithMetadata(
    ScreenshotOptions(
        url = "https://example.com",
        includeMetadata = true
    )
)

println("Width: ${result.width}")
println("Height: ${result.height}")
println("File Size: ${result.fileSize}")
println("Duration: ${result.took}ms")
println("Cached: ${result.cached}")
// result.data contains base64 encoded image
```

### Batch Screenshots

```kotlin
import dev.snapapi.BatchOptions

val batch = client.batch(
    BatchOptions(
        urls = listOf(
            "https://example.com",
            "https://example.org",
            "https://example.net"
        ),
        format = "png",
        webhookUrl = "https://your-server.com/webhook"
    )
)

println("Job ID: ${batch.jobId}")

// Check status later
val status = client.getBatchStatus(batch.jobId)
if (status.status == "completed") {
    status.results?.forEach { result ->
        println("${result.url}: ${result.status}")
    }
}
```

### Get API Capabilities

```kotlin
val capabilities = client.getCapabilities()
println("API Version: ${capabilities.version}")
```

### Get API Usage

```kotlin
val usage = client.getUsage()
println("Used: ${usage.used}")
println("Limit: ${usage.limit}")
println("Remaining: ${usage.remaining}")
println("Resets at: ${usage.resetAt}")
```

## Android Usage

### Add Internet Permission

Add to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Use with Coroutines

```kotlin
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.launch

class ScreenshotViewModel : ViewModel() {
    private val client = SnapAPI("sk_live_xxx")

    fun captureScreenshot(url: String) {
        viewModelScope.launch {
            try {
                val screenshot = client.screenshot(
                    ScreenshotOptions(url = url)
                )
                // Handle screenshot bytes
            } catch (e: SnapAPIException) {
                // Handle error
            }
        }
    }
}
```

### Use with Jetpack Compose

```kotlin
@Composable
fun ScreenshotScreen() {
    var bitmap by remember { mutableStateOf<Bitmap?>(null) }
    val scope = rememberCoroutineScope()
    val client = remember { SnapAPI("sk_live_xxx") }

    LaunchedEffect(Unit) {
        scope.launch {
            try {
                val bytes = client.screenshot(
                    ScreenshotOptions(url = "https://example.com")
                )
                bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
            } catch (e: SnapAPIException) {
                // Handle error
            }
        }
    }

    bitmap?.let {
        Image(
            bitmap = it.asImageBitmap(),
            contentDescription = "Screenshot"
        )
    }
}
```

## Configuration Options

### Client Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `apiKey` | String | *required* | Your API key |
| `baseUrl` | String | `https://api.snapapi.pics` | API base URL |
| `timeout` | Int | `60000` | Request timeout in ms |

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
| `isMobile` | Boolean? | `false` | Emulate mobile device |
| `hasTouch` | Boolean? | `false` | Enable touch events |
| `isLandscape` | Boolean? | `false` | Landscape orientation |
| `fullPage` | Boolean? | `false` | Capture full scrollable page |
| `fullPageScrollDelay` | Int? | `400` | Delay between scroll steps (ms) |
| `fullPageMaxHeight` | Int? | - | Max height for full page (px) |
| `selector` | String? | - | CSS selector for element capture |
| `clipX`, `clipY` | Int? | - | Clip region position |
| `clipWidth`, `clipHeight` | Int? | - | Clip region size |
| `delay` | Int? | `0` | Delay before capture (0-30000ms) |
| `timeout` | Int? | `30000` | Max wait time (1000-60000ms) |
| `waitUntil` | String? | `"load"` | `"load"`, `"domcontentloaded"`, `"networkidle"` |
| `waitForSelector` | String? | - | Wait for element before capture |
| `darkMode` | Boolean? | `false` | Emulate dark mode |
| `reducedMotion` | Boolean? | `false` | Reduce animations |
| `css` | String? | - | Custom CSS to inject |
| `javascript` | String? | - | JS to execute before capture |
| `hideSelectors` | List<String>? | - | CSS selectors to hide |
| `clickSelector` | String? | - | Element to click before capture |
| `clickDelay` | Int? | - | Delay after click (ms) |
| `blockAds` | Boolean? | `false` | Block ads |
| `blockTrackers` | Boolean? | `false` | Block trackers |
| `blockCookieBanners` | Boolean? | `false` | Hide cookie banners |
| `blockChatWidgets` | Boolean? | `false` | Block chat widgets |
| `blockResources` | List<String>? | - | Resource types to block |
| `userAgent` | String? | - | Custom User-Agent |
| `extraHeaders` | Map<String, String>? | - | Custom HTTP headers |
| `cookies` | List<Cookie>? | - | Cookies to set |
| `httpAuth` | HttpAuth? | - | HTTP basic auth credentials |
| `proxy` | ProxyConfig? | - | Proxy configuration |
| `geolocation` | Geolocation? | - | Geolocation coordinates |
| `timezone` | String? | - | Timezone (e.g., "America/New_York") |
| `locale` | String? | - | Locale (e.g., "en-US") |
| `pdfOptions` | PdfOptions? | - | PDF generation options |
| `thumbnail` | ThumbnailOptions? | - | Thumbnail generation options |
| `failOnHttpError` | Boolean? | `false` | Fail on 4xx/5xx responses |
| `cache` | Boolean? | `false` | Enable caching |
| `cacheTtl` | Int? | `86400` | Cache TTL in seconds |
| `responseType` | String? | `"binary"` | `"binary"`, `"base64"`, `"json"` |
| `includeMetadata` | Boolean? | `false` | Include page metadata |
| `extractMetadata` | ExtractMetadata? | - | Additional metadata to extract |

## Error Handling

```kotlin
import dev.snapapi.SnapAPIException

try {
    val screenshot = client.screenshot(
        ScreenshotOptions(url = "invalid-url")
    )
} catch (e: SnapAPIException) {
    println("Code: ${e.code}")           // "INVALID_URL"
    println("Status: ${e.statusCode}")   // 400
    println("Message: ${e.message}")     // "The provided URL is not valid"
    println("Details: ${e.details}")     // {url=invalid-url}

    // Check if error is retryable
    if (e.isRetryable()) {
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

## License

MIT
