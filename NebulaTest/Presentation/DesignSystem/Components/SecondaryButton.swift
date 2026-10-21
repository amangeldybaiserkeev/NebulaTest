import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.bodySemibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: ControlSize.buttonHeight)
                .background(Color.card.opacity(Opacity.secondary), in: .rect(cornerRadius: Radius.md))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    SecondaryButton(title: "Share") {}
        .padding()
        .background(Color.appBackground)
}
