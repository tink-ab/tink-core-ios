import Foundation

struct User {
    typealias ID = Identifier<User>

    var created: Date
    var id: ID
    var profile: UserProfile
}
