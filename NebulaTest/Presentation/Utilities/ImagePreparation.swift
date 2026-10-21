import UIKit

enum ImagePreparation {
    struct Prepared {
        let image: UIImage
        let jpeg: Data
    }

    private static let maxDimension: Double = 1280
    private static let compressionQuality: Double = 0.8

    static func prepare(_ data: Data) async -> Prepared? {
        await Task.detached(priority: .userInitiated) {
            guard let source = UIImage(data: data) else { return nil }
            let scale = min(1, maxDimension / max(source.size.width, source.size.height))
            let size = CGSize(width: source.size.width * scale, height: source.size.height * scale)
            let format = UIGraphicsImageRendererFormat()
            format.scale = 1
            let image = UIGraphicsImageRenderer(size: size, format: format).image { _ in
                source.draw(in: CGRect(origin: .zero, size: size))
            }
            guard let jpeg = image.jpegData(compressionQuality: compressionQuality) else { return nil }
            return Prepared(image: image, jpeg: jpeg)
        }.value
    }
}
