import Foundation

public struct BudgetPeriodOverview {
    /// The budget.
    public let budgetSpecification: Budget
    /// List of budget periods.
    public let budgetPeriods: [BudgetPeriod]
    /// First period start expressed as UTC epoch timestamp in milliseconds.
    public let start: Date
    /// Last period end expressed as UTC epoch timestamp in milliseconds.
    public let end: Date
    /// Total amount spent within the listed periods.
    public let totalSpentAmount: CurrencyDenominatedAmount?
    /// Average period spending for the listed periods.
    public let averageSpentAmount: CurrencyDenominatedAmount?
}

