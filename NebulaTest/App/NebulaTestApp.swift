import SwiftUI

@main
struct NebulaTestApp: App {
    @StateObject private var holder = ContainerHolder()

    var body: some Scene {
        WindowGroup {
            RootView(container: holder.container)
        }
    }
}
