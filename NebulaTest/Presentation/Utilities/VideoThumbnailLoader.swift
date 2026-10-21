import AVFoundation
import UIKit

actor VideoThumbnailLoader {
    static let directory = URL.cachesDirectory.appending(path: "VideoThumbnails")

    private let memory = NSCache<NSURL, UIImage>()
    private var inFlight: [URL: Task<UIImage?, Never>] = [:]

    private let maximumSide: Double = 600
    private let compressionQuality: Double = 0.8

    init() {
        try? FileManager.default.createDirectory(at: Self.directory, withIntermediateDirectories: true)
    }

    func thumbnail(for url: URL) async -> UIImage? {
        if let cached = memory.object(forKey: url as NSURL) { return cached }
        if let task = inFlight[url] { return await task.value }
        let task = Task { await load(url) }
        inFlight[url] = task
        let image = await task.value
        inFlight[url] = nil
        if let image { memory.setObject(image, forKey: url as NSURL) }
        return image
    }

    private func load(_ url: URL) async -> UIImage? {
        let file = Self.directory.appending(path: url.lastPathComponent).appendingPathExtension("jpg")
        if let data = try? Data(contentsOf: file), let image = UIImage(data: data) { return image }

        let generator = AVAssetImageGenerator(asset: AVURLAsset(url: url))
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: maximumSide, height: maximumSide)
        guard let cgImage = try? await generator.image(at: .zero).image else { return nil }
        let image = UIImage(cgImage: cgImage)
        try? image.jpegData(compressionQuality: compressionQuality)?.write(to: file)
        return image
    }
}
