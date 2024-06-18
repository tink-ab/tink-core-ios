import Foundation

extension PredictedRecurringTransaction {
    init(from restRecurringTransaction: RESTPredictedRecurringTransaction) {
        self.id = .init(UUID().uuidString)
        self.accountID = .init(restRecurringTransaction.accountId)
        self.amount = CurrencyDenominatedAmount(restRecurringTransaction.amount.predicted)
        self.groupID = .init(restRecurringTransaction.groupId)
        self.booked = restRecurringTransaction.date.predicted
        self.date = restRecurringTransaction.date.predicted
        self.description = restRecurringTransaction.description.display
        self.originalDescription = restRecurringTransaction.description.original
    }
}
