import Foundation

struct UpdateBudgetRequest {
    /** The name of the Budget. */
    var name: String
    /** The target amount for the budget. The currency must match the user profile currency setting. */
    var amount: CurrencyDenominatedAmount
    /** The filter defining the budget and which transactions that is included in it. The configured fields of the filter are applied as logical and operator (intersection). */
    var filter: [Budget.Filter]
    /** Periodicity configuration for the budget. */
    var periodicity: Budget.Periodicity
}
