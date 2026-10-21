import SwiftUI

struct MainFlowView: View {
    let container: AppContainer

    @State private var path: [AppRoute] = []
    @State private var isPaywallPresented = false
    @State private var isNewChatPresented = false
    @Namespace private var composerNamespace

    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                MainView(
                    viewModel: container.makeMainViewModel(),
                    composerNamespace: composerNamespace,
                    isComposerHidden: isNewChatPresented,
                    onOpenChat: openNewChat,
                    onOpenVideo: { path.append(.videoTemplates) },
                    onOpenHistory: { path.append(.history) },
                    onOpenSettings: { path.append(.settings) },
                    onShowPaywall: { isPaywallPresented = true }
                )
                .navigationDestination(for: AppRoute.self, destination: destination)
                .toolbar(.hidden, for: .navigationBar)
            }

            if isNewChatPresented {
                ChatView(
                    viewModel: container.makeChatViewModel(chatID: nil),
                    container: container,
                    composerNamespace: composerNamespace,
                    onClose: closeNewChat
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .fullScreenCover(isPresented: $isPaywallPresented) {
            PaywallView(
                viewModel: container.makePaywallViewModel(),
                onClose: { isPaywallPresented = false },
                onUnlock: { isPaywallPresented = false }
            )
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .chat(let id):
            ChatView(
                viewModel: container.makeChatViewModel(chatID: id),
                container: container,
                composerNamespace: nil,
                onClose: { path.removeLast() }
            )
        case .videoTemplates:
            Text("AI Video")
        case .history:
            Text("History")
        case .settings:
            Text("Settings")
        }
    }

    private func openNewChat() {
        withAnimation(Animations.screen) { isNewChatPresented = true }
    }

    private func closeNewChat() {
        withAnimation(Animations.screen) { isNewChatPresented = false }
    }
}
