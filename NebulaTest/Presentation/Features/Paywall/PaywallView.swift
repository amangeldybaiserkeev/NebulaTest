import SwiftUI

struct PaywallView: View {
    @StateObject private var viewModel: PaywallViewModel
    let onClose: () -> Void
    let onUnlock: () -> Void

    var closeButtonDelay: Double = 2

    @State private var isCloseButtonVisible = false

    init(viewModel: PaywallViewModel, onClose: @escaping () -> Void, onUnlock: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onClose = onClose
        self.onUnlock = onUnlock
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            GlowBackground(glowOpacity: Opacity.half)

            VStack(spacing: 0) {
                ScrollView {
                    PaywallContentView(
                        plans: viewModel.plans,
                        selectedPlanID: viewModel.selectedPlanID,
                        onSelectPlan: viewModel.selectPlan
                    )
                    .padding(.horizontal, Spacing.reg)
                    .padding(.vertical, Spacing.reg)
                }
                .scrollIndicators(.hidden)

                PaywallBottomBar(
                    isUnlockEnabled: viewModel.selectedPlanID != nil && !viewModel.isPurchasing,
                    onUnlock: purchase,
                    onRestore: restore,
                    onPrivacyPolicy: openPrivacyPolicy,
                    onTermsOfUse: openTermsOfUse
                )
            }

            PaywallCloseButton(isVisible: isCloseButtonVisible, action: onClose)

            if viewModel.isPurchasing {
                PurchaseProgressOverlay()
            }
        }
        .task { await viewModel.load() }
        .task(revealCloseButton)
        .onChange(of: viewModel.didUnlock) { didUnlock in
            if didUnlock { onUnlock() }
        }
        .alert("Something went wrong", isPresented: $viewModel.isErrorPresented) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private func purchase() {
        Task { await viewModel.purchase() }
    }

    private func restore() {
        Task { await viewModel.restore() }
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
}
