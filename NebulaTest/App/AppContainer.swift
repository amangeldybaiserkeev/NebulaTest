import Foundation

@MainActor
final class AppContainer {
    let onboardingStore: OnboardingStateStore
    let subscriptionService: SubscriptionService
    let chatAPI: ChatAPI
    let chatStore: ChatStore

    init() {
        onboardingStore = UserDefaultsOnboardingStateStore()
        let subscriptionService = ApphudSubscriptionService(
            apiKey: AppConfig.Apphud.apiKey,
            paywallID: AppConfig.Apphud.paywallID
        )
        self.subscriptionService = subscriptionService

        let chatClient = URLSessionHTTPClient(
            configuration: APIConfiguration(
                baseURL: AppConfig.API.chatBaseURL,
                bearerToken: AppConfig.API.bearerToken,
                applicationID: AppConfig.API.applicationID,
                userID: { MainActor.assumeIsolated { subscriptionService.userID } }
            )
        )
        chatAPI = DolaChatAPI(client: chatClient)
        chatStore = CoreDataChatStore(container: PersistenceController().container)
    }

    func makeRootViewModel() -> RootViewModel {
        RootViewModel(onboardingStore: onboardingStore)
    }

    func makePaywallViewModel() -> PaywallViewModel {
        PaywallViewModel(subscriptionService: subscriptionService)
    }

    func makeMainViewModel() -> MainViewModel {
        MainViewModel(subscriptionService: subscriptionService)
    }

    func makeChatViewModel(chatID: UUID?) -> ChatViewModel {
        ChatViewModel(chatID: chatID, api: chatAPI, store: chatStore, subscriptionService: subscriptionService)
    }
}
