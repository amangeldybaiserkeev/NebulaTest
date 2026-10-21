import SwiftUI

struct OptionAnchorKey: PreferenceKey {
    static let defaultValue: [TemplatePreviewViewModel.Option: Anchor<CGRect>] = [:]

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value.merge(nextValue()) { $1 }
    }
}

struct OptionRow: View {
    let title: String
    let value: String
    let option: TemplatePreviewViewModel.Option
    let action: () -> Void

    private let height: Double = 60

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                Text(title)
                    .foregroundStyle(.white.opacity(Opacity.secondary))
                Spacer()
                Text(value)
                    .foregroundStyle(.white)
            }
            .font(AppFont.bodyMedium)
            .padding(.horizontal, Spacing.reg)
            .frame(height: height)
            .background(Color.card.opacity(Opacity.half), in: .rect(cornerRadius: Radius.md))
            .contentShape(.rect(cornerRadius: Radius.md))
        }
        .buttonStyle(PressableButtonStyle())
        .anchorPreference(key: OptionAnchorKey.self, value: .bounds) { [option: $0] }
    }
}

#Preview {
    OptionRow(title: "Format", value: "16:9", option: .format) {}
        .padding()
        .background(Color.appBackground)
}
