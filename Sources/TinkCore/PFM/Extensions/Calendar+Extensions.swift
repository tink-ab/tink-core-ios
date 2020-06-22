import Foundation

extension Calendar {
    /// Returns the first moment of a given month, as a Date.
    ///
    /// For example, pass in `Date()`, if you want the start of the current month.
    /// - Parameter date: The date to search.
    /// - Returns: The first moment of the given month.
    func startOfMonth(for date: Date) -> Date? {
        let components = dateComponents([.year, .month], from: date)
        return self.date(from: components)
    }

    /// Returns the last moment of a given month, as a Date.
    ///
    /// For example, pass in `Date()`, if you want the end of the current month.
    /// - Parameter date: The date to search.
    /// - Returns: The last moment of the given month.
    func endOfMonth(for date: Date) -> Date? {
        guard let startDate = startOfMonth(for: date) else { return nil }
        let components = DateComponents(month: 1, day: 0, hour: 0, minute: 0, second: -1)
        return self.date(byAdding: components, to: startDate)
    }

    /// Returns the last moment of a given day, as a Date.
    ///
    /// For example, pass in `Date()`, if you want the end of the current day.
    /// - Parameter date: The date to search.
    /// - Returns: The last moment of the given day.
    func endOfDay(for date: Date) -> Date? {
        let startDate = startOfDay(for: date)
        let components = DateComponents(day: 1, hour: 0, minute: 0, second: -1)
        return self.date(byAdding: components, to: startDate)
    }
}
