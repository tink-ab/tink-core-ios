import Foundation

public protocol TransferService {
    func accounts(destinationURIs: [URL], completion: @escaping (Result<[Account], Error>) -> Void) -> RetryCancellable?
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
        completion: @escaping (Result<SignableOperation, Error>
        ) -> Void
    ) -> RetryCancellable?
    func transferStatus(id: Transfer.ID, completion: @escaping (Result<SignableOperation, Error>) -> Void) -> RetryCancellable?
}
