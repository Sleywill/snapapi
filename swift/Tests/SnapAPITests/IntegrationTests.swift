import XCTest
@testable import SnapAPI

/// Integration tests against the live SnapAPI at https://api.snapapi.pics
/// Uses the demo API key.
final class IntegrationTests: XCTestCase {
    let apiKey = ProcessInfo.processInfo.environment["SNAPAPI_API_KEY"] ?? "test_key_not_set"

    // MARK: - Error Parsing Tests

    /// Test that an invalid API key returns a properly parsed error with message.
    func testInvalidApiKeyError() async throws {
        let client = SnapAPI(apiKey: "sk_live_INVALID_KEY_12345")

        do {
            _ = try await client.screenshot(
                ScreenshotOptions(url: "https://example.com")
            )
            XCTFail("Expected SnapAPIError to be thrown")
        } catch let error as SnapAPIError {
            print("Error code: \(error.code)")
            print("Error message: \(error.message)")
            print("Error statusCode: \(error.statusCode)")
            // The API should return 401 with error: "Unauthorized"
            XCTAssertEqual(error.statusCode, 401)
            // After fix: code should be derived from the flat "error" field
            XCTAssertEqual(error.code, "UNAUTHORIZED")
            // The message should contain something about invalid API key
            XCTAssertTrue(error.message.lowercased().contains("invalid") || error.message.lowercased().contains("api key"),
                          "Expected message about invalid API key, got: \(error.message)")
            // Should NOT be the generic "HTTP 401" fallback
            XCTAssertNotEqual(error.code, "HTTP_ERROR", "Error parsing fell through to generic handler - bug not fixed!")
            print("PASS: Error parsing works correctly for 401 Unauthorized")
        } catch {
            XCTFail("Expected SnapAPIError, got: \(error)")
        }
    }

    /// Test validation error (missing required field).
    func testValidationError() async throws {
        let client = SnapAPI(apiKey: apiKey)

        // Send empty body by bypassing local validation - we can test with an invalid url
        do {
            _ = try await client.screenshot(
                ScreenshotOptions(url: "not-a-valid-url")
            )
            // The API might still try to capture or return an error
            print("Note: API accepted the invalid URL (might resolve or fail)")
        } catch let error as SnapAPIError {
            print("Validation error code: \(error.code)")
            print("Validation error message: \(error.message)")
            print("Validation error statusCode: \(error.statusCode)")
            // Should NOT be the generic fallback
            XCTAssertNotEqual(error.code, "HTTP_ERROR",
                              "Error parsing fell through to generic handler - bug not fixed!")
            print("PASS: Validation error parsing works correctly")
        } catch {
            XCTFail("Expected SnapAPIError, got: \(error)")
        }
    }

    // MARK: - Screenshot Tests

    /// Test basic screenshot capture.
    func testBasicScreenshot() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let data = try await client.screenshot(
            ScreenshotOptions(
                url: "https://example.com",
                format: "png",
                width: 800,
                height: 600
            )
        )

        XCTAssertGreaterThan(data.count, 1000, "Screenshot data should be substantial")
        // PNG files start with the PNG signature: 0x89504E47
        XCTAssertEqual(data[0], 0x89, "Should start with PNG signature byte 1")
        XCTAssertEqual(data[1], 0x50, "Should start with PNG signature byte 2 (P)")
        XCTAssertEqual(data[2], 0x4E, "Should start with PNG signature byte 3 (N)")
        XCTAssertEqual(data[3], 0x47, "Should start with PNG signature byte 4 (G)")
        print("PASS: Basic screenshot capture works. Size: \(data.count) bytes")
    }

    /// Test JPEG format screenshot.
    func testJpegScreenshot() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let data = try await client.screenshot(
            ScreenshotOptions(
                url: "https://example.com",
                format: "jpeg",
                quality: 80,
                width: 800,
                height: 600
            )
        )

        XCTAssertGreaterThan(data.count, 1000, "Screenshot data should be substantial")
        // JPEG files start with 0xFFD8FF
        XCTAssertEqual(data[0], 0xFF, "Should start with JPEG signature byte 1")
        XCTAssertEqual(data[1], 0xD8, "Should start with JPEG signature byte 2")
        print("PASS: JPEG screenshot capture works. Size: \(data.count) bytes")
    }

    /// Test WebP format screenshot.
    func testWebpScreenshot() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let data = try await client.screenshot(
            ScreenshotOptions(
                url: "https://example.com",
                format: "webp",
                width: 800,
                height: 600
            )
        )

        XCTAssertGreaterThan(data.count, 100, "Screenshot data should be substantial")
        // WebP starts with "RIFF" (0x52494646)
        XCTAssertEqual(data[0], 0x52, "Should start with RIFF signature (R)")
        XCTAssertEqual(data[1], 0x49, "Should start with RIFF signature (I)")
        XCTAssertEqual(data[2], 0x46, "Should start with RIFF signature (F)")
        XCTAssertEqual(data[3], 0x46, "Should start with RIFF signature (F)")
        print("PASS: WebP screenshot capture works. Size: \(data.count) bytes")
    }

    /// Test screenshot with metadata (JSON response).
    func testScreenshotWithMetadata() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let result = try await client.screenshotWithMetadata(
            ScreenshotOptions(
                url: "https://example.com",
                width: 800,
                height: 600,
                includeMetadata: true
            )
        )

        XCTAssertTrue(result.success, "Should be successful")
        XCTAssertGreaterThan(result.width, 0, "Should have width")
        XCTAssertGreaterThan(result.height, 0, "Should have height")
        XCTAssertGreaterThan(result.fileSize, 0, "Should have file size")
        XCTAssertGreaterThan(result.took, 0, "Should have timing")
        XCTAssertFalse(result.data.isEmpty, "Should have base64 data")

        // Verify image data can be decoded
        let imageData = result.imageData
        XCTAssertNotNil(imageData, "Should be able to decode base64 data")

        print("PASS: Screenshot with metadata works.")
        print("  Width: \(result.width), Height: \(result.height)")
        print("  File size: \(result.fileSize), Took: \(result.took)ms")
        print("  Format: \(result.format), Cached: \(result.cached)")
        if let meta = result.metadata {
            print("  Title: \(meta.title ?? "nil")")
        }
    }

    /// Test screenshot from HTML content.
    func testScreenshotFromHtml() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let html = """
        <html>
        <body style="display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0;background:#1a1a2e;color:#e94560;font-family:sans-serif;">
            <h1>SnapAPI Swift SDK Test</h1>
        </body>
        </html>
        """

        let data = try await client.screenshotFromHtml(
            html,
            options: ScreenshotOptions(format: "png", width: 800, height: 600)
        )

        XCTAssertGreaterThan(data.count, 1000)
        XCTAssertEqual(data[0], 0x89, "Should be PNG")
        print("PASS: HTML screenshot works. Size: \(data.count) bytes")
    }

    /// Test screenshot with dark mode.
    func testDarkModeScreenshot() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let data = try await client.screenshot(
            ScreenshotOptions(
                url: "https://example.com",
                width: 800,
                height: 600,
                darkMode: true
            )
        )

        XCTAssertGreaterThan(data.count, 1000)
        print("PASS: Dark mode screenshot works. Size: \(data.count) bytes")
    }

    /// Test full-page screenshot.
    func testFullPageScreenshot() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let data = try await client.screenshot(
            ScreenshotOptions(
                url: "https://example.com",
                width: 800,
                fullPage: true
            )
        )

        XCTAssertGreaterThan(data.count, 1000)
        print("PASS: Full page screenshot works. Size: \(data.count) bytes")
    }

    // MARK: - PDF Tests

    /// Test PDF generation.
    func testPdfGeneration() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let data = try await client.pdf(
            ScreenshotOptions(url: "https://example.com")
        )

        XCTAssertGreaterThan(data.count, 1000)
        // PDF files start with "%PDF"
        let header = String(data: data.prefix(4), encoding: .ascii)
        XCTAssertEqual(header, "%PDF", "Should start with PDF signature")
        print("PASS: PDF generation works. Size: \(data.count) bytes")
    }

    // MARK: - Usage / Info Tests

    /// Test getting API usage info.
    func testGetUsage() async throws {
        let client = SnapAPI(apiKey: apiKey)

        let usage = try await client.getUsage()
        print("Usage - Used: \(usage.used), Limit: \(usage.limit), Remaining: \(usage.remaining)")
        XCTAssertGreaterThanOrEqual(usage.limit, 0)
        XCTAssertGreaterThanOrEqual(usage.used, 0)
        print("PASS: Get usage works.")
    }

    // MARK: - Error isRetryable

    func testErrorIsRetryable() {
        let rateLimited = SnapAPIError(code: "RATE_LIMITED", message: "Too many", statusCode: 429)
        XCTAssertTrue(rateLimited.isRetryable)

        let unauthorized = SnapAPIError(code: "UNAUTHORIZED", message: "Bad key", statusCode: 401)
        XCTAssertFalse(unauthorized.isRetryable)

        print("PASS: isRetryable logic works correctly")
    }

    // MARK: - Flat Error Parsing Unit Test

    /// Unit test that directly validates FlatErrorResponse parsing.
    func testFlatErrorResponseParsing() throws {
        // Simulate the actual API response format
        let json = """
        {"statusCode": 401, "error": "Unauthorized", "message": "Invalid API key."}
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(FlatErrorResponse.self, from: json)
        XCTAssertEqual(decoded.statusCode, 401)
        XCTAssertEqual(decoded.error, "Unauthorized")
        XCTAssertEqual(decoded.message, "Invalid API key.")
        XCTAssertNil(decoded.details)
        print("PASS: FlatErrorResponse decodes correctly")
    }

    /// Unit test for validation error with details array.
    func testFlatErrorResponseWithDetails() throws {
        let json = """
        {"statusCode": 400, "error": "Validation Error", "message": "Invalid parameters", "details": ["url is required", "format must be png or jpeg"]}
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(FlatErrorResponse.self, from: json)
        XCTAssertEqual(decoded.statusCode, 400)
        XCTAssertEqual(decoded.error, "Validation Error")
        XCTAssertEqual(decoded.message, "Invalid parameters")
        XCTAssertNotNil(decoded.details)
        XCTAssertEqual(decoded.details?.count, 2)
        print("PASS: FlatErrorResponse with details decodes correctly")
    }
}
