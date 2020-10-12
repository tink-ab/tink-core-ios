import Foundation

struct RESTTransaction: Decodable {
    let accountId: String
    let categoryId: String
    let amount: Double
    let categoryType: RESTCategoryType
    let currencyDenominatedAmount: RESTCurrencyDenominatedAmount
    let currencyDenominatedOriginalAmount: RESTCurrencyDenominatedAmount
    let date: Date
    let description: String
    let dispensableAmount: Double?
    let id: String
    let lastModified: Date
    let notes: String
    let originalAmount: Double
    let originalDate: Date
    let originalDescription: String
    let inserted: Date?
    let timestamp: Date
    let type: RESTTransactionType
    let upcoming: Bool
    let userId: String
    let pending: Bool
}

enum RESTTransactionType: String, DefaultableDecodable {
    case `default` = "DEFAULT"
    case creditCard = "CREDIT_CARD"
    case transfer = "TRANSFER"
    case payment = "PAYMENT"
    case withdrawal = "WITHDRAWAL"
    case unknown = "UNKNOWN"

    static var decodeFallbackValue: RESTTransactionType = .unknown
}
