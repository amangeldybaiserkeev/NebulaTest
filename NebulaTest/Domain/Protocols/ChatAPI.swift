import Foundation

protocol ChatAPI: Sendable {
    func sendMessage(_ text: String, chatID: UUID) async throws -> String
}
