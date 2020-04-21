import Foundation

class RESTAccountService {

    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func accounts(
        completion: @escaping (Result<[RESTAccount], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTAccountListResponse>(path: "/api/v1/accounts/list", method: .get, contentType: .json) { result in
            let newResult = result.map { $0.accounts }
            completion(newResult)
        }
        return client.performRequest(request)
    }
}
