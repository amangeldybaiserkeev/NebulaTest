import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(spacing: Spacing.lg) {
                Image(.icSparkleLogo60)
                Text("Nebula")
                    .font(AppFont.title)
                    .foregroundStyle(.white)
                Text("Design tokens check")
                    .font(AppFont.caption)
                    .foregroundStyle(.textSecondary)
                RoundedRectangle(cornerRadius: Radius.xl)
                    .fill(LinearGradient.accent)
                    .frame(height: 50)
                    .padding(.horizontal, Spacing.lg)
            }
        }
    }
}

#Preview {
    ContentView()
}
