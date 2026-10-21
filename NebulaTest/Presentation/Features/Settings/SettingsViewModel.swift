import Combine
import Foundation
import UserNotifications

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool {
        didSet { defaults.set(notificationsEnabled, forKey: Self.notificationsKey) }
    }
    @Published private(set) var cacheSize: Int64 = 0
    @Published var toast: Toast?
    @Published var isPaywallPresented = false
    @Published var isSharePresented = false
    @Published private(set) var isRestoring = false

    let appVersion: String

    private let subscriptionService: SubscriptionService
    private let cache: AppCache
    private let defaults: UserDefaults

    private static let notificationsKey = "settings.notificationsEnabled"

    init(subscriptionService: SubscriptionService, cache: AppCache, defaults: UserDefaults = .standard) {
        self.subscriptionService = subscriptionService
        self.cache = cache
        self.defaults = defaults
        notificationsEnabled = defaults.bool(forKey: Self.notificationsKey)
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var cacheSizeText: String {
        ByteCountFormatter.string(fromByteCount: cacheSize, countStyle: .file)
    }

    func refreshCacheSize() {
        cacheSize = cache.size()
    }

    func clearCache() {
        cache.clear()
        refreshCacheSize()
    }

    func setNotifications(_ enabled: Bool) async {
        guard enabled else {
            notificationsEnabled = false
            return
        }
        let center = UNUserNotificationCenter.current()
        notificationsEnabled = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    func restore() async {
        guard !isRestoring else { return }
        isRestoring = true
        defer { isRestoring = false }
        do {
            try await subscriptionService.restore()
            toast = Toast(style: .success, title: "Purchases restored")
        } catch {
            toast = Toast(style: .error, title: error.localizedDescription)
        }
    }
}
