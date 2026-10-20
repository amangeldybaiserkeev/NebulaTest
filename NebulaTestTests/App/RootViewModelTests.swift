import XCTest
@testable import NebulaTest

@MainActor
final class RootViewModelTests: XCTestCase {
    func testFirstLaunchGoesToOnboardingAfterSplash() async {
        let store = MockOnboardingStateStore(hasCompletedOnboarding: false)
        let viewModel = RootViewModel(onboardingStore: store)

        await viewModel.start()

        XCTAssertEqual(viewModel.phase, .onboarding)
    }

    func testReturningUserSkipsOnboarding() async {
        let store = MockOnboardingStateStore(hasCompletedOnboarding: true)
        let viewModel = RootViewModel(onboardingStore: store)

        await viewModel.start()

        XCTAssertEqual(viewModel.phase, .main)
    }

    func testCompletingOnboardingPersistsAndShowsPaywall() {
        let store = MockOnboardingStateStore()
        let viewModel = RootViewModel(onboardingStore: store)

        viewModel.completeOnboarding()

        XCTAssertTrue(store.hasCompletedOnboarding)
        XCTAssertEqual(viewModel.phase, .paywall)
    }
}
