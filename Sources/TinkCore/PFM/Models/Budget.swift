import Foundation

public struct Budget {
    public typealias ID = Identifier<Budget>

    public enum Periodicity: Equatable {
        case oneOff(OneOffPeriodicity)
        case recurring(RecurringPeriodicity)
    }

    public struct RecurringPeriodicity: Equatable {
        public enum PeriodUnit {
            case week
            case month
            case year
        }

        /// Recurring periodicity unit.
        public let periodUnit: PeriodUnit

        public init(periodUnit: PeriodUnit) {
            self.periodUnit = periodUnit
        }
    }

    public struct OneOffPeriodicity: Equatable {
        /// Budget start expressed as UTC epoch timestamp in milliseconds.
        public let start: Date
        /// Budget end expressed as UTC epoch timestamp in milliseconds.
        public let end: Date

        public init(start: Date, end: Date) {
            self.start = start
            self.end = end
        }
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

    @available(*, deprecated)
    public init(id: Budget.ID, name: String, amount: CurrencyDenominatedAmount?, filter: [Budget.Filter], periodicity: Budget.Periodicity?) {
        self.id = id
        self.name = name
        self.amount = amount
        self.filter = filter
        self.periodicity = periodicity
    }
}

// MARK: Budget Transaction

extension Budget {
    public struct Transaction {
        /// The ID of the transaction.
        public let id: TinkCore.Transaction.ID
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

        @available(*, deprecated)
        public init(id: TinkCore.Transaction.ID, amount: CurrencyDenominatedAmount, dispensableAmount: CurrencyDenominatedAmount?, date: Date?, description: String?, categoryCode: Category.Code?, accountID: Account.ID?) {
            self.id = id
            self.amount = amount
            self.dispensableAmount = dispensableAmount
            self.date = date
            self.description = description
            self.categoryCode = categoryCode
            self.accountID = accountID
        }
    }
}
