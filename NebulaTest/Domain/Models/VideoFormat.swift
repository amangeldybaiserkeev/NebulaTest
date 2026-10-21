import Foundation

enum VideoFormat: String, CaseIterable, Identifiable {
    case landscape = "16:9"
    case portrait = "9:16"
    case square = "1:1"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .landscape: "Landscape"
        case .portrait: "Portrait · Stories"
        case .square: "Square"
        }
    }

    var aspectRatio: Double {
        switch self {
        case .landscape: Self.wideSide / Self.narrowSide
        case .portrait: Self.narrowSide / Self.wideSide
        case .square: 1
        }
    }

    private static let wideSide: Double = 16
    private static let narrowSide: Double = 9
}
