import Foundation

struct User {
    typealias ID = Identifier<User>

    var created: Date
    var id: ID
    var username: String
    var nationalID: String
    var profile: UserProfile
}
