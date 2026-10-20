import SwiftUI

struct PaywallPlansSection: View {
    let plans: LoadState<[PaywallPlanItem]>
    let selectedPlanID: String?
    let onSelectPlan: (String) -> Void

    private let placeholderCount = 2

    var body: some View {
        VStack(spacing: Spacing.md) {
            switch plans {
            case .idle, .loading:
                ForEach(0..<placeholderCount, id: \.self) { _ in
                    PaywallPlanPlaceholderRow()
                }
            case .loaded(let items):
                ForEach(items) { plan in
                    PaywallPlanRow(plan: plan, isSelected: plan.id == selectedPlanID) {
                        onSelectPlan(plan.id)
                    }
                }
            case .failed(let message):
                Text(message)
                    .font(AppFont.caption)
                    .foregroundStyle(.textSecondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .frame(height: ControlSize.rowHeight)
            }
        }
        .animation(Animations.state, value: plans)
    }
}
