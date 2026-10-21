import SwiftUI

struct PaywallPlanRow: View {
    let plan: PaywallPlanItem
    let isSelected: Bool
    let onSelect: () -> Void

    private let borderWidth: Double = 1

    var body: some View {
        Button(action: onSelect) {
            PaywallPlanRowLabel(plan: plan)
                .padding(.leading, Spacing.lg)
                .padding(.trailing, Spacing.reg)
                .padding(.vertical, Spacing.reg)
                .frame(height: ControlSize.rowHeight)
                .background {
                    RoundedRectangle(cornerRadius: Radius.md)
                        .strokeBorder(borderStyle, lineWidth: borderWidth)
                }
                .contentShape(.rect(cornerRadius: Radius.md))
        }
        .buttonStyle(PressableButtonStyle())
        .animation(Animations.state, value: isSelected)
    }

    private var borderStyle: AnyShapeStyle {
        isSelected ? AnyShapeStyle(LinearGradient.accent) : AnyShapeStyle(Color.white.opacity(Opacity.muted))
    }
}

#Preview {
    VStack(spacing: Spacing.sm) {
        PaywallPlanRow(plan: PaywallPlanItem.placeholders[0], isSelected: true) {}
        PaywallPlanRow(plan: PaywallPlanItem.placeholders[1], isSelected: false) {}
    }
    .padding()
    .background(Color.appBackground)
}
