import Foundation

public struct UpdateBudgetRequest {
    /// The name of the Budget.
    public let name: String
    /// The target amount for the budget. The currency must match the user profile currency setting.
    public let amount: CurrencyDenominatedAmount
    /// The filter defining the budget and which transactions that is included in it. The configured fields of the filter are applied as logical and operator (intersection).
    public let filter: [Budget.Filter]
    /// Periodicity configuration for the budget.
    public let periodicity: Budget.Periodicity
}
