import SwiftUI

struct ToastView: View {
    let toast: Toast

    private let borderWidth: Double = 1

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(toast.style == .success ? .icToastCheck : .icToastClose)
                .resizable()
                .frame(size: IconSize.reg)
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Text(toast.title)
                    .font(AppFont.bodySemibold)
                    .foregroundStyle(.white)
                if let subtitle = toast.subtitle {
                    Text(subtitle)
                        .font(AppFont.caption)
                        .foregroundStyle(.textSecondary)
                }
            }
            .padding(.trailing, Spacing.xxs)
        }
        .padding(.horizontal, Spacing.reg)
        .padding(.vertical, Spacing.sm)
        .background(Color.card.opacity(Opacity.medium), in: .capsule)
        .background(.ultraThinMaterial, in: .capsule)
        .overlay {
            Capsule().strokeBorder(Color.white.opacity(Opacity.light), lineWidth: borderWidth)
        }
    }
}

#Preview {
    VStack(spacing: Spacing.reg) {
        ToastView(toast: Toast(style: .success, title: "Copied"))
        ToastView(toast: Toast(style: .error, title: "Copy failed"))
        ToastView(toast: Toast(style: .success, title: "Video saved", subtitle: "You can find it in your Photos"))
    }
    .padding()
    .background(Color.appBackground)
}
