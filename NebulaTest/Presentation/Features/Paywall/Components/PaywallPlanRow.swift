import SwiftUI

struct PaywallPlanRow: View {
    let plan: PaywallPlanItem
    let isSelected: Bool
    let onSelect: () -> Void

    private let borderWidth: Double = 1

    var body: some View {
        Button(action: onSelect) {
            PaywallPlanRowLabel(plan: plan)
                .padding(.leading, Spacing.xl)
                .padding(.trailing, Spacing.lg)
                .padding(.vertical, Spacing.lg)
                .frame(height: ControlSize.rowHeight)
                .background {
                    RoundedRectangle(cornerRadius: Radius.xl)
                        .strokeBorder(borderStyle, lineWidth: borderWidth)
                }
                .contentShape(.rect(cornerRadius: Radius.xl))
        }
        .buttonStyle(PressableButtonStyle())
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .animation(Animations.state, value: isSelected)
    }

    private var borderStyle: AnyShapeStyle {
        isSelected ? AnyShapeStyle(LinearGradient.accent) : AnyShapeStyle(Color.white.opacity(Opacity.muted))
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        PaywallPlanRow(plan: PaywallPlanItem.placeholders[0], isSelected: true) {}
        PaywallPlanRow(plan: PaywallPlanItem.placeholders[1], isSelected: false) {}
    }
    .padding()
    .background(Color.appBackground)
}
