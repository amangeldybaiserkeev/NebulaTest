import Combine
import UIKit

@MainActor
final class HistoryViewModel: ObservableObject {
    enum Segment: String, CaseIterable, Identifiable {
        case chat = "Chat"
        case video = "Video"

        var id: String { rawValue }
    }

    @Published var segment: Segment = .chat
    @Published private(set) var sections: [ChatHistorySection] = []
    @Published private(set) var previewImages: [UUID: UIImage] = [:]
    @Published var openSwipeRowID: UUID?
    @Published var renameTitle = ""
    @Published var isRenamePresented = false
    @Published var chatToDelete: Chat?
    @Published var toast: Toast?

    private let chatStore: ChatStore
    private let generationManager: VideoGenerationManager
    private var chatToRename: Chat?
    private var cancellable: AnyCancellable?

    init(chatStore: ChatStore, generationManager: VideoGenerationManager) {
        self.chatStore = chatStore
        self.generationManager = generationManager
        cancellable = generationManager.objectWillChange.sink { [weak self] _ in self?.objectWillChange.send() }
        load()
    }

    var generations: [VideoGeneration] {
        generationManager.generations
    }

    var canSaveRename: Bool {
        !renameTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func load() {
        sections = ChatHistorySection.build(from: (try? chatStore.chats()) ?? [])
        loadPreviewImages()
    }

    func observeChanges() async {
        for await _ in chatStore.changes {
            load()
        }
    }

    func beginRename(_ chat: Chat) {
        chatToRename = chat
        renameTitle = chat.title
        isRenamePresented = true
    }

    func confirmRename() {
        guard let chat = chatToRename, canSaveRename else { return }
        do {
            try chatStore.rename(chatID: chat.id, title: renameTitle.trimmingCharacters(in: .whitespacesAndNewlines))
        } catch {
            toast = Toast(style: .error, title: "Couldn’t rename chat")
        }
        chatToRename = nil
    }

    func confirmDelete() {
        guard let chat = chatToDelete else { return }
        do {
            try chatStore.deleteChat(id: chat.id)
        } catch {
            toast = Toast(style: .error, title: "Couldn’t delete chat")
        }
        chatToDelete = nil
    }

    func retry(generationID: UUID) {
        do {
            try generationManager.retry(id: generationID)
        } catch {
            toast = Toast(style: .error, title: "Couldn’t restart generation")
        }
    }

    private func loadPreviewImages() {
        for generation in generations where generation.videoURL == nil && previewImages[generation.id] == nil {
            if let data = generationManager.sourceImage(id: generation.id), let image = UIImage(data: data) {
                previewImages[generation.id] = image
            }
        }
    }
}
