package dev.snapapi

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/**
 * Device preset names for common devices.
 */
object DevicePresets {
    // Desktop
    const val DESKTOP_1080P = "desktop-1080p"
    const val DESKTOP_1440P = "desktop-1440p"
    const val DESKTOP_4K = "desktop-4k"

    // Mac
    const val MACBOOK_PRO_13 = "macbook-pro-13"
    const val MACBOOK_PRO_16 = "macbook-pro-16"
    const val IMAC_24 = "imac-24"

    // iPhone
    const val IPHONE_SE = "iphone-se"
    const val IPHONE_12 = "iphone-12"
    const val IPHONE_13 = "iphone-13"
    const val IPHONE_14 = "iphone-14"
    const val IPHONE_14_PRO = "iphone-14-pro"
    const val IPHONE_15 = "iphone-15"
    const val IPHONE_15_PRO = "iphone-15-pro"
    const val IPHONE_15_PRO_MAX = "iphone-15-pro-max"

    // iPad
    const val IPAD = "ipad"
    const val IPAD_MINI = "ipad-mini"
    const val IPAD_AIR = "ipad-air"
    const val IPAD_PRO_11 = "ipad-pro-11"
    const val IPAD_PRO_12_9 = "ipad-pro-12.9"

    // Android
    const val PIXEL_7 = "pixel-7"
    const val PIXEL_8 = "pixel-8"
    const val PIXEL_8_PRO = "pixel-8-pro"
    const val SAMSUNG_GALAXY_S23 = "samsung-galaxy-s23"
    const val SAMSUNG_GALAXY_S24 = "samsung-galaxy-s24"
    const val SAMSUNG_GALAXY_TAB_S9 = "samsung-galaxy-tab-s9"
}

/**
 * Represents a browser cookie.
 */
@Serializable
data class Cookie(
    val name: String,
    val value: String,
    val domain: String? = null,
    val path: String? = null,
    val expires: Long? = null,
    val httpOnly: Boolean? = null,
    val secure: Boolean? = null,
    val sameSite: String? = null
)

/**
 * HTTP basic authentication credentials.
 */
@Serializable
data class HttpAuth(
    val username: String,
    val password: String
)

/**
 * Proxy configuration.
 */
@Serializable
data class ProxyConfig(
    val server: String,
    val username: String? = null,
    val password: String? = null,
    val bypass: List<String>? = null
)

/**
 * Geolocation coordinates.
 */
@Serializable
data class Geolocation(
    val latitude: Double,
    val longitude: Double,
    val accuracy: Double? = null
)

/**
 * PDF generation options.
 */
@Serializable
data class PdfOptions(
    val pageSize: String? = null,
    val width: String? = null,
    val height: String? = null,
    val landscape: Boolean? = null,
    val marginTop: String? = null,
    val marginRight: String? = null,
    val marginBottom: String? = null,
    val marginLeft: String? = null,
    val printBackground: Boolean? = null,
    val headerTemplate: String? = null,
    val footerTemplate: String? = null,
    val displayHeaderFooter: Boolean? = null,
    val scale: Double? = null,
    val pageRanges: String? = null,
    val preferCSSPageSize: Boolean? = null
)

/**
 * Thumbnail generation options.
 */
@Serializable
data class ThumbnailOptions(
    val enabled: Boolean = true,
    val width: Int? = null,
    val height: Int? = null,
    val fit: String? = null // "cover", "contain", "fill"
)

/**
 * Options for additional metadata extraction.
 */
@Serializable
data class ExtractMetadata(
    val fonts: Boolean? = null,
    val colors: Boolean? = null,
    val links: Boolean? = null,
    val httpStatusCode: Boolean? = null
)

/**
 * Screenshot options.
 */
@Serializable
data class ScreenshotOptions(
    val url: String? = null,
    val html: String? = null,
    val markdown: String? = null,
    val format: String? = null,
    val quality: Int? = null,
    val device: String? = null,
    val width: Int? = null,
    val height: Int? = null,
    val deviceScaleFactor: Double? = null,
    val isMobile: Boolean? = null,
    val hasTouch: Boolean? = null,
    val isLandscape: Boolean? = null,
    val fullPage: Boolean? = null,
    val fullPageScrollDelay: Int? = null,
    val fullPageMaxHeight: Int? = null,
    val selector: String? = null,
    val selectorScrollIntoView: Boolean? = null,
    val clipX: Int? = null,
    val clipY: Int? = null,
    val clipWidth: Int? = null,
    val clipHeight: Int? = null,
    val delay: Int? = null,
    val timeout: Int? = null,
    val waitUntil: String? = null,
    val waitForSelector: String? = null,
    val waitForSelectorTimeout: Int? = null,
    val darkMode: Boolean? = null,
    val reducedMotion: Boolean? = null,
    val css: String? = null,
    val javascript: String? = null,
    val hideSelectors: List<String>? = null,
    val clickSelector: String? = null,
    val clickDelay: Int? = null,
    val blockAds: Boolean? = null,
    val blockTrackers: Boolean? = null,
    val blockCookieBanners: Boolean? = null,
    val blockChatWidgets: Boolean? = null,
    val blockResources: List<String>? = null,
    val userAgent: String? = null,
    val extraHeaders: Map<String, String>? = null,
    val cookies: List<Cookie>? = null,
    val httpAuth: HttpAuth? = null,
    val proxy: ProxyConfig? = null,
    val geolocation: Geolocation? = null,
    val timezone: String? = null,
    val locale: String? = null,
    val pdfOptions: PdfOptions? = null,
    val thumbnail: ThumbnailOptions? = null,
    @SerialName("failOnHttpError")
    val failOnHttpError: Boolean? = null,
    val cache: Boolean? = null,
    @SerialName("cacheTtl")
    val cacheTtl: Int? = null,
    val responseType: String? = null,
    val includeMetadata: Boolean? = null,
    val extractMetadata: ExtractMetadata? = null,
    val failIfContentMissing: List<String>? = null,
    val failIfContentContains: List<String>? = null
)

/**
 * Scroll easing function for video capture.
 */
enum class ScrollEasing(val value: String) {
    @SerialName("linear") LINEAR("linear"),
    @SerialName("ease_in") EASE_IN("ease_in"),
    @SerialName("ease_out") EASE_OUT("ease_out"),
    @SerialName("ease_in_out") EASE_IN_OUT("ease_in_out"),
    @SerialName("ease_in_out_quint") EASE_IN_OUT_QUINT("ease_in_out_quint")
}

/**
 * Video capture options.
 */
@Serializable
data class VideoOptions(
    val url: String,
    val format: String? = "mp4",
    val quality: Int? = null,
    val width: Int? = 1280,
    val height: Int? = 720,
    val device: String? = null,
    val duration: Int? = 5000,
    val fps: Int? = 24,
    val delay: Int? = null,
    val timeout: Int? = 60000,
    val waitUntil: String? = null,
    val waitForSelector: String? = null,
    val darkMode: Boolean? = null,
    val blockAds: Boolean? = null,
    val blockCookieBanners: Boolean? = null,
    val css: String? = null,
    val javascript: String? = null,
    val hideSelectors: List<String>? = null,
    val userAgent: String? = null,
    val cookies: List<Cookie>? = null,
    val responseType: String? = null,
    val scroll: Boolean? = null,
    val scrollDelay: Int? = null,
    val scrollDuration: Int? = null,
    val scrollBy: Int? = null,
    val scrollEasing: ScrollEasing? = null,
    val scrollBack: Boolean? = null,
    val scrollComplete: Boolean? = null
)

/**
 * Video capture result.
 */
@Serializable
data class VideoResult(
    val success: Boolean,
    val data: String? = null,
    val format: String,
    val width: Int,
    val height: Int,
    val fileSize: Int,
    val duration: Int,
    val took: Int
)

/**
 * Page metadata from screenshot.
 */
@Serializable
data class ScreenshotMetadata(
    val title: String? = null,
    val description: String? = null,
    val favicon: String? = null,
    val ogTitle: String? = null,
    val ogDescription: String? = null,
    val ogImage: String? = null,
    val httpStatusCode: Int? = null,
    val fonts: List<String>? = null,
    val colors: List<String>? = null,
    val links: List<String>? = null
)

/**
 * Screenshot result with metadata.
 */
@Serializable
data class ScreenshotResult(
    val success: Boolean,
    val data: String,
    val width: Int,
    val height: Int,
    val fileSize: Int,
    val took: Int,
    val format: String,
    val cached: Boolean = false,
    val metadata: ScreenshotMetadata? = null,
    val thumbnail: String? = null
)

/**
 * Batch screenshot options.
 */
@Serializable
data class BatchOptions(
    val urls: List<String>,
    val format: String? = null,
    val quality: Int? = null,
    val width: Int? = null,
    val height: Int? = null,
    val fullPage: Boolean? = null,
    val darkMode: Boolean? = null,
    val blockAds: Boolean? = null,
    val blockCookieBanners: Boolean? = null,
    val webhookUrl: String? = null
)

/**
 * Batch job result.
 */
@Serializable
data class BatchResult(
    val success: Boolean,
    val jobId: String,
    val status: String,
    val total: Int,
    val completed: Int? = null,
    val failed: Int? = null
)

/**
 * Individual item result in a batch.
 */
@Serializable
data class BatchItemResult(
    val url: String,
    val status: String,
    val data: String? = null,
    val error: String? = null,
    val duration: Int? = null
)

/**
 * Batch job status.
 */
@Serializable
data class BatchStatus(
    val success: Boolean,
    val jobId: String,
    val status: String,
    val total: Int,
    val completed: Int,
    val failed: Int,
    val results: List<BatchItemResult>? = null,
    val createdAt: String? = null,
    val completedAt: String? = null
)

/**
 * Device information.
 */
@Serializable
data class DeviceInfo(
    val id: String,
    val name: String,
    val width: Int,
    val height: Int,
    val deviceScaleFactor: Double,
    val isMobile: Boolean
)

/**
 * Result of GetDevices.
 */
@Serializable
data class DevicesResult(
    val success: Boolean,
    val devices: Map<String, List<DeviceInfo>>,
    val total: Int
)

/**
 * Result of GetCapabilities.
 */
@Serializable
data class CapabilitiesResult(
    val success: Boolean,
    val version: String,
    val capabilities: Map<String, kotlinx.serialization.json.JsonElement>
)

/**
 * API usage statistics.
 */
@Serializable
data class UsageResult(
    val used: Int,
    val limit: Int,
    val remaining: Int,
    val resetAt: String
)

/**
 * API error response (flat format).
 * The API returns: {"statusCode": 401, "error": "Unauthorized", "message": "Invalid API key.", "details": [...]}
 */
@Serializable
data class ErrorResponse(
    val statusCode: Int,
    val error: String,
    val message: String,
    val details: List<kotlinx.serialization.json.JsonElement>? = null
)

// Extract API Types

enum class ExtractType {
    markdown, text, html, article, structured, links, images, metadata
}

@Serializable
data class ExtractOptions(
    val url: String,
    val type: ExtractType? = ExtractType.markdown,
    val selector: String? = null,
    val waitFor: String? = null,
    val timeout: Int? = null,
    val darkMode: Boolean? = null,
    val blockAds: Boolean? = null,
    val blockCookieBanners: Boolean? = null,
    val includeImages: Boolean? = null,
    val maxLength: Int? = null,
    val cleanOutput: Boolean? = null
)

@Serializable
data class ExtractResult(
    val success: Boolean,
    val type: String,
    val url: String,
    val data: kotlinx.serialization.json.JsonElement,
    val responseTime: Int
)

@Serializable
data class ExtractArticle(
    val title: String,
    val byline: String? = null,
    val content: String,
    val textContent: String? = null,
    val excerpt: String? = null,
    val siteName: String? = null,
    val publishedTime: String? = null,
    val length: Int? = null,
    val readingTime: Int? = null
)

@Serializable
data class ExtractStructured(
    val url: String,
    val title: String,
    val author: String,
    val publishedTime: String,
    val description: String,
    val image: String? = null,
    val wordCount: Int,
    val content: String
)

@Serializable
data class ExtractLink(
    val text: String,
    val href: String
)

@Serializable
data class ExtractImage(
    val src: String,
    val alt: String,
    val title: String? = null,
    val width: Int? = null,
    val height: Int? = null
)

@Serializable
data class ExtractPageMetadata(
    val title: String,
    val url: String,
    val description: String,
    val keywords: String? = null,
    val author: String? = null,
    val ogTitle: String? = null,
    val ogDescription: String? = null,
    val ogImage: String? = null,
    val canonical: String? = null,
    val favicon: String? = null
)

@Serializable
data class AnalyzeOptions(
    val url: String,
    val prompt: String,
    val provider: String? = "openai",
    val apiKey: String,
    val model: String? = null,
    val jsonSchema: kotlinx.serialization.json.JsonElement? = null,
    val timeout: Int? = null,
    val waitFor: String? = null,
    val blockAds: Boolean? = null,
    val blockCookieBanners: Boolean? = null,
    val includeScreenshot: Boolean? = null,
    val includeMetadata: Boolean? = null,
    val maxContentLength: Int? = null
)

@Serializable
data class AnalyzeResult(
    val success: Boolean,
    val url: String,
    val metadata: kotlinx.serialization.json.JsonElement? = null,
    val analysis: kotlinx.serialization.json.JsonElement,
    val provider: String,
    val model: String,
    val responseTime: Int
)
