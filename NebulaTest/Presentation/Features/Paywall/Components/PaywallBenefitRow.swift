import SwiftUI

struct PaywallBenefitRow: View {
    let benefit: PaywallBenefit

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(benefit.icon)
                .resizable()
                .frame(size: IconSize.reg)
                .foregroundStyle(LinearGradient.accent)
            Text(benefit.text)
                .font(AppFont.bodyMedium)
                .foregroundStyle(.white)
        }
        .padding(.vertical, Spacing.xxs)
    }
}
