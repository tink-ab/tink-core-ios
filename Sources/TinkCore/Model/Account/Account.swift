import Foundation

public struct Account: Hashable {
    public typealias ID = Identifier<Account>

    public enum Kind {
        case checking
        case savings
        case investment
        case mortgage
        case creditCard
        case loan
        case pension
        case other
        case external
    }

    public let id: ID
    public let balance: CurrencyDenominatedAmount?
    public let name: String
    public let kind: Kind
    public let number: String
}
