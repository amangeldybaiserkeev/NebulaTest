import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    let composerNamespace: Namespace.ID
    let isComposerHidden: Bool
    let onOpenChat: () -> Void
    let onOpenVideo: () -> Void
    let onOpenHistory: () -> Void
    let onOpenSettings: () -> Void
    let onShowPaywall: () -> Void

    private let titleKerning: Double = 0.4

    init(
        viewModel: MainViewModel,
        composerNamespace: Namespace.ID,
        isComposerHidden: Bool,
        onOpenChat: @escaping () -> Void,
        onOpenVideo: @escaping () -> Void,
        onOpenHistory: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void,
        onShowPaywall: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.composerNamespace = composerNamespace
        self.isComposerHidden = isComposerHidden
        self.onOpenChat = onOpenChat
        self.onOpenVideo = onOpenVideo
        self.onOpenHistory = onOpenHistory
        self.onOpenSettings = onOpenSettings
        self.onShowPaywall = onShowPaywall
    }

    var body: some View {
        ZStack {
            GlowBackground(glowOpacity: Opacity.muted)

            VStack(spacing: 0) {
                MainHeader(
                    isPremium: viewModel.isPremium,
                    onHistory: onOpenHistory,
                    onPro: onShowPaywall,
                    onSettings: onOpenSettings
                )

                Spacer()

                VStack(spacing: Spacing.lg) {
                    Image(.icSparkleLogo60)
                    Text("Your AI tools,\nready to go")
                        .font(AppFont.title)
                        .kerning(titleKerning)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    composer
                }

                VideoFeatureCard(action: onOpenVideo)
                    .padding(.top, Spacing.xxxl)

                Spacer()
            }
            .padding(.horizontal, Spacing.reg)
        }
        .task { await viewModel.observePremiumStatus() }
    }

    @ViewBuilder
    private var composer: some View {
        if isComposerHidden {
            Color.clear.frame(height: TouchTarget.large)
        } else {
            MessageComposerButton(placeholder: "Ask anything...", action: onOpenChat)
                .matchedGeometryEffect(id: ComposerGeometry.id, in: composerNamespace)
        }
    }
}
