import SwiftUI

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(.icBackArrow)
                .resizable()
                .frame(size: IconSize.reg)
                .foregroundStyle(.white)
                .hitTarget(visibleSize: IconSize.reg)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    BackButton {}
        .background(Color.appBackground)
}
