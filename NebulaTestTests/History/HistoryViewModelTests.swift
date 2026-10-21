import XCTest
@testable import NebulaTest

@MainActor
final class HistoryViewModelTests: XCTestCase {
    private let persistence = PersistenceController(inMemory: true)
    private lazy var chatStore = CoreDataChatStore(container: persistence.container)
    private lazy var manager = VideoGenerationManager(
        api: MockVideoAPI(),
        store: CoreDataVideoStore(container: persistence.container)
    )

    private func makeViewModel() -> HistoryViewModel {
        HistoryViewModel(chatStore: chatStore, generationManager: manager)
    }

    func testRenameUpdatesChatTitle() throws {
        let chat = try chatStore.createChat(id: UUID(), title: "Old")
        let viewModel = makeViewModel()

        viewModel.beginRename(chat)
        XCTAssertEqual(viewModel.renameTitle, "Old")
        viewModel.renameTitle = "  New  "
        viewModel.confirmRename()
        viewModel.load()

        XCTAssertEqual(try chatStore.chat(id: chat.id)?.title, "New")
        XCTAssertEqual(viewModel.sections.first?.chats.first?.title, "New")
    }

    func testRenameIsBlockedForEmptyTitle() throws {
        let chat = try chatStore.createChat(id: UUID(), title: "Old")
        let viewModel = makeViewModel()

        viewModel.beginRename(chat)
        viewModel.renameTitle = "   "

        XCTAssertFalse(viewModel.canSaveRename)
        viewModel.confirmRename()
        XCTAssertEqual(try chatStore.chat(id: chat.id)?.title, "Old")
    }

    func testDeleteRemovesChat() throws {
        let chat = try chatStore.createChat(id: UUID(), title: "Chat")
        let viewModel = makeViewModel()

        viewModel.chatToDelete = chat
        viewModel.confirmDelete()
        viewModel.load()

        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertNil(try chatStore.chat(id: chat.id))
    }
}
