import SwiftUI

struct SwipeAction {
    let systemImage: String
    let background: Color
    let action: () -> Void
}

struct RowSwipeActions: ViewModifier {
    let rowID: UUID
    @Binding var activeRowID: UUID?
    let actions: [SwipeAction]

    @State private var offsetX: Double = 0
    @State private var isOpen = false

    private let actionSize: Double = 50
    private let actionSpacing: Double = 12
    private let minimumDragDistance: Double = 10
    private let openThreshold: Double = 0.5
    private let symbolSize: Double = 15

    private var maxOffset: Double {
        Double(actions.count) * (actionSize + actionSpacing)
    }

    private var progress: Double {
        min(-offsetX / maxOffset, 1)
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                if isOpen {
                    Color.clear.contentShape(.rect).onTapGesture(perform: close)
                }
            }
            .overlay(alignment: .trailing) {
                actionsView.offset(x: maxOffset)
            }
            .offset(x: offsetX)
            .highPriorityGesture(dragGesture)
            .onChange(of: activeRowID) { activeRowID in
                if activeRowID != rowID { close() }
            }
    }

    private var actionsView: some View {
        HStack(spacing: actionSpacing) {
            ForEach(actions.indices, id: \.self) { index in
                let action = actions[index]
                Button {
                    close()
                    action.action()
                } label: {
                    Image(systemName: action.systemImage)
                        .font(.system(size: symbolSize))
                        .foregroundStyle(.white)
                        .frame(size: actionSize)
                        .background(action.background, in: .circle)
                }
                .buttonStyle(PressableButtonStyle())
                .offset(x: Double(actions.count - 1 - index) * (actionSize + actionSpacing) * (1 - progress))
            }
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: minimumDragDistance)
            .onChanged { value in
                if activeRowID != rowID { activeRowID = rowID }
                offsetX = min(0, max(-maxOffset, restingOffset + value.translation.width))
            }
            .onEnded { value in
                let predicted = restingOffset + value.predictedEndTranslation.width
                withAnimation(Animations.page) {
                    isOpen = -predicted > maxOffset * openThreshold
                    offsetX = isOpen ? -maxOffset : 0
                }
            }
    }

    private var restingOffset: Double {
        isOpen ? -maxOffset : 0
    }

    private func close() {
        withAnimation(Animations.page) {
            isOpen = false
            offsetX = 0
        }
    }
}

extension View {
    func rowSwipeActions(rowID: UUID, activeRowID: Binding<UUID?>, actions: [SwipeAction]) -> some View {
        modifier(RowSwipeActions(rowID: rowID, activeRowID: activeRowID, actions: actions))
    }
}
