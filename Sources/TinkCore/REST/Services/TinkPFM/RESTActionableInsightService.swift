import Foundation

class RESTActionableInsightService {
    
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func insights(
        completion: @escaping (Result<[RESTActionableInsight], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/insights", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    /// Lists all archived insights for the user.
    ///
    /// - Parameter completion: Completion handler with a result of archived insights if successful or an error if request failed.
    @discardableResult
    func archivedInsights(
        completion: @escaping (Result<[RESTArchivedInsight], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/insights/archived", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    @discardableResult
    func archiveInsight(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTSimpleRequest(path: "/api/v1/insights/\(id)/archive", method: .put, contentType: .json, completion: { result in
            let mapped = result.map { (response) -> Void in
                return ()
            }
            completion(mapped)
        })
        return client.performRequest(request)
    }
}
