import Foundation

extension Budget {
    init?(restBudget: RESTBudget) {
        guard let id = restBudget.id else { return nil }
        self.id = .init(id)
        self.name = restBudget.name ?? ""
        self.amount = restBudget.amount.flatMap(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount:))

        switch restBudget.periodicityType {
        case .oneOff:
            let oneOffPeriodicity = restBudget.oneOffPeriodicity.map ({ OneOffPeriodicity(restOneOffPeriodicity: $0) })
            periodicity = oneOffPeriodicity.flatMap { Periodicity.oneOff($0) }
        case .recurring:
            let recurringPeriodicity = restBudget.recurringPeriodicity.map ({ RecurringPeriodicity(restRecurringPeriodicity: $0) })
            periodicity = recurringPeriodicity.flatMap { Periodicity.recurring($0) }
        default:
            periodicity = nil
        }
        var newFilter = [Filter]()

        newFilter += restBudget.filter?.accounts?
            .compactMap { $0.id }
            .map(Account.ID.init(_:))
            .map(Filter.account)
            ?? []

        newFilter += restBudget.filter?.categories?
            .compactMap { $0.code }
            .map(Category.Code.init(_:))
            .map(Filter.category)
            ?? []

        newFilter += restBudget.filter?.tags?
            .compactMap { $0.key }
            .map(Filter.tag)
            ?? []

        if let query = restBudget.filter?.freeTextQuery {
            newFilter.append(.search(query))
        }

        self.filter = newFilter
    }
}

extension Budget.RecurringPeriodicity {
    init(restRecurringPeriodicity: RESTBudget.RecurringPeriodicity) {
        switch restRecurringPeriodicity.periodUnit {
        case .month:
            self = .init(periodUnit: .month)
        case .week:
            self = .init(periodUnit: .week)
        case .year:
            self = .init(periodUnit: .year)
        }
    }
}

extension Budget.OneOffPeriodicity {
    init(restOneOffPeriodicity: RESTBudget.OneOffPeriodicity) {
        self = .init(start: restOneOffPeriodicity.start, end: restOneOffPeriodicity.end)
    }
}
