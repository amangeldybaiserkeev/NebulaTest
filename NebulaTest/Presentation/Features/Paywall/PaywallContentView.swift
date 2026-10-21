import SwiftUI

struct PaywallContentView: View {
    let plans: LoadState<[PaywallPlanItem]>
    let selectedPlanID: String?
    let onSelectPlan: (String) -> Void

    private let ghostTopPadding: Double = 14
    private let benefits = PaywallBenefit.all

    var body: some View {
        VStack(spacing: 0) {
            Image(.imgGhostPaywall)
                .padding(.top, ghostTopPadding)

            Text("Create anything\nyou want")
                .font(AppFont.largeTitle)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.top, Spacing.lg)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                ForEach(benefits) { benefit in
                    PaywallBenefitRow(benefit: benefit)
                }
            }
            .padding(.top, Spacing.xxl)

            PaywallPlansSection(plans: plans, selectedPlanID: selectedPlanID, onSelectPlan: onSelectPlan)
                .padding(.top, Spacing.xxl)
        }
    }
}

#Preview {
    PaywallContentView(plans: .loaded(PaywallPlanItem.placeholders), selectedPlanID: "year") { _ in }
        .background(Color.appBackground)
}
