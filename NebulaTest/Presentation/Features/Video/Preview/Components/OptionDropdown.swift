import SwiftUI

struct OptionDropdown: View {
    let items: [DropdownItem]
    let selectedID: String
    let onSelect: (String) -> Void

    private let width: Double = 220
    private let rowHeight: Double = 60
    private let iconSize: Double = 22
    private let checkWidth: Double = 12
    private let selectedBackground: Double = 0.06
    private let subtitleOpacity: Double = 0.45

    var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { item in
                row(item, isSelected: item.id == selectedID)
            }
        }
        .frame(width: width)
        .background(Color.card.opacity(Opacity.prominent), in: .rect(cornerRadius: Radius.reg))
        .background(.ultraThinMaterial, in: .rect(cornerRadius: Radius.reg))
    }

    private func row(_ item: DropdownItem, isSelected: Bool) -> some View {
        Button {
            onSelect(item.id)
        } label: {
            HStack(spacing: Spacing.sm) {
                if let icon = item.icon {
                    Image(icon)
                        .resizable()
                        .frame(size: iconSize)
                        .foregroundStyle(.white.opacity(isSelected ? 1 : Opacity.secondary))
                }
                VStack(alignment: .leading, spacing: Spacing.xxxs) {
                    Text(item.title)
                        .font(AppFont.bodyMedium)
                        .foregroundStyle(.white.opacity(isSelected ? 1 : Opacity.pressed))
                    if let subtitle = item.subtitle {
                        Text(subtitle)
                            .font(AppFont.systemSmall)
                            .foregroundStyle(.white.opacity(subtitleOpacity))
                    }
                }
                Spacer()
                if isSelected {
                    Image(.icDropdownCheck)
                        .resizable()
                        .scaledToFit()
                        .frame(width: checkWidth)
                }
            }
            .padding(.horizontal, Spacing.reg)
            .frame(height: rowHeight)
            .background(isSelected ? Color.white.opacity(selectedBackground) : .clear)
            .contentShape(.rect)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    OptionDropdown(items: VideoFormat.allCases.map(DropdownItem.init), selectedID: "16:9") { _ in }
        .padding()
        .background(Color.appBackground)
}
