import Foundation

struct RESTBudgetTransactionsResponse: Decodable {
    /** List of transactions for a budget. */
    let transactions: [RESTBudgetTransaction]
}

