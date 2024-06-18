import Foundation

struct RESTStatisticQuery: Encodable {
    let description: String?
    let padResultUntilToday: Bool?
    let periods: [String]?
    let resolution: RESTStatisticQueryResolution?
    let types: [RESTStatisticQueryType]?
}

enum RESTStatisticQueryResolution: String, Encodable, DefaultableDecodable {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
    case monthlyAdjusted = "MONTHLY_ADJUSTED"
    case yearly = "YEARLY"
    case all = "ALL"
    case unknown

    static var decodeFallbackValue: RESTStatisticQueryResolution = .unknown
}

enum RESTStatisticQueryType: String, Encodable, DefaultableDecodable {
    case balancesByAccount = "balances-by-account"
    case balancesByAccountTypeGroup = "balances-by-account-type-group"
    case expensesByCategory = "expenses-by-category"
    case expensesByPrimaryCategory = "expenses-by-primary-category"
    case expensesByCategoryByCount = "expenses-by-category/by-count"
    case expensesByPrimaryCategoryByCount = "expenses-by-primary-category/by-count"
    case incomeByCategory = "income-by-category"
    case incomeAndExpenses = "income-and-expenses"
    case leftToSpend = "left-to-spend"
    case leftToSpendAverage = "left-to-spend-average"
    case safeToSpend = "safe-to-spend"
    case expensesByCostStructure = "expenses-by-cost-structure"
    case unknown

    static var decodeFallbackValue: RESTStatisticQueryType = .unknown
}
