enum RESTCategoryType: String, Decodable {
    case expenses = "EXPENSES"
    case income = "INCOME"
    case transfers = "TRANSFERS"
    case unknown
}
