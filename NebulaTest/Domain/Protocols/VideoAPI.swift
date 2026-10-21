import Foundation

protocol VideoAPI: Sendable {
    func templates() async throws -> [VideoTemplate]
    func startGeneration(templateID: Int, image: Data, quality: String) async throws -> Int
    func generationStatus(id: Int) async throws -> GenerationStatus
}
