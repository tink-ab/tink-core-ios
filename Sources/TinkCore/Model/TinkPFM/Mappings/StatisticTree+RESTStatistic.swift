import Foundation

extension StatisticTree {
    init(restStatistics: [RESTStatistic], currencyCode: CurrencyCode, periods: [RESTPeriod], now: Date = Date()) {
        var expenseAmountsByMonth = [Month: CategoryData.CategoryPeriodData]()
        var incomeAmountsByMonth = [Month: CategoryData.CategoryPeriodData]()

        let statisticsByType = Dictionary(grouping: restStatistics, by: { $0.type })

        let periodByKey = Dictionary(grouping: periods, by: { $0.name ?? "" }).compactMapValues({ $0.first })

        let currentPeriod = periods.first(where: { period in
            guard let start = period.startDate, let end = period.endDate else { return false }
            let dateInterval = DateInterval(start: start, end: end)
            return dateInterval.contains(now)
        })

        for (type, statistics) in statisticsByType {
            switch type {
            case .expensesByCategory, .incomeByCategory:
                let statisticsByMonth = Dictionary(grouping: statistics, by: { $0.period })

                for (periodKey, monthStatistics) in statisticsByMonth {
                    guard
                        let month = Month(value: periodKey),
                        let period = periodByKey[periodKey],
                        let start = period.startDate,
                        let end = period.endDate
                        else { continue }

                    let statisticsByCategoryReference: [Category.ID: [RESTStatistic]] = Dictionary(grouping: monthStatistics, by: { Category.ID($0.description) })

                    let amountsByCategoryReference: [Category.ID: CurrencyDenominatedAmount] = statisticsByCategoryReference.mapValues { (categoryStatistics) -> CurrencyDenominatedAmount in
                        let total = categoryStatistics
                            .map({ $0.value })
                            .reduce(0, +)
                        return CurrencyDenominatedAmount(total, currencyCode: currencyCode)
                    }

                    let dateInterval = DateInterval(start: start, end: end)

                    let data = CategoryData.CategoryPeriodData(
                        dateInterval: dateInterval,
                        amountsByCategoryReference: amountsByCategoryReference
                    )

                    switch type {
                    case .expensesByCategory:
                        expenseAmountsByMonth[month] = data
                    case .incomeByCategory:
                        incomeAmountsByMonth[month] = data
                    default: break
                    }

                }

                // If statistics is missing data for the current month, add empty data for that month so UI can display that.
                // This can happen at the start of a new monthly period.
                if
                    let currentPeriod = currentPeriod,
                    let currentPeriodKey = currentPeriod.name,
                    let currentMonth = Month(value: currentPeriodKey),
                    let start = currentPeriod.startDate,
                    let end = currentPeriod.endDate
                {
                    let zeroData = CategoryData.CategoryPeriodData(
                        dateInterval: DateInterval(start: start, end: end),
                        amountsByCategoryReference: [:]
                    )

                    switch type {
                    case .expensesByCategory:
                        if expenseAmountsByMonth[currentMonth] == nil {
                            expenseAmountsByMonth[currentMonth] = zeroData
                        }
                    case .incomeByCategory:
                        if incomeAmountsByMonth[currentMonth] == nil {
                            incomeAmountsByMonth[currentMonth] = zeroData
                        }
                    default:
                        break
                    }
                }
            case .leftToSpend:
                break
            case .leftToSpendAverage:
                break
            }
        }

        if statisticsByType[.expensesByCategory] != nil {
            self.expensesCategoryData = CategoryData(amounts: expenseAmountsByMonth)
        } else {
            self.expensesCategoryData = nil
        }

        if statisticsByType[.incomeByCategory] != nil {
            self.incomeCategoryData = CategoryData(amounts: incomeAmountsByMonth)
        } else {
            self.incomeCategoryData = nil
        }
    }
}
