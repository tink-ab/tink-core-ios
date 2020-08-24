import Foundation

public struct BudgetPeriod: Equatable {
    /// Period start expressed as UTC epoch timestamp in milliseconds.
    public var start: Date
    /// Period end expressed as UTC epoch timestamp in milliseconds.
    public var end: Date
    /// Period spent amount.
    public var spentAmount: CurrencyDenominatedAmount?
}
