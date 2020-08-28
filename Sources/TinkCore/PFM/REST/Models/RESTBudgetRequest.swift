import Foundation

typealias RESTCreateRecurringBudgetRequest = RESTBudgetRequest
typealias RESTCreateOneOffBudgetRequest = RESTBudgetRequest
typealias RESTUpdateBudgetRequest = RESTBudgetRequest

struct RESTBudgetRequest: Encodable {
    /// The name of the Budget.
    let name: String
    /// The target amount for the budget. The currency must match the user profile currency setting.
    let amount: RESTCurrencyDenominatedAmount
    /// The filter defining the budget and which transactions that is included in it. The configured fields of the filter are applied as logical and operator (intersection).
    let filter: RESTBudget.Filter
    /// Periodicity configuration for the one off budget.
    let oneOffPeriodicity: RESTBudget.OneOffPeriodicity?
    /// Periodicity configuration for the recurring budget.
    let recurringPeriodicity: RESTBudget.RecurringPeriodicity?
}
