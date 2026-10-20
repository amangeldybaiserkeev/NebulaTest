import Foundation

struct PaywallPlanItem: Identifiable, Equatable {
    let id: String
    let periodTitle: String
    let weeklyPrice: String
    let fullPrice: String
    let badge: String?

    static let placeholders: [Self] = [
        Self(id: "year", periodTitle: "Year", weeklyPrice: "$1.27", fullPrice: "$ 69.99", badge: "SAVE 80%"),
        Self(id: "month", periodTitle: "Month", weeklyPrice: "$1.99", fullPrice: "$ 7.99", badge: nil)
    ]
}
