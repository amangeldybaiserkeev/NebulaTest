import Lottie
import SwiftUI

struct GeneratingView: View {
    @ObservedObject var manager: VideoGenerationManager
    let generationID: UUID
    let onBack: () -> Void
    let onFinished: (VideoGeneration) -> Void

    @State private var toast: Toast?

    private let loaderSize: Double = 200

    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(onBack: onBack)
            Spacer()
            VStack(spacing: Spacing.xxxl) {
                LottieView(animation: .named("generating_loader"))
                    .looping()
                    .resizable()
                    .frame(size: loaderSize)
                VStack(spacing: Spacing.xs) {
                    Text("Generating…")
                        .font(AppFont.heading)
                        .foregroundStyle(.white)
                    Text("We’re creating the best result for you")
                        .font(AppFont.body)
                        .foregroundStyle(.textSecondary)
                }
            }
            Spacer()
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toast($toast)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: handleStatus)
        .onChange(of: manager.generation(id: generationID)?.status) { _ in handleStatus() }
    }

    private func handleStatus() {
        guard let generation = manager.generation(id: generationID) else { return }
        switch generation.status {
        case .generating:
            break
        case .finished:
            onFinished(generation)
        case .failed(let message):
            toast = Toast(style: .error, title: message)
        }
    }
}
