import SwiftUI

struct Toast: Equatable {
    enum Style {
        case success
        case error
    }

    let style: Style
    let title: String
    var subtitle: String?
}
