import Foundation

struct Month: Hashable, Comparable, Codable {
    static func < (lhs: Month, rhs: Month) -> Bool {
        if lhs.year == rhs.year {
            return lhs.month < rhs.month
        } else {
            return lhs.year < rhs.year
        }
    }
    
    var year: Int
    var month: Int

    var calendar: Calendar { .current }

    init() {
        let date = Date()
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        assert(components.year != nil)
        assert(components.month != nil)
        self.year = components.year ?? 1970
        self.month = components.month ?? 1
    }
    
    init(year: Int, month: Int) {
        self.year = year
        self.month = month
    }

    init(dateComponents: DateComponents) {
        assert(dateComponents.year != nil)
        assert(dateComponents.month != nil)
        self.year = dateComponents.year ?? 1970
        self.month = dateComponents.month ?? 1
    }
    
    init(date: Date) {
        let components = Calendar.current.dateComponents([.year, .month], from: date)
        assert(components.year != nil)
        assert(components.month != nil)
        self.year = components.year ?? 1970
        self.month = components.month ?? 1
    }

    var dateComponents: DateComponents { DateComponents(year: year, month: month) }
    
    var date: Date? { calendar.date(from: dateComponents) }
    
    mutating func add(year offset: Int) {
        year += offset
    }
    
    @discardableResult
    mutating func add(month offset: Int) -> Bool {
        guard let date = date else { return false }
        guard let newDate = calendar.date(byAdding: .month, value: offset, to: date) else { return false }
        let newComponents = calendar.dateComponents([.year, .month], from: newDate)
        guard let year = newComponents.year, let month = newComponents.month else { return false }
        self.year = year
        self.month = month
        return true
    }
    
    func adding(year offset: Int) -> Month {
        var new = self
        new.add(year: offset)
        return new
    }
    
    func adding(month offset: Int) -> Month {
        var new = self
        new.add(month: offset)
        return new
    }
}
