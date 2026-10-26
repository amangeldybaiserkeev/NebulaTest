import XCTest
@testable import NebulaTest

@MainActor
final class ChatStoreChangesTests: XCTestCase {
    func testEverySubscriberReceivesChanges() async throws {
        let store = CoreDataChatStore(container: PersistenceController(inMemory: true).container)
        var first = store.changes.makeAsyncIterator()
        var second = store.changes.makeAsyncIterator()

        _ = try store.createChat(id: UUID(), title: "Hi")

        let firstChange = await first.next()
        let secondChange = await second.next()
        XCTAssertNotNil(firstChange)
        XCTAssertNotNil(secondChange)
    }

    func testCancelledSubscriberDoesNotSilenceOthers() async throws {
        let store = CoreDataChatStore(container: PersistenceController(inMemory: true).container)
        let cancelled = Task { for await _ in store.changes {} }
        cancelled.cancel()
        _ = await cancelled.value

        var iterator = store.changes.makeAsyncIterator()
        _ = try store.createChat(id: UUID(), title: "Hi")

        let change = await iterator.next()
        XCTAssertNotNil(change)
    }
}
