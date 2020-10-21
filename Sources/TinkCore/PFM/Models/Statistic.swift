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

    public let userID: String

    public init(description: String, payload: String?, period: StatisticPeriod, resoultion: Statistic.Resolution, kind: Statistic.Kind, value: Double, userID: String) {
        self.description = description
        self.payload = payload
        self.period = period
        self.resoultion = resoultion
        self.kind = kind
        self.value = value
        self.userID = userID
    }
}

public enum StatisticPeriod: Hashable {
    case year(Int)
    case week(year: Int, week: Int)
    case month(year: Int, month: Int)
    case day(year: Int, month: Int, day: Int)

    /// Will map to the proper backend string representation of the reaspective periods.
    public var stringRepresentation: String {
        switch self {
        case .year(let year): return "\(year)"
        case .month(year: let year, month: let month): return String(format: "%d-%02d", year, month)
        case .week(year: let year, week: let week): return String(format: "%d:%02d", year, week)
        case .day(year: let year, month: let month, day: let day): return String(format: "%d-%02d-%02d", year, month, day)
        }
    }

    init?(string: String) {
        if let year = Int(string) {
            self = .year(year)
            return
        }

        do {
            let monthExpression = try NSRegularExpression(pattern: #"^(\d+)-(\d{2})$"#, options: [])
            let weekExpression = try NSRegularExpression(pattern: #"^(\d+):(\d{2})$"#, options: [])
            let dayExpression = try NSRegularExpression(pattern: #"^(\d+)-(\d{2})-(\d{2})$"#, options: [])

            let range = NSRange(string.startIndex..<string.endIndex,
                                in: string)

            for match in monthExpression.matches(in: string, options: [], range: range) {
                if match.numberOfRanges == 3,
                   let firstCaptureRange = Range(match.range(at: 1), in: string),
                   let secondCaptureRange = Range(match.range(at: 2), in: string),
                   let year = Int(string[firstCaptureRange]),
                   let month = Int(string[secondCaptureRange]) {
                    self = .month(year: year, month: month)
                    return
                }
            }

            for match in weekExpression.matches(in: string, options: [], range: range) {
                if match.numberOfRanges == 3,
                   let firstCaptureRange = Range(match.range(at: 1), in: string),
                   let secondCaptureRange = Range(match.range(at: 2), in: string),
                   let year = Int(string[firstCaptureRange]),
                   let week = Int(string[secondCaptureRange]) {
                    self = .week(year: year, week: week)
                    return
                }
            }

            for match in dayExpression.matches(in: string, options: [], range: range) {
                if match.numberOfRanges == 4,
                   let firstRange = Range(match.range(at: 1), in: string),
                   let secondRange = Range(match.range(at: 2), in: string),
                   let thirdRange = Range(match.range(at: 3), in: string),
                   let year = Int(string[firstRange]),
                   let month = Int(string[secondRange]),
                   let day = Int(string[thirdRange]) {
                    self = .day(year: year, month: month, day: day)
                    return
                }
            }
            return nil
        } catch {
            return nil
        }
    }
}
