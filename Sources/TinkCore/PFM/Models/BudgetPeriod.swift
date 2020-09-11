import Foundation

extension Budget {
    public struct Period: Equatable {
        /// Period date interval
        public let dateInterval: DateInterval
        /// Period spent amount.
        public let spentAmount: CurrencyDenominatedAmount?

        public init(dateInterval: DateInterval, spentAmount: CurrencyDenominatedAmount?) {
            self.dateInterval = dateInterval
            self.spentAmount = spentAmount
        }
    }
}
