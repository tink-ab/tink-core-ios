import Foundation

struct RESTUserService: UserService {

    let client: RESTClient

    func user(completion: @escaping (Result<User, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTUser>(path: "/api/v1/user", method: .get, contentType: .json) { result in
            completion(result.map(User.init))
        }

        return client.performRequest(request)
    }

    @discardableResult
    func userProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTUserProfile>(path: "/api/v1/user/profile", method: .get, contentType: .json) { result in
            completion(result.map(UserProfile.init))
        }

        return client.performRequest(request)
    }
}
