import Foundation

final class RESTUserService: UserService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    func userProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTUser>(path: "/api/v1/user", method: .get, contentType: .json) { result in
            completion(result.map(User.init))
        }

        return client.performRequest(request)
    }

    @discardableResult
    func userProfile(completion: @escaping (Result<RESTUserProfile, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest(path: "/api/v1/user/profile", method: .get, contentType: .json) { result in
            completion(result.map(UserProfile.init))
        }

        return client.performRequest(request)
    }
}
