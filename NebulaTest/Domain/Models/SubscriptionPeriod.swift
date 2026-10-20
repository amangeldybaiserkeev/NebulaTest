import Foundation

enum SubscriptionPeriod: Equatable {
    case week
    case month
    case year

    private static let weeksPerMonth: Decimal = 4
    private static let weeksPerYear: Decimal = 52

    var weeks: Decimal {
        switch self {
        case .week: 1
        case .month: Self.weeksPerMonth
        case .year: Self.weeksPerYear
        }
    }

    var title: String {
        switch self {
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        }
    }
}
