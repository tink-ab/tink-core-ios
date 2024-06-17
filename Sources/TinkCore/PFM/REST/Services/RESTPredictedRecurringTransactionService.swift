import Foundation

final class RESTPredictedRecurringTransactionService: PredictedRecurringTransactionService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func transactions(
        groupIdIn: String? = nil,
        pageToken: String? = nil,
        pageSize: Int? = nil,
        completion: @escaping (Result<([PredictedRecurringTransaction], NextPageToken), Error>) -> Void
    ) -> Cancellable? {
        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.appendURLQueryItem(name: "groupIdIn", value: groupIdIn)
        urlQueryItems.appendURLQueryItem(name: "pageToken", value: pageToken)
        urlQueryItems.appendURLQueryItem(name: "pageSize", value: pageSize)

        let request = RESTResourceRequest<RESTPredictedListRecurringTransactionsResponse>(path: "/enrichment/v1/predicted-recurring-transactions", method: .get, contentType: .json, parameters: urlQueryItems) { result in
            let mapped = result.map { transactionsResponse -> ([PredictedRecurringTransaction], NextPageToken) in
                let recurringTransactions = transactionsResponse.predictedRecurringTransactions.map(PredictedRecurringTransaction.init)
                return (recurringTransactions, transactionsResponse.nextPageToken)
            }
            completion(mapped)
        }

        return client.performRequest(request)
    }
}

extension Array where Element == URLQueryItem {
    mutating func appendURLQueryItem(name: String, value: String?) {
        if let value {
            append(URLQueryItem(name: name, value: value))
        }
    }

    mutating func appendURLQueryItem(name: String, value: Int?) {
        if let value {
            append(URLQueryItem(name: name, value: String(value)))
        }
    }
}
