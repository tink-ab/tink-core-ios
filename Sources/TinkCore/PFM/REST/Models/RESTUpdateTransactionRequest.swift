import Foundation

struct RESTUpdateTransactionRequest: Encodable {
    let currencyDenominatedAmount: RESTCurrencyDenominatedAmount
    let categoryId: String
    let date: Date
    let description: String
    let notes: String?
}
