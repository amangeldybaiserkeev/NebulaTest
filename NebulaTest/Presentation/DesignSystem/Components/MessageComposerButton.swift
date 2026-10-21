import SwiftUI

struct MessageComposerButton: View {
    let placeholder: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.reg) {
                Image(.icSparkleLogo60)
                    .renderingMode(.template)
                    .resizable()
                    .frame(size: IconSize.reg)
                    .foregroundStyle(.white)
                Text(placeholder)
                    .font(AppFont.body)
                    .foregroundStyle(.white.opacity(Opacity.half))
                Spacer(minLength: 0)
            }
            .padding(.horizontal, Spacing.reg)
            .frame(height: TouchTarget.large)
            .background(Color.card.opacity(Opacity.prominent), in: .rect(cornerRadius: Radius.md))
            .animatedGradientBorder(cornerRadius: Radius.md)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    MessageComposerButton(placeholder: "Ask anything...") {}
        .padding()
        .background(Color.appBackground)
}
