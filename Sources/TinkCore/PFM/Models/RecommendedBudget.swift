import Foundation

public struct RecommendedBudget {
    /// The target amount for the budget. The currency will match the user profile currency setting.
    public let amount: CurrencyDenominatedAmount?
    /// The filter defines the budget and which transactions that are included in it. The configured fields of the filter are applied as logical and operator (intersection).
    public let filter: [Budget.Filter]
    /// The name of the recommended Budget.
    public let name: String
    /// Periodicity configuration for the recurring budget.
    public let recurringPeriodicity: Budget.RecurringPeriodicity?
}
