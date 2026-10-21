import Foundation

enum AppRoute: Hashable {
    case chat(id: UUID)
    case videoTemplates
    case templatePreview(templateID: Int, category: String)
    case generating(id: UUID)
    case videoResult(id: UUID)
    case history
    case settings
}
