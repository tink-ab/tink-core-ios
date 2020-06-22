import Foundation

struct RESTTransaction: Decodable {
    let accountId: String
    let currencyDenominatedAmount: RESTCurrencyDenominatedAmount
    let description: String
    let date: Date?
    let id: String
    let inserted: Date?
    let categoryId: String
    let categoryType: RESTCategoryType
    let upcoming: Bool
    let pending: Bool
}
