import SwiftUI

struct OnboardingView: View {
    let onFinish: () -> Void

    @State private var currentPage = 0
    private let pages = OnboardingPage.all
    private let topInset = WindowSafeArea.insets.top
    private let controlsSpacing: Double = 20

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(pages) { page in
                    OnboardingPageView(page: page, topInset: topInset)
                        .tag(page.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            VStack(spacing: controlsSpacing) {
                PageIndicator(pageCount: pages.count, currentPage: currentPage)
                GradientButton(title: "Continue", action: advance)
                    .padding(.horizontal, Spacing.reg)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(Animations.page) {
                currentPage += 1
            }
        } else {
            onFinish()
        }
    }
}

#Preview {
    OnboardingView(onFinish: {})
}
