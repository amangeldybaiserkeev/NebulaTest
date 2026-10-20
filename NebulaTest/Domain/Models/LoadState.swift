import Foundation

enum LoadState<Value: Equatable>: Equatable {
    case idle
    case loading
    case loaded(Value)
    case failed(message: String)

    var value: Value? {
        if case .loaded(let value) = self { value } else { nil }
    }

    var isLoading: Bool {
        if case .loading = self { true } else { false }
    }
}
