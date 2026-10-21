import SwiftUI

struct ChatHeaderTitle: View {
    let date: Date
    let isPinned: Bool

    private let avatarSize: Double = 32

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(.icSparkleLogo60)
                .renderingMode(.template)
                .resizable()
                .frame(size: IconSize.reg)
                .foregroundStyle(.white)
                .frame(size: avatarSize)
                .background(LinearGradient.accent, in: .circle)

            VStack(alignment: .leading, spacing: Spacing.xxxs) {
                HStack(spacing: Spacing.xxs) {
                    Text("AI Chat")
                        .font(AppFont.navTitle)
                    if isPinned {
                        Image(.icPinTiny)
                            .resizable()
                            .scaledToFit()
                            .frame(height: IconSize.xxs)
                    }
                }
                Text(date, format: .chatDate)
                    .font(AppFont.caption)
            }
            .foregroundStyle(.white)
        }
    }
}
