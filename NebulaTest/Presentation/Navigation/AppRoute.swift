import Foundation

enum AppRoute: Hashable {
    case chat(id: UUID)
    case videoTemplates
    case history
    case settings
}
