import SwiftUI

struct HistorySegmentedControl: View {
    @Binding var selection: HistoryViewModel.Segment

    @Namespace private var namespace

    private let segmentHeight: Double = 32

    var body: some View {
        HStack(spacing: 0) {
            ForEach(HistoryViewModel.Segment.allCases) { segment in
                Button {
                    withAnimation(Animations.state) { selection = segment }
                } label: {
                    Text(segment.rawValue)
                        .font(AppFont.bodySemibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: segmentHeight)
                        .background {
                            if segment == selection {
                                Capsule()
                                    .fill(Color.white.opacity(Opacity.subtle))
                                    .matchedGeometryEffect(id: "selection", in: namespace)
                            }
                        }
                        .contentShape(.capsule)
                }
                .buttonStyle(PressableButtonStyle())
            }
        }
        .padding(Spacing.xxs)
        .background(Color.card.opacity(Opacity.medium), in: .capsule)
    }
}

#Preview {
    HistorySegmentedControl(selection: .constant(.chat))
        .padding()
        .background(Color.appBackground)
}
