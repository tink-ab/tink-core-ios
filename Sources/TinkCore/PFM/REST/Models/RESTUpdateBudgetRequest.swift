import Foundation

struct RESTUpdateBudgetRequest: Encodable {
    /** The name of the Budget. */
    let name: String
    /** The target amount for the budget. */
    let amount: RESTCurrencyDenominatedAmount
    /** The filter defining the budget and which transactions that is included in it. The configured fields of the filter are applied as logical and operator (intersection). */
    let filter: RESTBudget.Filter
    /** Periodicity configuration for a RECURRING budget. Required if periodicityType is set to RECURRING. */
    let recurringPeriodicity: RESTBudget.RecurringPeriodicity?
    /** Periodicity configuration for a ONE_OFF budget. Required if periodicityType is set to ONE_OFF. */
    let oneOffPeriodicity: RESTBudget.OneOffPeriodicity?
}

