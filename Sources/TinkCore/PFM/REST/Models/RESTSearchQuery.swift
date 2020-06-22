import Foundation

struct RESTSearchQuery: Encodable {
    var limit: Int?
    var offset: Int?
    var accounts: [String]?
    var categories: [String]?
    var startDate: Date?
    var endDate: Date?
    var includeUpcoming: Bool = false
    var queryString: String?
    var sort: RESTSortType?
    var order: RESTOrderType?
}

enum RESTSortType: String, Encodable {
    case score = "SCORE"
    case date = "DATE"
    case account = "ACCOUNT"
    case description = "DESCRIPTION"
    case amount = "AMOUNT"
    case category = "CATEGORY"
}

enum RESTOrderType: String, Encodable {
    case asc = "ASC"
    case desc = "DESC"
}
