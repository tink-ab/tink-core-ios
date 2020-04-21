import Foundation

struct CategoryData: Codable {

    struct CategoryPeriodData: Codable {
        let dateInterval: DateInterval
        let amountsByCategoryReference: [Category.ID: CurrencyDenominatedAmount]

        var totalCurrencyDenominatedAmount: CurrencyDenominatedAmount {
            return amountsByCategoryReference.values.reduce(CurrencyDenominatedAmount(), { $0 + $1 })
        }

        func totalCurrencyDenominatedAmount(for category: CategoryTree.Node) -> CurrencyDenominatedAmount? {
            var amount: Double = 0

            var currencyCode: CurrencyCode?
            if let categoryAmount = amountsByCategoryReference[category.id] {
                currencyCode = categoryAmount.currencyCode
                amount += categoryAmount.doubleValue
            }

            for subcategory in category.subcategories {
                if let currencyAmount = totalCurrencyDenominatedAmount(for: subcategory) {
                    currencyCode = currencyAmount.currencyCode
                    amount += currencyAmount.doubleValue
                }
            }
            guard let _currencyCode = currencyCode else {
                return nil
            }
            return CurrencyDenominatedAmount(amount, currencyCode: _currencyCode)
        }
    }
    
    let amounts: [Month: CategoryPeriodData]

    init(amounts: [Month: CategoryPeriodData] = [:]) {
        self.amounts = amounts
    }

    func amount(for period: Month, in category: CategoryTree.Node) -> CurrencyDenominatedAmount? {
        guard let periodData = amounts[period] else { return nil }
        return periodData.totalCurrencyDenominatedAmount(for: category)
    }

    var currentMonth: Month? {
        let now = Date()
        return amounts
            .first(where: { $1.dateInterval.contains(now) })?
            .key
    }
}
