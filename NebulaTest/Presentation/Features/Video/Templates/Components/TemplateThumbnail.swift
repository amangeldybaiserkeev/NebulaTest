import SwiftUI

struct TemplateThumbnail: View {
    let url: URL
    let loader: VideoThumbnailLoader

    @State private var image: UIImage?

    var body: some View {
        Color.card
            .overlay {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity)
                }
            }
            .clipped()
            .animation(Animations.fadeIn, value: image)
            .task(id: url) { image = await loader.thumbnail(for: url) }
    }
}
