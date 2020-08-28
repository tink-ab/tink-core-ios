import Foundation

extension Budget.Transaction {
    init?(restBudgetTransaction: RESTBudgetTransaction) {
        guard let transactionID = restBudgetTransaction.id,
            let amount = restBudgetTransaction.amount else {
                return nil
        }
        self.id = Transaction.ID(transactionID)
        self.amount = CurrencyDenominatedAmount(restCurrencyDenominatedAmount: amount)
        self.accountID = restBudgetTransaction.accountId.map({ Account.ID($0) })
        self.categoryCode = restBudgetTransaction.categoryCode.map({ Category.Code($0) })
        self.date = restBudgetTransaction.date
        self.description = restBudgetTransaction.description
        self.dispensableAmount = restBudgetTransaction.dispensableAmount.map({ CurrencyDenominatedAmount(restCurrencyDenominatedAmount: $0)
        })
    }
}
