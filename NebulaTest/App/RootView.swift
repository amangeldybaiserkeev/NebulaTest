import SwiftUI

struct RootView: View {
    @StateObject private var viewModel: RootViewModel

    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
        _viewModel = StateObject(wrappedValue: container.makeRootViewModel())
    }

    var body: some View {
        ZStack {
            switch viewModel.phase {
            case .splash:
                SplashView()
                    .transition(.opacity)
            case .onboarding:
                OnboardingView(onFinish: viewModel.completeOnboarding)
                    .transition(.opacity)
            case .paywall:
                PaywallView(
                    viewModel: container.makePaywallViewModel(),
                    onClose: viewModel.finishPaywall,
                    onUnlock: viewModel.finishPaywall
                )
                    .transition(.move(edge: .trailing))
            case .main:
                MainFlowView(container: container)
                    .transition(.opacity)
            }
        }
        .animation(Animations.screen, value: viewModel.phase)
        .task { await viewModel.start() }
    }
}
