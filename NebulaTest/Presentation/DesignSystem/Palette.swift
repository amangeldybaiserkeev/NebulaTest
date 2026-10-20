import SwiftUI

extension LinearGradient {
    static let accent = LinearGradient(
        colors: [.gradientStart, .gradientEnd],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
