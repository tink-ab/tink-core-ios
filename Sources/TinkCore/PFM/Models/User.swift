import Foundation

public struct User {
    public typealias ID = Identifier<User>

    public let created: Date
    public let id: ID
    public let username: String?
    let nationalID: String?
    public let profile: UserProfile

    public init(created: Date, id: User.ID, username: String?, nationalID: String?, profile: UserProfile) {
        self.created = created
        self.id = id
        self.username = username
        self.nationalID = nationalID
        self.profile = profile
    }
}
