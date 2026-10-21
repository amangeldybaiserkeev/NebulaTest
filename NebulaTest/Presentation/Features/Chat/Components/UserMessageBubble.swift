import SwiftUI

struct UserMessageBubble: View {
    let text: String

    var body: some View {
        Text(text)
            .font(AppFont.body)
            .foregroundStyle(.white)
            .padding(Spacing.reg)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient.accent,
                in: .rect(topLeadingRadius: Radius.md, bottomLeadingRadius: Radius.md, topTrailingRadius: Radius.md)
            )
    }
}
