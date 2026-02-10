package dev.snapapi

import kotlinx.coroutines.runBlocking
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertTrue

class SnapAPITest {

    private val apiKey = System.getenv("SNAPAPI_API_KEY") ?: "test_key_not_set"
    private val client = SnapAPI(apiKey)

    // --- Error Handling Tests ---

    @Test
    fun `test invalid API key returns proper error`() {
        val badClient = SnapAPI("invalid_key_12345")
        val exception = assertThrows<SnapAPIException> {
            runBlocking {
                badClient.screenshot(ScreenshotOptions(url = "https://example.com"))
            }
        }
        println("[TEST] Invalid API key error: code=${exception.code}, statusCode=${exception.statusCode}, message=${exception.message}")
        assertEquals(401, exception.statusCode)
        assertEquals("Unauthorized", exception.code)
        assertTrue(exception.message!!.contains("API key"))
    }

    @Test
    fun `test validation error with missing url returns proper error`() {
        val exception = assertThrows<SnapAPIException> {
            runBlocking {
                // Send empty body to trigger validation error
                client.screenshotWithMetadata(ScreenshotOptions())
            }
        }
        println("[TEST] Validation error: code=${exception.code}, statusCode=${exception.statusCode}, message=${exception.message}, details=${exception.details}")
        assertEquals(400, exception.statusCode)
        // The error field should be a string like "Validation Error"
        assertTrue(exception.code.isNotBlank(), "Error code should not be blank")
        assertNotNull(exception.details, "Validation errors should have details")
        assertTrue(exception.details!!.isNotEmpty(), "Details should not be empty")
    }

    // --- Screenshot Tests ---

    @Test
    fun `test basic screenshot returns image bytes`() {
        val bytes = runBlocking {
            client.screenshot(ScreenshotOptions(url = "https://example.com", format = "png"))
        }
        println("[TEST] Screenshot size: ${bytes.size} bytes")
        assertTrue(bytes.size > 1000, "Screenshot should be more than 1000 bytes")
        // PNG magic bytes: 0x89 0x50 0x4E 0x47
        assertEquals(0x89.toByte(), bytes[0], "Should start with PNG magic byte")
        assertEquals(0x50.toByte(), bytes[1], "Second byte should be 'P'")
    }

    @Test
    fun `test screenshot with jpeg format`() {
        val bytes = runBlocking {
            client.screenshot(ScreenshotOptions(url = "https://example.com", format = "jpeg", quality = 80))
        }
        println("[TEST] JPEG screenshot size: ${bytes.size} bytes")
        assertTrue(bytes.size > 1000)
        // JPEG magic bytes: 0xFF 0xD8
        assertEquals(0xFF.toByte(), bytes[0], "Should start with JPEG magic byte")
        assertEquals(0xD8.toByte(), bytes[1], "Second byte should be 0xD8")
    }

    @Test
    fun `test screenshot with webp format`() {
        val bytes = runBlocking {
            client.screenshot(ScreenshotOptions(url = "https://example.com", format = "webp"))
        }
        println("[TEST] WebP screenshot size: ${bytes.size} bytes")
        assertTrue(bytes.size > 100)
        // WebP magic: RIFF....WEBP
        val header = bytes.take(4).toByteArray().decodeToString()
        assertEquals("RIFF", header, "Should start with RIFF header")
    }

    @Test
    fun `test screenshot with metadata returns structured result`() {
        val result = runBlocking {
            client.screenshotWithMetadata(ScreenshotOptions(url = "https://example.com", includeMetadata = true))
        }
        println("[TEST] Metadata result: success=${result.success}, width=${result.width}, height=${result.height}, format=${result.format}, took=${result.took}ms")
        assertTrue(result.success)
        assertTrue(result.width > 0)
        assertTrue(result.height > 0)
        assertTrue(result.data.isNotBlank())
        assertTrue(result.took > 0)
    }

    @Test
    fun `test screenshot from HTML`() {
        val html = "<html><body><h1>Hello from Kotlin SDK Test</h1></body></html>"
        val bytes = runBlocking {
            client.screenshotFromHtml(html)
        }
        println("[TEST] HTML screenshot size: ${bytes.size} bytes")
        assertTrue(bytes.size > 1000)
    }

    @Test
    fun `test screenshot with device preset`() {
        val bytes = runBlocking {
            client.screenshotDevice("https://example.com", DevicePresets.IPHONE_15_PRO)
        }
        println("[TEST] Device preset screenshot size: ${bytes.size} bytes")
        assertTrue(bytes.size > 1000)
    }

    // --- Usage Test ---

    @Test
    fun `test get usage returns valid data`() {
        val usage = runBlocking {
            client.getUsage()
        }
        println("[TEST] Usage: used=${usage.used}, limit=${usage.limit}, remaining=${usage.remaining}, resetAt=${usage.resetAt}")
        assertTrue(usage.limit > 0, "Limit should be positive")
        assertTrue(usage.remaining >= 0, "Remaining should be non-negative")
    }

    // --- API Key Validation ---

    @Test
    fun `test empty API key throws IllegalArgumentException`() {
        assertThrows<IllegalArgumentException> {
            SnapAPI("")
        }
    }

    @Test
    fun `test blank API key throws IllegalArgumentException`() {
        assertThrows<IllegalArgumentException> {
            SnapAPI("   ")
        }
    }

    // --- Base URL Check ---

    @Test
    fun `test default base URL is correct`() {
        assertEquals("https://api.snapapi.pics", SnapAPI.DEFAULT_BASE_URL)
    }
}
