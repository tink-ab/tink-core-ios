import Foundation

/// A cluster of transactions to be categorized.
public struct TransactionCluster {
    /// The categorization improvement achived if cluster is categorized.
    public let categorizationImprovement: Double
    /// A description of the cluster to categorized.
    public let description: String
    /// List of transactions belonging to this cluster.
    public let transactions: [Transaction]

    @available(*, deprecated)
    public init(categorizationImprovement: Double, description: String, transactions: [Transaction]) {
        self.categorizationImprovement = categorizationImprovement
        self.description = description
        self.transactions = transactions
    }
}
