import Foundation

/// A representation of a recurring transaction group.
public struct RecurringTransactionsGroup {
    /// A unique identifier of a `RecurringTransactionsGroup`.
    public typealias ID = Identifier<RecurringTransactionsGroup>
    /// The unique identifier of this `RecurringTransactionsGroup`.
    public let id: ID
    /// The category id of the recurring transaction.
    public var categoryID: Category.ID
}
