import Foundation

@MainActor
protocol ChatStore: AnyObject {
    var changes: AsyncStream<Void> { get }

    func chats() throws -> [Chat]
    func chat(id: UUID) throws -> Chat?
    func messages(chatID: UUID) throws -> [ChatMessage]
    func createChat(id: UUID, title: String) throws -> Chat
    func append(_ message: ChatMessage, to chatID: UUID) throws
    func replaceLastAssistantMessage(with message: ChatMessage, in chatID: UUID) throws
    func rename(chatID: UUID, title: String) throws
    func setPinned(_ isPinned: Bool, chatID: UUID) throws
    func deleteChat(id: UUID) throws
}
