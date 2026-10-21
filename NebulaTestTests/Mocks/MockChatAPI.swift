import Foundation
@testable import NebulaTest

final class MockChatAPI: ChatAPI, @unchecked Sendable {
    var reply = "Sandbox reply"
    var error: Error?
    private(set) var sentMessages: [String] = []

    func sendMessage(_ text: String, chatID: UUID) async throws -> String {
        sentMessages.append(text)
        if let error { throw error }
        return reply
    }
}
