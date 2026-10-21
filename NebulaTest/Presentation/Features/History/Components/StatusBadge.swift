import SwiftUI

struct StatusBadge: View {
    let title: String
    let color: Color

    private let dotSize: Double = 6
    private let dotSpacing: Double = 5
    private let leadingPadding: Double = 8
    private let trailingPadding: Double = 10
    private let backgroundOpacity: Double = 0.7
    private let borderWidth: Double = 1

    var body: some View {
        HStack(spacing: dotSpacing) {
            Circle()
                .fill(color)
                .frame(size: dotSize)
            Text(title)
                .font(AppFont.small)
                .foregroundStyle(color)
        }
        .padding(.vertical, Spacing.xxs)
        .padding(.leading, leadingPadding)
        .padding(.trailing, trailingPadding)
        .background(Color.appBackground.opacity(backgroundOpacity), in: .capsule)
        .overlay {
            Capsule().strokeBorder(color.opacity(Opacity.half), lineWidth: borderWidth)
        }
    }
}

#Preview {
    HStack {
        StatusBadge(title: "New", color: .success)
        StatusBadge(title: "In progress", color: .gradientStart)
        StatusBadge(title: "Error", color: .statusError)
    }
    .padding()
    .background(Color.appBackground)
}
