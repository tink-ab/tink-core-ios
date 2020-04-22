/// The response received when trying to authenticate with the `UserService`.
public struct AuthenticateResponse: Decodable {
    public let accessToken: AccessToken
}
