import Foundation

public struct User {
    typealias ID = Identifier<User>

    var created: Date?
    var id: ID
    public var username: String?
    var nationalID: String?
    var profile: UserProfile
}
