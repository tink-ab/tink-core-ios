enum RESTCategoryType: String, DefaultableDecodable {
    case expenses = "EXPENSES"
    case income = "INCOME"
    case transfers = "TRANSFERS"
    case unknown

    static var decodeFallbackValue: RESTCategoryType = .unknown
}
