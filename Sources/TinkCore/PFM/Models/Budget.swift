import Foundation

public struct Budget {
    public typealias ID = Identifier<Budget>

    public enum Periodicity: Equatable {
        case oneOff(OneOffPeriodicity)
        case recurring(RecurringPeriodicity)
    }

    public struct RecurringPeriodicity: Equatable {
        enum PeriodUnit {
            case week
            case month
            case year
        }

        /// Recurring periodicity unit.
        let periodUnit: PeriodUnit
    }

    public struct OneOffPeriodicity: Equatable {
        /// Budget start expressed as UTC epoch timestamp in milliseconds.
        let start: Date
        /// Budget end expressed as UTC epoch timestamp in milliseconds.
        let end: Date
    }

    public enum Filter {
        case account(Account.ID)
        case category(Category.Code)
        case tag(String)
        case search(String)
    }

    public let id: ID
    public let name: String
    public let amount: CurrencyDenominatedAmount?
    public let filter: [Filter]
    public let periodicity: Periodicity?
}

// MARK: Budget Transaction
extension Budget {
    public struct Transaction {
        /// The ID of the transaction.
        public let id: TinkPFMUI.Transaction.ID
        /// The transaction amount.
        public let amount: CurrencyDenominatedAmount
        /// The dispensable amount. This amount will e.g. be reduced if the account it belongs to has ownership set to 50%.
        public let dispensableAmount: CurrencyDenominatedAmount?
        /// Date of the transaction expressed as UTC epoch timestamp in milliseconds.
        public let date: Date?
        /// Description of the transaction.
        public let description: String?
        /// Category code.
        public let categoryCode: Category.Code?
        /// The ID of the account this transaction belongs to.
        public let accountID: Account.ID?
    }
}
