import SwiftUI

struct PaywallBenefitRow: View {
    let benefit: PaywallBenefit

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(benefit.icon)
                .resizable()
                .frame(width: IconSize.md, height: IconSize.md)
                .accessibilityHidden(true)
            Text(benefit.text)
                .font(AppFont.bodyMedium)
                .foregroundStyle(.white)
        }
        .padding(.vertical, Spacing.xs)
    }
}
