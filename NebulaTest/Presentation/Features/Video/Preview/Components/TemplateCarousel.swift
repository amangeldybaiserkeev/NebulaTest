import SwiftUI

struct TemplateCarousel: View {
    let templates: [VideoTemplate]
    @Binding var currentIndex: Int
    let loader: VideoThumbnailLoader

    @State private var dragOffset: Double = 0

    private let sideInset: Double = 30
    private let horizontalInsets: Double = 60
    private let swipeThreshold: Double = 60

    var body: some View {
        GeometryReader { proxy in
            let cardWidth = proxy.size.width - horizontalInsets
            let step = cardWidth + Spacing.reg
            HStack(spacing: Spacing.reg) {
                ForEach(Array(templates.enumerated()), id: \.element.id) { index, template in
                    card(template, distance: abs(index - currentIndex))
                        .frame(width: cardWidth)
                }
            }
            .offset(x: sideInset - Double(currentIndex) * step + dragOffset)
            .gesture(dragGesture)
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: Spacing.xs)
            .onChanged { dragOffset = $0.translation.width }
            .onEnded { value in
                let predicted = value.predictedEndTranslation.width
                var index = currentIndex
                if predicted < -swipeThreshold { index += 1 } else if predicted > swipeThreshold { index -= 1 }
                withAnimation(Animations.page) {
                    currentIndex = min(max(index, 0), templates.count - 1)
                    dragOffset = 0
                }
            }
    }

    @ViewBuilder
    private func card(_ template: VideoTemplate, distance: Int) -> some View {
        ZStack {
            if distance <= 1 {
                TemplateThumbnail(url: template.previewURL, loader: loader)
            } else {
                Color.card
            }
            if distance == 0 {
                LoopingVideoPlayer(url: template.previewURL)
            }
        }
        .clipShape(.rect(cornerRadius: Radius.sm))
    }
}
