import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    let container: AppContainer
    let composerNamespace: Namespace.ID?
    let onClose: () -> Void

    @FocusState private var isComposerFocused: Bool

    init(viewModel: ChatViewModel, container: AppContainer, composerNamespace: Namespace.ID?, onClose: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
        self.composerNamespace = composerNamespace
        self.onClose = onClose
    }

    var body: some View {
        VStack(spacing: 0) {
            ChatHeader(
                date: viewModel.chat?.createdAt ?? .now,
                isPinned: viewModel.isPinned,
                onBack: close,
                onMore: { viewModel.isActionsMenuPresented = true }
            )

            if viewModel.messages.isEmpty, !viewModel.isGenerating {
                ChatEmptyState(suggestions: viewModel.suggestions, onSelect: viewModel.useSuggestion)
            } else {
                ChatMessageList(
                    messages: viewModel.messages,
                    isGenerating: viewModel.isGenerating,
                    lastAssistantMessageID: viewModel.lastAssistantMessageID,
                    onCopy: viewModel.copy,
                    onRegenerate: regenerate
                )
            }

            composer
        }
        .background(Color.appBackground.ignoresSafeArea())
        .overlay(alignment: .top) {
            if viewModel.isActionsMenuPresented {
                actionsMenu
            }
        }
        .animation(Animations.state, value: viewModel.isActionsMenuPresented)
        .toast($viewModel.toast)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: viewModel.load)
        .task(focusComposer)
        .onChange(of: viewModel.isDeleted) { if $0 { close() } }
        .alert("Delete chat?", isPresented: $viewModel.isDeleteAlertPresented) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive, action: viewModel.deleteChat)
        } message: {
            Text("This chat will be removed from your history.")
        }
        .sheet(isPresented: $viewModel.isSharePresented) {
            ShareSheet(items: [viewModel.shareText])
        }
        .fullScreenCover(isPresented: $viewModel.isPaywallPresented) {
            PaywallView(
                viewModel: container.makePaywallViewModel(),
                onClose: { viewModel.isPaywallPresented = false },
                onUnlock: { viewModel.isPaywallPresented = false }
            )
        }
    }

    private var actionsMenu: some View {
        ChatActionsMenu(
            isPinned: viewModel.isPinned,
            onShare: { viewModel.isActionsMenuPresented = false; viewModel.isSharePresented = true },
            onTogglePin: { viewModel.isActionsMenuPresented = false; viewModel.togglePin() },
            onDelete: { viewModel.isActionsMenuPresented = false; viewModel.isDeleteAlertPresented = true },
            onDismiss: { viewModel.isActionsMenuPresented = false }
        )
        .padding(.top, ControlSize.headerHeight)
        .transition(.opacity)
    }

    private var composer: some View {
        MessageComposer(
            text: $viewModel.draft,
            placeholder: viewModel.messages.isEmpty ? "Ask anything..." : "How can I help you?",
            isSendEnabled: viewModel.canSend,
            isFocused: $isComposerFocused,
            onSend: send
        )
        .composerGeometry(in: composerNamespace)
    }

    private func send() {
        Task { await viewModel.send() }
    }

    private func regenerate() {
        Task { await viewModel.regenerate() }
    }

    @Sendable
    private func focusComposer() async {
        try? await Task.sleep(for: .seconds(Animations.Seconds.screen))
        isComposerFocused = true
    }

    private func close() {
        isComposerFocused = false
        onClose()
    }
}
