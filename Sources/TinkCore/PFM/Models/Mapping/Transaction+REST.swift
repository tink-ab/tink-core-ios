import Foundation

extension Transaction {
    init(from restTransaction: RESTTransaction) {
        self.id = .init(restTransaction.id)
        self.accountID = .init(restTransaction.accountId)
        self.amount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: restTransaction.currencyDenominatedAmount)
        self.categoryID = .init(restTransaction.categoryId)
        self.description = restTransaction.description
        self.date = restTransaction.date
        self.inserted = restTransaction.timestamp
        self.originalAmount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: restTransaction.currencyDenominatedOriginalAmount)
        self.originalDate = restTransaction.originalDate
        self.originalDescription = restTransaction.originalDescription
        self.notes = restTransaction.notes
        self.isPending = restTransaction.pending
        self.categoryType = .init(from: restTransaction.categoryType)
        self.dispensableAmount = restTransaction.dispensableAmount
        self.lastModified = restTransaction.lastModified
        self.type = .init(from: restTransaction.type)
        self.userId = restTransaction.userId

        let now = Date()
        if let endOfDay = Calendar.current.endOfDay(for: now) {
            self.isUpcomingOrInFuture = restTransaction.upcoming || restTransaction.date > endOfDay
        } else {
            self.isUpcomingOrInFuture = restTransaction.upcoming
        }
    }
}

extension TransactionType {
    init(from restTransactionType: RESTTransactionType) {
        switch restTransactionType {
        case .default:
            self = .default
        case .creditCard:
            self = .creditCard
        case .transfer:
            self = .transfer
        case .payment:
            self = .payment
        case .withdrawal:
            self = .withdrawal
        case .unknown:
            self = .unknown
        }
    }
}

extension CategoryType {
    init(from restCategoryType: RESTCategoryType) {
        switch restCategoryType {
        case .expenses:
            self = .expenses
        case .income:
            self = .income
        case .transfers:
            self = .transfers
        case .unknown:
            self = .unknown
        }
    }
}
