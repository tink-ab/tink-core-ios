import Foundation

public final class RESTOAuthService: OAuthService {

    private let client: RESTClient

    public init(tink: Tink) {
        self.client = tink.client
    }

    init(client: RESTClient) {
        self.client = client
    }

    public func createAnonymous(market: Market?, locale: Locale, origin: String?, completion: @escaping (Result<AccessToken, Error>) -> Void) -> RetryCancellable? {

        let body = RESTAnonymousUserRequest(market: market?.code ?? "", origin: origin, locale: locale.identifier)

        let data = try? JSONEncoder().encode(body)
        let request = RESTResourceRequest<RESTAnonymousUserResponse>(path: "/api/v1/user/anonymous", method: .post, body: data, contentType: .json) { (result) in

            completion(result.map { AccessToken($0.access_token) })
        }

        return client.performRequest(request)
    }

    public func authenticate(code: AuthorizationCode, completion: @escaping (Result<AuthenticateResponse, Error>) -> Void) -> RetryCancellable? {
        var request = RESTResourceRequest(path: "/link/v1/authentication/token", method: .post, contentType: .json, completion: completion)
        let body = ["code": code.rawValue]
        request.body = try? JSONEncoder().encode(body)

        return client.performRequest(request)
    }
}
