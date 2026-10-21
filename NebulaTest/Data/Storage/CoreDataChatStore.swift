import CoreData

@MainActor
final class CoreDataChatStore: ChatStore {
    enum StoreError: Error {
        case chatNotFound
    }

    let changes: AsyncStream<Void>

    private let context: NSManagedObjectContext
    private let continuation: AsyncStream<Void>.Continuation

    init(container: NSPersistentContainer) {
        context = container.viewContext
        (changes, continuation) = AsyncStream.makeStream(of: Void.self)
    }

    func chats() throws -> [Chat] {
        let request = ChatEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ChatEntity.updatedAt, ascending: false)]
        return try context.fetch(request).map(Chat.init)
    }

    func chat(id: UUID) throws -> Chat? {
        try entity(id: id).map(Chat.init)
    }

    func messages(chatID: UUID) throws -> [ChatMessage] {
        let request = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "chat.id == %@", chatID as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MessageEntity.createdAt, ascending: true)]
        return try context.fetch(request).map(ChatMessage.init)
    }

    func createChat(id: UUID, title: String) throws -> Chat {
        let entity = ChatEntity(context: context)
        let now = Date.now
        entity.id = id
        entity.title = title
        entity.createdAt = now
        entity.updatedAt = now
        entity.isPinned = false
        try save()
        return Chat(entity)
    }

    func append(_ message: ChatMessage, to chatID: UUID) throws {
        let chat = try requireEntity(id: chatID)
        let entity = MessageEntity(context: context)
        entity.fill(from: message)
        entity.chat = chat
        chat.lastMessagePreview = message.text
        chat.updatedAt = message.createdAt
        try save()
    }

    func replaceLastAssistantMessage(with message: ChatMessage, in chatID: UUID) throws {
        let chat = try requireEntity(id: chatID)
        let request = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "chat.id == %@ AND role == %@", chatID as CVarArg, ChatMessage.Role.assistant.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MessageEntity.createdAt, ascending: false)]
        request.fetchLimit = 1
        let entity = try context.fetch(request).first ?? MessageEntity(context: context)
        entity.fill(from: message)
        entity.chat = chat
        chat.lastMessagePreview = message.text
        chat.updatedAt = message.createdAt
        try save()
    }

    func rename(chatID: UUID, title: String) throws {
        try requireEntity(id: chatID).title = title
        try save()
    }

    func setPinned(_ isPinned: Bool, chatID: UUID) throws {
        try requireEntity(id: chatID).isPinned = isPinned
        try save()
    }

    func deleteChat(id: UUID) throws {
        context.delete(try requireEntity(id: id))
        try save()
    }

    private func entity(id: UUID) throws -> ChatEntity? {
        let request = ChatEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func requireEntity(id: UUID) throws -> ChatEntity {
        guard let entity = try entity(id: id) else { throw StoreError.chatNotFound }
        return entity
    }

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
        continuation.yield()
    }
}

private extension Chat {
    init(_ entity: ChatEntity) {
        self.init(
            id: entity.id ?? UUID(),
            title: entity.title ?? "",
            createdAt: entity.createdAt ?? .now,
            updatedAt: entity.updatedAt ?? .now,
            isPinned: entity.isPinned,
            lastMessagePreview: entity.lastMessagePreview
        )
    }
}

private extension ChatMessage {
    init(_ entity: MessageEntity) {
        self.init(
            id: entity.id ?? UUID(),
            role: Role(rawValue: entity.role ?? "") ?? .assistant,
            text: entity.text ?? "",
            createdAt: entity.createdAt ?? .now
        )
    }
}

private extension MessageEntity {
    func fill(from message: ChatMessage) {
        id = message.id
        role = message.role.rawValue
        text = message.text
        createdAt = message.createdAt
    }
}
