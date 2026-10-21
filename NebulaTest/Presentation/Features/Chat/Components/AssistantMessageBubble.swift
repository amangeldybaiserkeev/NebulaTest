import SwiftUI

struct AssistantMessageBubble: View {
    let text: String
    let canRegenerate: Bool
    let onCopy: () -> Void
    let onRegenerate: () -> Void

    private let textOpacity: Double = 0.8
    private let dividerOpacity: Double = 0.1
    private let actionsOpacity: Double = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.reg) {
            Text(attributedText)
                .font(AppFont.body)
                .foregroundStyle(.white.opacity(textOpacity))
                .frame(maxWidth: .infinity, alignment: .leading)

            Rectangle()
                .fill(Color.white.opacity(dividerOpacity))
                .frame(height: 1)

            HStack {
                actionButton(.icCopy, action: onCopy)
                Spacer()
                if canRegenerate {
                    actionButton(.icRefresh, action: onRegenerate)
                }
            }
            .opacity(actionsOpacity)
        }
        .padding(Spacing.reg)
        .background(
            Color.card.opacity(Opacity.half),
            in: .rect(topLeadingRadius: Radius.md, bottomTrailingRadius: Radius.md, topTrailingRadius: Radius.md)
        )
        .padding(.leading, Spacing.sm)
    }

    private var attributedText: AttributedString {
        (try? AttributedString(markdown: text, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            ?? AttributedString(text)
    }

    private func actionButton(_ icon: ImageResource, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(icon)
                .resizable()
                .frame(size: IconSize.reg)
                .foregroundStyle(.white)
                .hitTarget(visibleSize: IconSize.reg)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
