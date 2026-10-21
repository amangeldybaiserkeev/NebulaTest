import Foundation
@testable import NebulaTest

// swiftlint:disable force_unwrapping

final class MockVideoAPI: VideoAPI, @unchecked Sendable {
    struct StartCall: Equatable {
        let templateID: Int
        let quality: String
        let imageSize: Int
    }

    var templatesResult: Result<[VideoTemplate], Error> = .success([])
    var startResult: Result<Int, Error> = .success(1)
    var statuses: [GenerationStatus] = [.success(URL(string: "https://example.com/video.mp4")!)]
    private(set) var startCalls: [StartCall] = []
    private(set) var statusCalls = 0

    func templates() async throws -> [VideoTemplate] {
        try templatesResult.get()
    }

    func startGeneration(templateID: Int, image: Data, quality: String) async throws -> Int {
        startCalls.append(StartCall(templateID: templateID, quality: quality, imageSize: image.count))
        return try startResult.get()
    }

    func generationStatus(id: Int) async throws -> GenerationStatus {
        statusCalls += 1
        return statuses.count > 1 ? statuses.removeFirst() : statuses[0]
    }
}

extension VideoTemplate {
    static func stub(
        id: Int = 1,
        category: String = "📈 Trending",
        qualities: [String] = ["360p", "720p", "1080p"]
    ) -> VideoTemplate {
        VideoTemplate(
            id: id,
            providerID: id * 100,
            name: "Template \(id)",
            category: category,
            qualities: qualities,
            previewURL: URL(string: "https://example.com/\(id).mp4")!
        )
    }
}

// swiftlint:enable force_unwrapping
