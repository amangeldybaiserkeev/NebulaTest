import Foundation

struct SubscriptionPlan: Identifiable, Equatable {
    let id: String
    let period: SubscriptionPeriod
    let price: Decimal
    let displayPrice: String
    let displayPricePerWeek: String

    var pricePerWeek: Decimal {
        price / period.weeks
    }
}
