import SwiftUI

struct GlowBackground: View {
    var glowOpacity: Double = Opacity.muted

    private enum Figma {
        static let glowWidth: Double = 665
        static let glowHeight: Double = 429
        static let glowOffsetX: Double = -78
        static let glowOffsetY: Double = -131
        // Figma layer blur radius is roughly twice the Gaussian radius SwiftUI expects.
        static let glowBlur: Double = 50
        static let leftShadeWidth: Double = 383
        static let leftShadeHeight: Double = 237
        static let leftShadeOffsetX: Double = -19
        static let leftShadeOffsetY: Double = 97
        static let rightShadeWidth: Double = 315
        static let rightShadeHeight: Double = 236
        static let rightShadeOffsetX: Double = 316
        static let rightShadeOffsetY: Double = 147
        static let shadeBlur: Double = 54
    }

    var body: some View {
        Color.appBackground
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    Ellipse()
                        .fill(LinearGradient.accent)
                        .frame(width: Figma.glowWidth, height: Figma.glowHeight)
                        .blur(radius: Figma.glowBlur)
                        .opacity(glowOpacity)
                        .offset(x: Figma.glowOffsetX, y: Figma.glowOffsetY)

                    Ellipse()
                        .fill(Color.appBackground)
                        .frame(width: Figma.leftShadeWidth, height: Figma.leftShadeHeight)
                        .blur(radius: Figma.shadeBlur)
                        .offset(x: Figma.leftShadeOffsetX, y: Figma.leftShadeOffsetY)

                    Ellipse()
                        .fill(Color.appBackground)
                        .frame(width: Figma.rightShadeWidth, height: Figma.rightShadeHeight)
                        .blur(radius: Figma.shadeBlur)
                        .offset(x: Figma.rightShadeOffsetX, y: Figma.rightShadeOffsetY)
                }
                .compositingGroup()
            }
            .clipped()
            .ignoresSafeArea()
            .allowsHitTesting(false)
    }
}

#Preview {
    GlowBackground()
}
