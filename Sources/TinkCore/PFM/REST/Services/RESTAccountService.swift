import Foundation

final class RESTAccountService: AccountService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func accounts(completion: @escaping (Result<[Account], Error>) -> Void) -> Cancellable? {
        let request = RESTResourceRequest<RESTAccountListResponse>(path: "/api/v1/accounts/list", method: .get, contentType: .json) { result in
            let newResult = result.map { $0.accounts.map(Account.init) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    func update(
        id: Account.ID,
        name: String?,
        type: Account.Kind?,
        accountNumber: String?,
        isFavorite: Bool?,
        ownership: Double?,
        accountExclusion: Account.AccountExclusion?,
        completion: @escaping (Result<Account, Error>) -> Void
    ) -> Cancellable? {
        var restType: RESTAccount.ModelType? {
            switch type {
            case .checking:
                return .checking
            case .savings:
                return .savings
            case .investment:
                return .investment
            case .mortgage:
                return .mortgage
            case .creditCard:
                return .creditCard
            case .loan:
                return .loan
            case .pension:
                return .pension
            case .other:
                return .other
            case .external:
                return .external
            case .unknown:
                return .unknown
            case .none:
                return nil
            }
        }

        let updateRequest = RESTUpdateAccountRequest(
            id: id.value,
            name: name,
            accountNumber: accountNumber,
            ownership: ownership,
            favored: isFavorite,
            type: restType
        )

        let request = RESTResourceRequest<RESTAccount>(
            path: "/api/v1/accounts/\(id.value)",
            method: .put,
            body: updateRequest,
            contentType: .json,
            completion: { result in
                completion(result.map(Account.init(restAccount:)))
            }
        )

        return client.performRequest(request)
    }
}
