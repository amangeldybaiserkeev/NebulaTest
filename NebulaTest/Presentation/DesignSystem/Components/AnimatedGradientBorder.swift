import SwiftUI

struct AnimatedGradientBorder: ViewModifier {
    let cornerRadius: Double
    var lineWidth: Double = 1
    var cycleDuration: Double = 2.5

    private let fullTurn: Double = 360

    func body(content: Content) -> some View {
        content.overlay {
            TimelineView(.animation) { timeline in
                let progress = timeline.date.timeIntervalSinceReferenceDate
                    .truncatingRemainder(dividingBy: cycleDuration) / cycleDuration
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        AngularGradient(
                            colors: [.gradientStart, .gradientEnd, .gradientStart],
                            center: .center,
                            angle: .degrees(progress * fullTurn)
                        ),
                        lineWidth: lineWidth
                    )
            }
        }
    }
}

extension View {
    func animatedGradientBorder(cornerRadius: Double, lineWidth: Double = 1) -> some View {
        modifier(AnimatedGradientBorder(cornerRadius: cornerRadius, lineWidth: lineWidth))
    }
}
