import Foundation
@testable import NebulaTest

final class MockOnboardingStateStore: OnboardingStateStore {
    var hasCompletedOnboarding: Bool

    init(hasCompletedOnboarding: Bool = false) {
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
