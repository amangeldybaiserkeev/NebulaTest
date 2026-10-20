import SwiftUI

enum AppFont {
    enum Weight {
        case regular
        case medium
        case semibold
        case bold

        var fontName: String {
            switch self {
            case .regular: "Inter-Regular"
            case .medium: "Inter-Medium"
            case .semibold: "Inter-SemiBold"
            case .bold: "Inter-Bold"
            }
        }
    }

    enum Size {
        static let largeTitle: Double = 34
        static let title: Double = 28
        static let heading: Double = 20
        static let navTitle: Double = 18
        static let closeIcon: Double = 17
        static let body: Double = 16
        static let caption: Double = 14
        static let small: Double = 12
        static let legal: Double = 11
    }

    static func custom(_ size: Double, weight: Weight = .regular) -> Font {
        Font.custom(weight.fontName, size: size)
    }

    static let largeTitle = custom(Size.largeTitle, weight: .bold)
    static let title = custom(Size.title, weight: .bold)
    static let heading = custom(Size.heading, weight: .semibold)
    static let navTitle = custom(Size.navTitle, weight: .semibold)
    static let body = custom(Size.body)
    static let bodyMedium = custom(Size.body, weight: .medium)
    static let bodySemibold = custom(Size.body, weight: .semibold)
    static let caption = custom(Size.caption)
    static let captionMedium = custom(Size.caption, weight: .medium)
    static let small = custom(Size.small, weight: .medium)

    static let systemSmall = Font.system(size: Size.small)
    static let systemLegal = Font.system(size: Size.legal)
    static let systemCloseIcon = Font.system(size: Size.closeIcon)
}
