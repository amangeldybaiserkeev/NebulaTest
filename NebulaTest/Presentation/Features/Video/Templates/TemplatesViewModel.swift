import Combine
import Foundation

@MainActor
final class TemplatesViewModel: ObservableObject {
    @Published var selectedCategory: String?

    private let catalog: TemplateCatalog
    private var cancellable: AnyCancellable?

    init(catalog: TemplateCatalog) {
        self.catalog = catalog
        cancellable = catalog.objectWillChange.sink { [weak self] _ in self?.objectWillChange.send() }
    }

    var state: LoadState<[VideoTemplate]> {
        catalog.state
    }

    var categories: [String] {
        catalog.categories
    }

    var templates: [VideoTemplate] {
        selectedCategory.map(catalog.templates(in:)) ?? catalog.templates
    }

    func load() async {
        await catalog.load()
        if selectedCategory == nil {
            selectedCategory = categories.first
        }
    }
}
