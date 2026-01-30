import Foundation

/// SnapAPI SDK for iOS/macOS
///
/// Example usage:
/// ```swift
/// let client = SnapAPI(apiKey: "sk_live_xxx")
///
/// // Capture a screenshot
/// let screenshot = try await client.screenshot(
///     ScreenshotOptions(url: "https://example.com")
/// )
///
/// // Save to file
/// try screenshot.write(to: URL(fileURLWithPath: "screenshot.png"))
/// ```
public actor SnapAPI {
    /// SDK version
    public static let version = "1.1.1"

    /// Default base URL
    public static let defaultBaseURL = "https://api.snapapi.pics"

    /// Default timeout in seconds
    public static let defaultTimeout: TimeInterval = 60

    private let apiKey: String
    private let baseURL: String
    private let session: URLSession

    /// Initialize the SnapAPI client.
    ///
    /// - Parameters:
    ///   - apiKey: Your SnapAPI API key
    ///   - baseURL: Optional custom base URL
    ///   - timeout: Request timeout in seconds (default: 60)
    public init(
        apiKey: String,
        baseURL: String = defaultBaseURL,
        timeout: TimeInterval = defaultTimeout
    ) {
        precondition(!apiKey.isEmpty, "API key is required")

        self.apiKey = apiKey
        self.baseURL = baseURL.trimmingCharacters(in: CharacterSet(charactersIn: "/"))

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        self.session = URLSession(configuration: config)
    }

    // MARK: - Screenshot Methods

    /// Capture a screenshot of the specified URL or HTML content.
    ///
    /// - Parameter options: Screenshot options
    /// - Returns: Raw image data
    public func screenshot(_ options: ScreenshotOptions) async throws -> Data {
        guard options.url != nil || options.html != nil else {
            throw SnapAPIError(
                code: "INVALID_PARAMS",
                message: "Either url or html is required",
                statusCode: 400
            )
        }

        return try await doRequest("POST", path: "/v1/screenshot", body: options)
    }

    /// Capture a screenshot and return metadata.
    ///
    /// - Parameter options: Screenshot options (responseType will be set to json)
    /// - Returns: Screenshot result with metadata
    public func screenshotWithMetadata(_ options: ScreenshotOptions) async throws -> ScreenshotResult {
        var opts = options
        opts.responseType = "json"

        let data = try await screenshot(opts)
        return try JSONDecoder().decode(ScreenshotResult.self, from: data)
    }

    /// Capture a screenshot from HTML content.
    ///
    /// - Parameters:
    ///   - html: HTML content to render
    ///   - options: Additional screenshot options
    /// - Returns: Raw image data
    public func screenshotFromHtml(_ html: String, options: ScreenshotOptions? = nil) async throws -> Data {
        var opts = options ?? ScreenshotOptions()
        opts.html = html
        opts.url = nil
        return try await screenshot(opts)
    }

    /// Capture a screenshot using a device preset.
    ///
    /// - Parameters:
    ///   - url: URL to capture
    ///   - device: Device preset
    ///   - options: Additional screenshot options
    /// - Returns: Raw image data
    public func screenshotDevice(
        url: String,
        device: DevicePreset,
        options: ScreenshotOptions? = nil
    ) async throws -> Data {
        var opts = options ?? ScreenshotOptions()
        opts.url = url
        opts.device = device.rawValue
        return try await screenshot(opts)
    }

    // MARK: - PDF Methods

    /// Generate a PDF from a URL or HTML content.
    ///
    /// - Parameter options: Screenshot options (format will be set to pdf)
    /// - Returns: Raw PDF data
    public func pdf(_ options: ScreenshotOptions) async throws -> Data {
        guard options.url != nil || options.html != nil else {
            throw SnapAPIError(
                code: "INVALID_PARAMS",
                message: "Either url or html is required",
                statusCode: 400
            )
        }

        var opts = options
        opts.format = "pdf"
        opts.responseType = "binary"
        return try await doRequest("POST", path: "/v1/screenshot", body: opts)
    }

    /// Generate a PDF from HTML content.
    ///
    /// - Parameters:
    ///   - html: HTML content to render
    ///   - pdfOptions: PDF generation options
    /// - Returns: Raw PDF data
    public func pdfFromHtml(_ html: String, pdfOptions: PdfOptions? = nil) async throws -> Data {
        return try await pdf(ScreenshotOptions(
            html: html,
            format: "pdf",
            pdfOptions: pdfOptions
        ))
    }

    // MARK: - Video Methods

    /// Capture a video of a webpage with optional scroll animation.
    ///
    /// - Parameter options: Video options
    /// - Returns: Raw video data
    public func video(_ options: VideoOptions) async throws -> Data {
        return try await doRequest("POST", path: "/v1/video", body: options)
    }

    /// Capture a video and return structured result with metadata.
    ///
    /// - Parameter options: Video options
    /// - Returns: Video result with metadata
    public func videoWithResult(_ options: VideoOptions) async throws -> VideoResult {
        var opts = options
        opts.responseType = "json"
        let data = try await doRequest("POST", path: "/v1/video", body: opts)
        return try JSONDecoder().decode(VideoResult.self, from: data)
    }

    // MARK: - Batch Methods

    /// Capture screenshots of multiple URLs.
    ///
    /// - Parameter options: Batch options
    /// - Returns: Batch result with job ID
    public func batch(_ options: BatchOptions) async throws -> BatchResult {
        guard !options.urls.isEmpty else {
            throw SnapAPIError(
                code: "INVALID_PARAMS",
                message: "URLs are required",
                statusCode: 400
            )
        }

        let data = try await doRequest("POST", path: "/v1/screenshot/batch", body: options)
        return try JSONDecoder().decode(BatchResult.self, from: data)
    }

    /// Check the status of a batch job.
    ///
    /// - Parameter jobId: The batch job ID
    /// - Returns: Batch status with results if completed
    public func getBatchStatus(_ jobId: String) async throws -> BatchStatus {
        let data: Data = try await doRequest("GET", path: "/v1/screenshot/batch/\(jobId)", body: nil as Empty?)
        return try JSONDecoder().decode(BatchStatus.self, from: data)
    }

    // MARK: - Info Methods

    /// Get available device presets.
    ///
    /// - Returns: Devices result with presets grouped by category
    public func getDevices() async throws -> DevicesResult {
        let data: Data = try await doRequest("GET", path: "/v1/devices", body: nil as Empty?)
        return try JSONDecoder().decode(DevicesResult.self, from: data)
    }

    /// Get API capabilities and features.
    ///
    /// - Returns: Capabilities result
    public func getCapabilities() async throws -> CapabilitiesResult {
        let data: Data = try await doRequest("GET", path: "/v1/capabilities", body: nil as Empty?)
        return try JSONDecoder().decode(CapabilitiesResult.self, from: data)
    }

    /// Get API usage statistics.
    ///
    /// - Returns: Usage result with limits and remaining quota
    public func getUsage() async throws -> UsageResult {
        let data: Data = try await doRequest("GET", path: "/v1/usage", body: nil as Empty?)
        return try JSONDecoder().decode(UsageResult.self, from: data)
    }

    // MARK: - Private Methods

    private func doRequest<T: Encodable>(_ method: String, path: String, body: T?) async throws -> Data {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw SnapAPIError(
                code: "INVALID_URL",
                message: "Invalid URL",
                statusCode: 400
            )
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue(apiKey, forHTTPHeaderField: "X-Api-Key")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("snapapi-swift/\(Self.version)", forHTTPHeaderField: "User-Agent")

        if let body = body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .useDefaultKeys
            request.httpBody = try encoder.encode(body)
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw SnapAPIError(
                code: "CONNECTION_ERROR",
                message: "Invalid response",
                statusCode: 0
            )
        }

        if httpResponse.statusCode >= 400 {
            try handleError(data: data, statusCode: httpResponse.statusCode)
        }

        return data
    }

    private func handleError(data: Data, statusCode: Int) throws -> Never {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
            throw SnapAPIError(
                code: errorResponse.error.code,
                message: errorResponse.error.message,
                statusCode: statusCode,
                details: errorResponse.error.details
            )
        } catch let error as SnapAPIError {
            throw error
        } catch {
            throw SnapAPIError(
                code: "HTTP_ERROR",
                message: "HTTP \(statusCode)",
                statusCode: statusCode
            )
        }
    }
}

// MARK: - Empty Type for GET requests

private struct Empty: Encodable {}

// MARK: - SnapAPIError

/// Error thrown by SnapAPI operations.
public struct SnapAPIError: Error, LocalizedError, Sendable {
    /// Error code
    public let code: String

    /// Error message
    public let message: String

    /// HTTP status code
    public let statusCode: Int

    /// Additional error details
    public let details: [String: AnyCodable]?

    public init(
        code: String,
        message: String,
        statusCode: Int,
        details: [String: AnyCodable]? = nil
    ) {
        self.code = code
        self.message = message
        self.statusCode = statusCode
        self.details = details
    }

    public var errorDescription: String? {
        "[\(code)] \(message) (HTTP \(statusCode))"
    }

    /// Check if the error is retryable.
    public var isRetryable: Bool {
        code == "RATE_LIMITED" || code == "TIMEOUT" || statusCode >= 500
    }
}

// MARK: - Convenience Extensions

#if canImport(UIKit)
import UIKit

extension ScreenshotResult {
    /// Convert the screenshot data to UIImage
    public var uiImage: UIImage? {
        imageData.flatMap { UIImage(data: $0) }
    }

    /// Convert the thumbnail data to UIImage
    public var thumbnailUIImage: UIImage? {
        thumbnailData.flatMap { UIImage(data: $0) }
    }
}
#endif

#if canImport(AppKit)
import AppKit

extension ScreenshotResult {
    /// Convert the screenshot data to NSImage
    public var nsImage: NSImage? {
        imageData.flatMap { NSImage(data: $0) }
    }

    /// Convert the thumbnail data to NSImage
    public var thumbnailNSImage: NSImage? {
        thumbnailData.flatMap { NSImage(data: $0) }
    }
}
#endif
