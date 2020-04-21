import Foundation

public struct Account: Hashable {
    public typealias ID = Identifier<Account>

    enum Kind: String {
        case checking = "CHECKING"
        case savings = "SAVINGS"
        case investment = "INVESTMENT"
        case mortgage = "MORTGAGE"
        case creditCard = "CREDIT_CARD"
        case loan = "LOAN"
        case pension = "PENSION"
        case other = "OTHER"
        case external = "EXTERNAL"
    }

    public let id: ID
    let balance: CurrencyDenominatedAmount?
    let name: String
    let type: Kind
    let number: String
}
