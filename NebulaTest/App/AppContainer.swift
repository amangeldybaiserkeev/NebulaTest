import Foundation

@MainActor
final class AppContainer {
    let onboardingStore: OnboardingStateStore
    let subscriptionService: SubscriptionService
    let chatAPI: ChatAPI
    let chatStore: ChatStore
    let videoStore: VideoStore
    let templateCatalog: TemplateCatalog
    let generationManager: VideoGenerationManager
    let thumbnailLoader: VideoThumbnailLoader

    init() {
        onboardingStore = UserDefaultsOnboardingStateStore()
        let subscriptionService = ApphudSubscriptionService(
            apiKey: AppConfig.Apphud.apiKey,
            paywallID: AppConfig.Apphud.paywallID
        )
        self.subscriptionService = subscriptionService

        func makeClient(baseURL: URL) -> HTTPClient {
            URLSessionHTTPClient(
                configuration: APIConfiguration(
                    baseURL: baseURL,
                    bearerToken: AppConfig.API.bearerToken,
                    applicationID: AppConfig.API.applicationID,
                    userID: { MainActor.assumeIsolated { subscriptionService.userID } }
                )
            )
        }
        chatAPI = DolaChatAPI(client: makeClient(baseURL: AppConfig.API.chatBaseURL))
        let videoAPI = PixverseVideoAPI(
            client: makeClient(baseURL: AppConfig.API.videoBaseURL),
            applicationID: AppConfig.API.applicationID
        )

        let persistence = PersistenceController()
        chatStore = CoreDataChatStore(container: persistence.container)
        videoStore = CoreDataVideoStore(container: persistence.container)
        templateCatalog = TemplateCatalog(api: videoAPI)
        generationManager = VideoGenerationManager(api: videoAPI, store: videoStore)
        thumbnailLoader = VideoThumbnailLoader()
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

    func makeTemplatesViewModel() -> TemplatesViewModel {
        TemplatesViewModel(catalog: templateCatalog)
    }

    func makeTemplatePreviewViewModel(templateID: Int, category: String) -> TemplatePreviewViewModel {
        TemplatePreviewViewModel(
            templates: templateCatalog.templates(in: category),
            selectedTemplateID: templateID,
            generationManager: generationManager,
            subscriptionService: subscriptionService
        )
    }

    func makeHistoryViewModel() -> HistoryViewModel {
        HistoryViewModel(chatStore: chatStore, generationManager: generationManager)
    }

    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(subscriptionService: subscriptionService, cache: AppCache())
    }

    func makeVideoResultViewModel(generationID: UUID) -> VideoResultViewModel {
        VideoResultViewModel(generationID: generationID, generationManager: generationManager, saver: VideoSaver())
    }
}
