extension StatisticType {
    var restType: RESTStatisticQueryType {
        switch self {
        case .expensesByCategoryCode: return .expensesByCategory
        case .incomeByCategoryCode: return .incomeByCategory
        }
    }
}
