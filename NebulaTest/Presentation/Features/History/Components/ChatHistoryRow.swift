import SwiftUI

struct ChatHistoryRow: View {
    let chat: Chat
    let action: () -> Void

    private let pinOpacity: Double = 0.24

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.reg) {
                Image(.icSparkleLogo60)
                    .resizable()
                    .frame(size: IconSize.md)

                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(chat.title)
                        .font(AppFont.bodySemibold)
                        .foregroundStyle(.white)
                    Text(chat.lastMessagePreview ?? "")
                        .font(AppFont.caption)
                        .foregroundStyle(.white.opacity(Opacity.half))
                }
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)

                if chat.isPinned {
                    Image(.icPinSmall)
                        .resizable()
                        .scaledToFit()
                        .frame(size: IconSize.reg)
                        .foregroundStyle(.white.opacity(pinOpacity))
                }
            }
            .padding(Spacing.reg)
            .frame(height: ControlSize.rowHeight)
            .background(Color.card.opacity(Opacity.muted), in: .rect(cornerRadius: Radius.md))
            .contentShape(.rect(cornerRadius: Radius.md))
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    ChatHistoryRow(
        chat: Chat(id: UUID(), title: "Chat name", createdAt: .now, updatedAt: .now, isPinned: true, lastMessagePreview: "Hello")
    ) {}
    .padding()
    .background(Color.appBackground)
}
