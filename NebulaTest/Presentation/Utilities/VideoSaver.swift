import Foundation
import Photos

struct VideoSaver {
    enum SaveError: Error {
        case notAuthorized
    }

    func localFile(for remoteURL: URL) async throws -> URL {
        let destination = URL.temporaryDirectory.appending(path: remoteURL.lastPathComponent)
        if FileManager.default.fileExists(atPath: destination.path()) {
            return destination
        }
        let (downloaded, _) = try await URLSession.shared.download(from: remoteURL)
        try FileManager.default.moveItem(at: downloaded, to: destination)
        return destination
    }

    func saveToPhotos(_ remoteURL: URL) async throws {
        let file = try await localFile(for: remoteURL)
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        guard status == .authorized || status == .limited else { throw SaveError.notAuthorized }
        try await PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: file)
        }
    }
}
