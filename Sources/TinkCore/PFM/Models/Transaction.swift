import Foundation

/// A representation of a transaction.
public struct Transaction {
    /// A unique identifier of a `Transaction`.
    public typealias ID = Identifier<Transaction>

    /// The internal identifier of the account that the transaction belongs to.
    public let accountID: Account.ID
    /// The amount of the transaction.
    public let amount: CurrencyDenominatedAmount
    /// The category of the transaction.
    public var categoryID: Category.ID
    /// The description of the transaction.
    public let description: String
    /// The date the transaction was executed.
    public let date: Date
    /// The unique identifier of this `Transaction`.
    public let id: ID
    /// The timestamp of when the transaction was first saved to database.
    public let inserted: Date
    /// Indicates if this is an upcoming transaction not booked yet.
    public let isUpcomingOrInFuture: Bool

    public init(id: ID, accountID: Account.ID, amount: CurrencyDenominatedAmount, categoryID: Category.ID, description: String, date: Date, inserted: Date, isUpcomingOrInFuture: Bool) {
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
