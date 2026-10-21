import SwiftUI

struct MessageComposer: View {
    @Binding var text: String
    let placeholder: String
    let isSendEnabled: Bool
    var isFocused: FocusState<Bool>.Binding
    let onSend: () -> Void

    private let maxLines = 3
    private let disabledSendOpacity = Opacity.muted

    var body: some View {
        HStack(alignment: .bottom, spacing: Spacing.lg) {
            TextField("", text: $text, axis: .vertical)
                .font(AppFont.body)
                .foregroundStyle(.white)
                .tint(.white)
                .lineLimit(1...maxLines)
                .focused(isFocused)
                .submitLabel(.return)
                .overlay(alignment: .leading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .font(AppFont.body)
                            .foregroundStyle(.textSecondary)
                            .allowsHitTesting(false)
                    }
                }
                .padding(.vertical, Spacing.sm)

            Button(action: onSend) {
                Image(.icSend)
                    .resizable()
                    .frame(size: IconSize.reg)
                    .foregroundStyle(.white)
                    .frame(size: IconSize.xxl)
                    .background(LinearGradient.accent, in: .circle)
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(!isSendEnabled)
            .opacity(isSendEnabled ? 1 : disabledSendOpacity)
            .animation(Animations.state, value: isSendEnabled)
        }
        .padding(.horizontal, Spacing.reg)
        .padding(.vertical, Spacing.sm)
        .frame(minHeight: ControlSize.composerHeight, alignment: .bottom)
        .background(Color.card, in: .rect(topLeadingRadius: Radius.md, topTrailingRadius: Radius.md))
    }
}
