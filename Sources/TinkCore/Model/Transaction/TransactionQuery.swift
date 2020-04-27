import Foundation

/// The `TransactionQuery` is used to determine which transactions to show.
/// If no queries are selected, all transactions will be available.
public struct TransactionsQuery: Equatable {
    /// A list of account ids to include transactions from.
    public let accountIDs: [Account.ID]
    /// A list of caregory ids to include transactions from.
    public var categoryIDs: [Category.ID]
    /// A date interval for which transactions to include.
    public let dateInterval: DateInterval?
    /// Transaction query.
    public var query: String?
    /// Incluce planned transactions which have not been withdrawn yet.
    public let includeUpcoming: Bool
    /// Determine sortation for transactions.
    public let sort: Sort
    /// Determinea how the transactions will be ordered.
    public let order: Order
    /// The maximum amount of transactions to fetch.
    public var limit: Int?

    /// A type that determines how to sort the transactions.
    public enum Sort: String {
        /// Sort transactions by date.
        case date
        /// Sort transactions by account.
        case account
        /// Sort transactions by description.
        case description
        /// Sort transactions by amount.
        case amount
        /// Sort transactions by category.
        case category
    }

    /// A type that determines the order of the transactions.
    public enum Order: String {
        /// Display transactions in an ascending order.
        case ascending
        /// Display transactions in a descending order.
        case descending
    }

    /// Initialize a new `TransactionQuery`
    /// - Parameters:
    ///   - accountIDs: A list of account ids to include transactions from.
    ///   - categoryIDs: A list of caregory ids to include transactions from.
    ///   - dateInterval: A date interval for which transactions to include.
    ///   - query: Transaction query.
    ///   - includeUpcoming: Incluce planned transactions which have not been withdrawn yet.
    ///   - sort: Determine sortation for transactions.
    ///   - order: Determinea how the transactions will be ordered.
    ///   - limit: The maximum amount of transactions to fetch.
    public init(accountIDs: [Account.ID] = [], categoryIDs: [Category.ID] = [], dateInterval: DateInterval? = nil, query: String? = nil, includeUpcoming: Bool = false, sort: Sort = .date, order: Order = .descending, limit: Int? = nil) {
        self.accountIDs = accountIDs
        self.categoryIDs = categoryIDs
        self.dateInterval = dateInterval
        self.query = query
        self.includeUpcoming = includeUpcoming
        self.sort = sort
        self.order = order
        self.limit = limit
    }
}

enum TransactionsQueryError: Error {
    /// We are unable to reliably match queries with a search string, so only update transactions with matching ids
    case notMatchable
}

extension Collection where Element == Transaction {
    func filter(with query: TransactionsQuery) throws -> [Transaction] {
        if let queryString = query.query, !queryString.isEmpty { throw TransactionsQueryError.notMatchable }

        return filter { transaction in
            if !query.accountIDs.isEmpty {
                guard query.accountIDs.contains(transaction.accountID) else { return false }
            }

            if !query.categoryIDs.isEmpty {
                guard query.categoryIDs.contains(transaction.categoryID) else { return false }
            }

            if let dateInterval = query.dateInterval, let date = transaction.date, !dateInterval.contains(date) {
                return false
            }

            if !query.includeUpcoming, transaction.isUpcomingOrInFuture {
                return false
            }

            return true
        }
    }
}
