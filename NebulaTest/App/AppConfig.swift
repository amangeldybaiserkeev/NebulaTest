import Foundation

enum AppConfig {
    enum Apphud {
        static let apiKey = infoValue("APPHUD_API_KEY")
        static let paywallID = "main"
    }

    enum API {
        static let bearerToken = infoValue("API_BEARER_TOKEN")
        static let applicationID = "com.test.test"
        static let chatBaseURL = url("https://nebulaapps.site/dola")
        static let videoBaseURL = url("https://nebulaapps.site/pixverse")
    }

    // Placeholders
    enum Links {
        static let privacyPolicy = url("https://nebulaapps.site/privacy")
        static let termsOfUse = url("https://nebulaapps.site/terms")
        static let support = url("mailto:support@nebulaapps.site")
        static let appStore = url("https://apps.apple.com/app/id0000000000")
    }

    private static func url(_ string: StaticString) -> URL {
        guard let url = URL(string: "\(string)") else { fatalError("Invalid URL literal: \(string)") }
        return url
    }

    private static func infoValue(_ key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String, !value.isEmpty else {
            fatalError("Missing \(key) in Info.plist. Check Configuration/Secrets.xcconfig.")
        }
        return value
    }
}
