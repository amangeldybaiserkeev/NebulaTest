import Foundation

struct Endpoint {
    let path: String
    var method: HTTPMethod = .get
    var query: [String: String] = [:]
    var body: RequestBody = .none
}
