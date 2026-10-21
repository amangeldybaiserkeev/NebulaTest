import Combine
import Foundation

@MainActor
final class VideoResultViewModel: ObservableObject {
    @Published private(set) var generation: VideoGeneration?
    @Published var isPlaying = false
    @Published var notice: Toast?
    @Published var shareURL: URL?
    @Published private(set) var isBusy = false

    private let saver: VideoSaver

    init(generationID: UUID, generationManager: VideoGenerationManager, saver: VideoSaver) {
        self.saver = saver
        generation = generationManager.generation(id: generationID)
        generationManager.markSeen(id: generationID)
    }

    var videoURL: URL? {
        generation?.videoURL
    }

    var format: VideoFormat {
        generation?.format ?? .landscape
    }

    func togglePlayback() {
        isPlaying.toggle()
    }

    func download() async {
        guard let videoURL, !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        do {
            try await saver.saveToPhotos(videoURL)
            notice = Toast(style: .success, title: "Video saved", subtitle: "You can find it in your Photos")
        } catch {
            notice = Toast(style: .error, title: "Couldn’t save video", subtitle: "Please try again")
        }
    }

    func share() async {
        guard let videoURL, !isBusy else { return }
        isBusy = true
        defer { isBusy = false }
        do {
            shareURL = try await saver.localFile(for: videoURL)
        } catch {
            notice = Toast(style: .error, title: "Couldn’t share video", subtitle: "Please try again")
        }
    }
}
