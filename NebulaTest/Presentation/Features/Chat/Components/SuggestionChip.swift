import SwiftUI

struct SuggestionChip: View {
    let title: String
    let action: () -> Void

    private let verticalPadding: Double = 10
    private let horizontalPadding: Double = 14
    private let borderWidth: Double = 1
    private let borderOpacity: Double = 0.12
    private let textOpacity: Double = 0.9

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.caption)
                .foregroundStyle(.white.opacity(textOpacity))
                .padding(.vertical, verticalPadding)
                .padding(.horizontal, horizontalPadding)
                .background(Color.card.opacity(Opacity.pressed), in: .capsule)
                .overlay {
                    Capsule().strokeBorder(Color.white.opacity(borderOpacity), lineWidth: borderWidth)
                }
        }
        .buttonStyle(PressableButtonStyle())
    }
}
