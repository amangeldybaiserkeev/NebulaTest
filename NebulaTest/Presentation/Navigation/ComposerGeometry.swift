import SwiftUI

enum ComposerGeometry {
    static let id = "message-composer"
}

extension View {
    @ViewBuilder
    func composerGeometry(in namespace: Namespace.ID?) -> some View {
        if let namespace {
            matchedGeometryEffect(id: ComposerGeometry.id, in: namespace)
        } else {
            self
        }
    }
}
