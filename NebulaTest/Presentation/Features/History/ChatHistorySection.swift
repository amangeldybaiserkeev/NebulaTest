import Foundation

struct ChatHistorySection: Identifiable, Equatable {
    let id: String
    let title: String
    let chats: [Chat]

    static func build(from chats: [Chat], now: Date = .now, calendar: Calendar = .current) -> [Self] {
        let sorted = chats.sorted { $0.updatedAt > $1.updatedAt }
        var sections: [Self] = []

        let pinned = sorted.filter(\.isPinned)
        if !pinned.isEmpty {
            sections.append(Self(id: "pinned", title: "Pinned", chats: pinned))
        }

        var days: [Date] = []
        var chatsByDay: [Date: [Chat]] = [:]
        for chat in sorted where !chat.isPinned {
            let day = calendar.startOfDay(for: chat.updatedAt)
            if chatsByDay[day] == nil { days.append(day) }
            chatsByDay[day, default: []].append(chat)
        }
        for day in days {
            sections.append(Self(
                id: day.formatted(.iso8601),
                title: title(for: day, now: now, calendar: calendar),
                chats: chatsByDay[day] ?? []
            ))
        }
        return sections
    }

    private static func title(for day: Date, now: Date, calendar: Calendar) -> String {
        if calendar.isDate(day, inSameDayAs: now) { return "Today" }
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: now), calendar.isDate(day, inSameDayAs: yesterday) {
            return "Yesterday"
        }
        return day.formatted(.historyDay)
    }
}
