import Foundation

public final class RESTUserService: UserService {
    private let client: RESTClient

    public init(tink: Tink) {
        self.client = tink.client
    }

    init(client: RESTClient) {
        self.client = client
    }

    public func user(completion: @escaping (Result<User, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTUser>(path: "/api/v1/user", method: .get, contentType: .json) { result in
            completion(result.map(User.init))
        }

        return client.performRequest(request)
    }

    @discardableResult
    public func userProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTUserProfile>(path: "/api/v1/user/profile", method: .get, contentType: .json) { result in
            completion(result.map(UserProfile.init))
        }

        return client.performRequest(request)
    }
}
