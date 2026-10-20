import SwiftUI

struct PaywallBenefit: Identifiable {
    let icon: ImageResource
    let text: String

    var id: String { text }

    static let all: [Self] = [
        Self(icon: .icSparkleLogo60, text: "Get results in seconds"),
        Self(icon: .icMagicPencil60, text: "Turn any text into better writing"),
        Self(icon: .icPrompt, text: "Simplify complex information"),
        Self(icon: .icImageToImage60, text: "Create content with AI templates")
    ]
}
