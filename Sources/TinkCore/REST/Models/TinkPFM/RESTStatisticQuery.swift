import Foundation

struct RESTStatisticQuery: Encodable {
    let description: String?
    let padResultUntilToday: Bool?
    let periods: [Date]?
    let resolution: RESTStatisticQueryResolution?
    let types: [RESTStatisticQueryType]?
}

enum RESTStatisticQueryResolution: String, Codable {
    case daily = "DAILY"
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
    case monthlyAdjusted = "MONTHLY_ADJUSTED"
    case yearly = "YEARLY"
    case all = "ALL"
}

enum RESTStatisticQueryType: String, Codable {
    case expensesByCategory = "expenses-by-category"
    case incomeByCategory = "income-by-category"
    case leftToSpend = "left-to-spend"
    case leftToSpendAverage = "left-to-spend-average"
}
