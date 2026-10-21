import XCTest
@testable import NebulaTest

final class ChatHistorySectionTests: XCTestCase {
    private let calendar = Calendar(identifier: .gregorian)
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    private func chat(_ title: String, daysAgo: Int, pinned: Bool = false) -> Chat {
        let date = calendar.date(byAdding: .day, value: -daysAgo, to: now) ?? now
        return Chat(id: UUID(), title: title, createdAt: date, updatedAt: date, isPinned: pinned, lastMessagePreview: nil)
    }

    func testGroupsPinnedTodayYesterdayAndOlderChats() {
        let chats = [
            chat("Old", daysAgo: 10),
            chat("Yesterday", daysAgo: 1),
            chat("Pinned", daysAgo: 3, pinned: true),
            chat("Today", daysAgo: 0)
        ]

        let sections = ChatHistorySection.build(from: chats, now: now, calendar: calendar)

        XCTAssertEqual(sections.map(\.title).prefix(3), ["Pinned", "Today", "Yesterday"])
        XCTAssertEqual(sections.count, 4)
        XCTAssertEqual(sections.last?.chats.map(\.title), ["Old"])
        XCTAssertEqual(sections.first?.chats.map(\.title), ["Pinned"])
    }

    func testOmitsPinnedSectionWhenNothingIsPinned() {
        let sections = ChatHistorySection.build(from: [chat("Today", daysAgo: 0)], now: now, calendar: calendar)

        XCTAssertEqual(sections.map(\.title), ["Today"])
    }

    func testSortsNewestFirstInsideSection() {
        let older = chat("Older", daysAgo: 0)
        var newer = chat("Newer", daysAgo: 0)
        newer.updatedAt = older.updatedAt.addingTimeInterval(60)

        let sections = ChatHistorySection.build(from: [older, newer], now: now, calendar: calendar)

        XCTAssertEqual(sections.first?.chats.map(\.title), ["Newer", "Older"])
    }
}
