import SwiftUI

struct ProBadgeButton: View {
    let action: () -> Void

    private let verticalPadding: Double = 7
    private let letterSpacing: Double = 0.56

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xxs) {
                Image(.icProSparkle)
                    .resizable()
                    .frame(size: IconSize.xxs)
                Text("PRO")
                    .font(AppFont.captionSemibold)
                    .kerning(letterSpacing)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, verticalPadding)
            .frame(height: IconSize.xxl)
            .background(LinearGradient.accent, in: .capsule)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    ProBadgeButton {}
        .padding()
        .background(Color.appBackground)
}
