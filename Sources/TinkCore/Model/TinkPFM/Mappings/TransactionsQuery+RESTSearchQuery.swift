extension RESTSortType {
    init(transactionQuerySort: TransactionsQuery.Sort) {
        switch transactionQuerySort {
        case .date:
            self = .date
        case .account:
            self = .account
        case .description:
            self = .description
        case .amount:
            self = .amount
        case .category:
            self = .category
        }
    }
}

extension RESTOrderType {
    init(transactionQueryOrder: TransactionsQuery.Order) {
        switch transactionQueryOrder {
        case .ascending:
            self = .asc
        case .descending:
            self = .desc
        }
    }
}
