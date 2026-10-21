import SwiftUI

struct VideoFeatureCardLabel: View {
    private let iconBackground: Double = 36

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Image(.icImageToImage60)
                .renderingMode(.template)
                .resizable()
                .frame(size: IconSize.sm)
                .foregroundStyle(.white)
                .frame(size: iconBackground)
                .background(Color.white.opacity(Opacity.light), in: .circle)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("Turn Photo\ninto Video")
                    .font(AppFont.heading20Medium)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                HStack(spacing: Spacing.xs) {
                    Text("Animate")
                    Circle().frame(size: Spacing.xxs)
                    Text("Templates")
                }
                .font(AppFont.caption)
                .foregroundStyle(.white.opacity(Opacity.prominent))
            }
        }
    }
}
