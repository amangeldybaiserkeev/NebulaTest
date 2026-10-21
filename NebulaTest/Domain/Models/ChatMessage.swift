import Foundation

struct ChatMessage: Identifiable, Equatable {
    enum Role: String {
        case user
        case assistant
    }

    let id: UUID
    let role: Role
    let text: String
    let createdAt: Date
}
