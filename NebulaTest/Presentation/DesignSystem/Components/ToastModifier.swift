import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    var duration: Double = 2

    @State private var dragOffset: Double = 0

    func body(content: Content) -> some View {
        content.overlay(alignment: .top) {
            if let toast {
                ToastView(toast: toast)
                    .padding(.top, Spacing.xs)
                    .offset(y: min(dragOffset, 0))
                    .gesture(dismissGesture)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .task(id: toast) { await autoDismiss() }
            }
        }
        .animation(Animations.page, value: toast)
    }

    private var dismissGesture: some Gesture {
        DragGesture(minimumDistance: Spacing.xs)
            .onChanged { dragOffset = $0.translation.height }
            .onEnded { value in
                if value.translation.height < -Spacing.md { dismiss() } else { dragOffset = 0 }
            }
    }

    private func autoDismiss() async {
        try? await Task.sleep(for: .seconds(duration))
        guard !Task.isCancelled else { return }
        dismiss()
    }

    private func dismiss() {
        toast = nil
        dragOffset = 0
    }
}

extension View {
    func toast(_ toast: Binding<Toast?>) -> some View {
        modifier(ToastModifier(toast: toast))
    }
}

#Preview {
    Color.appBackground
        .ignoresSafeArea()
        .toast(.constant(Toast(style: .success, title: "Copied")))
}
