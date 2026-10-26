import ApphudSDK
import Foundation
import OSLog
import StoreKit

@MainActor
final class ApphudSubscriptionService: SubscriptionService {
    private let paywallID: String
    private let broadcaster = StreamBroadcaster<Bool>()
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NebulaTest", category: "Subscriptions")
    private var products: [String: ApphudProduct] = [:]
    private var loadedPaywalls: [ApphudPaywall] = []
    private var paywallWaiters: [CheckedContinuation<[ApphudPaywall], Never>] = []
    private static let paywallsTimeoutSeconds: Double = 10

    init(apiKey: String, paywallID: String) {
        self.paywallID = paywallID
        #if DEBUG
        Apphud.enableDebugLogs()
        #endif
        Apphud.start(apiKey: apiKey)
        Apphud.setDelegate(self)
    }

    var userID: String {
        Apphud.userID()
    }

    var premiumUpdates: AsyncStream<Bool> {
        broadcaster.makeStream()
    }

    var isPremium: Bool {
        Apphud.hasActiveSubscription()
    }

    func loadPlans() async throws -> [SubscriptionPlan] {
        guard let paywall = await findPaywall() else {
            logger.error("Paywall \(self.paywallID, privacy: .public) not found")
            throw SubscriptionError.paywallNotFound
        }
        logger.debug("Paywall products: \(paywall.products.map(\.productId), privacy: .public)")

        var plans: [SubscriptionPlan] = []
        for product in paywall.products {
            products[product.productId] = product
            if let storeProduct = try? await product.product(),
               let plan = SubscriptionPlanMapper.plan(from: storeProduct) {
                plans.append(plan)
            } else {
                logger.error("StoreKit product unavailable for \(product.productId, privacy: .public)")
            }
        }
        return plans
    }

    func purchase(planID: String) async throws {
        guard let product = products[planID] else { throw SubscriptionError.productUnavailable }
        let result = await Apphud.purchase(product)
        if let error = result.error, Self.isUserCancellation(error) { throw CancellationError() }
        guard result.success else { throw SubscriptionError.purchaseFailed }
        broadcaster.send(true)
    }

    func restore() async throws {
        if await Apphud.restorePurchases() != nil { throw SubscriptionError.restoreFailed }
        guard Apphud.hasActiveSubscription() else { throw SubscriptionError.nothingToRestore }
        broadcaster.send(true)
    }

    private static func isUserCancellation(_ error: Error) -> Bool {
        if let storeKitError = error as? StoreKitError, case .userCancelled = storeKitError { return true }
        return (error as? SKError)?.code == .paymentCancelled
    }

    private func findPaywall() async -> ApphudPaywall? {
        let placements = await Apphud.placements()
        if let paywall = placements.first(where: { $0.identifier == paywallID })?.paywall
            ?? placements.compactMap(\.paywall).first(where: { $0.identifier == paywallID }) {
            return paywall
        }
        logger.debug("No placement for \(self.paywallID, privacy: .public), falling back to paywalls list")
        return await paywalls().first { $0.identifier == paywallID }
    }

    // The Apphud project of this task has a plain paywall list and no placements,
    // so the paywall is taken from the delegate callback that delivers that list.
    private func paywalls() async -> [ApphudPaywall] {
        if !loadedPaywalls.isEmpty { return loadedPaywalls }
        return await withCheckedContinuation { waiter in
            paywallWaiters.append(waiter)
            Task { [weak self] in
                try? await Task.sleep(for: .seconds(Self.paywallsTimeoutSeconds))
                self?.resumePaywallWaiters()
            }
        }
    }

    private func resumePaywallWaiters() {
        let waiters = paywallWaiters
        paywallWaiters.removeAll()
        waiters.forEach { $0.resume(returning: loadedPaywalls) }
    }
}

extension ApphudSubscriptionService: ApphudDelegate {
    nonisolated func apphudSubscriptionsUpdated(_ subscriptions: [ApphudSubscription]) {
        let isActive = subscriptions.contains { $0.isActive() }
        Task { @MainActor in broadcaster.send(isActive) }
    }

    nonisolated func paywallsDidFullyLoad(paywalls: [ApphudPaywall]) {
        Task { @MainActor in
            loadedPaywalls = paywalls
            resumePaywallWaiters()
        }
    }
}
