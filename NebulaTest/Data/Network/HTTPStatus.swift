import Foundation

enum HTTPStatus {
    static let success = 200..<300
    static let unauthorized = 401
    static let paymentRequired = 402
    static let forbidden = 403
    static let notFound = 404
}
