import Foundation

public struct RESTUpdateTransactionRequest: Encodable {
    let amount: RESTCurrencyDenominatedAmount
    let categoryId: String
    let date: Date
    let description: String
    let notes: String?
}
