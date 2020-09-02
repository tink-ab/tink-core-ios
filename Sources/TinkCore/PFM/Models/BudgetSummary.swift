public struct BudgetSummary {
    /// The budget.
    public let budget: Budget
    /// The current running period.
    public let budgetPeriod: Budget.Period

    public init(budget: Budget, budgetPeriod: Budget.Period) {
        self.budget = budget
        self.budgetPeriod = budgetPeriod
    }
}
