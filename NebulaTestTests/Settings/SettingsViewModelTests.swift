import XCTest
@testable import NebulaTest

@MainActor
final class SettingsViewModelTests: XCTestCase {
    private let subscriptions = MockSubscriptionService()

    private func makeViewModel() -> SettingsViewModel {
        let defaults = UserDefaults(suiteName: "SettingsViewModelTests") ?? .standard
        defaults.removePersistentDomain(forName: "SettingsViewModelTests")
        return SettingsViewModel(subscriptionService: subscriptions, cache: AppCache(), defaults: defaults)
    }

    func testRestoreSuccessShowsToast() async {
        let viewModel = makeViewModel()

        await viewModel.restore()

        XCTAssertEqual(viewModel.toast?.style, .success)
        XCTAssertFalse(viewModel.isRestoring)
    }

    func testRestoreFailureShowsErrorToast() async {
        subscriptions.restoreError = SubscriptionError.paywallNotFound
        let viewModel = makeViewModel()

        await viewModel.restore()

        XCTAssertEqual(viewModel.toast?.style, .error)
    }

    func testDisablingNotificationsDoesNotRequestPermission() async {
        let viewModel = makeViewModel()

        await viewModel.setNotifications(false)

        XCTAssertFalse(viewModel.notificationsEnabled)
    }
}
