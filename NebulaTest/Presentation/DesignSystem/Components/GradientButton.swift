import SwiftUI

struct GradientButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.bodySemibold)
                .foregroundStyle(isEnabled ? .white : .textSecondary)
                .frame(maxWidth: .infinity)
                .frame(height: ControlSize.buttonHeight)
                .background(
                    isEnabled ? AnyShapeStyle(LinearGradient.accent) : AnyShapeStyle(Color.card),
                    in: .rect(cornerRadius: Radius.md)
                )
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!isEnabled)
        .animation(Animations.state, value: isEnabled)
    }
}

#Preview {
    VStack(spacing: Spacing.reg) {
        GradientButton(title: "Continue") {}
        GradientButton(title: "Create", isEnabled: false) {}
    }
    .padding()
    .background(Color.appBackground)
}
