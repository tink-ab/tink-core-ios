import Foundation

extension Budget.Period {
    init(restBudgetPeriod: RESTBudgetPeriod) {
        self.dateInterval = DateInterval(start: restBudgetPeriod.start, end: restBudgetPeriod.end)
        spentAmount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: restBudgetPeriod.spentAmount)
    }
}

extension BudgetSummary {
    init(restBudgetSummary: RESTBudgetSummary) {
        budget = Budget(restBudget: restBudgetSummary.budgetSpecification)
        budgetPeriod = Budget.Period(restBudgetPeriod: restBudgetSummary.budgetPeriod)
    }
}
