import Combine
import Foundation
import UIKit

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var chat: Chat?
    @Published private(set) var messages: [ChatMessage] = []
    @Published var draft = ""
    @Published private(set) var isGenerating = false
    @Published var toast: Toast?
    @Published var isPaywallPresented = false
    @Published var isActionsMenuPresented = false
    @Published var isDeleteAlertPresented = false
    @Published var isSharePresented = false
    @Published private(set) var isDeleted = false

    let suggestions = ["Help me write an email", "Explain it simply", "Translate a text", "Plan my day"]

    private let chatID: UUID
    private let api: ChatAPI
    private let store: ChatStore
    private let subscriptionService: SubscriptionService
    private let titleLimit = 40

    init(chatID: UUID?, api: ChatAPI, store: ChatStore, subscriptionService: SubscriptionService) {
        self.chatID = chatID ?? UUID()
        self.api = api
        self.store = store
        self.subscriptionService = subscriptionService
    }

    var canSend: Bool {
        !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isGenerating
    }

    var isPinned: Bool {
        chat?.isPinned ?? false
    }

    var shareText: String {
        messages.map { "\($0.role == .user ? "You" : "AI"): \($0.text)" }.joined(separator: "\n\n")
    }

    var lastAssistantMessageID: UUID? {
        messages.last { $0.role == .assistant }?.id
    }

    func load() {
        do {
            chat = try store.chat(id: chatID)
            messages = try store.messages(chatID: chatID)
        } catch {
            toast = Toast(style: .error, title: "Couldn't load chat")
        }
    }

    func useSuggestion(_ suggestion: String) {
        draft = suggestion
    }

    func send() async {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canSend else { return }
        guard subscriptionService.isPremium else {
            isPaywallPresented = true
            return
        }
        draft = ""
        do {
            if chat == nil {
                chat = try store.createChat(id: chatID, title: String(text.prefix(titleLimit)))
            }
            let userMessage = ChatMessage(id: UUID(), role: .user, text: text, createdAt: .now)
            try store.append(userMessage, to: chatID)
            messages.append(userMessage)
        } catch {
            toast = Toast(style: .error, title: "Couldn't save message")
            return
        }
        await generate(for: text, replacingLast: false)
    }

    func regenerate() async {
        guard !isGenerating, let lastUserMessage = messages.last(where: { $0.role == .user }) else { return }
        await generate(for: lastUserMessage.text, replacingLast: true)
    }

    func copy(_ message: ChatMessage) {
        UIPasteboard.general.string = message.text
        let copied = UIPasteboard.general.string == message.text
        toast = copied ? Toast(style: .success, title: "Copied") : Toast(style: .error, title: "Copy failed")
    }

    func togglePin() {
        guard let chat else { return }
        do {
            try store.setPinned(!chat.isPinned, chatID: chat.id)
            self.chat?.isPinned.toggle()
        } catch {
            toast = Toast(style: .error, title: "Couldn't update chat")
        }
    }

    func deleteChat() {
        do {
            if chat != nil { try store.deleteChat(id: chatID) }
            isDeleted = true
        } catch {
            toast = Toast(style: .error, title: "Couldn't delete chat")
        }
    }

    private func generate(for prompt: String, replacingLast: Bool) async {
        isGenerating = true
        defer { isGenerating = false }
        do {
            let reply = try await api.sendMessage(prompt, chatID: chatID)
            let assistantMessage = ChatMessage(id: UUID(), role: .assistant, text: reply, createdAt: .now)
            if replacingLast, let index = messages.lastIndex(where: { $0.role == .assistant }) {
                try store.replaceLastAssistantMessage(with: assistantMessage, in: chatID)
                messages[index] = assistantMessage
            } else {
                try store.append(assistantMessage, to: chatID)
                messages.append(assistantMessage)
            }
        } catch is CancellationError {
            return
        } catch {
            toast = Toast(style: .error, title: error.localizedDescription)
        }
    }
}
