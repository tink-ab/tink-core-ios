import Foundation

extension Month {
    init?(value: String, calendar: Calendar = .current) {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDashSeparatorInDate]
        guard let date = dateFormatter.date(from: value) else { return nil }
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let year = components.year, let month = components.month else { return nil }
        self = Month(year: year, month: month)
    }
    
    var periodKey: String {
        guard let date = date else {
            return "\(year)-\(month)"
        }
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.formatOptions = [.withYear, .withMonth, .withDashSeparatorInDate]
        let key = dateFormatter.string(from: date)
        return key
    }
}
