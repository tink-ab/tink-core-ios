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
    /// A free-text field modifiable by the user. Any 'word' (whitespace separated), prefixed with a #, is considered a tag. These tags become searchable.
    public let notes: String?
    /// The orginal description of the transaction. This will not change even if the owner of the transaction has changed the description.
    public let originalDescription: String
    /// The orginal date of the transaction. This will not change even if the owner of the transaction has changed the date.
    public let originalDate: Date
    /// The orginal amount of the transaction. This will not change even if the owner of the transaction has changed the amount.
    public let originalAmount: CurrencyDenominatedAmount

    public init(id: ID, accountID: Account.ID, amount: CurrencyDenominatedAmount, categoryID: Category.ID, description: String, date: Date, inserted: Date, isUpcomingOrInFuture: Bool) {
        self.id = id
        self.accountID = accountID
        self.amount = amount
        self.categoryID = categoryID
        self.description = description
        self.date = date
        self.inserted = inserted
        self.isUpcomingOrInFuture = isUpcomingOrInFuture
        self.originalDescription = description
        self.originalDate = date
        self.originalAmount = amount
        self.notes = nil 
    }
}

extension Transaction: Hashable {}
