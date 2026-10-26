import SwiftUI

struct VideoHistoryCard: View {
    let generation: VideoGeneration
    let previewImage: UIImage?
    let thumbnailLoader: VideoThumbnailLoader
    let onOpen: () -> Void
    let onRetry: () -> Void

    private let dimOpacity: Double = 0.55
    private let blurRadius: Double = 6
    private let textOpacity: Double = 0.85
    private let retryBackground: Double = 0.14
    private let retryVerticalPadding: Double = 7
    private let retryHorizontalPadding: Double = 14
    private let smallFontSize: Double = 13
    private let spinnerScale: Double = 1.6

    var body: some View {
        Button {
            if generation.videoURL != nil { onOpen() }
        } label: {
            Color.card
                .aspectRatio(generation.format.aspectRatio, contentMode: .fit)
                .overlay { preview }
                .overlay { stateOverlay }
                .overlay(alignment: .topLeading) { badge.padding(Spacing.xs) }
                .clipShape(.rect(cornerRadius: Radius.sm))
                .contentShape(.rect(cornerRadius: Radius.sm))
        }
        .buttonStyle(PressableButtonStyle())
    }

    @ViewBuilder
    private var preview: some View {
        if let url = generation.videoURL {
            TemplateThumbnail(url: url, loader: thumbnailLoader)
        } else if let previewImage {
            Image(uiImage: previewImage)
                .resizable()
                .scaledToFill()
                .blur(radius: blurRadius)
        }
    }

    @ViewBuilder
    private var stateOverlay: some View {
        switch generation.status {
        case .finished:
            EmptyView()
        case .generating:
            Color.appBackground.opacity(dimOpacity)
            VStack(spacing: Spacing.xs) {
                ProgressView()
                    .tint(.white)
                    .scaleEffect(spinnerScale)
                    .frame(size: IconSize.lg)
                Text("Generating…")
                    .font(AppFont.custom(smallFontSize, weight: .medium))
                    .foregroundStyle(.white.opacity(textOpacity))
            }
        case .failed:
            Color.appBackground.opacity(dimOpacity)
            VStack(spacing: Spacing.xs) {
                Text("Something went wrong")
                    .font(AppFont.custom(smallFontSize, weight: .medium))
                    .foregroundStyle(.white.opacity(textOpacity))
                Button(action: onRetry) {
                    Text("Try again")
                        .font(AppFont.custom(smallFontSize, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, retryVerticalPadding)
                        .padding(.horizontal, retryHorizontalPadding)
                        .background(Color.white.opacity(retryBackground), in: .capsule)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
    }

    @ViewBuilder
    private var badge: some View {
        switch generation.status {
        case .generating:
            StatusBadge(title: "In progress", color: .gradientStart)
        case .failed:
            StatusBadge(title: "Error", color: .statusError)
        case .finished:
            if generation.isNew {
                StatusBadge(title: "New", color: .success)
            }
        }
    }
}

#Preview {
    let states: [VideoGeneration.Status] = [
        .generating,
        .failed("Something went wrong"),
        .finished(URL(fileURLWithPath: "/dev/null"))
    ]
    return HStack(alignment: .top, spacing: Spacing.xs) {
        ForEach(Array(states.enumerated()), id: \.offset) { _, status in
            VideoHistoryCard(
                generation: VideoGeneration(
                    id: UUID(),
                    remoteID: nil,
                    templateID: 1,
                    templateName: "Clay",
                    format: .portrait,
                    quality: "720p",
                    status: status,
                    createdAt: .now,
                    isNew: true
                ),
                previewImage: UIImage(named: "img_onboarding_2_bg"),
                thumbnailLoader: VideoThumbnailLoader(),
                onOpen: {},
                onRetry: {}
            )
        }
    }
    .padding(Spacing.reg)
    .background(Color.appBackground)
}
