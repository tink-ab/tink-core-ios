import Foundation

public final class RESTAuthenticationService: AuthenticationService {

    private let client: RESTClient

    public init(tink: Tink) {
        self.client = tink.client
    }

    init(client: RESTClient) {
        self.client = client
    }

    public func clientDescription(clientID: String, scopes: [Scope], redirectURI: URL, completion: @escaping (Result<ClientDescription, Error>) -> Void) -> RetryCancellable? {

        let body = RESTDescribeOAuth2ClientRequest(clientId: clientID, redirectUri: redirectURI.absoluteString, scope: scopes.scopeDescription)

        let data = try? JSONEncoder().encode(body)

        let request = RESTResourceRequest<RESTDescribeOAuth2ClientResponse>(path: "/api/v1/oauth/describe", method: .post, body: data, contentType: .json, completion: { result in
            completion(result.map(ClientDescription.init))
        })

        return client.performRequest(request)
    }

    public func authorize(clientID: String, redirectURI: URL, scopes: [Scope], completion: @escaping (Result<AuthorizationCode, Error>) -> Void) -> RetryCancellable? {

        let body = [
            "clientId": clientID,
            "redirectUri": redirectURI.absoluteString,
            "scope": scopes.scopeDescription,
        ]
        let data = try? JSONEncoder().encode(body)

        let request = RESTResourceRequest<RESTAuthorizationResponse>(path: "/api/v1/oauth/authorize", method: .post, body: data, contentType: .json) { result in
            completion(result.map { $0.code })
        }

        return client.performRequest(request)
    }
}
