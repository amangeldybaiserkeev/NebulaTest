import SwiftUI

struct ChatActionsMenu: View {
    let isPinned: Bool
    let onShare: () -> Void
    let onTogglePin: () -> Void
    let onDelete: () -> Void
    let onDismiss: () -> Void

    private let menuWidth: Double = 230
    private let rowHeight: Double = 47
    private let rowVerticalPadding: Double = 13
    private let separatorOpacity: Double = 0.06
    private let dimOpacity = Opacity.secondary

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.opacity(dimOpacity)
                .ignoresSafeArea()
                .onTapGesture(perform: onDismiss)

            VStack(spacing: 0) {
                row("Share", icon: .icMenuShare, action: onShare)
                separator
                row(isPinned ? "Unpin chat" : "Pin chat", icon: isPinned ? .icMenuUnpin : .icMenuPin, action: onTogglePin)
                separator
                row("Delete chat", icon: .icMenuDelete, tint: .danger, action: onDelete)
            }
            .frame(width: menuWidth)
            .background(Color.card.opacity(Opacity.pressed), in: .rect(cornerRadius: Radius.reg))
            .background(.ultraThinMaterial, in: .rect(cornerRadius: Radius.reg))
            .padding(.trailing, Spacing.reg)
        }
    }

    private var separator: some View {
        Rectangle().fill(Color.white.opacity(separatorOpacity)).frame(height: 1)
    }

    private func row(_ title: String, icon: ImageResource, tint: Color = .white, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                Text(title)
                    .font(AppFont.bodyMedium)
                Spacer()
                Image(icon)
                    .resizable()
                    .frame(size: IconSize.sm)
            }
            .foregroundStyle(tint)
            .padding(.horizontal, Spacing.reg)
            .padding(.vertical, rowVerticalPadding)
            .frame(height: rowHeight)
            .contentShape(.rect)
        }
        .buttonStyle(PressableButtonStyle())
    }
}
