import Foundation

enum GenerationStatus: Equatable {
    case generating
    case success(URL)
    case error
}
