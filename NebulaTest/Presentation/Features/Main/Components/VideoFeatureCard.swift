import SwiftUI

struct VideoFeatureCard: View {
    let action: () -> Void

    private let height: Double = 161
    private let swooshOffsetX: Double = 132
    private let swooshOffsetY: Double = -70
    private let gradientStartX: Double = 0.03
    private let gradientStartY: Double = 0.04
    private let gradientEndY: Double = 0.81

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .topLeading) {
                VideoFeatureCardLabel()
                VideoFeatureCardBadge()
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
            }
            .padding(Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .frame(height: height)
            .background {
                ZStack(alignment: .topLeading) {
                    LinearGradient(
                        colors: [.gradientStart, .gradientEnd],
                        startPoint: UnitPoint(x: gradientStartX, y: gradientStartY),
                        endPoint: UnitPoint(x: 1, y: gradientEndY)
                    )
                    Image(.imgMainVideoCard)
                        .opacity(Opacity.half)
                        .offset(x: swooshOffsetX, y: swooshOffsetY)
                }
                .allowsHitTesting(false)
            }
            .clipShape(.rect(cornerRadius: Radius.md))
            .contentShape(.rect(cornerRadius: Radius.md))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    VideoFeatureCard {}
        .padding()
        .background(Color.appBackground)
}
