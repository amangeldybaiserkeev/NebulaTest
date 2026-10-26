import Combine
import Foundation

@MainActor
final class RootViewModel: ObservableObject {
    enum Phase: Equatable {
        case splash
        case onboarding
        case paywall
        case main
    }

    static let splashSeconds: Double = 1.5

    @Published private(set) var phase: Phase = .splash

    private let onboardingStore: OnboardingStateStore
    private let splashDuration: Duration

    init(onboardingStore: OnboardingStateStore, splashDuration: Duration = .seconds(RootViewModel.splashSeconds)) {
        self.onboardingStore = onboardingStore
        self.splashDuration = splashDuration
    }

    func start() async {
        guard phase == .splash else { return }
        try? await Task.sleep(for: splashDuration)
        guard !Task.isCancelled else { return }
        phase = onboardingStore.hasCompletedOnboarding ? .main : .onboarding
    }

    func completeOnboarding() {
        onboardingStore.hasCompletedOnboarding = true
        phase = .paywall
    }

    func finishPaywall() {
        phase = .main
    }
}
