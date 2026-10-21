import Foundation

enum APIError: LocalizedError, Equatable {
    case invalidURL
    case network(String)
    case unauthorized
    case insufficientCredits
    case notFound
    case server(statusCode: Int)
    case decoding

    var errorDescription: String? {
        switch self {
        case .invalidURL: "The request address is invalid."
        case .network(let message): message
        case .unauthorized: "Authorization failed. Please try again later."
        case .insufficientCredits: "Not enough credits to complete this request."
        case .notFound: "The requested resource was not found."
        case .server(let statusCode): "Server error (\(statusCode)). Please try again."
        case .decoding: "Unexpected response from the server."
        }
    }
}
