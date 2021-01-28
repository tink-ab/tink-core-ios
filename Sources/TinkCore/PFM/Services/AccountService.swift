public protocol AccountService {
    func accounts(completion: @escaping (Result<[Account], Error>) -> Void) -> Cancellable?
    func update(
        id: Account.ID,
        name: String,
        type: Account.Kind,
        accountNumber: String,
        isFavorite: Bool,
        ownership: Double,
        completion: @escaping (Result<Account, Error>) -> Void
    ) -> Cancellable?
}
