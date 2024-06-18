import Foundation

final class RESTRecurringTransactionsGroupService: RecurringTransactionsGroupService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func recurringTransactionsGroups(
        pageToken: String?,
        pageSize: Int?,
        status: RecurringTransactionsGroupStatus?, completion: @escaping (Result<([RecurringTransactionsGroup], NextPageToken), any Error>) -> Void
    ) -> (any Cancellable)? {
        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.appendURLQueryItem(name: "pageToken", value: pageToken)
        urlQueryItems.appendURLQueryItem(name: "pageSize", value: pageSize)
        urlQueryItems.appendURLQueryItem(name: "status", value: status?.rawValue)

        let request = RESTResourceRequest<RESTListRecurringTransactionsGroupsResponse>(path: "/enrichment/v1/recurring-transactions-groups", method: .get, contentType: .json, parameters: urlQueryItems) { result in
            let mapped = result.map { recurringTransactionsGroupsResponse -> ([RecurringTransactionsGroup], NextPageToken) in
                let recurringTransactionsGroups = recurringTransactionsGroupsResponse.recurringTransactionsGroups.map(RecurringTransactionsGroup.init)
                return (recurringTransactionsGroups, recurringTransactionsGroupsResponse.nextPageToken)
            }
            completion(mapped)
        }

        return client.performRequest(request)
    }
}

extension RecurringTransactionsGroup {
    init(from restRecurringTransactionsGroup: RESTRecurringTransactionsGroup) {
        self.id = .init(restRecurringTransactionsGroup.id)
        self.categoryID = .init(restRecurringTransactionsGroup.categoryId)
    }
}

struct RESTListRecurringTransactionsGroupsResponse: Decodable {
    let nextPageToken: String
    let recurringTransactionsGroups: [RESTRecurringTransactionsGroup]
}

struct RESTRecurringTransactionsGroup: Decodable {
    let amount: RESTRecurringTransactionsGroupAmount
    let categoryId: String
    let id: String
    let name: String
    let occurrences: RESTOccurrences
    let period: RESTPeriod
    let status: String?
}

struct RESTRecurringTransactionsGroupAmount: Decodable {
    let currencyCode: String
}

struct RESTOccurrences: Decodable {
    let count: Int
}
