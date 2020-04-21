import Foundation

class RESTUserService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func user(
        completion: @escaping (Result<RESTUser, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/user", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    @discardableResult
    func userProfile(
        completion: @escaping (Result<RESTUserProfile, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/user/profile", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }
}
