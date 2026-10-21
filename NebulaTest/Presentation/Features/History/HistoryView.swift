import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    let thumbnailLoader: VideoThumbnailLoader
    let onBack: () -> Void
    let onOpenChat: (UUID) -> Void
    let onOpenVideo: (UUID) -> Void

    init(
        viewModel: HistoryViewModel,
        thumbnailLoader: VideoThumbnailLoader,
        onBack: @escaping () -> Void,
        onOpenChat: @escaping (UUID) -> Void,
        onOpenVideo: @escaping (UUID) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.thumbnailLoader = thumbnailLoader
        self.onBack = onBack
        self.onOpenChat = onOpenChat
        self.onOpenVideo = onOpenVideo
    }

    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(title: "History", onBack: onBack)
            HistorySegmentedControl(selection: $viewModel.segment)
                .padding(.horizontal, Spacing.reg)
                .padding(.vertical, Spacing.xs)
            content
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toast($viewModel.toast)
        .toolbar(.hidden, for: .navigationBar)
        .task { await viewModel.observeChanges() }
        .onAppear(perform: viewModel.load)
        .alert("Rename chat", isPresented: $viewModel.isRenamePresented) {
            TextField("Chat name", text: $viewModel.renameTitle)
            Button("Cancel", role: .cancel) {}
            Button("Save", action: viewModel.confirmRename)
                .disabled(!viewModel.canSaveRename)
        } message: {
            Text("Enter a new name for this chat")
        }
        .alert("Delete chat?", isPresented: isDeletePresented) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive, action: viewModel.confirmDelete)
        } message: {
            Text("This chat will be removed from your history.")
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.segment {
        case .chat:
            if viewModel.sections.isEmpty {
                HistoryEmptyState(
                    icon: .icMagicPencil60,
                    title: "No chats yet",
                    subtitle: "Start a conversation to see\nyour history here"
                )
            } else {
                ChatHistoryList(
                    sections: viewModel.sections,
                    activeRowID: $viewModel.openSwipeRowID,
                    onOpen: { onOpenChat($0.id) },
                    onRename: viewModel.beginRename,
                    onDelete: { viewModel.chatToDelete = $0 }
                )
            }
        case .video:
            if viewModel.generations.isEmpty {
                HistoryEmptyState(
                    icon: .icImageToImage60,
                    title: "No videos yet",
                    subtitle: "Create your first video to see it here"
                )
            } else {
                VideoHistoryGrid(
                    generations: viewModel.generations,
                    previewImages: viewModel.previewImages,
                    thumbnailLoader: thumbnailLoader,
                    onOpen: { onOpenVideo($0.id) },
                    onRetry: { viewModel.retry(generationID: $0.id) }
                )
            }
        }
    }

    private var isDeletePresented: Binding<Bool> {
        Binding(
            get: { viewModel.chatToDelete != nil },
            set: { if !$0 { viewModel.chatToDelete = nil } }
        )
    }
}
