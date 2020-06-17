import Foundation

public class RESTBeneficiaryService: BeneficiaryService {
    private let client: RESTClient

    public init(tink: Tink) {
        self.client = tink.client
    }

    init(client: RESTClient) {
        self.client = client
    }

    public func beneficiaries(completion: @escaping (Result<[Beneficiary], Error>) -> Void) -> RetryCancellable? {
        let request = RESTResourceRequest<RESTBeneficiaryListResponse>(path: "/api/v1/beneficiaries", method: .get, contentType: .json) { result in
            let mappedResult = result.map { $0.beneficiaries.map { Beneficiary(restBeneficiary: $0) } }
            completion(mappedResult)
        }

        return client.performRequest(request)
    }

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
    public func createBeneficiary(
        accountNumberKind: AccountNumberKind,
        accountNumber: String,
        name: String,
        ownerAccountID: Account.ID,
        credentialsID: Credentials.ID,
        appURI: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable? {
        let body = RESTCreateBeneficiaryRequest(
            accountNumberType: accountNumberType.value,
            accountNumber: accountNumber,
            name: name,
            ownerAccountId: ownerAccountID.value,
            credentialsId: credentialsID.value,
            appUri: appURI.absoluteString
        )
        let request = RESTSimpleRequest(path: "/api/v1/beneficiaries", method: .post, body: body, contentType: .json) { result in
            completion(result.map { _ in })
        }
        return client.performRequest(request)
    }
}
