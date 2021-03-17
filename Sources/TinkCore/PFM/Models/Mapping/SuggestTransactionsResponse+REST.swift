import Foundation

extension SuggestTransactionsResponse {
    init(from restSuggestTransactionsResponse: RESTSuggestTransactionsResponse) {
        self.categorizationImprovement = restSuggestTransactionsResponse.categorizationImprovement
        self.categorizationLevel = restSuggestTransactionsResponse.categorizationLevel
        self.clusters = restSuggestTransactionsResponse.clusters.map { TransactionCluster(from: $0) }
    }
}
