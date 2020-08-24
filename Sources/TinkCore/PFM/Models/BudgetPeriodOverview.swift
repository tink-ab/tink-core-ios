import Foundation

public struct BudgetPeriodOverview {
    /// The budget.
    public var budgetSpecification: Budget
    /// List of budget periods.
    public var budgetPeriods: [BudgetPeriod]
    /// First period start expressed as UTC epoch timestamp in milliseconds.
    public var start: Date
    /// Last period end expressed as UTC epoch timestamp in milliseconds.
    public var end: Date
    /// Total amount spent within the listed periods.
    public var totalSpentAmount: CurrencyDenominatedAmount?
    /// Average period spending for the listed periods.
    public var averageSpentAmount: CurrencyDenominatedAmount?
}

