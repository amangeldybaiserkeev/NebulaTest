import SwiftUI

struct ChatHistoryList: View {
    let sections: [ChatHistorySection]
    @Binding var activeRowID: UUID?
    let onOpen: (Chat) -> Void
    let onRename: (Chat) -> Void
    let onDelete: (Chat) -> Void

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: Spacing.xxl) {
                ForEach(sections) { section in
                    VStack(alignment: .leading, spacing: Spacing.reg) {
                        Text(section.title)
                            .font(AppFont.heading)
                            .foregroundStyle(.white)
                        VStack(spacing: Spacing.sm) {
                            ForEach(section.chats) { chat in
                                row(chat)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.reg)
            .padding(.top, Spacing.lg)
            .padding(.bottom, Spacing.reg)
        }
        .scrollIndicators(.hidden)
        .onTapGesture { activeRowID = nil }
    }

    private func row(_ chat: Chat) -> some View {
        ChatHistoryRow(chat: chat) { onOpen(chat) }
            .rowSwipeActions(
                rowID: chat.id,
                activeRowID: $activeRowID,
                actions: [
                    SwipeAction(systemImage: "pencil", background: .orange) { onRename(chat) },
                    SwipeAction(systemImage: "trash", background: .red) { onDelete(chat) }
                ]
            )
    }
}
