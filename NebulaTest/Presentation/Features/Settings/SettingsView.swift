import StoreKit
import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel
    let container: AppContainer
    let onBack: () -> Void

    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview

    private let groupSpacing: Double = 28

    init(viewModel: SettingsViewModel, container: AppContainer, onBack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
        self.onBack = onBack
    }

    var body: some View {
        VStack(spacing: 0) {
            TitleHeader(title: "Settings", onBack: onBack)
            ScrollView {
                VStack(spacing: groupSpacing) {
                    supportGroup
                    purchasesGroup
                    infoGroup
                    Text("App Version: \(viewModel.appVersion)")
                        .font(AppFont.systemFootnote)
                        .foregroundStyle(.white.opacity(Opacity.secondary))
                        .padding(.vertical, Spacing.reg)
                }
                .padding(.top, Spacing.reg)
                .padding(.bottom, Spacing.reg)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.appBackground.ignoresSafeArea())
        .toast($viewModel.toast)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: viewModel.refreshCacheSize)
        .sheet(isPresented: $viewModel.isSharePresented) {
            ShareSheet(items: [AppConfig.Links.appStore])
        }
        .fullScreenCover(isPresented: $viewModel.isPaywallPresented) {
            PaywallView(
                viewModel: container.makePaywallViewModel(),
                onClose: { viewModel.isPaywallPresented = false },
                onUnlock: { viewModel.isPaywallPresented = false }
            )
        }
    }

    private var supportGroup: some View {
        SettingsGroup(title: "Support us") {
            SettingsRow(symbol: "star", title: "Rate app") { requestReview() }
            SettingsRow(symbol: "square.and.arrow.up", title: "Share with friends") { viewModel.isSharePresented = true }
        }
    }

    private var purchasesGroup: some View {
        SettingsGroup(title: "Purchases & Actions") {
            SettingsRow(symbol: "sparkles", title: "Upgrade plan") { viewModel.isPaywallPresented = true }
            SettingsRow(symbol: "bell", title: "Notifications", accessory: .toggle(notificationsBinding))
            SettingsRow(
                symbol: "trash",
                title: "Clear cache",
                accessory: .detail(viewModel.cacheSizeText),
                action: viewModel.clearCache
            )
            SettingsRow(symbol: "arrow.clockwise.icloud", title: "Restore purchases") {
                Task { await viewModel.restore() }
            }
        }
    }

    private var infoGroup: some View {
        SettingsGroup(title: "Info & legal") {
            SettingsRow(symbol: "text.bubble", title: "Contact us") { openURL(AppConfig.Links.support) }
            SettingsRow(symbol: "folder.badge.person.crop", title: "Privacy Policy") { openURL(AppConfig.Links.privacyPolicy) }
            SettingsRow(symbol: "doc.text", title: "Usage Policy") { openURL(AppConfig.Links.termsOfUse) }
        }
    }

    private var notificationsBinding: Binding<Bool> {
        Binding(
            get: { viewModel.notificationsEnabled },
            set: { enabled in Task { await viewModel.setNotifications(enabled) } }
        )
    }
}
