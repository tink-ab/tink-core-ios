import Foundation

public protocol BeneficiaryService {
    func beneficiaries(completion: @escaping (Result<[Beneficiary], Error>) -> Void) -> RetryCancellable?
    func createBeneficiary(
        accountNumberKind: AccountNumberKind,
        accountNumber: String,
        name: String,
        ownerAccountID: Account.ID,
        credentialsID: Credentials.ID,
        appURI: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable?
}
