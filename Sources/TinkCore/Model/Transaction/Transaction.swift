import Foundation

/// A representation of a transaction.
public struct Transaction {
    /// A unique identifier of a `Transaction`.
    public typealias ID = Identifier<Transaction>

    let accountID: Account.ID
    let amount: CurrencyDenominatedAmount?
    var categoryID: Category.ID
    let description: String
    let date: Date?
    /// The unique identifier of this `Transaction`.
    public let id: ID
    let inserted: Date?
    let isUpcomingOrInFuture: Bool
}

extension Transaction: Hashable {}
