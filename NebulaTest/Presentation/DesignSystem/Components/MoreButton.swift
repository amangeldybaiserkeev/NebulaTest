import SwiftUI

struct MoreButton: View {
    let action: () -> Void

    private let dotCount = 3
    private let dotSize: Double = 4
    private let dotSpacing: Double = 3

    var body: some View {
        Button(action: action) {
            HStack(spacing: dotSpacing) {
                ForEach(0..<dotCount, id: \.self) { _ in
                    Circle().fill(.white).frame(size: dotSize)
                }
            }
            .frame(size: IconSize.xxl)
            .background(Color.white.opacity(Opacity.subtle), in: .circle)
            .hitTarget(visibleSize: IconSize.xxl)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    MoreButton {}
        .padding()
        .background(Color.appBackground)
}
