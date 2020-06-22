import Foundation

class RESTActionableInsightService {

    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    public func insights(
        completion: @escaping (Result<[ActionableInsight], Error>) -> Void
    ) -> RetryCancellable? {
        let request = RESTResourceRequest<[RESTActionableInsight]>(path: "/api/v1/insights", method: .get, contentType: .json) { result in
            completion(result.map { $0.compactMap(ActionableInsight.init) })
        }
        return client.performRequest(request)
    }

    /// Lists all archived insights for the user.
    ///
    /// - Parameter completion: Completion handler with a result of archived insights if successful or an error if request failed.
    @discardableResult
    public func archivedInsights(
        completion: @escaping (Result<[ActionableInsight], Error>) -> Void
    ) -> RetryCancellable? {
        let request = RESTResourceRequest<[RESTArchivedInsight]>(path: "/api/v1/insights/archived", method: .get, contentType: .json) { result in
            completion(result.map { $0.compactMap(ActionableInsight.init) })
        }
        return client.performRequest(request)
    }

    @discardableResult
    public func selectInsightAction(
        insightAction: String,
        insightID: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable? {

        let body = [
            "insightAction": insightAction,
            "insightId": insightID
        ]

        let request = RESTSimpleRequest(path: "/api/v1/insights/action", method: .post, body: body, contentType: .json) { result in
            completion(result.flatMap { response in
                guard let response = response as? HTTPURLResponse else {
                    return .failure(URLError(.cannotParseResponse))
                }

                guard response.statusCode == 204 else {
                    return .failure(URLError(.cannotParseResponse))
                }

                return .success
            })
        }
    }

    @discardableResult
    public func archiveInsight(
        id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable? {
        let request = RESTSimpleRequest(path: "/api/v1/insights/\(id)/archive", method: .put, contentType: .json, completion: { result in
            let mapped = result.map { (response) -> Void in
                return ()
            }
            completion(mapped)
        })
        return client.performRequest(request)
    }
}
