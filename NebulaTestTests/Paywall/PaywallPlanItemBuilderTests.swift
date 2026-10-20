import XCTest
@testable import NebulaTest

final class PaywallPlanItemBuilderTests: XCTestCase {
    private let yearly = SubscriptionPlan(
        id: "year", period: .year, price: 39.99, displayPrice: "$39.99", displayPricePerWeek: "$0.77"
    )
    private let weekly = SubscriptionPlan(
        id: "week", period: .week, price: 4.99, displayPrice: "$4.99", displayPricePerWeek: "$4.99"
    )

    func testLongestPeriodComesFirst() {
        let items = PaywallPlanItemBuilder.items(from: [weekly, yearly])

        XCTAssertEqual(items.map(\.id), ["year", "week"])
    }

    func testCheaperWeeklyRateGetsSavingBadge() {
        let items = PaywallPlanItemBuilder.items(from: [weekly, yearly])

        XCTAssertEqual(items.first?.badge, "SAVE 84%")
        XCTAssertNil(items.last?.badge)
    }

    func testSinglePlanHasNoBadge() {
        let items = PaywallPlanItemBuilder.items(from: [yearly])

        XCTAssertNil(items.first?.badge)
    }

    func testUsesStoreFormattedPrices() {
        let items = PaywallPlanItemBuilder.items(from: [yearly])

        XCTAssertEqual(items.first?.weeklyPrice, "$0.77")
        XCTAssertEqual(items.first?.fullPrice, "$39.99")
    }
}
