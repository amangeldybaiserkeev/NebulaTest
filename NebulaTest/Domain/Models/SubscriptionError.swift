import Foundation

enum SubscriptionError: LocalizedError, Equatable {
    case paywallNotFound
    case productUnavailable
    case purchaseFailed
    case restoreFailed
    case nothingToRestore

    var errorDescription: String? {
        switch self {
        case .paywallNotFound: "Subscription plans are unavailable right now."
        case .productUnavailable: "This plan is unavailable. Please try another one."
        case .purchaseFailed: "Purchase failed. Please try again."
        case .restoreFailed: "Couldn’t restore purchases. Please try again."
        case .nothingToRestore: "No active subscription found for this account."
        }
    }
}
