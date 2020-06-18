import Foundation

struct RESTAuthenticationService: AuthenticationService {

    let client: RESTClient

    @discardableResult
    func clientDescription(clientID: String, scopes: [Scope], redirectURI: URL, completion: @escaping (Result<ClientDescription, Error>) -> Void) -> RetryCancellable? {

        let body = RESTDescribeOAuth2ClientRequest(clientId: clientID, redirectUri: redirectURI.absoluteString, scope: scopes.scopeDescription)

        let request = RESTResourceRequest<RESTDescribeOAuth2ClientResponse>(path: "/api/v1/oauth/describe", method: .post, body: body, contentType: .json, completion: { result in
            completion(result.map(ClientDescription.init))
        })

        return client.performRequest(request)
    }

    @discardableResult
    func authorize(clientID: String, redirectURI: URL, scopes: [Scope], completion: @escaping (Result<AuthorizationCode, Error>) -> Void) -> RetryCancellable? {

        let body = [
            "clientId": clientID,
            "redirectUri": redirectURI.absoluteString,
            "scope": scopes.scopeDescription,
        ]
        
        let request = RESTResourceRequest<RESTAuthorizationResponse>(path: "/api/v1/oauth/authorize", method: .post, body: body, contentType: .json, completion: { result in
            completion(result.map(\.code).map(AuthorizationCode.init(_:)))
        })

        return client.performRequest(request)
    }
}
