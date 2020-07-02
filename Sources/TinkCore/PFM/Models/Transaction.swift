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
}

extension Transaction: Hashable {}
