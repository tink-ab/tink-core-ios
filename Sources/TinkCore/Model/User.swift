import Foundation

public struct User {
    public typealias ID = Identifier<User>

    var created: Date?
    public var id: ID
    public var username: String?
    var nationalID: String?
    var profile: UserProfile
}
