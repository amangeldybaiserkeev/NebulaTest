import SwiftUI

struct SettingsRow: View {
    enum Accessory {
        case chevron
        case detail(String)
        case toggle(Binding<Bool>)
    }

    let symbol: String
    let title: String
    var accessory: Accessory = .chevron
    var action: (() -> Void)?

    private let iconWidth: Double = 28
    private let iconTrailingPadding: Double = 8
    private let symbolSize: Double = 17
    private let chevronSize: Double = 13

    var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: Spacing.xxs) {
                Image(systemName: symbol)
                    .font(.system(size: symbolSize))
                    .foregroundStyle(LinearGradient.accent)
                    .frame(width: iconWidth)
                    .padding(.trailing, iconTrailingPadding)
                Text(title)
                    .font(AppFont.body)
                    .foregroundStyle(.white)
                Spacer()
                accessoryView
            }
            .padding(.horizontal, Spacing.reg)
            .frame(height: TouchTarget.minimum)
            .background(Color.card.opacity(Opacity.muted), in: .capsule)
            .contentShape(.capsule)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(action == nil)
    }

    @ViewBuilder
    private var accessoryView: some View {
        switch accessory {
        case .chevron:
            chevron
        case .detail(let text):
            HStack(spacing: Spacing.reg) {
                Text(text)
                    .font(AppFont.body)
                    .foregroundStyle(.textSecondary)
                chevron
            }
        case .toggle(let isOn):
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(.gradientEnd)
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: chevronSize, weight: .semibold))
            .foregroundStyle(LinearGradient.accent)
    }
}

#Preview {
    VStack(spacing: Spacing.xs) {
        SettingsRow(symbol: "star", title: "Rate app") {}
        SettingsRow(symbol: "trash", title: "Clear cache", accessory: .detail("5 MB")) {}
        SettingsRow(symbol: "bell", title: "Notifications", accessory: .toggle(.constant(false)))
    }
    .padding()
    .background(Color.appBackground)
}
