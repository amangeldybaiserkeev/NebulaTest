import SwiftUI

struct GradientSpinner: View {
    var lineWidth: Double = 3

    private let trimEnd: Double = 0.75
    private let turnDuration: Double = 1
    private let fullTurn: Double = 360

    var body: some View {
        TimelineView(.animation) { timeline in
            let progress = timeline.date.timeIntervalSinceReferenceDate
                .truncatingRemainder(dividingBy: turnDuration) / turnDuration
            Circle()
                .trim(from: 0, to: trimEnd)
                .stroke(LinearGradient.accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(progress * fullTurn))
        }
    }
}

#Preview {
    GradientSpinner()
        .frame(size: IconSize.lg)
        .padding()
        .background(Color.appBackground)
}
