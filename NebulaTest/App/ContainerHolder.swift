import Combine
import Foundation

@MainActor
final class ContainerHolder: ObservableObject {
    let container = AppContainer()
}
