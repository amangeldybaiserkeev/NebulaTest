import Foundation

protocol OnboardingStateStore: AnyObject {
    var hasCompletedOnboarding: Bool { get set }
}
