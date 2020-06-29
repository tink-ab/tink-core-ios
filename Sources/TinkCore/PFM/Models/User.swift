import Foundation

public struct User {
    public typealias ID = Identifier<User>

    public let created: Date
    public let id: ID
    public let username: String?
    let nationalID: String?
    public let profile: UserProfile
}
