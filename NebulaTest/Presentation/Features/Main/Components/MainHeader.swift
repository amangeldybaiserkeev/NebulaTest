import SwiftUI

struct MainHeader: View {
    let isPremium: Bool
    let onHistory: () -> Void
    let onPro: () -> Void
    let onSettings: () -> Void

    var body: some View {
        HStack {
            CircleIconButton(icon: .icHistoryClock, action: onHistory)
            Spacer()
            if !isPremium {
                ProBadgeButton(action: onPro)
                    .transition(.opacity)
            }
            Spacer()
            CircleIconButton(icon: .icSettings, action: onSettings)
        }
        .padding(.horizontal, Spacing.reg)
        .padding(.vertical, Spacing.xs)
        .animation(Animations.state, value: isPremium)
    }
}

#Preview {
    VStack {
        MainHeader(isPremium: false, onHistory: {}, onPro: {}, onSettings: {})
        MainHeader(isPremium: true, onHistory: {}, onPro: {}, onSettings: {})
    }
    .background(Color.appBackground)
}
