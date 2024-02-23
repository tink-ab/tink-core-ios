import Foundation

@available(*, deprecated)
extension TransactionCluster {
    init(from restTransactionCluster: RESTTransactionCluster) {
        self.categorizationImprovement = restTransactionCluster.categorizationImprovement
        self.description = restTransactionCluster.description
        self.transactions = restTransactionCluster.transactions.map { Transaction(from: $0) }
    }
}
