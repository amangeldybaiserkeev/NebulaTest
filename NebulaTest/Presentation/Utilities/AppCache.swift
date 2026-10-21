import Foundation

struct AppCache {
    private let directories = [VideoThumbnailLoader.directory, URL.temporaryDirectory]

    func size() -> Int64 {
        files().reduce(into: Int64.zero) { total, file in
            let size = (try? file.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
            total += Int64(size)
        }
    }

    func clear() {
        for file in files() {
            try? FileManager.default.removeItem(at: file)
        }
    }

    private func files() -> [URL] {
        directories.flatMap { directory in
            (try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.fileSizeKey])) ?? []
        }
    }
}
