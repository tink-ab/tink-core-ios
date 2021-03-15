struct RESTSuggestTransactionsResponse: Decodable {
    let categorizationImprovement: Double
    let categorizationLevel: Double
    let clusters: [RESTTransactionCluster]
}
