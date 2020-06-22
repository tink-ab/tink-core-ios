import Foundation

extension Transaction {
    init(from restTransaction: RESTTransaction) {
        self.id = .init(restTransaction.id)
        self.accountID = .init(restTransaction.accountId)
        self.amount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: restTransaction.currencyDenominatedAmount)
        self.categoryID = .init(restTransaction.categoryId)
        self.description = restTransaction.description
        self.date = restTransaction.date
        self.inserted = restTransaction.inserted

        let now = Date()
        if let date = date, let endOfDay = Calendar.current.endOfDay(for: now) {
            self.isUpcomingOrInFuture = restTransaction.upcoming || date > endOfDay
        } else {
            self.isUpcomingOrInFuture = restTransaction.upcoming
        }
    }
}
