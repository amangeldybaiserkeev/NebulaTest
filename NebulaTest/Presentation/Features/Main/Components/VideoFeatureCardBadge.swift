import SwiftUI

struct VideoFeatureCardBadge: View {
    private let height: Double = 32
    private let kerning: Double = 0.06

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Text("Ready in seconds")
                .font(AppFont.systemSmall)
                .kerning(kerning)
            Image(.icPlay56)
                .resizable()
                .scaledToFit()
                .frame(size: IconSize.xs)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, Spacing.sm)
        .frame(height: height)
        .background(Color.white.opacity(Opacity.muted), in: .capsule)
    }
}
