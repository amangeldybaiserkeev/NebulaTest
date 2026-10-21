import SwiftUI

struct PaywallPlanRowLabel: View {
    let plan: PaywallPlanItem

    private let badgeVerticalPadding: Double = 6

    var body: some View {
        HStack(spacing: Spacing.xs) {
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                HStack(spacing: Spacing.xxxs) {
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
                    .padding(.horizontal, Spacing.reg)
                    .padding(.vertical, badgeVerticalPadding)
                    .background(LinearGradient.accent, in: .capsule)
            }
        }
    }
}
