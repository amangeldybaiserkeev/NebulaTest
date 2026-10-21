import Foundation

struct VideoTemplate: Identifiable, Hashable {
    let id: Int
    let providerID: Int
    let name: String
    let category: String
    let qualities: [String]
    let previewURL: URL
}
