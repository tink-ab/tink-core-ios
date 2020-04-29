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
    public let period: String

    public let resoultion: Resolution
    public let kind: Kind
    public let value: Double

    let userID: String
}


