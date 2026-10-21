import SwiftUI

struct TemplateCard: View {
    let template: VideoTemplate
    let thumbnailLoader: VideoThumbnailLoader
    let action: () -> Void

    private let height: Double = 232

    var body: some View {
        Button(action: action) {
            TemplateThumbnail(url: template.previewURL, loader: thumbnailLoader)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .overlay {
                    LinearGradient(colors: [.card, .card.opacity(0)], startPoint: .bottom, endPoint: .top)
                }
                .overlay(alignment: .bottom) {
                    Text(template.name)
                        .font(AppFont.body)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .padding(Spacing.xs)
                }
                .clipShape(.rect(cornerRadius: Radius.md))
                .contentShape(.rect(cornerRadius: Radius.md))
        }
        .buttonStyle(PressableButtonStyle())
    }
}
