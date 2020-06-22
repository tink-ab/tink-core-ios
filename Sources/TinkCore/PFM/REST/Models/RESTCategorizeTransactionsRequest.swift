struct RESTCategorizeTransactionsListRequest: Encodable {
    let categorizationList: [RESTCategorizeTransactionsRequest]
}

struct RESTCategorizeTransactionsRequest: Encodable {
    let categoryId: String
    let transactionIds: [String]
}
