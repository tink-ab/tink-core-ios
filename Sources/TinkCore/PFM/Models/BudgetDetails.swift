import Foundation

public struct BudgetDetails {
    /// The budget.
    public let budgetSpecification: Budget
    /// List of budget periods.
    public let budgetPeriods: [Budget.Period]
    /// Period date interval
    public let dateInterval: DateInterval
    /// Total amount spent within the listed periods.
    public let totalSpentAmount: CurrencyDenominatedAmount?
    /// Average period spending for the listed periods.
    public let averageSpentAmount: CurrencyDenominatedAmount?
}
