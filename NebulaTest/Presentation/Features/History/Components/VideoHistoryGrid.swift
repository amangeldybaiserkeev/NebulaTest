import SwiftUI

struct VideoHistoryGrid: View {
    let generations: [VideoGeneration]
    let previewImages: [UUID: UIImage]
    let thumbnailLoader: VideoThumbnailLoader
    let onOpen: (VideoGeneration) -> Void
    let onRetry: (VideoGeneration) -> Void

    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: Spacing.xs) {
                ForEach(columns, id: \.first?.id) { column in
                    LazyVStack(spacing: Spacing.xs) {
                        ForEach(column) { generation in
                            VideoHistoryCard(
                                generation: generation,
                                previewImage: previewImages[generation.id],
                                thumbnailLoader: thumbnailLoader,
                                onOpen: { onOpen(generation) },
                                onRetry: { onRetry(generation) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.reg)
            .padding(.top, Spacing.lg)
            .padding(.bottom, Spacing.reg)
        }
        .scrollIndicators(.hidden)
    }

    private var columns: [[VideoGeneration]] {
        var left: [VideoGeneration] = []
        var right: [VideoGeneration] = []
        var leftHeight: Double = 0
        var rightHeight: Double = 0
        for generation in generations {
            let height = 1 / generation.format.aspectRatio
            if leftHeight <= rightHeight {
                left.append(generation)
                leftHeight += height
            } else {
                right.append(generation)
                rightHeight += height
            }
        }
        return [left, right]
    }
}
