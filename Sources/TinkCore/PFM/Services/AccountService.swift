public protocol AccountService {
    func accounts(completion: @escaping (Result<[Account], Error>) -> Void) -> Cancellable?
}
