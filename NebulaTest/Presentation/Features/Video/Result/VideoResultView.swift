import SwiftUI

struct VideoResultView: View {
    @StateObject private var viewModel: VideoResultViewModel
    let onBack: () -> Void
    let onReplace: () -> Void

    init(viewModel: VideoResultViewModel, onBack: @escaping () -> Void, onReplace: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBack = onBack
        self.onReplace = onReplace
    }

    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(title: "Result", onBack: onBack)

            GeometryReader { proxy in
                let size = fit(viewModel.format.aspectRatio, in: proxy.size)
                player
                    .frame(width: size.width, height: size.height)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, Spacing.reg)

            HStack(spacing: Spacing.reg) {
                SecondaryButton(title: "Share", action: share)
                GradientButton(title: "Download", action: download)
            }
            .disabled(viewModel.isBusy)
            .padding(Spacing.reg)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .notice($viewModel.notice)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $viewModel.shareURL) { url in
            ShareSheet(items: [url])
        }
    }

    @ViewBuilder
    private var player: some View {
        if let url = viewModel.videoURL {
            ResultPlayer(url: url, isPlaying: viewModel.isPlaying, onReplace: onReplace)
                .clipShape(.rect(cornerRadius: Radius.md))
                .contentShape(.rect(cornerRadius: Radius.md))
                .onTapGesture(perform: viewModel.togglePlayback)
        }
    }

    private func fit(_ aspectRatio: Double, in size: CGSize) -> CGSize {
        let width = min(size.width, size.height * aspectRatio)
        return CGSize(width: width, height: width / aspectRatio)
    }

    private func share() {
        Task { await viewModel.share() }
    }

    private func download() {
        Task { await viewModel.download() }
    }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}
