import Foundation

public protocol TransactionService {
    func transactions(
        query: TransactionsQuery,
        offset: Int?,
        completion: @escaping (Result<([Transaction], Bool), Error>) -> Void
    ) -> Cancellable?

    func categorize(
        _ transactionIDs: [String],
        as newCategoryID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?

    func transactionsSimilar(
        to transactionID: String,
        ifCategorizedAs categoryID: String,
        completion: @escaping (Result<[Transaction], Error>) -> Void
    ) -> Cancellable?

    func transaction(
        id: Transaction.ID,
        completion: @escaping (Result<Transaction, Error>) -> Void
    ) -> Cancellable?

    func update(
        transactionID: Transaction.ID,
        amount: CurrencyDenominatedAmount,
        categoryID: Category.ID,
        date: Date,
        description: String,
        notes: String?,
        completion: @escaping (Result<Transaction, Error>) -> Void
    ) -> Cancellable?

    func suggestTransactions(
        numberOfClusters: Int,
        completion: @escaping (Result<SuggestTransactionsResponse, Error>) -> Void
    ) -> Cancellable?
}
