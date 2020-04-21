import Foundation

/// A representation of a transaction.
public struct Transaction: Codable {
    /// A unique identifier of a `Transaction`.
    public typealias ID = Identifier<Transaction>

    let accountId: Account.ID
    let amount: CurrencyDenominatedAmount?
    var categoryId: Category.ID
    let description: String
    let date: Date?
    /// The unique identifier of this `Transaction`.
    public let id: ID
    let inserted: Date?
    let isUpcomingOrInFuture: Bool
}

extension Transaction: Hashable { }
