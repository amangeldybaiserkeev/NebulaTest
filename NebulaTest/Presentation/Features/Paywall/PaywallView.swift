import SwiftUI

struct PaywallView: View {
    let onClose: () -> Void
    let onUnlock: () -> Void

    var plans: [PaywallPlanItem] = PaywallPlanItem.placeholders
    var closeButtonDelay: Double = 2

    @State private var selectedPlanID: String?
    @State private var isCloseButtonVisible = false

    var body: some View {
        ZStack(alignment: .topLeading) {
            GlowBackground(glowOpacity: Opacity.half)

            VStack(spacing: 0) {
                ScrollView {
                    PaywallContentView(plans: plans, selectedPlanID: selectedPlanID, onSelectPlan: selectPlan)
                        .padding(.horizontal, Spacing.screenEdge)
                        .padding(.vertical, Spacing.lg)
                }
                .scrollIndicators(.hidden)

                PaywallBottomBar(
                    onUnlock: onUnlock,
                    onRestore: restorePurchases,
                    onPrivacyPolicy: openPrivacyPolicy,
                    onTermsOfUse: openTermsOfUse
                )
            }

            PaywallCloseButton(isVisible: isCloseButtonVisible, action: onClose)
        }
        .onAppear(perform: selectDefaultPlan)
        .task(revealCloseButton)
    }

    private func selectPlan(_ id: String) {
        selectedPlanID = id
    }

    private func selectDefaultPlan() {
        if selectedPlanID == nil {
            selectedPlanID = plans.first?.id
        }
    }

    @Sendable
    private func revealCloseButton() async {
        try? await Task.sleep(for: .seconds(closeButtonDelay))
        withAnimation(Animations.fadeIn) {
            isCloseButtonVisible = true
        }
    }

    private func openPrivacyPolicy() {}
    private func openTermsOfUse() {}
    private func restorePurchases() {}
}

#Preview {
    PaywallView(onClose: {}, onUnlock: {})
}
