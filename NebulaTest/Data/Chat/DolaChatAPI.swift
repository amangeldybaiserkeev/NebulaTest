import Foundation

final class DolaChatAPI: ChatAPI {
    private let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func sendMessage(_ text: String, chatID: UUID) async throws -> String {
        let endpoint = Endpoint(
            path: "dola/chats/\(chatID.uuidString)/messages",
            method: .post,
            body: .json(SendMessageRequestDTO(message: text))
        )
        let response: SendMessageResponseDTO = try await client.send(endpoint)
        return response.assistantMessage
    }
}
