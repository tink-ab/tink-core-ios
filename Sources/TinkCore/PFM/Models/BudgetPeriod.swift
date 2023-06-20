import Foundation

extension Budget {
    public struct Period: Equatable {
        /// Period date interval
        public let dateInterval: DateInterval
        /// Period spent amount.
        public let spentAmount: CurrencyDenominatedAmount?
    }
}
