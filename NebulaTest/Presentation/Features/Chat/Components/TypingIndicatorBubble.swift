import SwiftUI

struct TypingIndicatorBubble: View {
    @State private var phase = 0

    private static let largeDot: Double = 19
    private static let mediumDot: Double = 15
    private static let smallDot: Double = 10
    private let sizes = [largeDot, mediumDot, smallDot]
    private let dimOpacity = Opacity.subtle
    private let stepSeconds: Double = 0.4

    var body: some View {
        HStack(spacing: Spacing.xxs) {
            ForEach(sizes.indices, id: \.self) { index in
                Circle()
                    .fill(index == phase ? AnyShapeStyle(LinearGradient.accent) : AnyShapeStyle(Color.white.opacity(dimOpacity)))
                    .frame(size: sizes[index])
            }
        }
        .padding(Spacing.reg)
        .background(
            Color.card.opacity(Opacity.half),
            in: .rect(topLeadingRadius: Radius.md, bottomTrailingRadius: Radius.md, topTrailingRadius: Radius.md)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(Animations.state, value: phase)
        .task(animate)
    }

    @Sendable
    private func animate() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(stepSeconds))
            phase = (phase + 1) % sizes.count
        }
    }
}
