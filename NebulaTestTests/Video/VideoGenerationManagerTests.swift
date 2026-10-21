import XCTest
@testable import NebulaTest

// swiftlint:disable force_unwrapping

@MainActor
final class VideoGenerationManagerTests: XCTestCase {
    private let api = MockVideoAPI()
    private let store = CoreDataVideoStore(container: PersistenceController(inMemory: true).container)

    private func makeManager() -> VideoGenerationManager {
        VideoGenerationManager(api: api, store: store, pollInterval: .milliseconds(10))
    }

    private func waitUntilFinished(_ manager: VideoGenerationManager, id: UUID) async {
        for _ in 0..<100 where manager.generation(id: id)?.status == .generating {
            try? await Task.sleep(for: .milliseconds(10))
        }
    }

    func testStartPersistsGenerationAndPollsUntilSuccess() async throws {
        api.statuses = [.generating, .generating, .success(URL(string: "https://example.com/done.mp4")!)]
        let manager = makeManager()

        let generation = try manager.start(template: .stub(), image: Data([1, 2, 3]), format: .square, quality: "720p")
        await waitUntilFinished(manager, id: generation.id)

        XCTAssertEqual(api.startCalls.count, 1)
        XCTAssertEqual(api.startCalls.first?.templateID, 100)
        XCTAssertEqual(api.startCalls.first?.quality, "720p")
        XCTAssertEqual(api.statusCalls, 3)
        XCTAssertEqual(manager.generation(id: generation.id)?.videoURL?.lastPathComponent, "done.mp4")
        XCTAssertEqual(try store.generation(id: generation.id)?.remoteID, 1)
        XCTAssertEqual(try store.imageData(id: generation.id), Data([1, 2, 3]))
    }

    func testFailedStartMarksGenerationAsFailed() async throws {
        api.startResult = .failure(APIError.insufficientCredits)
        let manager = makeManager()

        let generation = try manager.start(template: .stub(), image: Data(), format: .landscape, quality: "1080p")
        await waitUntilFinished(manager, id: generation.id)

        XCTAssertEqual(manager.generation(id: generation.id)?.status, .failed(APIError.insufficientCredits.localizedDescription))
    }

    func testRetryRestartsFailedGeneration() async throws {
        api.statuses = [.error]
        let manager = makeManager()
        let generation = try manager.start(template: .stub(), image: Data([9]), format: .portrait, quality: "720p")
        await waitUntilFinished(manager, id: generation.id)
        XCTAssertEqual(manager.generation(id: generation.id)?.status, .failed("Something went wrong"))

        api.statuses = [.success(URL(string: "https://example.com/retry.mp4")!)]
        try manager.retry(id: generation.id)
        await waitUntilFinished(manager, id: generation.id)

        XCTAssertEqual(api.startCalls.count, 2)
        XCTAssertEqual(manager.generation(id: generation.id)?.videoURL?.lastPathComponent, "retry.mp4")
    }

    func testPendingGenerationResumesPollingOnLaunch() async throws {
        api.statuses = [.generating]
        let first = makeManager()
        let generation = try first.start(template: .stub(), image: Data(), format: .square, quality: "720p")
        try? await Task.sleep(for: .milliseconds(30))

        api.statuses = [.success(URL(string: "https://example.com/resumed.mp4")!)]
        let second = makeManager()
        await waitUntilFinished(second, id: generation.id)

        XCTAssertEqual(second.generation(id: generation.id)?.videoURL?.lastPathComponent, "resumed.mp4")
    }

    func testMarkSeenClearsNewFlag() async throws {
        let manager = makeManager()
        let generation = try manager.start(template: .stub(), image: Data(), format: .square, quality: "720p")
        XCTAssertTrue(manager.generation(id: generation.id)?.isNew ?? false)

        manager.markSeen(id: generation.id)

        XCTAssertFalse(manager.generation(id: generation.id)?.isNew ?? true)
    }
}

// swiftlint:enable force_unwrapping
