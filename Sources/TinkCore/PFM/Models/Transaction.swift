import Foundation

/// A representation of a transaction.
public struct Transaction {
    /// A unique identifier of a `Transaction`.
    public typealias ID = Identifier<Transaction>

    public let accountID: Account.ID
    public let amount: CurrencyDenominatedAmount?
    public var categoryID: Category.ID
    public let description: String
    public let date: Date?
    /// The unique identifier of this `Transaction`.
    public let id: ID
    public let inserted: Date?
    public let isUpcomingOrInFuture: Bool

    public init(id: ID, accountID: Account.ID, amount: CurrencyDenominatedAmount?, categoryID: Category.ID, description: String, date: Date?, inserted: Date?, isUpcomingOrInFuture: Bool) {
        self.id = id
        self.accountID = accountID
        self.amount = amount
        self.categoryID = categoryID
        self.description = description
        self.date = date
        self.inserted = inserted
        self.isUpcomingOrInFuture = isUpcomingOrInFuture
    }
}

extension Transaction: Hashable {}
