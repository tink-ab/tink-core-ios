import Foundation

struct RESTBudgetService: BudgetService {

    let client: RESTClient

    @discardableResult
    func budgets(
        includeArchived: Bool,
        completion: @escaping (Result<[Budget], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTListBudgetSpecificationsResponse>(path: "/api/v1/budgets", method: .get, contentType: .json) { result in
            let newResult = result.map { ($0.budgetSpecifications ?? []).compactMap(Budget.init(restBudget:)) }
            completion(newResult)
        }
        return client.performRequest(request)
    }
}
