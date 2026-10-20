import Foundation

@MainActor
final class AppContainer {
    let onboardingStore: OnboardingStateStore
    let subscriptionService: SubscriptionService

    init() {
        onboardingStore = UserDefaultsOnboardingStateStore()
        subscriptionService = ApphudSubscriptionService(
            apiKey: AppConfig.Apphud.apiKey,
            paywallID: AppConfig.Apphud.paywallID
        )
    }

    func makeRootViewModel() -> RootViewModel {
        RootViewModel(onboardingStore: onboardingStore)
    }

    func makePaywallViewModel() -> PaywallViewModel {
        PaywallViewModel(subscriptionService: subscriptionService)
    }
}
