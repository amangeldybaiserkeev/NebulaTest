import SwiftUI

struct PaywallCloseButton: View {
    let isVisible: Bool
    let action: () -> Void

    private let inset: Double = 6

    var body: some View {
        Button("Close", systemImage: "xmark", action: action)
            .labelStyle(.iconOnly)
            .font(AppFont.systemCloseIcon)
            .foregroundStyle(.white)
            .frame(width: ControlSize.touchTarget, height: ControlSize.touchTarget)
            .contentShape(.rect)
            .opacity(isVisible ? Opacity.prominent : 0)
            .allowsHitTesting(isVisible)
            .padding(.leading, inset)
            .padding(.top, inset)
    }
}

#Preview {
    PaywallCloseButton(isVisible: true) {}
        .background(Color.appBackground)
}
