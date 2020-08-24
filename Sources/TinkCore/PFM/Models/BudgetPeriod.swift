import Foundation

public struct BudgetPeriod: Equatable {
    /// Period start expressed as UTC epoch timestamp in milliseconds.
    public let start: Date
    /// Period end expressed as UTC epoch timestamp in milliseconds.
    public let end: Date
    /// Period spent amount.
    public let spentAmount: CurrencyDenominatedAmount?
}
