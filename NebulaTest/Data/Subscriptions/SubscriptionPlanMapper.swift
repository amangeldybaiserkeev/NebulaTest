import StoreKit

enum SubscriptionPlanMapper {
    static func plan(from product: Product) -> SubscriptionPlan? {
        guard let period = period(from: product.subscription?.subscriptionPeriod) else { return nil }
        let pricePerWeek = product.price / period.weeks
        return SubscriptionPlan(
            id: product.id,
            period: period,
            price: product.price,
            displayPrice: product.displayPrice,
            displayPricePerWeek: product.priceFormatStyle.format(pricePerWeek)
        )
    }

    private static func period(from period: Product.SubscriptionPeriod?) -> SubscriptionPeriod? {
        guard let period, period.value == 1 else { return nil }
        return switch period.unit {
        case .week: .week
        case .month: .month
        case .year: .year
        default: nil
        }
    }
}
