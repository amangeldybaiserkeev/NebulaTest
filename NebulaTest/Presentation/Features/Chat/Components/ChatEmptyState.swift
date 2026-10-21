import SwiftUI

struct ChatEmptyState: View {
    let suggestions: [String]
    let onSelect: (String) -> Void

    var body: some View {
        VStack(spacing: Spacing.lg) {
            VStack(spacing: Spacing.xs) {
                HStack(spacing: 0) {
                    Text("Your ")
                    Text("AI assistant").foregroundStyle(LinearGradient.accent)
                    Text(" for anything")
                }
                .font(AppFont.heading)
                Text("Pick a suggestion below or ask your own question")
                    .font(AppFont.caption)
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)

            WrapLayout(spacing: Spacing.xs) {
                ForEach(suggestions, id: \.self) { suggestion in
                    SuggestionChip(title: suggestion) { onSelect(suggestion) }
                }
            }
        }
        .padding(.horizontal, Spacing.reg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ChatEmptyState(suggestions: ["Help me write an email", "Explain it simply", "Translate a text", "Plan my day"]) { _ in }
        .background(Color.appBackground)
}
