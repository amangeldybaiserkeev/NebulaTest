import SwiftUI

extension LinearGradient {
    static let accent = LinearGradient(
        colors: [.gradientStart, .gradientEnd],
        startPoint: .leading,
        endPoint: .trailing
    )
}
