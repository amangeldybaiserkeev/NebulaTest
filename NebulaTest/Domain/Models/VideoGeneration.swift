import Foundation

struct VideoGeneration: Identifiable, Equatable {
    enum Status: Equatable {
        case generating
        case finished(URL)
        case failed(String)
    }

    let id: UUID
    var remoteID: Int?
    let templateID: Int
    let templateName: String
    let format: VideoFormat
    let quality: String
    var status: Status
    let createdAt: Date
    var isNew: Bool

    var videoURL: URL? {
        if case .finished(let url) = status { url } else { nil }
    }
}
