import SwiftUI

struct NoticeModifier: ViewModifier {
    @Binding var notice: Toast?
    var duration: Double = 2

    private let width: Double = 239
    private let dimOpacity: Double = 0.6

    func body(content: Content) -> some View {
        content.overlay {
            if let notice {
                ZStack {
                    Color.black.opacity(dimOpacity).ignoresSafeArea()
                    card(notice)
                }
                .transition(.opacity)
                .task(id: notice) { await autoDismiss() }
            }
        }
        .animation(Animations.page, value: notice)
    }

    private func card(_ notice: Toast) -> some View {
        VStack(spacing: Spacing.xs) {
            Image(notice.style == .success ? .icSavedCheck40 : .icSavedError40)
                .resizable()
                .frame(size: IconSize.xxl)
            VStack(spacing: Spacing.xxs) {
                Text(notice.title)
                    .font(AppFont.bodySemibold)
                    .foregroundStyle(.white)
                if let subtitle = notice.subtitle {
                    Text(subtitle)
                        .font(AppFont.caption)
                        .foregroundStyle(.white.opacity(Opacity.half))
                }
            }
            .multilineTextAlignment(.center)
        }
        .padding(.vertical, Spacing.lg)
        .padding(.horizontal, Spacing.reg)
        .frame(width: width)
        .background(Color.card.opacity(Opacity.medium), in: .rect(cornerRadius: Radius.md))
        .background(.ultraThinMaterial, in: .rect(cornerRadius: Radius.md))
    }

    private func autoDismiss() async {
        try? await Task.sleep(for: .seconds(duration))
        guard !Task.isCancelled else { return }
        notice = nil
    }
}

extension View {
    func notice(_ notice: Binding<Toast?>) -> some View {
        modifier(NoticeModifier(notice: notice))
    }
}

#Preview {
    Color.appBackground
        .ignoresSafeArea()
        .notice(.constant(Toast(style: .success, title: "Video saved", subtitle: "You can find it in your Photos")))
}
