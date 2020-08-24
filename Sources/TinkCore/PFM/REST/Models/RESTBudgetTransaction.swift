import Foundation

struct RESTBudgetTransaction: Decodable {
    /** The ID of the transaction. */
    let id: String?
    /** The transaction amount. */
    let amount: RESTCurrencyDenominatedAmount?
    /** The dispensable amount. This amount will e.g. be reduced if the account it belongs to has ownership set to 50%. */
    let dispensableAmount: RESTCurrencyDenominatedAmount?
    /** Date of the transaction expressed as UTC epoch timestamp in milliseconds. */
    let date: Date?
    /** Description of the transaction. */
    let description: String?
    /** Category code. */
    let categoryCode: String?
    /** The ID of the account this transaction belongs to. */
    let accountId: String?
}

