import SwiftUI

struct HistoryEmptyState: View {
    let icon: ImageResource
    let title: String
    let subtitle: String

    private let titleKerning: Double = 0.4

    var body: some View {
        VStack(spacing: Spacing.reg) {
            Image(icon)
                .resizable()
                .frame(size: IconSize.hero)
            VStack(spacing: Spacing.xs) {
                Text(title)
                    .font(AppFont.title)
                    .kerning(titleKerning)
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(AppFont.body)
                    .foregroundStyle(.white.opacity(Opacity.half))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HistoryEmptyState(icon: .icMagicPencil60, title: "No chats yet", subtitle: "Start a conversation to see\nyour history here")
        .background(Color.appBackground)
}
