import SwiftUI

enum AppFont {
    enum Weight {
        case regular
        case medium
        case semibold
        case bold
        
        var fontName: String {
            switch self {
            case .regular: return "Inter-Regular"
            case .medium: return "Inter-Medium"
            case .semibold: return "Inter-SemiBold"
            case .bold: return "Inter-Bold"
            }
        }
    }
    
    static func custom(_ size: CGFloat, weight: Weight = .regular) -> Font {
        Font.custom(weight.fontName, size: size)
    }
    
    static let largeTitle = custom(34, weight: .bold)
    static let title = custom(28, weight: .bold)
    static let heading = custom(20, weight: .semibold)
    static let navTitle = custom(18, weight: .semibold)
    static let body = custom(16)
    static let bodyMedium = custom(16, weight: .medium)
    static let bodySemibold = custom(16, weight: .semibold)
    static let caption = custom(14)
    static let captionMedium = custom(14, weight: .medium)
    static let small = custom(12, weight: .medium)
}
