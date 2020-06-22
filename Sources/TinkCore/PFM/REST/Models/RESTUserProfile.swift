import Foundation

struct RESTUserProfile: Decodable {
    var currency: String
    var locale: String
    var market: String
    var periodAdjustedDay: Int
    var periodMode: RESTPeriodMode
    var timeZone: String
}
