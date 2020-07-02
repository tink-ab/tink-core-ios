import Foundation

struct RESTUser: Decodable {
    /// The date when the user was created.
    var created: Date
    /// The user-specific feature flags assigned to the user.
    var flags: [String]?
    /// The internal identifier of the user.
    var id: String
    /// Detected national identification number of the end-user.
    var nationalId: String?
    /// The configurable profile of the user.
    var profile: RESTUserProfile
    /// The username (usually email) of the user.
    var username: String?
    /// The internal identifier of the app that the user belongs to.
    var appId: String
}
