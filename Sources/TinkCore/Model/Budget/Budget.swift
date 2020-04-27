import Foundation

public struct Budget {
    public typealias ID = Identifier<Budget>

    enum Filter {
        case account(Account.ID)
        case category(Category.Code)
        case tag(String)
        case search(String)
    }

    let id: ID
    let name: String
    let amount: CurrencyDenominatedAmount?
    let filter: [Filter]
}
