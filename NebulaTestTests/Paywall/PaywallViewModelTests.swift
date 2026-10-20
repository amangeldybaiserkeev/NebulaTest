import XCTest
@testable import NebulaTest

@MainActor
final class PaywallViewModelTests: XCTestCase {
    private let yearly = SubscriptionPlan(
        id: "year", period: .year, price: 39.99, displayPrice: "$39.99", displayPricePerWeek: "$0.77"
    )

    func testLoadSelectsFirstPlan() async {
        let service = MockSubscriptionService()
        service.plansResult = .success([yearly])
        let viewModel = PaywallViewModel(subscriptionService: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.plans.value?.count, 1)
        XCTAssertEqual(viewModel.selectedPlanID, "year")
    }

    func testLoadFailureExposesMessage() async {
        let service = MockSubscriptionService()
        service.plansResult = .failure(SubscriptionError.paywallNotFound)
        let viewModel = PaywallViewModel(subscriptionService: service)

        await viewModel.load()

        XCTAssertEqual(viewModel.plans, .failed(message: SubscriptionError.paywallNotFound.localizedDescription))
    }

    func testSuccessfulPurchaseUnlocks() async {
        let service = MockSubscriptionService()
        service.plansResult = .success([yearly])
        let viewModel = PaywallViewModel(subscriptionService: service)
        await viewModel.load()

        await viewModel.purchase()

        XCTAssertEqual(service.purchasedPlanIDs, ["year"])
        XCTAssertTrue(viewModel.didUnlock)
        XCTAssertFalse(viewModel.isPurchasing)
    }

    func testCancelledPurchaseIsSilent() async {
        let service = MockSubscriptionService()
        service.plansResult = .success([yearly])
        service.purchaseError = CancellationError()
        let viewModel = PaywallViewModel(subscriptionService: service)
        await viewModel.load()

        await viewModel.purchase()

        XCTAssertFalse(viewModel.didUnlock)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFailedRestoreShowsError() async {
        let service = MockSubscriptionService()
        service.restoreError = SubscriptionError.nothingToRestore
        let viewModel = PaywallViewModel(subscriptionService: service)

        await viewModel.restore()

        XCTAssertFalse(viewModel.didUnlock)
        XCTAssertEqual(viewModel.errorMessage, SubscriptionError.nothingToRestore.localizedDescription)
    }
}
