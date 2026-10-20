import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            GlowBackground(glowOpacity: Opacity.muted)
            Text("Your AI tools,\nready to go")
                .font(AppFont.title)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    MainView()
}
