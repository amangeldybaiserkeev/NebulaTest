import SwiftUI

struct PurchaseProgressOverlay: View {
    var body: some View {
        Color.appBackground.opacity(Opacity.secondary)
            .ignoresSafeArea()
            .overlay {
                ProgressView()
                    .tint(.white)
                    .controlSize(.large)
            }
            .transition(.opacity)
            .accessibilityLabel("Processing purchase")
    }
}
