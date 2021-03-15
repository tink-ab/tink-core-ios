public struct SuggestTransactionsResponse {

    /// The categorization improvement achived if cluster is categorized.
    public let categorizationImprovement: Double
    /// The current categorization level before categorization.
    public let categorizationLevel: Double
    /// Clusters to categorize.
    public let clusters: [TransactionCluster]

    internal init (from restSuggestTransactionsResponse: RESTSuggestTransactionsResponse) {
        self.categorizationImprovement = .init(restSuggestTransactionsResponse.categorizationImprovement)
        self.categorizationLevel = .init(restSuggestTransactionsResponse.categorizationLevel)
        self.clusters = restSuggestTransactionsResponse.clusters.map { TransactionCluster.init(from: $0) }
    }
}
