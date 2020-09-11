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

    public init(budgetSpecification: Budget, budgetPeriods: [Budget.Period], dateInterval: DateInterval, totalSpentAmount: CurrencyDenominatedAmount?, averageSpentAmount: CurrencyDenominatedAmount?) {
        self.budgetSpecification = budgetSpecification
        self.budgetPeriods = budgetPeriods
        self.dateInterval = dateInterval
        self.totalSpentAmount = totalSpentAmount
        self.averageSpentAmount = averageSpentAmount
    }
}
