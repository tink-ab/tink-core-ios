import Foundation

extension SuggestTransactionsResponse {
    init (from restSuggestTransactionsResponse: RESTSuggestTransactionsResponse) {
        self.categorizationImprovement = .init(restSuggestTransactionsResponse.categorizationImprovement)
        self.categorizationLevel = .init(restSuggestTransactionsResponse.categorizationLevel)
        self.clusters = restSuggestTransactionsResponse.clusters.map { TransactionCluster.init(from: $0) }
    }
}
