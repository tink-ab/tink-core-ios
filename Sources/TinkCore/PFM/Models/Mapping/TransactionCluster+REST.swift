import Foundation

extension TransactionCluster {
    init(from restTransactionCluster: RESTTransactionCluster) {
        self.categorizationImprovement = .init(restTransactionCluster.categorizationImprovement)
        self.description = .init(restTransactionCluster.description)
        self.transactions = restTransactionCluster.transactions.map { Transaction.init(from: $0) } 
    }
}
