import Combine
import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    @Published private(set) var isPremium: Bool

    private let subscriptionService: SubscriptionService

    init(subscriptionService: SubscriptionService) {
        self.subscriptionService = subscriptionService
        isPremium = subscriptionService.isPremium
    }

    func observePremiumStatus() async {
        isPremium = subscriptionService.isPremium
        for await isPremium in subscriptionService.premiumUpdates {
            self.isPremium = isPremium
        }
    }
}
