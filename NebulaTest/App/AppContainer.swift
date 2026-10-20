import Foundation

final class AppContainer {
    let onboardingStore: OnboardingStateStore

    init() {
        onboardingStore = UserDefaultsOnboardingStateStore()
    }

    @MainActor
    func makeRootViewModel() -> RootViewModel {
        RootViewModel(onboardingStore: onboardingStore)
    }
}
