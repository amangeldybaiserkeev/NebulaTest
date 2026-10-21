import SwiftUI

struct ErrorStateView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Text(message)
                .font(AppFont.body)
                .foregroundStyle(.textSecondary)
                .multilineTextAlignment(.center)
            GradientButton(title: "Try again", action: onRetry)
        }
        .padding(.horizontal, Spacing.reg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorStateView(message: "Server error (500). Please try again.") {}
        .background(Color.appBackground)
}
