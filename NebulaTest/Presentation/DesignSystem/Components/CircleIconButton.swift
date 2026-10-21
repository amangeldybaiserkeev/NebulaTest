import SwiftUI

struct CircleIconButton: View {
    let icon: ImageResource
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(icon)
                .resizable()
                .frame(size: IconSize.reg)
                .foregroundStyle(.white)
                .frame(size: IconSize.xxl)
                .background(Color.white.opacity(Opacity.subtle), in: .circle)
                .frame(size: TouchTarget.minimum)
                .contentShape(.rect)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    CircleIconButton(icon: .icSettings) {}
        .padding()
        .background(Color.appBackground)
}
