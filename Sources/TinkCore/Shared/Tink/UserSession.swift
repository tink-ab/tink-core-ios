import Foundation

/// A user session to use with the Tink object.
public enum UserSession {
    /// An OAuth access token.
    case accessToken(String)
}
