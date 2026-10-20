import SwiftUI

struct OnboardingPageView: View {
    let page: OnboardingPage
    let topInset: Double

    private let titleTopPadding: Double = 56

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                Image(page.background)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .accessibilityHidden(true)

                VStack(spacing: Spacing.md) {
                    Text(page.title)
                        .font(AppFont.title)
                        .foregroundStyle(.white)
                    Text(page.subtitle)
                        .font(AppFont.body)
                        .foregroundStyle(.white.opacity(Opacity.secondary))
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.screenEdge)
                .padding(.top, topInset + titleTopPadding)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    OnboardingPageView(page: OnboardingPage.all[0], topInset: 0)
}
