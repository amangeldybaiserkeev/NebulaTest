import SwiftUI

struct OnboardingPage: Identifiable, Equatable {
    let id: Int
    let title: String
    let subtitle: String
    let background: ImageResource

    static let all: [Self] = [
        Self(
            id: 0,
            title: "Ask AI anything",
            subtitle: "Answers, emails, ideas and plans in seconds",
            background: .imgOnboarding1Bg
        ),
        Self(
            id: 1,
            title: "Turn photos into videos",
            subtitle: "Pick a template — AI animates your photo",
            background: .imgOnboarding2Bg
        )
    ]
}
