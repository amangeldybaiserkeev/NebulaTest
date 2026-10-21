import SwiftUI

struct ReplaceButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                Image(.icRefresh)
                    .resizable()
                    .frame(size: IconSize.reg)
                Text("Replace")
                    .font(AppFont.caption)
            }
            .foregroundStyle(.white)
            .padding(.vertical, Spacing.xs)
            .padding(.horizontal, Spacing.sm)
            .background(Color.card.opacity(Opacity.muted), in: .capsule)
            .background(.ultraThinMaterial, in: .capsule)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    ReplaceButton {}
        .padding()
        .background(Color.appBackground)
}
