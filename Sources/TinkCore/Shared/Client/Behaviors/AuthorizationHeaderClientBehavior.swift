import Foundation

final class AuthorizationHeaderClientBehavior: ClientBehavior {
    var userSession: UserSession?

    init(userSession: UserSession?) {
        self.userSession = userSession
    }

    var headers: [String: String] {
        switch userSession {
        case .accessToken(let accessToken):
            return ["Authorization": "Bearer \(accessToken)"]
        default:
            return [:]
        }
    }
}
