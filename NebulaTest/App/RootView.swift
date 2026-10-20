import SwiftUI

struct RootView: View {
    @StateObject private var viewModel: RootViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    init(container: AppContainer) {
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
                PaywallView(onClose: viewModel.finishPaywall, onUnlock: viewModel.finishPaywall)
                    .transition(reduceMotion ? .opacity : .move(edge: .trailing))
            case .main:
                MainView()
                    .transition(.opacity)
            }
        }
        .animation(Animations.screen, value: viewModel.phase)
        .task { await viewModel.start() }
    }
}
