import SwiftUI

struct PaywallPlanPlaceholderRow: View {
    private let borderWidth: Double = 1

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.xl)
            .strokeBorder(Color.white.opacity(Opacity.muted), lineWidth: borderWidth)
            .frame(height: ControlSize.rowHeight)
            .overlay {
                ProgressView()
                    .tint(.textSecondary)
            }
            .accessibilityLabel("Loading plans")
    }
}
