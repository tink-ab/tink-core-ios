import Foundation

/// A representation of a predicted recurring transaction.
public struct PredictedRecurringTransaction {
    /// A unique identifier of a `PredictedRecurringTransaction`.
    public typealias ID = Identifier<PredictedRecurringTransaction>
    /// The unique identifier of this `PredictedRecurringTransaction`.
    public let id: ID
    /// The internal identifier of the account that the recurring transaction belongs to.
    public let accountID: Account.ID
    /// The amount of the transaction.
    public let amount: CurrencyDenominatedAmount
    /// The identifier of the related recurring transactions group.
    public var groupID: RecurringTransactionsGroup.ID
    /// The date that the transaction was received by the bank.
    public let booked: String
    /// The date the transaction will be executed.
    public let date: String
    /// The formatted and prettified description of the recurring transaction.
    public let description: String
    /// The raw (original and unprettified) description of the recurring transaction.
    public let originalDescription: String

    public init(accountID: Account.ID, amount: CurrencyDenominatedAmount, groupID: RecurringTransactionsGroup.ID, booked: String, date: String, description: String, originalDescription: String) {
        self.id = .init(UUID().uuidString)
        self.accountID = accountID
        self.amount = amount
        self.groupID = groupID
        self.booked = booked
        self.date = date
        self.description = description
        self.originalDescription = originalDescription
    }
}

extension PredictedRecurringTransaction: Hashable, Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.date == rhs.date &&
            lhs.description == rhs.description &&
            lhs.booked == rhs.booked &&
            lhs.originalDescription == rhs.originalDescription &&
            lhs.amount == rhs.amount &&
            lhs.accountID == rhs.accountID &&
            lhs.groupID == rhs.groupID
    }
}
