import Foundation

@MainActor
protocol SubscriptionService: AnyObject {
    var userID: String { get }
    var isPremium: Bool { get }
    var premiumUpdates: AsyncStream<Bool> { get }

    func loadPlans() async throws -> [SubscriptionPlan]
    func purchase(planID: String) async throws
    func restore() async throws
}
