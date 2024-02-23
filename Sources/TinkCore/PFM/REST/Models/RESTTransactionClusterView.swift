@available(*, deprecated)
struct RESTTransactionCluster: Decodable {
    let categorizationImprovement: Double
    let description: String
    let transactions: [RESTTransaction]
}
