import Foundation

final class RESTTransactionService: TransactionService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func transactions(
        query: TransactionsQuery,
        offset: Int? = nil,
        completion: @escaping (Result<([Transaction], Bool), Error>) -> Void
    ) -> Cancellable? {
        var searchQuery = RESTSearchQuery()

        searchQuery.limit = query.limit
        searchQuery.offset = offset
        searchQuery.accounts = query.accountIDs.isEmpty ? nil : query.accountIDs.map { $0.value }
        searchQuery.categories = query.categoryIDs.isEmpty ? nil : query.categoryIDs.map { $0.value }
        searchQuery.startDate = query.dateInterval?.start
        searchQuery.endDate = query.dateInterval?.end
        // FIXME: We have to always fetch with `includeUpcoming` set to `true` since backend will not include todays transactions until noon when a transaction has changed from being upcoming.
        searchQuery.includeUpcoming = true
        searchQuery.queryString = query.query
        searchQuery.order = RESTOrderType(transactionQueryOrder: query.order)
        searchQuery.sort = RESTSortType(transactionQuerySort: query.sort)

        let request = RESTResourceRequest<RESTSearchResponse>(path: "/api/v1/search", method: .post, body: searchQuery, contentType: .json) { result in
            let mapped = result.map { transactionsResponse -> ([Transaction], Bool) in
                let transactions = transactionsResponse.results.compactMap { $0.transaction.flatMap(Transaction.init) }
                let hasMore = transactions.count >= (query.limit ?? 50)
                return (transactions, hasMore)
            }
            completion(mapped)
        }

        return client.performRequest(request)
    }

    @discardableResult
    func categorize(
        _ transactionIDs: [String],
        as newCategoryID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        let listRequest = RESTCategorizeTransactionsListRequest(
            categorizationList: [
                RESTCategorizeTransactionsRequest(
                    categoryId: newCategoryID,
                    transactionIds: transactionIDs
                )
            ]
        )

        let request = RESTSimpleRequest(path: "/api/v1/transactions/categorize-multiple", method: .put, body: listRequest, contentType: .json) { result in
            let mapped = result.map { _ in
            }
            completion(mapped)
        }

        return client.performRequest(request)
    }

    @discardableResult
    func transactionsSimilar(
        to transactionID: String,
        ifCategorizedAs categoryID: String,
        completion: @escaping (Result<[Transaction], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTSimilarTransactionsResponse>(path: "/api/v1/transactions/\(transactionID)/similar", method: .get, contentType: nil, parameters: [.init(name: "categoryId", value: categoryID)]) { result in
            let mapped = result.map { $0.transactions.compactMap(Transaction.init) }
            completion(mapped)
        }

        return client.performRequest(request)
    }

    func transaction(id: Transaction.ID, completion: @escaping (Result<Transaction, Error>) -> Void) -> Cancellable? {
        let request = RESTResourceRequest<RESTTransaction>(path: "/api/v1/transactions/\(id.value)", method: .get, contentType: nil) { result in
            let mapped = result.map(Transaction.init)
            completion(mapped)
        }

        return client.performRequest(request)
    }

    func update(transactionID: Transaction.ID, amount: CurrencyDenominatedAmount, categoryID: Category.ID, date: Date, description: String, notes: String?, completion: @escaping (Result<Transaction, Error>) -> Void) -> Cancellable? {
        let body = RESTUpdateTransactionRequest(currencyDenominatedAmount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: amount), categoryId: categoryID.value, date: date, description: description, notes: notes)

        let request = RESTResourceRequest<RESTTransaction>(path: "/api/v1/transactions/\(transactionID.value)", method: .put, body: body, contentType: .json) { result in
            let mapped = result.map(Transaction.init)
            completion(mapped)
        }

        return client.performRequest(request)
    }

    func suggestTransactions(numberOfClusters: Int?, evaluateEverything: Bool? = nil, completion: @escaping (Result<SuggestTransactionsResponse, Error>) -> Void) -> Cancellable? {
        var parameters: [URLQueryItem] = []

        if let numberOfClusters = numberOfClusters {
            parameters.append(.init(name: "numberOfClusters", value: String(numberOfClusters)))
        }

        if let evaluateEverything = evaluateEverything {
            parameters.append(.init(name: "evaluateEverything", value: evaluateEverything ? "true" : "false"))
        }

        let request = RESTResourceRequest<RESTSuggestTransactionsResponse>(path: "/api/v1/transactions/suggest", method: .get, contentType: .json, parameters: parameters) { result in
            let mapped = result.map(SuggestTransactionsResponse.init)
            completion(mapped)
        }

        return client.performRequest(request)
    }
}
