import Foundation

@MainActor
protocol VideoStore: AnyObject {
    var changes: AsyncStream<Void> { get }

    func generations() throws -> [VideoGeneration]
    func generation(id: UUID) throws -> VideoGeneration?
    func imageData(id: UUID) throws -> Data?
    func insert(_ generation: VideoGeneration, image: Data) throws
    func update(_ generation: VideoGeneration) throws
    func delete(id: UUID) throws
}
