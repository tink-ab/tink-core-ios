import Foundation

public struct User {
    public typealias ID = Identifier<User>

    public var created: Date
    public var id: ID
    public var username: String?
    var nationalID: String?
    public var profile: UserProfile
}
