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
