import SwiftUI

struct PaywallBottomBar: View {
    var isUnlockEnabled = true
    let onUnlock: () -> Void
    let onRestore: () -> Void
    let onPrivacyPolicy: () -> Void
    let onTermsOfUse: () -> Void

    private let legalKerning: Double = 0.06

    var body: some View {
        VStack(spacing: 0) {
            Label("Cancel Anytime", systemImage: "clock.arrow.circlepath")
                .font(AppFont.systemSmall)
                .foregroundStyle(.textSecondary)
                .padding(.vertical, Spacing.xs)

            GradientButton(title: "Unlock now", isEnabled: isUnlockEnabled, action: onUnlock)
                .padding(.horizontal, Spacing.reg)
                .padding(.top, Spacing.xxxs)

            HStack {
                Button("Privacy Policy", action: onPrivacyPolicy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Button("Restore Purchases", action: onRestore)
                    .frame(maxWidth: .infinity)
                Button("Terms of Use", action: onTermsOfUse)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .font(AppFont.systemLegal)
            .kerning(legalKerning)
            .foregroundStyle(.textSecondary)
            .padding(.horizontal, Spacing.reg)
            .padding(.top, Spacing.reg)
            .padding(.bottom, Spacing.xs)
        }
        .background(Color.appBackground)
    }
}

#Preview {
    PaywallBottomBar(onUnlock: {}, onRestore: {}, onPrivacyPolicy: {}, onTermsOfUse: {})
}
