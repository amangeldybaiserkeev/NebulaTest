import SwiftUI

struct ChatMessageList: View {
    let messages: [ChatMessage]
    let isGenerating: Bool
    let lastAssistantMessageID: UUID?
    let onCopy: (ChatMessage) -> Void
    let onRegenerate: () -> Void

    private let bottomAnchorID = "bottom"

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Spacing.lg) {
                    ForEach(messages) { message in
                        bubble(for: message)
                    }
                    if isGenerating {
                        TypingIndicatorBubble()
                    }
                    Color.clear.frame(height: 1).id(bottomAnchorID)
                }
                .padding(.horizontal, Spacing.reg)
                .padding(.vertical, Spacing.lg)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: messages.count) { _ in scrollToBottom(proxy) }
            .onChange(of: isGenerating) { _ in scrollToBottom(proxy) }
            .onAppear { proxy.scrollTo(bottomAnchorID, anchor: .bottom) }
        }
    }

    @ViewBuilder
    private func bubble(for message: ChatMessage) -> some View {
        switch message.role {
        case .user:
            UserMessageBubble(text: message.text)
        case .assistant:
            AssistantMessageBubble(
                text: message.text,
                canRegenerate: message.id == lastAssistantMessageID,
                onCopy: { onCopy(message) },
                onRegenerate: onRegenerate
            )
        }
    }

    private func scrollToBottom(_ proxy: ScrollViewProxy) {
        withAnimation(Animations.page) {
            proxy.scrollTo(bottomAnchorID, anchor: .bottom)
        }
    }
}
