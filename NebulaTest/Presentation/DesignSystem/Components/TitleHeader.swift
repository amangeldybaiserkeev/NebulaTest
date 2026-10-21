import SwiftUI

struct TitleHeader: View {
    var title: String?
    let onBack: () -> Void

    private let height: Double = 52

    var body: some View {
        ZStack {
            if let title {
                Text(title)
                    .font(AppFont.navTitle)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .padding(.horizontal, IconSize.reg + Spacing.reg)
            }
            HStack {
                BackButton(action: onBack)
                Spacer()
            }
        }
        .padding(.horizontal, Spacing.reg)
        .frame(height: height)
    }
}

#Preview {
    TitleHeader(title: "Result") {}
        .background(Color.appBackground)
}
