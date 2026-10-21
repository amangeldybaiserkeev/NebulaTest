import Combine
import Foundation

@MainActor
final class VideoGenerationManager: ObservableObject {
    @Published private(set) var generations: [VideoGeneration] = []

    private let api: VideoAPI
    private let store: VideoStore
    private let pollInterval: Duration
    private var pollers: [UUID: Task<Void, Never>] = [:]

    init(api: VideoAPI, store: VideoStore, pollInterval: Duration = VideoGenerationManager.defaultPollInterval) {
        self.api = api
        self.store = store
        self.pollInterval = pollInterval
        reload()
        resumePending()
    }

    func generation(id: UUID) -> VideoGeneration? {
        generations.first { $0.id == id }
    }

    func start(template: VideoTemplate, image: Data, format: VideoFormat, quality: String) throws -> VideoGeneration {
        let generation = VideoGeneration(
            id: UUID(),
            remoteID: nil,
            templateID: template.providerID,
            templateName: template.name,
            format: format,
            quality: quality,
            status: .generating,
            createdAt: .now,
            isNew: true
        )
        try store.insert(generation, image: image)
        reload()
        track(generation, image: image)
        return generation
    }

    func retry(id: UUID) throws {
        guard var generation = try store.generation(id: id), let image = try store.imageData(id: id) else { return }
        generation.status = .generating
        generation.remoteID = nil
        generation.isNew = true
        try store.update(generation)
        reload()
        track(generation, image: image)
    }

    func markSeen(id: UUID) {
        guard var generation = generation(id: id), generation.isNew else { return }
        generation.isNew = false
        try? store.update(generation)
        reload()
    }

    func delete(id: UUID) throws {
        pollers[id]?.cancel()
        pollers[id] = nil
        try store.delete(id: id)
        reload()
    }

    private func resumePending() {
        for generation in generations where generation.status == .generating {
            let image = (try? store.imageData(id: generation.id)) ?? Data()
            track(generation, image: image)
        }
    }

    private func track(_ generation: VideoGeneration, image: Data) {
        pollers[generation.id]?.cancel()
        pollers[generation.id] = Task { [weak self] in
            await self?.run(generation, image: image)
        }
    }

    private func run(_ generation: VideoGeneration, image: Data) async {
        var generation = generation
        do {
            if generation.remoteID == nil {
                generation.remoteID = try await api.startGeneration(
                    templateID: generation.templateID,
                    image: image,
                    quality: generation.quality
                )
                try store.update(generation)
                reload()
            }
            guard let remoteID = generation.remoteID else { return }
            while !Task.isCancelled {
                switch try await api.generationStatus(id: remoteID) {
                case .generating:
                    try await Task.sleep(for: pollInterval)
                case .success(let url):
                    return finish(generation, with: .finished(url))
                case .error:
                    return finish(generation, with: .failed("Something went wrong"))
                }
            }
        } catch is CancellationError {
            return
        } catch {
            finish(generation, with: .failed(error.localizedDescription))
        }
    }

    private func finish(_ generation: VideoGeneration, with status: VideoGeneration.Status) {
        var generation = generation
        generation.status = status
        try? store.update(generation)
        pollers[generation.id] = nil
        reload()
    }

    private func reload() {
        generations = (try? store.generations()) ?? []
    }
}

extension VideoGenerationManager {
    nonisolated static let defaultPollInterval: Duration = .seconds(defaultPollSeconds)
    nonisolated private static let defaultPollSeconds = 3
}
