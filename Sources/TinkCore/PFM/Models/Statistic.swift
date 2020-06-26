import Foundation

public struct Statistic {
    public enum Resolution {
        case daily, monthly, monthlyAdjusted, yearly, all, weekly
    }

    public enum Kind {
        case balancesByAccount
        case balancesByAccountTypeGroup
        case expensesByCategory
        case expensesByPrimaryCategory
        case expensesByCategoryByCount
        case expensesByPrimaryCategoryByCount
        case incomeByCategory
        case incomeAndExpenses
        case leftToSpend
        case leftToSpendAverage
    }

    public let description: String
    public let payload: String?
    public let period: StatisticPeriod

    public let resoultion: Resolution
    public let kind: Kind
    public let value: Double

    let userID: String
}

public enum StatisticPeriod {
    case year(Int)
    case week(year: Int, week: Int)
    case month(year: Int, month: Int)
    case day(year: Int, month: Int, day: Int)

    /// Will map to the proper backend string representation of the reaspective periods.
    var stringRepresentation: String {
        switch self {
        case .year(let year): return "\(year)"
        case .month(year: let year, month: let month): return String(format: "%d-%02d", year, month)
        case .week(year: let year, week: let week): return String(format: "%d:%02d", year, week)
        case .day(year: let year, month: let month, day: let day): return String(format: "%d-%02d-%02d", year, month, day)
        }
    }

    init?(string: String) {
//        if let year = Int(string) {
//            self = .year(year)
//        } else if let components = string.split(separator: ":") as? [Int],
//        components.count == 2, let numbers = compono {
//
//        } else if let
//
        return nil
    }
}
