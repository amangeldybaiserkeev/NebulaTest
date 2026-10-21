import SwiftUI

struct PhotoSlot: View {
    let state: TemplatePreviewViewModel.PhotoState

    private let size: Double = 100
    private let borderWidth: Double = 1

    var body: some View {
        ZStack {
            switch state {
            case .empty:
                RoundedRectangle(cornerRadius: Radius.sm)
                    .strokeBorder(LinearGradient.accent, lineWidth: borderWidth)
                Image(.icPlus)
                    .resizable()
                    .frame(size: IconSize.lg)
                    .foregroundStyle(.white)
            case .loading:
                Color.card.opacity(Opacity.muted)
                GradientSpinner()
                    .frame(size: IconSize.lg)
            case .ready(let image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            }
        }
        .frame(size: size)
        .clipShape(.rect(cornerRadius: Radius.sm))
        .contentShape(.rect(cornerRadius: Radius.sm))
    }
}

struct PhotoRemoveButton: View {
    let action: () -> Void

    private let cornerOffset = Spacing.sm + Spacing.xxxs

    var body: some View {
        Button(action: action) {
            Image(.icPhotoRemove)
                .resizable()
                .frame(size: IconSize.lg)
                .frame(size: TouchTarget.minimum)
                .contentShape(.circle)
        }
        .buttonStyle(PressableButtonStyle())
        .offset(x: cornerOffset, y: -cornerOffset)
    }
}

#Preview {
    HStack(spacing: Spacing.reg) {
        PhotoSlot(state: .empty)
        PhotoSlot(state: .loading)
    }
    .padding()
    .background(Color.appBackground)
}
