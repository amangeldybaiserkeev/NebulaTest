import SwiftUI

struct SplashView: View {
    var duration: Double = RootViewModel.splashSeconds

    @State private var progress: Double = 0

    private let barWidth: Double = 212
    private let barHeight: Double = 4

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: Spacing.lg) {
                Image(.imgGhostSplash)

                Capsule()
                    .fill(Color.white.opacity(Opacity.subtle))
                    .frame(width: barWidth, height: barHeight)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(LinearGradient.accent)
                            .frame(width: barWidth * progress, height: barHeight)
                    }
            }
        }
        .onAppear(perform: startProgress)
    }

    private func startProgress() {
        withAnimation(.linear(duration: duration)) {
            progress = 1
        }
    }
}

#Preview {
    SplashView()
}
