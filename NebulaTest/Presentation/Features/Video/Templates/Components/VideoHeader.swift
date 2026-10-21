import SwiftUI

struct VideoHeader: View {
    let onBack: () -> Void

    private let avatarSize: Double = 32

    var body: some View {
        HStack(spacing: Spacing.lg) {
            BackButton(action: onBack)

            HStack(spacing: Spacing.sm) {
                Image(.icImageToImage60)
                    .renderingMode(.template)
                    .resizable()
                    .frame(size: IconSize.reg)
                    .foregroundStyle(.white)
                    .frame(size: avatarSize)
                    .background(LinearGradient.accent, in: .circle)
                Text("AI Video")
                    .font(AppFont.navTitle)
                    .foregroundStyle(.white)
            }

            Spacer()
        }
        .padding(.horizontal, Spacing.reg)
        .frame(height: ControlSize.headerHeight)
        .background(Color.card.opacity(Opacity.faint).ignoresSafeArea(edges: .top))
    }
}

#Preview {
    VideoHeader {}
        .background(Color.appBackground)
}
