import Foundation

public protocol TransactionService {
    func transactions(
        query: TransactionsQuery,
        offset: Int?,
        completion: @escaping (Result<([Transaction], Bool), Error>) -> Void
    ) -> Cancellable?

    func categorize(
        _ transactionIds: [String],
        as newCategoryId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable?

    func transactionsSimilar(
        to transactionId: String,
        ifCategorizedAs categoryId: String,
        completion: @escaping (Result<[Transaction], Error>) -> Void
    ) -> Cancellable?
}
