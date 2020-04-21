import Foundation

final class DemoClient: Client {
    func performRequest(_ request: RESTRequest) -> Cancellable? {
        let resourceName: String
        switch request.path {
        case "/api/v1/statistics/query":
            resourceName = "Statistics"
        case "/api/v1/user":
            resourceName = "User"
        case "/api/v1/accounts/list":
            resourceName = "Accounts"
        case "/api/v1/search":
            resourceName = "Transactions"
        case "/api/v1/insights":
            resourceName = "ActionableInsights"
        case "/api/v1/calendar/periods/2019":
            resourceName = "Periods2019"
        case "/api/v1/calendar/periods/2020":
            resourceName = "Periods2020"
        case "/api/v1/categories":
            resourceName = "Categories"
        default:
            let error = CocoaError(.fileNoSuchFile)
            request.onResponse(.failure(error))
            return nil
        }

        guard let url = Bundle(for: DemoClient.self).url(forResource: resourceName, withExtension: "json") else {
            let error = CocoaError(.fileNoSuchFile)
            request.onResponse(.failure(error))
            return nil
        }

        let workItem = DispatchWorkItem {
            do {
                let data = try Data(contentsOf: url)
                let response = URLResponse()
                request.onResponse(.success((data, response)))
            } catch {
                request.onResponse(.failure(error))
            }
        }

        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5, execute: workItem)

        return workItem
    }
}
