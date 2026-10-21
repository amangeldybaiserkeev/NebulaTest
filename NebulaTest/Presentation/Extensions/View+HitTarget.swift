import SwiftUI

private let halfDivisor: Double = 2

extension View {
    /// Enlarges the tappable area to `minimum` points without changing the layout size.
    func hitTarget(visibleSize: Double, minimum: Double = TouchTarget.minimum) -> some View {
        let inset = max(0, (minimum - visibleSize) / halfDivisor)
        return padding(inset)
            .contentShape(.rect)
            .padding(-inset)
    }
}
