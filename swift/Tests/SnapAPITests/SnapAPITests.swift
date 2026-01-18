import XCTest
@testable import SnapAPI

final class SnapAPITests: XCTestCase {
    func testDevicePresetsExist() {
        XCTAssertEqual(DevicePreset.iPhone15Pro.rawValue, "iphone-15-pro")
        XCTAssertEqual(DevicePreset.iPadPro129.rawValue, "ipad-pro-12.9")
        XCTAssertEqual(DevicePreset.desktop4K.rawValue, "desktop-4k")
    }

    func testScreenshotOptionsEncoding() throws {
        let options = ScreenshotOptions(
            url: "https://example.com",
            format: "png",
            width: 1920,
            height: 1080
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(options)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        XCTAssertEqual(json?["url"] as? String, "https://example.com")
        XCTAssertEqual(json?["format"] as? String, "png")
        XCTAssertEqual(json?["width"] as? Int, 1920)
        XCTAssertEqual(json?["height"] as? Int, 1080)
    }

    func testCookieEncoding() throws {
        let cookie = Cookie(
            name: "session",
            value: "abc123",
            domain: "example.com"
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(cookie)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        XCTAssertEqual(json?["name"] as? String, "session")
        XCTAssertEqual(json?["value"] as? String, "abc123")
        XCTAssertEqual(json?["domain"] as? String, "example.com")
    }

    func testSnapAPIErrorIsRetryable() {
        let rateLimited = SnapAPIError(code: "RATE_LIMITED", message: "Too many requests", statusCode: 429)
        XCTAssertTrue(rateLimited.isRetryable)

        let timeout = SnapAPIError(code: "TIMEOUT", message: "Request timed out", statusCode: 504)
        XCTAssertTrue(timeout.isRetryable)

        let serverError = SnapAPIError(code: "INTERNAL_ERROR", message: "Server error", statusCode: 500)
        XCTAssertTrue(serverError.isRetryable)

        let clientError = SnapAPIError(code: "INVALID_URL", message: "Invalid URL", statusCode: 400)
        XCTAssertFalse(clientError.isRetryable)
    }
}
