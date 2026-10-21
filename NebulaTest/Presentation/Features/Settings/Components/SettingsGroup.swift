import SwiftUI

struct SettingsGroup<Rows: View>: View {
    let title: String
    @ViewBuilder let rows: Rows

    private let titleBottomPadding: Double = 6

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text(title)
                .font(AppFont.bodySemibold)
                .foregroundStyle(.white.opacity(Opacity.muted))
                .padding(.bottom, titleBottomPadding)
            rows
        }
        .padding(.horizontal, Spacing.reg)
    }
}
