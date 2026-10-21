import Foundation

struct SendMessageRequestDTO: Encodable {
    let message: String
}

struct SendMessageResponseDTO: Decodable {
    let chatId: String
    let assistantMessage: String

    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case assistantMessage = "assistant_message"
    }
}
