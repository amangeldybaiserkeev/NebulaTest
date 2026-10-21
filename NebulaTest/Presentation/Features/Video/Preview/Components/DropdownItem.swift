import SwiftUI

struct DropdownItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    var icon: ImageResource?

    init(_ format: VideoFormat) {
        id = format.id
        title = format.rawValue
        subtitle = format.subtitle
        icon = switch format {
        case .landscape: .icRatio169
        case .portrait: .icRatio916
        case .square: .icRatio11
        }
    }

    init(quality: String) {
        id = quality
        title = quality
        subtitle = switch quality {
        case "720p": "Faster generation"
        case "1080p": "Recommended"
        default: nil
        }
    }
}
