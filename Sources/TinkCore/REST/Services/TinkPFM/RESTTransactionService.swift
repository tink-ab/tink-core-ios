import Foundation

class RESTTransactionService {

    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func transactions(
        limit: Int? = nil,
        offset: Int? = nil,
        accounts: [String] = [],
        categories: [String] = [],
        startDate: Date? = nil,
        endDate: Date? = nil,
        includeUpcoming: Bool = false,
        query: String? = nil,
        sort: RESTSortType = .date,
        order: RESTOrderType = .desc,
        completion: @escaping (Result<([RESTTransaction], Bool), Error>) -> Void
    ) -> Cancellable? {
        var searchQuery = RESTSearchQuery()

        searchQuery.limit = limit
        searchQuery.offset = offset
        searchQuery.accounts = accounts.isEmpty ? nil : accounts
        searchQuery.categories = categories.isEmpty ? nil : categories
        searchQuery.startDate = startDate
        searchQuery.endDate = endDate
        // FIXME: We have to always fetch with `includeUpcoming` set to `true` since backend will not include todays transactions until noon when a transaction has changed from being upcoming.
        searchQuery.includeUpcoming = true
        searchQuery.queryString = query
        // Default to sorting by date to match gRPC api.
        searchQuery.order = order
        searchQuery.sort = sort

        let bodyEncoder = JSONEncoder()
        bodyEncoder.dateEncodingStrategy = .custom({ (date, encoder) in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970 * 1000))
        })
        let body = try! bodyEncoder.encode(searchQuery)

        let request = RESTResourceRequest<RESTSearchResponse>(path: "/api/v1/search", method: .post, body: body, contentType: .json) { result in
            let mapped = result.map { transactionsResponse -> ([RESTTransaction], Bool) in
                let transactions = transactionsResponse.results.compactMap { $0.transaction }
                let hasMore = transactions.count >= (limit ?? 50)
                return (transactions, hasMore)
            }
            completion(mapped)
        }

        return client.performRequest(request)
    }

    @discardableResult
    func categorize(
        _ transactionIds: [String],
        as newCategoryId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {

        let listRequest = RESTCategorizeTransactionsListRequest(
            categorizationList: [
                RESTCategorizeTransactionsRequest(
                    categoryId: newCategoryId,
                    transactionIds: transactionIds
                )
            ]
        )

        let bodyEncoder = JSONEncoder()
        let body = try! bodyEncoder.encode(listRequest)

        let request = RESTSimpleRequest(path: "/api/v1/transactions/categorize-multiple", method: .put, body: body, contentType: .json) { result in
            let mapped = result.map { (_) -> Void in
                return
            }
            completion(mapped)
        }

        return client.performRequest(request)
    }

    @discardableResult
    func transactionsSimilar(
        to transactionId: String,
        ifCategorizedAs categoryId: String,
        completion: @escaping (Result<[RESTTransaction], Error>) -> Void
    ) -> Cancellable? {

        let request = RESTResourceRequest<RESTSimilarTransactionsResponse>(path: "/api/v1/transactions/\(transactionId)/similar", method: .get, contentType: nil, parameters: [(name: "categoryId", value: categoryId)]) { result in
            let mapped = result.map { $0.transactions }
            completion(mapped)
        }

        return client.performRequest(request)
    }
}
