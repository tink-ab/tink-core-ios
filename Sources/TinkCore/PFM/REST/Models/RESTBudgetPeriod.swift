import Foundation

struct RESTBudgetPeriod: Decodable {
    /// Period start expressed as UTC epoch timestamp in milliseconds.
    let start: Date
    /// Period end expressed as UTC epoch timestamp in milliseconds.
    let end: Date
    /// Period spent amount.
    let spentAmount: RESTCurrencyDenominatedAmount
}
