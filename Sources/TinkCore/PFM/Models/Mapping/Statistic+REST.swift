import Foundation

extension Statistic {
    init?(restStatistic: RESTStatistic) {
        guard let period = StatisticPeriod(string: restStatistic.period),
              let type = Statistic.Kind(restType: restStatistic.type),
              let resolution = Statistic.Resolution(restStatisticResolution: restStatistic.resolution)
        else { return nil }
        self =
            .init(description: restStatistic.description, payload: restStatistic.payload, period: period, resolution: resolution, kind: type, value: restStatistic.value, userID: restStatistic.userId)
    }
}

extension Statistic.Kind {
    init?(restType: RESTStatisticQueryType) {
        switch restType {
        case .balancesByAccount: self = .balancesByAccount
        case .balancesByAccountTypeGroup: self = .balancesByAccountTypeGroup
        case .expensesByCategory: self = .expensesByCategory
        case .expensesByCategoryByCount: self = .expensesByCategoryByCount
        case .expensesByPrimaryCategory: self = .expensesByPrimaryCategory
        case .expensesByPrimaryCategoryByCount: self = .expensesByPrimaryCategoryByCount
        case .incomeAndExpenses: self = .incomeAndExpenses
        case .incomeByCategory: self = .incomeByCategory
        case .leftToSpend: self = .leftToSpend
        case .leftToSpendAverage: self = .leftToSpendAverage
        case .unknown: return nil
        }
    }
}

extension RESTStatisticQueryType {
    init(statisticKind: Statistic.Kind) {
        switch statisticKind {
        case .balancesByAccount: self = .balancesByAccount
        case .balancesByAccountTypeGroup: self = .balancesByAccountTypeGroup
        case .expensesByCategory: self = .expensesByCategory
        case .expensesByCategoryByCount: self = .expensesByCategoryByCount
        case .expensesByPrimaryCategory: self = .expensesByPrimaryCategory
        case .expensesByPrimaryCategoryByCount: self = .expensesByPrimaryCategoryByCount
        case .incomeAndExpenses: self = .incomeAndExpenses
        case .incomeByCategory: self = .incomeByCategory
        case .leftToSpend: self = .leftToSpend
        case .leftToSpendAverage: self = .leftToSpendAverage
        }
    }
}

extension Statistic.Resolution {
    init?(restStatisticResolution: RESTStatisticQueryResolution) {
        switch restStatisticResolution {
        case .all: self = .all
        case .daily: self = .daily
        case .monthly: self = .monthly
        case .monthlyAdjusted: self = .monthlyAdjusted
        case .weekly: self = .weekly
        case .yearly: self = .yearly
        case .unknown: return nil
        }
    }
}

extension RESTStatisticQueryResolution {
    init(statisticResolution: Statistic.Resolution) {
        switch statisticResolution {
        case .all: self = .all
        case .daily: self = .daily
        case .monthly: self = .monthly
        case .monthlyAdjusted: self = .monthlyAdjusted
        case .weekly: self = .weekly
        case .yearly: self = .yearly
        }
    }
}
