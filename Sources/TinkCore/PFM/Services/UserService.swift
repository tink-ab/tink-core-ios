import Foundation

public protocol UserService {
    func userProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) -> RetryCancellable?
    func user(completion: @escaping (Result<User, Error>) -> Void) -> RetryCancellable?
}
