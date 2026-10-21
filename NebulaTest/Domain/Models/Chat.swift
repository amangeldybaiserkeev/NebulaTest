import Foundation

struct Chat: Identifiable, Equatable {
    let id: UUID
    var title: String
    let createdAt: Date
    var updatedAt: Date
    var isPinned: Bool
    var lastMessagePreview: String?
}
