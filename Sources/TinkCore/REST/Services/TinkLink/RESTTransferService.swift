import Foundation

final class RESTTransferService: TransferService {
    private let client: RESTClient

    init(tink: Tink) {
        self.client = tink.client
    }

    init(client: RESTClient) {
        self.client = client
    }

    func accounts(destinationURIs: [URL], completion: @escaping (Result<[Account], Error>) -> Void) -> RetryCancellable? {
        let parameters: [URLQueryItem] = destinationURIs.map { URLQueryItem(name: "destination[]", value: $0.absoluteString) }

        let request = RESTResourceRequest<RESTAccountListResponse>(path: "/api/v1/transfer/accounts", method: .get, contentType: .json, parameters: parameters) { result in
            let mappedResult = result.map { $0.accounts.map { Account(restAccount: $0) } }
            completion(mappedResult)
        }

        return client.performRequest(request)
    }

    func transfer(
        amount: Decimal,
        currency: CurrencyCode,
        credentialsID: Credentials.ID?,
        transferID: Transfer.ID?,
        sourceURI: String,
        destinationURI: String,
        sourceMessage: String?,
        destinationMessage: String,
        dueDate: Date?,
        redirectURI: URL,
        completion: @escaping (Result<SignableOperation, Error>) -> Void
    ) -> RetryCancellable? {
        let body = RESTTransferRequest(
            amount: NSDecimalNumber(decimal: amount).doubleValue,
            credentialsId: credentialsID?.value,
            currency: currency.value,
            destinationMessage: destinationMessage,
            id: transferID?.value,
            sourceMessage: sourceMessage,
            dueDate: dueDate,
            messageType: nil,
            destinationUri: destinationURI,
            sourceUri: sourceURI,
            redirectUri: redirectURI.absoluteString
        )
        let request = RESTResourceRequest<RESTSignableOperation>(path: "/api/v1/transfer", method: .post, body: body, contentType: .json) { result in
            let mappedResult = result.map { SignableOperation($0) }
            completion(mappedResult)
        }

        return client.performRequest(request)
    }

    func transferStatus(id: Transfer.ID, completion: @escaping (Result<SignableOperation, Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTSignableOperation>(path: "/api/v1/transfer/\(id.value)/status", method: .get, contentType: .json) { result in
            let mappedResult = result.map { SignableOperation($0) }
            completion(mappedResult)
        }

        return client.performRequest(request)
    }
}
