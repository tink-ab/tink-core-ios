import Foundation

struct RESTBudgetDetailsResponse: Decodable {
    /// The budget.
    let budgetSpecification: RESTBudget
    /// List of budget periods.
    let budgetPeriods: [RESTBudgetPeriod]
    /// First period start expressed as UTC epoch timestamp in milliseconds.
    let start: Date
    /// Last period end expressed as UTC epoch timestamp in milliseconds.
    let end: Date
    /// Total amount spent within the listed periods.
    let totalSpentAmount: RESTCurreFncyDenominatedAmount?
    /// Average period spending for the listed periods.
    let averageSpentAmount: RESTCurrencyDenominatedAmount?
}

