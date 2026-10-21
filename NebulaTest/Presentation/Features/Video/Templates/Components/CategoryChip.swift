import SwiftUI

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppFont.caption)
                .foregroundStyle(.white.opacity(isSelected ? 1 : Opacity.half))
                .padding(.vertical, Spacing.xs)
                .padding(.horizontal, Spacing.reg)
                .background(
                    isSelected ? AnyShapeStyle(LinearGradient.accent) : AnyShapeStyle(Color.card.opacity(Opacity.secondary)),
                    in: .capsule
                )
        }
        .buttonStyle(PressableButtonStyle())
        .animation(Animations.state, value: isSelected)
    }
}

#Preview {
    HStack {
        CategoryChip(title: "Popular", isSelected: true) {}
        CategoryChip(title: "Funny", isSelected: false) {}
    }
    .padding()
    .background(Color.appBackground)
}
