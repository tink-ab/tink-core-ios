import Foundation

public protocol BeneficiaryService {
    func beneficiaries(completion: @escaping (Result<[Beneficiary], Error>) -> Void) -> RetryCancellable?
    /// Initiates a request to add beneficiary to the given account belonging to the authenticated user.
    ///
    /// - Parameters:
    ///   - accountNumberKind: The type of the `accountNumber` that this beneficiary has.
    ///   - accountNumber: The account number for the beneficiary. The structure of this field depends on the `accountNumberKind`.
    ///   - name: The name chosen by the user for this beneficiary.
    ///   - ownerAccountID: The identifier of the source account that this beneficiary should be added to.
    ///   - credentialsID: The ID of the `Credentials` used to add the beneficiary. Note that you can send in a different ID here than the credentials ID to which the account belongs. This functionality exists to support the case where you may have double credentials for one financial institution, due to PSD2 regulations.
    ///   - appURI: The end user will be redirected to this URI after the authorization code has been delivered.
    ///   - completion: The completion handler to call when the create beneficiary request is complete.
    /// - Returns: A cancellation handler.
    func create(
        accountNumberKind: AccountNumberKind,
        accountNumber: String,
        name: String,
        ownerAccountID: Account.ID,
        credentialsID: Credentials.ID,
        appURI: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable?
}
