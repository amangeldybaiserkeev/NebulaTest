import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? Animations.pressedScale : 1)
            .opacity(configuration.isPressed ? Opacity.pressed : 1)
            .animation(Animations.press, value: configuration.isPressed)
    }
}
