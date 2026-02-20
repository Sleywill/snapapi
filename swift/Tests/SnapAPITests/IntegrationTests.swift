import XCTest
@testable import SnapAPI

/// Integration tests against the live SnapAPI at https://api.snapapi.pics
final class IntegrationTests: XCTestCase {
    let apiKey: String = {
        guard let key = ProcessInfo.processInfo.environment["SNAPAPI_API_KEY"], !key.isEmpty else {
            fatalError("Set SNAPAPI_API_KEY environment variable to run integration tests")
        }
        return key
    }()

    lazy var client = SnapAPI(apiKey: apiKey, timeout: 120)

    /// Helper: run test body, skip gracefully if quota/plan limited
    func withQuotaHandling(_ body: () async throws -> Void, file: StaticString = #file, line: UInt = #line) async throws {
        do {
            try await body()
        } catch let error as SnapAPIError where error.code == "QUOTA_EXCEEDED" || error.code == "TOO_MANY_REQUESTS" {
            print("⚠️ Skipped: \(error.message)")
        } catch let error as SnapAPIError where error.code == "FORBIDDEN" {
            print("⚠️ Skipped: \(error.message)")
        }
    }

    // MARK: - 1. Ping
    func testPing() async throws {
        let result = try await client.ping()
        XCTAssertEqual(result.status, "ok")
        XCTAssertGreaterThan(result.timestamp, 0)
        print("✅ ping: status=\(result.status)")
    }

    // MARK: - 2. Usage
    func testGetUsage() async throws {
        try await withQuotaHandling {
            let usage = try await self.client.getUsage()
            XCTAssertGreaterThanOrEqual(usage.limit, 0)
            XCTAssertGreaterThanOrEqual(usage.used, 0)
            XCTAssertFalse(usage.resetAt.isEmpty)
            print("✅ usage: \(usage.used)/\(usage.limit)")
        }
    }

    // MARK: - 3. Devices
    func testGetDevices() async throws {
        let result = try await client.getDevices()
        XCTAssertTrue(result.success)
        XCTAssertGreaterThan(result.total, 0)
        print("✅ devices: \(result.total)")
    }

    // MARK: - 4. Capabilities
    func testGetCapabilities() async throws {
        let result = try await client.getCapabilities()
        XCTAssertTrue(result.success)
        XCTAssertFalse(result.version.isEmpty)
        print("✅ capabilities: v\(result.version)")
    }

    // MARK: - 5. Screenshot PNG
    func testScreenshotPNG() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", format: "png", width: 800, height: 600)
            )
            XCTAssertGreaterThan(data.count, 1000)
            XCTAssertEqual(data[0], 0x89)
            print("✅ screenshot PNG: \(data.count) bytes")
        }
    }

    // MARK: - 6. Screenshot JPEG
    func testScreenshotJPEG() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", format: "jpeg", quality: 80, width: 800, height: 600)
            )
            XCTAssertGreaterThan(data.count, 1000)
            XCTAssertEqual(data[0], 0xFF)
            XCTAssertEqual(data[1], 0xD8)
            print("✅ screenshot JPEG: \(data.count) bytes")
        }
    }

    // MARK: - 7. Screenshot WebP
    func testScreenshotWebP() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", format: "webp", width: 800, height: 600)
            )
            XCTAssertGreaterThan(data.count, 100)
            XCTAssertEqual(data[0], 0x52) // RIFF
            print("✅ screenshot WebP: \(data.count) bytes")
        }
    }

    // MARK: - 8. Screenshot from HTML
    func testScreenshotFromHtml() async throws {
        try await withQuotaHandling {
            let html = "<html><body style='background:#1a1a2e;color:#e94560;'><h1>SnapAPI Swift Test</h1></body></html>"
            let data = try await self.client.screenshotFromHtml(html, options: ScreenshotOptions(format: "png", width: 800, height: 600))
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot from HTML: \(data.count) bytes")
        }
    }

    // MARK: - 9. Screenshot from Markdown
    func testScreenshotFromMarkdown() async throws {
        try await withQuotaHandling {
            let md = "# Hello from SnapAPI\n\nThis is a **Swift SDK** test."
            let data = try await self.client.screenshotFromMarkdown(md, options: ScreenshotOptions(format: "png", width: 800, height: 600))
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot from Markdown: \(data.count) bytes")
        }
    }

    // MARK: - 10. Screenshot with metadata
    func testScreenshotWithMetadata() async throws {
        try await withQuotaHandling {
            let result = try await self.client.screenshotWithMetadata(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600, includeMetadata: true)
            )
            XCTAssertTrue(result.success)
            XCTAssertGreaterThan(result.width, 0)
            XCTAssertNotNil(result.imageData)
            print("✅ screenshot with metadata: \(result.width)x\(result.height)")
        }
    }

    // MARK: - 11. Screenshot with device preset
    func testScreenshotDevice() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshotDevice(url: "https://example.com", device: .iPhone15Pro)
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot device: \(data.count) bytes")
        }
    }

    // MARK: - 12. Screenshot full page
    func testScreenshotFullPage() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", width: 800, fullPage: true)
            )
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot full page: \(data.count) bytes")
        }
    }

    // MARK: - 13. Screenshot dark mode
    func testScreenshotDarkMode() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600, darkMode: true)
            )
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot dark mode: \(data.count) bytes")
        }
    }

    // MARK: - 14. Screenshot custom CSS/JS (requires Starter plan)
    func testScreenshotCustomCssJs() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600,
                    css: "body { background: red !important; }",
                    javascript: "document.title = 'Modified';")
            )
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot custom CSS/JS: \(data.count) bytes")
        }
    }

    // MARK: - 15. Screenshot blocking (requires Starter plan)
    func testScreenshotBlocking() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600,
                    blockAds: true, blockTrackers: true, blockCookieBanners: true, blockChatWidgets: true)
            )
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot with blocking: \(data.count) bytes")
        }
    }

    // MARK: - 16. Screenshot selector
    func testScreenshotSelector() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", selector: "h1")
            )
            XCTAssertGreaterThan(data.count, 100)
            print("✅ screenshot selector: \(data.count) bytes")
        }
    }

    // MARK: - 17. Screenshot delay & waitForSelector
    func testScreenshotDelayAndWait() async throws {
        try await withQuotaHandling {
            let data = try await self.client.screenshot(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600, delay: 1000, waitForSelector: "h1")
            )
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ screenshot delay+waitForSelector: \(data.count) bytes")
        }
    }

    // MARK: - 18. PDF (dedicated endpoint)
    func testPdf() async throws {
        try await withQuotaHandling {
            let data = try await self.client.pdf(ScreenshotOptions(url: "https://example.com"))
            XCTAssertGreaterThan(data.count, 1000)
            let header = String(data: data.prefix(4), encoding: .ascii)
            XCTAssertEqual(header, "%PDF")
            print("✅ PDF: \(data.count) bytes")
        }
    }

    // MARK: - 19. PDF from HTML
    func testPdfFromHtml() async throws {
        try await withQuotaHandling {
            let data = try await self.client.pdfFromHtml("<h1>Hello PDF</h1>", pdfOptions: PdfOptions(landscape: true))
            XCTAssertGreaterThan(data.count, 1000)
            let header = String(data: data.prefix(4), encoding: .ascii)
            XCTAssertEqual(header, "%PDF")
            print("✅ PDF from HTML: \(data.count) bytes")
        }
    }

    // MARK: - 20. Video
    func testVideo() async throws {
        try await withQuotaHandling {
            let data = try await self.client.video(VideoOptions(
                url: "https://example.com", width: 640, height: 480, duration: 3, fps: 12
            ))
            XCTAssertGreaterThan(data.count, 1000)
            print("✅ video: \(data.count) bytes")
        }
    }

    // MARK: - 21. Batch screenshot
    func testBatch() async throws {
        try await withQuotaHandling {
            let result = try await self.client.batch(BatchOptions(
                urls: ["https://example.com", "https://httpbin.org/html"],
                format: "png", width: 800, height: 600
            ))
            XCTAssertTrue(result.success)
            XCTAssertFalse(result.jobId.isEmpty)
            XCTAssertEqual(result.total, 2)
            print("✅ batch: jobId=\(result.jobId)")
        }
    }

    // MARK: - 22. Batch status polling
    func testBatchStatusPolling() async throws {
        try await withQuotaHandling {
            let result = try await self.client.batch(BatchOptions(
                urls: ["https://example.com"], format: "png", width: 800, height: 600
            ))
            var status: BatchStatus?
            for _ in 0..<30 {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                status = try await self.client.getBatchStatus(result.jobId)
                if status?.status == "completed" || status?.status == "failed" { break }
            }
            XCTAssertEqual(status?.status, "completed")
            print("✅ batch polling: completed")
        }
    }

    // MARK: - 23. Async screenshot
    func testAsyncScreenshot() async throws {
        try await withQuotaHandling {
            let job = try await self.client.screenshotAsync(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600)
            )
            XCTAssertTrue(job.success)
            XCTAssertTrue(job.async)
            XCTAssertFalse(job.jobId.isEmpty)
            XCTAssertEqual(job.status, "pending")
            print("✅ async screenshot: jobId=\(job.jobId)")
        }
    }

    // MARK: - 24. Async screenshot polling
    func testAsyncScreenshotPolling() async throws {
        try await withQuotaHandling {
            let job = try await self.client.screenshotAsync(
                ScreenshotOptions(url: "https://example.com", width: 800, height: 600)
            )
            var status: AsyncStatusResult?
            for _ in 0..<30 {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                status = try await self.client.getAsyncStatus(job.jobId)
                if status?.status == "completed" || status?.status == "failed" { break }
            }
            XCTAssertEqual(status?.status, "completed")
            XCTAssertGreaterThan(status?.fileSize ?? 0, 0)
            print("✅ async polling: completed, \(status?.fileSize ?? 0) bytes")
        }
    }

    // MARK: - 25-32. Extract endpoints
    func testExtractMarkdown() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractMarkdown("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            XCTAssertEqual(json?["type"] as? String, "markdown")
            print("✅ extract markdown")
        }
    }

    func testExtractText() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractText("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract text")
        }
    }

    func testExtractHtml() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extract(ExtractOptions(url: "https://example.com", type: .html))
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract html")
        }
    }

    func testExtractArticle() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractArticle("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract article")
        }
    }

    func testExtractLinks() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractLinks("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract links")
        }
    }

    func testExtractImages() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractImages("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract images")
        }
    }

    func testExtractMetadata() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractMetadata("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract metadata")
        }
    }

    func testExtractStructured() async throws {
        try await withQuotaHandling {
            let data = try await self.client.extractStructured("https://example.com")
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            XCTAssertEqual(json?["success"] as? Bool, true)
            print("✅ extract structured")
        }
    }

    // MARK: - 33. Error handling
    func testInvalidApiKeyError() async throws {
        let badClient = SnapAPI(apiKey: "sk_live_INVALID_KEY_12345")
        do {
            _ = try await badClient.screenshot(ScreenshotOptions(url: "https://example.com"))
            XCTFail("Expected error")
        } catch let error as SnapAPIError {
            XCTAssertEqual(error.statusCode, 401)
            XCTAssertEqual(error.code, "UNAUTHORIZED")
            print("✅ error handling: \(error.code)")
        }
    }

    // MARK: - 34. Error isRetryable
    func testErrorIsRetryable() {
        XCTAssertTrue(SnapAPIError(code: "RATE_LIMITED", message: "", statusCode: 429).isRetryable)
        XCTAssertFalse(SnapAPIError(code: "UNAUTHORIZED", message: "", statusCode: 401).isRetryable)
        print("✅ isRetryable")
    }

    // MARK: - 35. FlatErrorResponse parsing
    func testFlatErrorResponseParsing() throws {
        let json = "{\"statusCode\": 401, \"error\": \"Unauthorized\", \"message\": \"Invalid API key.\"}".data(using: .utf8)!
        let decoded = try JSONDecoder().decode(FlatErrorResponse.self, from: json)
        XCTAssertEqual(decoded.error, "Unauthorized")
        print("✅ FlatErrorResponse parsing")
    }
}
