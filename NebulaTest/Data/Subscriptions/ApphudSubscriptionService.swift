import ApphudSDK
import Foundation
import OSLog
import StoreKit

@MainActor
final class ApphudSubscriptionService: SubscriptionService {
    let premiumUpdates: AsyncStream<Bool>

    private let paywallID: String
    private let continuation: AsyncStream<Bool>.Continuation
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "NebulaTest", category: "Subscriptions")
    private var products: [String: ApphudProduct] = [:]

    init(apiKey: String, paywallID: String) {
        self.paywallID = paywallID
        (premiumUpdates, continuation) = AsyncStream.makeStream(of: Bool.self)
        #if DEBUG
        Apphud.enableDebugLogs()
        #endif
        Apphud.start(apiKey: apiKey)
        Apphud.setDelegate(self)
    }

    var userID: String {
        Apphud.userID()
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
        continuation.yield(true)
    }

    func restore() async throws {
        let error = await Apphud.restorePurchases()
        guard error == nil, Apphud.hasActiveSubscription() else { throw SubscriptionError.nothingToRestore }
        continuation.yield(true)
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

    private func paywalls() async -> [ApphudPaywall] {
        await withCheckedContinuation { waiter in
            Apphud.paywallsDidLoadCallback { paywalls, _ in
                waiter.resume(returning: paywalls)
            }
        }
    }
}

extension ApphudSubscriptionService: ApphudDelegate {
    nonisolated func apphudSubscriptionsUpdated(_ subscriptions: [ApphudSubscription]) {
        let isActive = subscriptions.contains { $0.isActive() }
        Task { @MainActor in continuation.yield(isActive) }
    }

    nonisolated func paywallsDidFullyLoad(paywalls: [ApphudPaywall]) {
        Task { @MainActor in
            logger.debug("Paywalls loaded: \(paywalls.map(\.identifier), privacy: .public)")
        }
    }

    nonisolated func placementsDidFullyLoad(placements: [ApphudPlacement]) {
        Task { @MainActor in
            logger.debug("Placements loaded: \(placements.map(\.identifier), privacy: .public)")
        }
    }
}
