import Combine
import Foundation

@MainActor
final class PaywallViewModel: ObservableObject {
    @Published private(set) var plans: LoadState<[PaywallPlanItem]> = .idle
    @Published var selectedPlanID: String?
    @Published private(set) var isPurchasing = false
    @Published var errorMessage: String?
    @Published private(set) var didUnlock = false

    private let subscriptionService: SubscriptionService

    init(subscriptionService: SubscriptionService) {
        self.subscriptionService = subscriptionService
    }

    func load() async {
        guard plans == .idle else { return }
        plans = .loading
        do {
            let items = PaywallPlanItemBuilder.items(from: try await subscriptionService.loadPlans())
            plans = .loaded(items)
            if selectedPlanID == nil { selectedPlanID = items.first?.id }
        } catch {
            plans = .failed(message: error.localizedDescription)
        }
    }

    func selectPlan(_ id: String) {
        selectedPlanID = id
    }

    func purchase() async {
        guard let selectedPlanID, !isPurchasing else { return }
        await perform { try await self.subscriptionService.purchase(planID: selectedPlanID) }
    }

    func restore() async {
        guard !isPurchasing else { return }
        await perform { try await self.subscriptionService.restore() }
    }

    private func perform(_ operation: () async throws -> Void) async {
        isPurchasing = true
        defer { isPurchasing = false }
        do {
            try await operation()
            didUnlock = true
        } catch is CancellationError {
            return
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
