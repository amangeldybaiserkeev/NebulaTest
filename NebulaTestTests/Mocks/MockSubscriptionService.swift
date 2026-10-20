import Foundation
@testable import NebulaTest

@MainActor
final class MockSubscriptionService: SubscriptionService {
    var userID = "test-user"
    var isPremium = false
    var plansResult: Result<[SubscriptionPlan], Error> = .success([])
    var purchaseError: Error?
    var restoreError: Error?
    private(set) var purchasedPlanIDs: [String] = []
    private(set) var restoreCallCount = 0

    let premiumUpdates: AsyncStream<Bool>
    private let continuation: AsyncStream<Bool>.Continuation

    init() {
        (premiumUpdates, continuation) = AsyncStream.makeStream(of: Bool.self)
    }

    func loadPlans() async throws -> [SubscriptionPlan] {
        try plansResult.get()
    }

    func purchase(planID: String) async throws {
        purchasedPlanIDs.append(planID)
        if let purchaseError { throw purchaseError }
        isPremium = true
        continuation.yield(true)
    }

    func restore() async throws {
        restoreCallCount += 1
        if let restoreError { throw restoreError }
        isPremium = true
        continuation.yield(true)
    }
}
