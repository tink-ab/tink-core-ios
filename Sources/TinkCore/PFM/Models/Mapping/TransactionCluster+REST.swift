import Foundation

extension TransactionCluster {
    init(from restTransactionCluster: RESTTransactionCluster) {
        self.categorizationImprovement = restTransactionCluster.categorizationImprovement
        self.description = restTransactionCluster.description
        self.transactions = restTransactionCluster.transactions.map { Transaction.init(from: $0) } 
    }
}
