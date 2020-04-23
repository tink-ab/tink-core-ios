import Foundation

final class RESTBudgetService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func budgets(
        includeArchived: Bool = false,
        completion: @escaping (Result<RESTListBudgetSpecificationsResponse, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/budgets", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }
}
