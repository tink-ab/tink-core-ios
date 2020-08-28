import Foundation

public struct BudgetPeriod: Equatable {
    /// Period date interval
    public let dateInterval: DateInterval
    /// Period spent amount.
    public let spentAmount: CurrencyDenominatedAmount?
}
