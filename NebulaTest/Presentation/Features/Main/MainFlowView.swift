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
                onClose: pop
            )
        case .videoTemplates, .templatePreview, .generating, .videoResult:
            videoDestination(for: route)
        case .history:
            HistoryView(
                viewModel: container.makeHistoryViewModel(),
                thumbnailLoader: container.thumbnailLoader,
                onBack: pop,
                onOpenChat: { path.append(.chat(id: $0)) },
                onOpenVideo: { path.append(.videoResult(id: $0)) }
            )
        case .settings:
            SettingsView(viewModel: container.makeSettingsViewModel(), container: container, onBack: pop)
        }
    }

    @ViewBuilder
    private func videoDestination(for route: AppRoute) -> some View {
        switch route {
        case .videoTemplates:
            TemplatesView(
                viewModel: container.makeTemplatesViewModel(),
                thumbnailLoader: container.thumbnailLoader,
                onBack: pop,
                onSelect: { path.append(.templatePreview(templateID: $0.id, category: $0.category)) }
            )
        case .templatePreview(let templateID, let category):
            TemplatePreviewView(
                viewModel: container.makeTemplatePreviewViewModel(templateID: templateID, category: category),
                container: container,
                thumbnailLoader: container.thumbnailLoader,
                onBack: pop,
                onCreated: { path.append(.generating(id: $0.id)) }
            )
        case .generating(let id):
            GeneratingView(
                manager: container.generationManager,
                generationID: id,
                onBack: pop,
                onFinished: { showResult(for: $0.id) }
            )
        case .videoResult(let id):
            VideoResultView(
                viewModel: container.makeVideoResultViewModel(generationID: id),
                onBack: pop,
                onReplace: pop
            )
        default:
            EmptyView()
        }
    }

    private func pop() {
        path.removeLast()
    }

    private func showResult(for generationID: UUID) {
        path.removeLast()
        path.append(.videoResult(id: generationID))
    }

    private func openNewChat() {
        withAnimation(Animations.screen) { isNewChatPresented = true }
    }

    private func closeNewChat() {
        withAnimation(Animations.screen) { isNewChatPresented = false }
    }
}
