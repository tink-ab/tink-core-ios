import Foundation

extension RecommendedBudget {
    init(restRecommendedBudget: RESTRecommendedBudget) {
        self.amount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: restRecommendedBudget.amount)
        self.filter = Budget.Filter.makeFilters(restFilter: restRecommendedBudget.filter)
        self.name = restRecommendedBudget.name
        self.recurringPeriodicity = Budget.RecurringPeriodicity(restRecurringPeriodicity: restRecommendedBudget.recurringPeriodicity)
    }
}
