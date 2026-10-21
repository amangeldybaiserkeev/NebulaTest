import SwiftUI

extension View {
    func frame(size: Double, alignment: Alignment = .center) -> some View {
        frame(width: size, height: size, alignment: alignment)
    }
}
