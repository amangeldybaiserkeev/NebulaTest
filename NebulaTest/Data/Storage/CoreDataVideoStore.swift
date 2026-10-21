import CoreData

@MainActor
final class CoreDataVideoStore: VideoStore {
    enum StoreError: Error {
        case generationNotFound
    }

    let changes: AsyncStream<Void>

    private let context: NSManagedObjectContext
    private let continuation: AsyncStream<Void>.Continuation

    init(container: NSPersistentContainer) {
        context = container.viewContext
        (changes, continuation) = AsyncStream.makeStream(of: Void.self)
    }

    func generations() throws -> [VideoGeneration] {
        let request = VideoEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \VideoEntity.createdAt, ascending: false)]
        return try context.fetch(request).map(VideoGeneration.init)
    }

    func generation(id: UUID) throws -> VideoGeneration? {
        try entity(id: id).map(VideoGeneration.init)
    }

    func imageData(id: UUID) throws -> Data? {
        try entity(id: id)?.image
    }

    func insert(_ generation: VideoGeneration, image: Data) throws {
        let entity = VideoEntity(context: context)
        entity.id = generation.id
        entity.templateID = Int64(generation.templateID)
        entity.templateName = generation.templateName
        entity.format = generation.format.rawValue
        entity.quality = generation.quality
        entity.createdAt = generation.createdAt
        entity.image = image
        entity.apply(generation)
        try save()
    }

    func update(_ generation: VideoGeneration) throws {
        try requireEntity(id: generation.id).apply(generation)
        try save()
    }

    func delete(id: UUID) throws {
        context.delete(try requireEntity(id: id))
        try save()
    }

    private func entity(id: UUID) throws -> VideoEntity? {
        let request = VideoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func requireEntity(id: UUID) throws -> VideoEntity {
        guard let entity = try entity(id: id) else { throw StoreError.generationNotFound }
        return entity
    }

    private func save() throws {
        guard context.hasChanges else { return }
        try context.save()
        continuation.yield()
    }
}

private enum StoredStatus: String {
    case generating
    case finished
    case failed
}

private extension VideoEntity {
    func apply(_ generation: VideoGeneration) {
        remoteID = generation.remoteID.map(NSNumber.init(value:))
        isNew = generation.isNew
        switch generation.status {
        case .generating:
            status = StoredStatus.generating.rawValue
            videoURL = nil
            errorMessage = nil
        case .finished(let url):
            status = StoredStatus.finished.rawValue
            videoURL = url
            errorMessage = nil
        case .failed(let message):
            status = StoredStatus.failed.rawValue
            videoURL = nil
            errorMessage = message
        }
    }
}

private extension VideoGeneration {
    init(_ entity: VideoEntity) {
        let status: Status = switch StoredStatus(rawValue: entity.status ?? "") {
        case .finished: entity.videoURL.map(Status.finished) ?? .failed("")
        case .failed: .failed(entity.errorMessage ?? "")
        case .generating, nil: .generating
        }
        self.init(
            id: entity.id ?? UUID(),
            remoteID: entity.remoteID?.intValue,
            templateID: Int(entity.templateID),
            templateName: entity.templateName ?? "",
            format: VideoFormat(rawValue: entity.format ?? "") ?? .landscape,
            quality: entity.quality ?? "",
            status: status,
            createdAt: entity.createdAt ?? .now,
            isNew: entity.isNew
        )
    }
}
