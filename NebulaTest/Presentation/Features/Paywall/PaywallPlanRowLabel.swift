import SwiftUI

struct PaywallPlanRowLabel: View {
    let plan: PaywallPlanItem

    private let badgeVerticalPadding: Double = 6

    var body: some View {
        HStack(spacing: Spacing.sm) {
            VStack(alignment: .leading, spacing: Spacing.xs) {
                HStack(spacing: Spacing.xxs) {
                    Text("\(plan.periodTitle) \(plan.weeklyPrice)")
                        .font(AppFont.bodyMedium)
                    Text("/ week")
                        .font(AppFont.body)
                }
                .foregroundStyle(.white)

                Text(plan.fullPrice)
                    .font(AppFont.caption)
                    .foregroundStyle(.textSecondary)
            }

            Spacer(minLength: 0)

            if let badge = plan.badge {
                Text(badge)
                    .font(AppFont.captionMedium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, Spacing.lg)
                    .padding(.vertical, badgeVerticalPadding)
                    .background(LinearGradient.accent, in: .capsule)
            }
        }
    }
}
