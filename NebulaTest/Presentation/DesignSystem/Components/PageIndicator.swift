import SwiftUI

struct PageIndicator: View {
    let pageCount: Int
    let currentPage: Int

    private let activeWidth: Double = 22
    private let dotSize: Double = 8
    private let dotSpacing: Double = 6

    var body: some View {
        HStack(spacing: dotSpacing) {
            ForEach(0..<pageCount, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage
                          ? AnyShapeStyle(LinearGradient.accent)
                          : AnyShapeStyle(Color.white.opacity(Opacity.faint)))
                    .frame(width: index == currentPage ? activeWidth : dotSize, height: dotSize)
            }
        }
        .animation(Animations.indicator, value: currentPage)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(currentPage + 1) of \(pageCount)")
    }
}

#Preview {
    PageIndicator(pageCount: 2, currentPage: 0)
        .padding()
        .background(Color.appBackground)
}
