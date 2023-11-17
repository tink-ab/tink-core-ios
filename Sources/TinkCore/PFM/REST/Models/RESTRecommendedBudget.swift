import Foundation

struct RESTRecommendedBudget: Decodable {
    let amount: RESTCurrencyDenominatedAmount
    let filter: RESTBudget.Filter
    let name: String
    let recurringPeriodicity: RESTBudget.RecurringPeriodicity
}

struct RESTRecommendedBudgetResponse: Decodable {
    let recommendedBudgets: [RESTRecommendedBudget]
}
