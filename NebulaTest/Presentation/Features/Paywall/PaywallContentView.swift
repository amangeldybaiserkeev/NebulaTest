import SwiftUI

struct PaywallContentView: View {
    let plans: [PaywallPlanItem]
    let selectedPlanID: String?
    let onSelectPlan: (String) -> Void

    private let ghostTopPadding: Double = 14
    private let benefits = PaywallBenefit.all

    var body: some View {
        VStack(spacing: 0) {
            Image(.imgGhostPaywall)
                .padding(.top, ghostTopPadding)
                .accessibilityHidden(true)

            Text("Create anything\nyou want")
                .font(AppFont.largeTitle)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, Spacing.xl)

            VStack(alignment: .leading, spacing: Spacing.sm) {
                ForEach(benefits) { benefit in
                    PaywallBenefitRow(benefit: benefit)
                }
            }
            .padding(.top, Spacing.xxl)

            VStack(spacing: Spacing.md) {
                ForEach(plans) { plan in
                    PaywallPlanRow(plan: plan, isSelected: plan.id == selectedPlanID) {
                        onSelectPlan(plan.id)
                    }
                }
            }
            .padding(.top, Spacing.xxl)
        }
    }
}

#Preview {
    PaywallContentView(plans: PaywallPlanItem.placeholders, selectedPlanID: "year") { _ in }
        .background(Color.appBackground)
}
