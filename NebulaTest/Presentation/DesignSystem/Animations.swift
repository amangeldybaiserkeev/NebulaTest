import SwiftUI

enum Animations {
    private enum Seconds {
        static let press: Double = 0.15
        static let state: Double = 0.2
        static let indicator: Double = 0.25
        static let page: Double = 0.3
        static let screen: Double = 0.35
    }

    static let press = Animation.easeOut(duration: Seconds.press)
    static let state = Animation.easeInOut(duration: Seconds.state)
    static let indicator = Animation.easeInOut(duration: Seconds.indicator)
    static let page = Animation.easeInOut(duration: Seconds.page)
    static let fadeIn = Animation.easeIn(duration: Seconds.page)
    static let screen = Animation.easeInOut(duration: Seconds.screen)

    static let pressedScale: Double = 0.98
}
