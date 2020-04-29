import Foundation

public struct Budget {
    public typealias ID = Identifier<Budget>

    public enum Filter {
        case account(Account.ID)
        case category(Category.Code)
        case tag(String)
        case search(String)
    }

    public let id: ID
    public let name: String
    public let amount: CurrencyDenominatedAmount?
    public let filter: [Filter]
}
