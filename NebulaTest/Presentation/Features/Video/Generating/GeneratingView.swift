import Lottie
import SwiftUI

struct GeneratingView: View {
    @ObservedObject var manager: VideoGenerationManager
    let generationID: UUID
    let onBack: () -> Void
    let onFinished: (VideoGeneration) -> Void

    private let loaderSize: Double = 200

    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(onBack: onBack)
            if let message = failureMessage {
                ErrorStateView(message: message, onRetry: retry)
            } else {
                loader
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: handleStatus)
        .onChange(of: manager.generation(id: generationID)?.status) { _ in handleStatus() }
    }

    private var loader: some View {
        VStack(spacing: 0) {
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
    }

    private var failureMessage: String? {
        guard case .failed(let message) = manager.generation(id: generationID)?.status else { return nil }
        return message.isEmpty ? "Something went wrong" : message
    }

    private func handleStatus() {
        guard let generation = manager.generation(id: generationID), case .finished = generation.status else { return }
        onFinished(generation)
    }

    private func retry() {
        try? manager.retry(id: generationID)
    }
}
