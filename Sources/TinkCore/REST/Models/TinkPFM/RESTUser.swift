import Foundation

struct RESTUser: Decodable {
    var created: Date
    var flag: [String]?
    var id: String
    var nationalId: String?
    var password: String?
    var profile: RESTUserProfile
    var username: String?
}
