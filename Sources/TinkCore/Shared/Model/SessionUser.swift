import Foundation

/// A user in the Tink API.
public struct SessionUser {
    let accessToken: AccessToken
    let user: User?

    /// The username of the current user.
    public var username: String? {
        return user?.username
    }

    init(accessToken: AccessToken, user: User? = nil) {
        self.accessToken = accessToken
        self.user = user
    }
}
