import Foundation

public final class RESTAccountService: AccountService {

    private let client: Client

    public init(tink: Tink) {
        self.client = tink.client
    }

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    public func accounts(completion: @escaping (Result<[Account], Error>) -> Void) -> Cancellable? {
        let request = RESTResourceRequest<RESTAccountListResponse>(path: "/api/v1/accounts/list", method: .get, contentType: .json) { result in
            let newResult = result.map { $0.accounts.map(Account.init) }
            completion(newResult)
        }
        return client.performRequest(request)
    }
}
