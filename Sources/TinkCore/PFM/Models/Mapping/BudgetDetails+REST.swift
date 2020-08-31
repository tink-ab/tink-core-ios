import Foundation

extension BudgetDetails {
    init(restBudgetDetailsResponse: RESTBudgetDetailsResponse) {
        let budgetSpecification = Budget.init(restBudget: restBudgetDetailsResponse.budgetSpecification)

        let budgetPeriods = restBudgetDetailsResponse.budgetPeriods.compactMap(Budget.Period.init(restBudgetPeriod:))

        self.averageSpentAmount = restBudgetDetailsResponse.averageSpentAmount.map(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount: ))
        self.totalSpentAmount = restBudgetDetailsResponse.totalSpentAmount.map(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount: ))
        self.dateInterval = DateInterval(start: restBudgetDetailsResponse.start, end: restBudgetDetailsResponse.end)
        self.budgetSpecification = budgetSpecification
        self.budgetPeriods = budgetPeriods
    }
}
