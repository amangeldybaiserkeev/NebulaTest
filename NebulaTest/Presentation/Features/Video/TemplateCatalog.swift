import Combine
import Foundation

@MainActor
final class TemplateCatalog: ObservableObject {
    @Published private(set) var state: LoadState<[VideoTemplate]> = .idle

    private let api: VideoAPI

    init(api: VideoAPI) {
        self.api = api
    }

    var templates: [VideoTemplate] {
        state.value ?? []
    }

    var categories: [String] {
        var seen: Set<String> = []
        return templates.map(\.category).filter { seen.insert($0).inserted }
    }

    func template(id: Int) -> VideoTemplate? {
        templates.first { $0.id == id }
    }

    func templates(in category: String) -> [VideoTemplate] {
        templates.filter { $0.category == category }
    }

    func load() async {
        guard state.value == nil else { return }
        state = .loading
        do {
            state = .loaded(try await api.templates())
        } catch {
            state = .failed(message: error.localizedDescription)
        }
    }
}
