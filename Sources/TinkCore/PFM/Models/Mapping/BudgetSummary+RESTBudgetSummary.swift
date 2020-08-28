import Foundation

extension BudgetPeriod {
    init?(restBudgetPeriod: RESTBudgetPeriod) {
        guard let start = restBudgetPeriod.start,
            let end = restBudgetPeriod.end else {
                return nil
        }
        self.dateInterval = DateInterval(start: start, end: end)
        spentAmount = restBudgetPeriod.spentAmount.map(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount:))
    }
}

extension BudgetSummary {
    init(restBudgetSummary: RESTBudgetSummary) {
        budget = restBudgetSummary.budgetSpecification.flatMap(Budget.init(restBudget:))
        budgetPeriod = restBudgetSummary.budgetPeriod.flatMap(BudgetPeriod.init(restBudgetPeriod:))
    }
}
