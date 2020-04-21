/// The response received when trying to authorize with the `AuthenticationService`.
public struct AuthorizationResponse: Decodable {
    public let code: AuthorizationCode
}
