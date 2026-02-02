package dev.snapapi

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import java.util.Base64

/**
 * SnapAPI SDK for Android/Kotlin
 *
 * Example usage:
 * ```kotlin
 * val client = SnapAPI("sk_live_xxx")
 *
 * // Capture a screenshot
 * val screenshot = client.screenshot(
 *     ScreenshotOptions(url = "https://example.com")
 * )
 *
 * // Save to file
 * File("screenshot.png").writeBytes(screenshot)
 * ```
 */
class SnapAPI(
    private val apiKey: String,
    private val baseUrl: String = DEFAULT_BASE_URL,
    private val timeout: Int = DEFAULT_TIMEOUT
) {
    companion object {
        const val DEFAULT_BASE_URL = "https://api.snapapi.pics"
        const val DEFAULT_TIMEOUT = 60000
        const val VERSION = "1.1.0"
        private const val USER_AGENT = "snapapi-kotlin/$VERSION"
    }

    private val json = Json {
        ignoreUnknownKeys = true
        encodeDefaults = false
        explicitNulls = false
    }

    init {
        require(apiKey.isNotBlank()) { "API key is required" }
    }

    /**
     * Capture a screenshot of the specified URL or HTML content.
     *
     * @param options Screenshot options
     * @return Raw image bytes
     */
    suspend fun screenshot(options: ScreenshotOptions): ByteArray {
        require(options.url != null || options.html != null) {
            "Either url or html is required"
        }

        return doRequest("POST", "/v1/screenshot", options)
    }

    /**
     * Capture a screenshot and return metadata.
     *
     * @param options Screenshot options (responseType will be set to json)
     * @return Screenshot result with metadata
     */
    suspend fun screenshotWithMetadata(options: ScreenshotOptions): ScreenshotResult {
        val opts = options.copy(responseType = "json")
        val response = doRequest("POST", "/v1/screenshot", opts)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Capture a screenshot from HTML content.
     *
     * @param html HTML content to render
     * @param options Additional screenshot options
     * @return Raw image bytes
     */
    suspend fun screenshotFromHtml(html: String, options: ScreenshotOptions? = null): ByteArray {
        val opts = options?.copy(html = html, url = null)
            ?: ScreenshotOptions(html = html)
        return screenshot(opts)
    }

    /**
     * Capture a screenshot using a device preset.
     *
     * @param url URL to capture
     * @param device Device preset name (use DevicePresets constants)
     * @param options Additional screenshot options
     * @return Raw image bytes
     */
    suspend fun screenshotDevice(
        url: String,
        device: String,
        options: ScreenshotOptions? = null
    ): ByteArray {
        val opts = options?.copy(url = url, device = device)
            ?: ScreenshotOptions(url = url, device = device)
        return screenshot(opts)
    }

    /**
     * Generate a PDF from a URL or HTML content.
     *
     * @param options Screenshot options (format will be set to pdf)
     * @return Raw PDF bytes
     */
    suspend fun pdf(options: ScreenshotOptions): ByteArray {
        require(options.url != null || options.html != null) {
            "Either url or html is required"
        }

        val opts = options.copy(format = "pdf", responseType = "binary")
        return doRequest("POST", "/v1/screenshot", opts)
    }

    /**
     * Generate a PDF from HTML content.
     *
     * @param html HTML content to render
     * @param pdfOptions PDF generation options
     * @return Raw PDF bytes
     */
    suspend fun pdfFromHtml(html: String, pdfOptions: PdfOptions? = null): ByteArray {
        return pdf(ScreenshotOptions(
            html = html,
            format = "pdf",
            pdfOptions = pdfOptions
        ))
    }

    /**
     * Capture a video of a webpage with optional scroll animation.
     *
     * @param options Video options
     * @return Raw video bytes
     */
    suspend fun video(options: VideoOptions): ByteArray {
        return doRequest("POST", "/v1/video", options)
    }

    /**
     * Capture a video and return structured result with metadata.
     *
     * @param options Video options
     * @return Video result with metadata
     */
    suspend fun videoWithResult(options: VideoOptions): VideoResult {
        val opts = options.copy(responseType = "json")
        val response = doRequest("POST", "/v1/video", opts)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Capture screenshots of multiple URLs.
     *
     * @param options Batch options
     * @return Batch result with job ID
     */
    suspend fun batch(options: BatchOptions): BatchResult {
        require(options.urls.isNotEmpty()) { "URLs are required" }

        val response = doRequest("POST", "/v1/screenshot/batch", options)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Check the status of a batch job.
     *
     * @param jobId The batch job ID
     * @return Batch status with results if completed
     */
    suspend fun getBatchStatus(jobId: String): BatchStatus {
        val response = doRequest("GET", "/v1/screenshot/batch/$jobId", null)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Get available device presets.
     *
     * @return Devices result with presets grouped by category
     */
    suspend fun getDevices(): DevicesResult {
        val response = doRequest("GET", "/v1/devices", null)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Get API capabilities and features.
     *
     * @return Capabilities result
     */
    suspend fun getCapabilities(): CapabilitiesResult {
        val response = doRequest("GET", "/v1/capabilities", null)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Get API usage statistics.
     *
     * @return Usage result with limits and remaining quota
     */
    suspend fun getUsage(): UsageResult {
        val response = doRequest("GET", "/v1/usage", null)
        return json.decodeFromString(response.decodeToString())
    }

    /**
     * Perform an HTTP request to the API.
     */

    // Extract API
    
    /**
     * Extract content from a webpage.
     */
    suspend fun extract(options: ExtractOptions): ExtractResult {
        require(options.url.isNotBlank()) { "URL is required" }
        
        val response = doRequest("POST", "/v1/extract", options)
        return json.decodeFromString(response.decodeToString())
    }
    
    /**
     * Extract markdown from a webpage.
     */
    suspend fun extractMarkdown(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.markdown))
    }
    
    /**
     * Extract article content from a webpage.
     */
    suspend fun extractArticle(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.article))
    }
    
    /**
     * Extract structured data for LLM/RAG workflows.
     */
    suspend fun extractStructured(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.structured))
    }
    
    /**
     * Extract plain text from a webpage.
     */
    suspend fun extractText(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.text))
    }
    
    /**
     * Extract all links from a webpage.
     */
    suspend fun extractLinks(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.links))
    }
    
    /**
     * Extract all images from a webpage.
     */
    suspend fun extractImages(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.images))
    }
    
    /**
     * Extract page metadata from a webpage.
     */
    suspend fun extractMetadata(url: String): ExtractResult {
        return extract(ExtractOptions(url = url, type = ExtractType.metadata))
    }

    private suspend fun <T> doRequest(method: String, path: String, body: T?): ByteArray {
        return withContext(Dispatchers.IO) {
            val url = URL("$baseUrl$path")
            val connection = url.openConnection() as HttpURLConnection

            try {
                connection.requestMethod = method
                connection.connectTimeout = timeout
                connection.readTimeout = timeout
                connection.setRequestProperty("X-Api-Key", apiKey)
                connection.setRequestProperty("Content-Type", "application/json")
                connection.setRequestProperty("User-Agent", USER_AGENT)

                if (body != null) {
                    connection.doOutput = true
                    val jsonBody = json.encodeToString(body)
                    connection.outputStream.use { it.write(jsonBody.toByteArray()) }
                }

                val responseCode = connection.responseCode

                if (responseCode >= 400) {
                    val errorBody = connection.errorStream?.use { it.readBytes() }
                        ?: ByteArray(0)
                    handleError(errorBody, responseCode)
                }

                connection.inputStream.use { it.readBytes() }
            } finally {
                connection.disconnect()
            }
        }
    }

    /**
     * Parse and throw a SnapAPIException from an HTTP error.
     */
    private fun handleError(body: ByteArray, statusCode: Int): Nothing {
        try {
            val errorResponse: ErrorResponse = json.decodeFromString(body.decodeToString())
            throw SnapAPIException(
                message = errorResponse.error.message,
                code = errorResponse.error.code,
                statusCode = statusCode,
                details = errorResponse.error.details
            )
        } catch (e: Exception) {
            if (e is SnapAPIException) throw e
            throw SnapAPIException(
                message = "HTTP $statusCode",
                code = "HTTP_ERROR",
                statusCode = statusCode
            )
        }
    }
}

/**
 * Exception thrown by SnapAPI operations.
 */
class SnapAPIException(
    message: String,
    val code: String,
    val statusCode: Int,
    val details: Map<String, kotlinx.serialization.json.JsonElement>? = null
) : Exception("[$code] $message (HTTP $statusCode)") {

    /**
     * Check if the error is retryable.
     */
    fun isRetryable(): Boolean {
        return code == "RATE_LIMITED" || code == "TIMEOUT" || statusCode >= 500
    }
}

/**
 * Extension function to decode base64 string to ByteArray.
 */
fun String.decodeBase64(): ByteArray = Base64.getDecoder().decode(this)

/**
 * Extension function to encode ByteArray to base64 string.
 */
fun ByteArray.encodeBase64(): String = Base64.getEncoder().encodeToString(this)
