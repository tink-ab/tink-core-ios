import Foundation

extension BudgetPeriodOverview {
    init(restBudgetDetailsResponse: RESTBudgetDetailsResponse) {
        let budgetSpecification = Budget.init(restBudget: restBudgetDetailsResponse.budgetSpecification)

        let budgetPeriods = restBudgetDetailsResponse.budgetPeriods.compactMap(BudgetPeriod.init(restBudgetPeriod:))

        self.averageSpentAmount = restBudgetDetailsResponse.averageSpentAmount.map(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount: ))
        self.totalSpentAmount = restBudgetDetailsResponse.totalSpentAmount.map(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount: ))
        self.start = restBudgetDetailsResponse.start
        self.end = restBudgetDetailsResponse.end
        self.budgetSpecification = budgetSpecification
        self.budgetPeriods = budgetPeriods
    }
}
