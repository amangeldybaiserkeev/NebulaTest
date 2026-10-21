import XCTest
@testable import NebulaTest

@MainActor
final class ChatViewModelTests: XCTestCase {
    private let api = MockChatAPI()
    private let store = CoreDataChatStore(container: PersistenceController(inMemory: true).container)
    private let subscriptions = MockSubscriptionService()

    override func setUp() {
        super.setUp()
        subscriptions.isPremium = true
    }

    private func makeViewModel(chatID: UUID? = nil) -> ChatViewModel {
        ChatViewModel(chatID: chatID, api: api, store: store, subscriptionService: subscriptions)
    }

    func testSendAppendsUserAndAssistantMessagesAndPersistsChat() async throws {
        let viewModel = makeViewModel()
        viewModel.draft = "Hello"

        await viewModel.send()

        XCTAssertEqual(viewModel.messages.map(\.role), [.user, .assistant])
        XCTAssertEqual(viewModel.messages.last?.text, "Sandbox reply")
        XCTAssertEqual(api.sentMessages, ["Hello"])
        XCTAssertEqual(try store.chats().count, 1)
        XCTAssertEqual(try store.chats().first?.title, "Hello")
    }

    func testSendWithoutSubscriptionOpensPaywallAndKeepsDraft() async {
        subscriptions.isPremium = false
        let viewModel = makeViewModel()
        viewModel.draft = "Hello"

        await viewModel.send()

        XCTAssertTrue(viewModel.isPaywallPresented)
        XCTAssertEqual(viewModel.draft, "Hello")
        XCTAssertTrue(viewModel.messages.isEmpty)
        XCTAssertTrue(api.sentMessages.isEmpty)
    }

    func testCannotSendEmptyDraft() {
        let viewModel = makeViewModel()
        viewModel.draft = "   "

        XCTAssertFalse(viewModel.canSend)
    }

    func testRegenerateReplacesLastAssistantMessage() async {
        let viewModel = makeViewModel()
        viewModel.draft = "Hello"
        await viewModel.send()
        api.reply = "Second reply"

        await viewModel.regenerate()

        XCTAssertEqual(viewModel.messages.count, 2)
        XCTAssertEqual(viewModel.messages.last?.text, "Second reply")
        XCTAssertEqual(api.sentMessages, ["Hello", "Hello"])
    }

    func testAPIErrorShowsToastAndKeepsUserMessage() async {
        api.error = APIError.server(statusCode: 500)
        let viewModel = makeViewModel()
        viewModel.draft = "Hello"

        await viewModel.send()

        XCTAssertEqual(viewModel.messages.map(\.role), [.user])
        XCTAssertEqual(viewModel.toast?.style, .error)
        XCTAssertFalse(viewModel.isGenerating)
    }

    func testDeleteRemovesChatFromStore() async throws {
        let viewModel = makeViewModel()
        viewModel.draft = "Hello"
        await viewModel.send()

        viewModel.deleteChat()

        XCTAssertTrue(viewModel.isDeleted)
        XCTAssertEqual(try store.chats().count, 0)
    }

    func testReopeningChatRestoresHistory() async throws {
        let first = makeViewModel()
        first.draft = "Hello"
        await first.send()
        let chatID = try XCTUnwrap(try store.chats().first?.id)

        let reopened = makeViewModel(chatID: chatID)
        reopened.load()

        XCTAssertEqual(reopened.messages.count, 2)
        XCTAssertEqual(reopened.chat?.title, "Hello")
    }
}
