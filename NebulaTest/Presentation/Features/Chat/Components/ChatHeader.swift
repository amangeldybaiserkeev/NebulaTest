import SwiftUI

struct ChatHeader: View {
    let date: Date
    let isPinned: Bool
    let onBack: () -> Void
    let onMore: () -> Void

    var body: some View {
        HStack(spacing: Spacing.lg) {
            Button(action: onBack) {
                Image(.icBackArrow)
                    .resizable()
                    .frame(size: IconSize.reg)
                    .foregroundStyle(.white)
                    .frame(size: TouchTarget.minimum)
                    .contentShape(.rect)
            }
            .buttonStyle(PressableButtonStyle())

            ChatHeaderTitle(date: date, isPinned: isPinned)

            Spacer()

            MoreButton(action: onMore)
        }
        .padding(.horizontal, Spacing.reg)
        .frame(height: ControlSize.headerHeight)
        .background(Color.card.opacity(Opacity.faint).ignoresSafeArea(edges: .top))
    }
}

#Preview {
    ChatHeader(date: .now, isPinned: true, onBack: {}, onMore: {})
        .background(Color.appBackground)
}
