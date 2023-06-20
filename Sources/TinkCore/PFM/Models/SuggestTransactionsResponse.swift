import Foundation

/// The response when fetching transactions to categorize.
public struct SuggestTransactionsResponse {
    /// The categorization improvement achived if cluster is categorized.
    public let categorizationImprovement: Double
    /// The current categorization level before categorization.
    public let categorizationLevel: Double
    /// Clusters to categorize.
    public let clusters: [TransactionCluster]
}
