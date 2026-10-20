import Foundation

enum PaywallPlanItemBuilder {
    private static let percent: Decimal = 100

    static func items(from plans: [SubscriptionPlan]) -> [PaywallPlanItem] {
        let sorted = plans.sorted { $0.period.weeks > $1.period.weeks }
        let highestWeekly = plans.map(\.pricePerWeek).max()
        return sorted.map { plan in
            PaywallPlanItem(
                id: plan.id,
                periodTitle: plan.period.title,
                weeklyPrice: plan.displayPricePerWeek,
                fullPrice: plan.displayPrice,
                badge: badge(for: plan, highestWeekly: highestWeekly)
            )
        }
    }

    static func badge(for plan: SubscriptionPlan, highestWeekly: Decimal?) -> String? {
        guard let highestWeekly, highestWeekly > 0, plan.pricePerWeek < highestWeekly else { return nil }
        let saving = (1 - plan.pricePerWeek / highestWeekly) * percent
        let rounded = Int(NSDecimalNumber(decimal: saving).doubleValue.rounded(.down))
        return rounded > 0 ? "SAVE \(rounded)%" : nil
    }
}
