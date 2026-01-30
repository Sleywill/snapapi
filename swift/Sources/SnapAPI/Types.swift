import Foundation

// MARK: - Device Presets

/// Device preset names for common devices.
public enum DevicePreset: String, Codable, CaseIterable, Sendable {
    // Desktop
    case desktop1080p = "desktop-1080p"
    case desktop1440p = "desktop-1440p"
    case desktop4K = "desktop-4k"

    // Mac
    case macBookPro13 = "macbook-pro-13"
    case macBookPro16 = "macbook-pro-16"
    case iMac24 = "imac-24"

    // iPhone
    case iPhoneSE = "iphone-se"
    case iPhone12 = "iphone-12"
    case iPhone13 = "iphone-13"
    case iPhone14 = "iphone-14"
    case iPhone14Pro = "iphone-14-pro"
    case iPhone15 = "iphone-15"
    case iPhone15Pro = "iphone-15-pro"
    case iPhone15ProMax = "iphone-15-pro-max"

    // iPad
    case iPad = "ipad"
    case iPadMini = "ipad-mini"
    case iPadAir = "ipad-air"
    case iPadPro11 = "ipad-pro-11"
    case iPadPro129 = "ipad-pro-12.9"

    // Android
    case pixel7 = "pixel-7"
    case pixel8 = "pixel-8"
    case pixel8Pro = "pixel-8-pro"
    case samsungGalaxyS23 = "samsung-galaxy-s23"
    case samsungGalaxyS24 = "samsung-galaxy-s24"
    case samsungGalaxyTabS9 = "samsung-galaxy-tab-s9"
}

// MARK: - Cookie

/// Represents a browser cookie.
public struct Cookie: Codable, Sendable {
    public let name: String
    public let value: String
    public let domain: String?
    public let path: String?
    public let expires: Int64?
    public let httpOnly: Bool?
    public let secure: Bool?
    public let sameSite: String?

    public init(
        name: String,
        value: String,
        domain: String? = nil,
        path: String? = nil,
        expires: Int64? = nil,
        httpOnly: Bool? = nil,
        secure: Bool? = nil,
        sameSite: String? = nil
    ) {
        self.name = name
        self.value = value
        self.domain = domain
        self.path = path
        self.expires = expires
        self.httpOnly = httpOnly
        self.secure = secure
        self.sameSite = sameSite
    }
}

// MARK: - HTTP Auth

/// HTTP basic authentication credentials.
public struct HttpAuth: Codable, Sendable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

// MARK: - Proxy Config

/// Proxy configuration.
public struct ProxyConfig: Codable, Sendable {
    public let server: String
    public let username: String?
    public let password: String?
    public let bypass: [String]?

    public init(
        server: String,
        username: String? = nil,
        password: String? = nil,
        bypass: [String]? = nil
    ) {
        self.server = server
        self.username = username
        self.password = password
        self.bypass = bypass
    }
}

// MARK: - Geolocation

/// Geolocation coordinates.
public struct Geolocation: Codable, Sendable {
    public let latitude: Double
    public let longitude: Double
    public let accuracy: Double?

    public init(latitude: Double, longitude: Double, accuracy: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.accuracy = accuracy
    }
}

// MARK: - PDF Options

/// PDF generation options.
public struct PdfOptions: Codable, Sendable {
    public let pageSize: String?
    public let width: String?
    public let height: String?
    public let landscape: Bool?
    public let marginTop: String?
    public let marginRight: String?
    public let marginBottom: String?
    public let marginLeft: String?
    public let printBackground: Bool?
    public let headerTemplate: String?
    public let footerTemplate: String?
    public let displayHeaderFooter: Bool?
    public let scale: Double?
    public let pageRanges: String?
    public let preferCSSPageSize: Bool?

    public init(
        pageSize: String? = nil,
        width: String? = nil,
        height: String? = nil,
        landscape: Bool? = nil,
        marginTop: String? = nil,
        marginRight: String? = nil,
        marginBottom: String? = nil,
        marginLeft: String? = nil,
        printBackground: Bool? = nil,
        headerTemplate: String? = nil,
        footerTemplate: String? = nil,
        displayHeaderFooter: Bool? = nil,
        scale: Double? = nil,
        pageRanges: String? = nil,
        preferCSSPageSize: Bool? = nil
    ) {
        self.pageSize = pageSize
        self.width = width
        self.height = height
        self.landscape = landscape
        self.marginTop = marginTop
        self.marginRight = marginRight
        self.marginBottom = marginBottom
        self.marginLeft = marginLeft
        self.printBackground = printBackground
        self.headerTemplate = headerTemplate
        self.footerTemplate = footerTemplate
        self.displayHeaderFooter = displayHeaderFooter
        self.scale = scale
        self.pageRanges = pageRanges
        self.preferCSSPageSize = preferCSSPageSize
    }
}

// MARK: - Thumbnail Options

/// Thumbnail generation options.
public struct ThumbnailOptions: Codable, Sendable {
    public let enabled: Bool
    public let width: Int?
    public let height: Int?
    public let fit: String? // "cover", "contain", "fill"

    public init(
        enabled: Bool = true,
        width: Int? = nil,
        height: Int? = nil,
        fit: String? = nil
    ) {
        self.enabled = enabled
        self.width = width
        self.height = height
        self.fit = fit
    }
}

// MARK: - Extract Metadata

/// Options for additional metadata extraction.
public struct ExtractMetadata: Codable, Sendable {
    public let fonts: Bool?
    public let colors: Bool?
    public let links: Bool?
    public let httpStatusCode: Bool?

    public init(
        fonts: Bool? = nil,
        colors: Bool? = nil,
        links: Bool? = nil,
        httpStatusCode: Bool? = nil
    ) {
        self.fonts = fonts
        self.colors = colors
        self.links = links
        self.httpStatusCode = httpStatusCode
    }
}

// MARK: - Screenshot Options

/// Screenshot options.
public struct ScreenshotOptions: Codable, Sendable {
    public var url: String?
    public var html: String?
    public var format: String?
    public var quality: Int?
    public var device: String?
    public var width: Int?
    public var height: Int?
    public var deviceScaleFactor: Double?
    public var isMobile: Bool?
    public var hasTouch: Bool?
    public var isLandscape: Bool?
    public var fullPage: Bool?
    public var fullPageScrollDelay: Int?
    public var fullPageMaxHeight: Int?
    public var selector: String?
    public var selectorScrollIntoView: Bool?
    public var clipX: Int?
    public var clipY: Int?
    public var clipWidth: Int?
    public var clipHeight: Int?
    public var delay: Int?
    public var timeout: Int?
    public var waitUntil: String?
    public var waitForSelector: String?
    public var waitForSelectorTimeout: Int?
    public var darkMode: Bool?
    public var reducedMotion: Bool?
    public var css: String?
    public var javascript: String?
    public var hideSelectors: [String]?
    public var clickSelector: String?
    public var clickDelay: Int?
    public var blockAds: Bool?
    public var blockTrackers: Bool?
    public var blockCookieBanners: Bool?
    public var blockChatWidgets: Bool?
    public var blockResources: [String]?
    public var userAgent: String?
    public var extraHeaders: [String: String]?
    public var cookies: [Cookie]?
    public var httpAuth: HttpAuth?
    public var proxy: ProxyConfig?
    public var geolocation: Geolocation?
    public var timezone: String?
    public var locale: String?
    public var pdfOptions: PdfOptions?
    public var thumbnail: ThumbnailOptions?
    public var failOnHttpError: Bool?
    public var cache: Bool?
    public var cacheTtl: Int?
    public var responseType: String?
    public var includeMetadata: Bool?
    public var extractMetadata: ExtractMetadata?
    public var failIfContentMissing: [String]?
    public var failIfContentContains: [String]?

    public init(
        url: String? = nil,
        html: String? = nil,
        format: String? = nil,
        quality: Int? = nil,
        device: String? = nil,
        width: Int? = nil,
        height: Int? = nil,
        deviceScaleFactor: Double? = nil,
        isMobile: Bool? = nil,
        hasTouch: Bool? = nil,
        isLandscape: Bool? = nil,
        fullPage: Bool? = nil,
        fullPageScrollDelay: Int? = nil,
        fullPageMaxHeight: Int? = nil,
        selector: String? = nil,
        selectorScrollIntoView: Bool? = nil,
        clipX: Int? = nil,
        clipY: Int? = nil,
        clipWidth: Int? = nil,
        clipHeight: Int? = nil,
        delay: Int? = nil,
        timeout: Int? = nil,
        waitUntil: String? = nil,
        waitForSelector: String? = nil,
        waitForSelectorTimeout: Int? = nil,
        darkMode: Bool? = nil,
        reducedMotion: Bool? = nil,
        css: String? = nil,
        javascript: String? = nil,
        hideSelectors: [String]? = nil,
        clickSelector: String? = nil,
        clickDelay: Int? = nil,
        blockAds: Bool? = nil,
        blockTrackers: Bool? = nil,
        blockCookieBanners: Bool? = nil,
        blockChatWidgets: Bool? = nil,
        blockResources: [String]? = nil,
        userAgent: String? = nil,
        extraHeaders: [String: String]? = nil,
        cookies: [Cookie]? = nil,
        httpAuth: HttpAuth? = nil,
        proxy: ProxyConfig? = nil,
        geolocation: Geolocation? = nil,
        timezone: String? = nil,
        locale: String? = nil,
        pdfOptions: PdfOptions? = nil,
        thumbnail: ThumbnailOptions? = nil,
        failOnHttpError: Bool? = nil,
        cache: Bool? = nil,
        cacheTtl: Int? = nil,
        responseType: String? = nil,
        includeMetadata: Bool? = nil,
        extractMetadata: ExtractMetadata? = nil,
        failIfContentMissing: [String]? = nil,
        failIfContentContains: [String]? = nil
    ) {
        self.url = url
        self.html = html
        self.format = format
        self.quality = quality
        self.device = device
        self.width = width
        self.height = height
        self.deviceScaleFactor = deviceScaleFactor
        self.isMobile = isMobile
        self.hasTouch = hasTouch
        self.isLandscape = isLandscape
        self.fullPage = fullPage
        self.fullPageScrollDelay = fullPageScrollDelay
        self.fullPageMaxHeight = fullPageMaxHeight
        self.selector = selector
        self.selectorScrollIntoView = selectorScrollIntoView
        self.clipX = clipX
        self.clipY = clipY
        self.clipWidth = clipWidth
        self.clipHeight = clipHeight
        self.delay = delay
        self.timeout = timeout
        self.waitUntil = waitUntil
        self.waitForSelector = waitForSelector
        self.waitForSelectorTimeout = waitForSelectorTimeout
        self.darkMode = darkMode
        self.reducedMotion = reducedMotion
        self.css = css
        self.javascript = javascript
        self.hideSelectors = hideSelectors
        self.clickSelector = clickSelector
        self.clickDelay = clickDelay
        self.blockAds = blockAds
        self.blockTrackers = blockTrackers
        self.blockCookieBanners = blockCookieBanners
        self.blockChatWidgets = blockChatWidgets
        self.blockResources = blockResources
        self.userAgent = userAgent
        self.extraHeaders = extraHeaders
        self.cookies = cookies
        self.httpAuth = httpAuth
        self.proxy = proxy
        self.geolocation = geolocation
        self.timezone = timezone
        self.locale = locale
        self.pdfOptions = pdfOptions
        self.thumbnail = thumbnail
        self.failOnHttpError = failOnHttpError
        self.cache = cache
        self.cacheTtl = cacheTtl
        self.responseType = responseType
        self.includeMetadata = includeMetadata
        self.extractMetadata = extractMetadata
        self.failIfContentMissing = failIfContentMissing
        self.failIfContentContains = failIfContentContains
    }
}

// MARK: - Scroll Easing

/// Easing function for scroll animation.
public enum ScrollEasing: String, Codable, Sendable {
    case linear = "linear"
    case easeIn = "ease_in"
    case easeOut = "ease_out"
    case easeInOut = "ease_in_out"
    case easeInOutQuint = "ease_in_out_quint"
}

// MARK: - Video Options

/// Video capture options.
public struct VideoOptions: Codable, Sendable {
    public var url: String
    public var format: String?
    public var quality: Int?
    public var width: Int?
    public var height: Int?
    public var device: String?
    public var duration: Int?
    public var fps: Int?
    public var delay: Int?
    public var timeout: Int?
    public var waitUntil: String?
    public var waitForSelector: String?
    public var darkMode: Bool?
    public var blockAds: Bool?
    public var blockCookieBanners: Bool?
    public var css: String?
    public var javascript: String?
    public var hideSelectors: [String]?
    public var userAgent: String?
    public var cookies: [Cookie]?
    public var responseType: String?
    public var scroll: Bool?
    public var scrollDelay: Int?
    public var scrollDuration: Int?
    public var scrollBy: Int?
    public var scrollEasing: ScrollEasing?
    public var scrollBack: Bool?
    public var scrollComplete: Bool?

    public init(
        url: String,
        format: String? = "mp4",
        quality: Int? = nil,
        width: Int? = 1280,
        height: Int? = 720,
        device: String? = nil,
        duration: Int? = 5,  // seconds (max 30)
        fps: Int? = 24,
        delay: Int? = nil,
        timeout: Int? = 60,  // seconds
        waitUntil: String? = nil,
        waitForSelector: String? = nil,
        darkMode: Bool? = nil,
        blockAds: Bool? = nil,
        blockCookieBanners: Bool? = nil,
        css: String? = nil,
        javascript: String? = nil,
        hideSelectors: [String]? = nil,
        userAgent: String? = nil,
        cookies: [Cookie]? = nil,
        responseType: String? = nil,
        scroll: Bool? = nil,
        scrollDelay: Int? = nil,
        scrollDuration: Int? = nil,
        scrollBy: Int? = nil,
        scrollEasing: ScrollEasing? = nil,
        scrollBack: Bool? = nil,
        scrollComplete: Bool? = nil
    ) {
        self.url = url
        self.format = format
        self.quality = quality
        self.width = width
        self.height = height
        self.device = device
        self.duration = duration
        self.fps = fps
        self.delay = delay
        self.timeout = timeout
        self.waitUntil = waitUntil
        self.waitForSelector = waitForSelector
        self.darkMode = darkMode
        self.blockAds = blockAds
        self.blockCookieBanners = blockCookieBanners
        self.css = css
        self.javascript = javascript
        self.hideSelectors = hideSelectors
        self.userAgent = userAgent
        self.cookies = cookies
        self.responseType = responseType
        self.scroll = scroll
        self.scrollDelay = scrollDelay
        self.scrollDuration = scrollDuration
        self.scrollBy = scrollBy
        self.scrollEasing = scrollEasing
        self.scrollBack = scrollBack
        self.scrollComplete = scrollComplete
    }
}

// MARK: - Video Result

/// Video capture result.
public struct VideoResult: Codable, Sendable {
    public let success: Bool
    public let data: String?
    public let format: String
    public let width: Int
    public let height: Int
    public let fileSize: Int
    public let duration: Int
    public let took: Int
}

// MARK: - Screenshot Metadata

/// Page metadata from screenshot.
public struct ScreenshotMetadata: Codable, Sendable {
    public let title: String?
    public let description: String?
    public let favicon: String?
    public let ogTitle: String?
    public let ogDescription: String?
    public let ogImage: String?
    public let httpStatusCode: Int?
    public let fonts: [String]?
    public let colors: [String]?
    public let links: [String]?
}

// MARK: - Screenshot Result

/// Screenshot result with metadata.
public struct ScreenshotResult: Codable, Sendable {
    public let success: Bool
    public let data: String
    public let width: Int
    public let height: Int
    public let fileSize: Int
    public let took: Int
    public let format: String
    public let cached: Bool
    public let metadata: ScreenshotMetadata?
    public let thumbnail: String?

    /// Decode the base64 data to Data
    public var imageData: Data? {
        Data(base64Encoded: data)
    }

    /// Decode the base64 thumbnail to Data
    public var thumbnailData: Data? {
        thumbnail.flatMap { Data(base64Encoded: $0) }
    }
}

// MARK: - Batch Options

/// Batch screenshot options.
public struct BatchOptions: Codable, Sendable {
    public let urls: [String]
    public let format: String?
    public let quality: Int?
    public let width: Int?
    public let height: Int?
    public let fullPage: Bool?
    public let darkMode: Bool?
    public let blockAds: Bool?
    public let blockCookieBanners: Bool?
    public let webhookUrl: String?

    public init(
        urls: [String],
        format: String? = nil,
        quality: Int? = nil,
        width: Int? = nil,
        height: Int? = nil,
        fullPage: Bool? = nil,
        darkMode: Bool? = nil,
        blockAds: Bool? = nil,
        blockCookieBanners: Bool? = nil,
        webhookUrl: String? = nil
    ) {
        self.urls = urls
        self.format = format
        self.quality = quality
        self.width = width
        self.height = height
        self.fullPage = fullPage
        self.darkMode = darkMode
        self.blockAds = blockAds
        self.blockCookieBanners = blockCookieBanners
        self.webhookUrl = webhookUrl
    }
}

// MARK: - Batch Result

/// Batch job result.
public struct BatchResult: Codable, Sendable {
    public let success: Bool
    public let jobId: String
    public let status: String
    public let total: Int
    public let completed: Int?
    public let failed: Int?
}

// MARK: - Batch Item Result

/// Individual item result in a batch.
public struct BatchItemResult: Codable, Sendable {
    public let url: String
    public let status: String
    public let data: String?
    public let error: String?
    public let duration: Int?
}

// MARK: - Batch Status

/// Batch job status.
public struct BatchStatus: Codable, Sendable {
    public let success: Bool
    public let jobId: String
    public let status: String
    public let total: Int
    public let completed: Int
    public let failed: Int
    public let results: [BatchItemResult]?
    public let createdAt: String?
    public let completedAt: String?
}

// MARK: - Device Info

/// Device information.
public struct DeviceInfo: Codable, Sendable {
    public let id: String
    public let name: String
    public let width: Int
    public let height: Int
    public let deviceScaleFactor: Double
    public let isMobile: Bool
}

// MARK: - Devices Result

/// Result of GetDevices.
public struct DevicesResult: Codable, Sendable {
    public let success: Bool
    public let devices: [String: [DeviceInfo]]
    public let total: Int
}

// MARK: - Capabilities Result

/// Result of GetCapabilities.
public struct CapabilitiesResult: Codable, Sendable {
    public let success: Bool
    public let version: String
    public let capabilities: [String: AnyCodable]
}

// MARK: - Usage Result

/// API usage statistics.
public struct UsageResult: Codable, Sendable {
    public let used: Int
    public let limit: Int
    public let remaining: Int
    public let resetAt: String
}

// MARK: - Error Response

/// API error response.
struct ErrorResponse: Codable {
    let error: ErrorDetails
}

/// Error details.
struct ErrorDetails: Codable {
    let code: String
    let message: String
    let details: [String: AnyCodable]?
}

// MARK: - AnyCodable

/// A type-erased Codable value for handling dynamic JSON.
public struct AnyCodable: Codable, Sendable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.value = NSNull()
        } else if let bool = try? container.decode(Bool.self) {
            self.value = bool
        } else if let int = try? container.decode(Int.self) {
            self.value = int
        } else if let double = try? container.decode(Double.self) {
            self.value = double
        } else if let string = try? container.decode(String.self) {
            self.value = string
        } else if let array = try? container.decode([AnyCodable].self) {
            self.value = array.map { $0.value }
        } else if let dictionary = try? container.decode([String: AnyCodable].self) {
            self.value = dictionary.mapValues { $0.value }
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Failed to decode AnyCodable")
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case is NSNull:
            try container.encodeNil()
        case let bool as Bool:
            try container.encode(bool)
        case let int as Int:
            try container.encode(int)
        case let double as Double:
            try container.encode(double)
        case let string as String:
            try container.encode(string)
        case let array as [Any]:
            try container.encode(array.map { AnyCodable($0) })
        case let dictionary as [String: Any]:
            try container.encode(dictionary.mapValues { AnyCodable($0) })
        default:
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Failed to encode AnyCodable"))
        }
    }
}
