import Foundation

extension FormatStyle where Self == Date.VerbatimFormatStyle {
    static var chatDate: Date.VerbatimFormatStyle {
        .verbatim(
            "\(day: .twoDigits).\(month: .twoDigits).\(year: .defaultDigits)",
            timeZone: .current,
            calendar: .current
        )
    }
}
