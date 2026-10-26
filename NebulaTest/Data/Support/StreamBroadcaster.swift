import Foundation

/// Hands out an independent `AsyncStream` per subscriber, so one cancelled consumer does not silence the rest.
@MainActor
final class StreamBroadcaster<Element: Sendable> {
    private var continuations: [UUID: AsyncStream<Element>.Continuation] = [:]

    func makeStream() -> AsyncStream<Element> {
        AsyncStream { continuation in
            let id = UUID()
            continuations[id] = continuation
            continuation.onTermination = { [weak self] _ in
                Task { @MainActor in self?.continuations[id] = nil }
            }
        }
    }

    func send(_ element: Element) {
        for continuation in continuations.values {
            continuation.yield(element)
        }
    }
}
