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
    /// The flag indicates if the original transaction is in pending state or not.
    public let isPending: Bool
    /// The category type of the transaction. Values: `expenses`, `income`, `transfers` and `unknown` in case the type is not specified.
    public let categoryType: CategoryType
    /// The dispensable amount of the transaction.
    public let dispensableAmount: Double?
    /// The date the transaction was last modified by the user.
    public let lastModified: Date
    /// The type of the transaction. Values: `default`, `creditCard`, `transfer`, `payment`, `withdrawal` and `unknown` in case the type is not specified.
    public let type: TransactionType
    /// The internal identifier of the user that the transaction belongs to.
    public let userId: String

    public init(id: ID, accountID: Account.ID, amount: CurrencyDenominatedAmount, categoryID: Category.ID, description: String, date: Date, inserted: Date, isUpcomingOrInFuture: Bool, notes: String?, originalDescription: String, originalDate: Date, originalAmount: CurrencyDenominatedAmount, isPending: Bool, categoryType: CategoryType, dispensableAmount: Double?, lastModified: Date, type: TransactionType, userId: String) {
        self.id = id
        self.accountID = accountID
        self.amount = amount
        self.categoryID = categoryID
        self.description = description
        self.date = date
        self.inserted = inserted
        self.isUpcomingOrInFuture = isUpcomingOrInFuture
        self.originalDescription = originalDescription
        self.originalDate = originalDate
        self.originalAmount = originalAmount
        self.notes = notes
        self.isPending = isPending
        self.categoryType = categoryType
        self.dispensableAmount = dispensableAmount
        self.lastModified = lastModified
        self.type = type
        self.userId = userId
    }
}

extension Transaction: Hashable {}

/// The `TransactionType` is just a PFM's representation of the `RESTTransactionType` model.
public enum TransactionType {
    case `default`
    case creditCard
    case transfer
    case payment
    case withdrawal
    case unknown
}

/// The `CategoryType` is just a PFM's representation of the `RESTCategoryType` model.
public enum CategoryType {
    case expenses
    case income
    case transfers
    case unknown
}
