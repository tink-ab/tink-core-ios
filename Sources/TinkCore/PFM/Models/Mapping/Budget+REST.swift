import Foundation

extension Budget {
    init(restBudget: RESTBudget) {
        self.id = .init(restBudget.id)
        self.name = restBudget.name
        self.amount = restBudget.amount.flatMap(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount:))

        switch restBudget.periodicityType {
        case .oneOff:
            let oneOffPeriodicity = restBudget.oneOffPeriodicity.map { OneOffPeriodicity(restOneOffPeriodicity: $0) }
            periodicity = oneOffPeriodicity.flatMap { Periodicity.oneOff($0) }
        case .recurring:
            let recurringPeriodicity = restBudget.recurringPeriodicity.map { RecurringPeriodicity(restRecurringPeriodicity: $0) }
            periodicity = recurringPeriodicity.flatMap { Periodicity.recurring($0) }
        default:
            periodicity = nil
        }

        self.filter = Budget.Filter.makeFilters(restFilter: restBudget.filter)
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

extension Budget.Filter {
    static func makeFilters(restFilter: RESTBudget.Filter?) -> [Budget.Filter] {
        var filters: [Budget.Filter] = []

        filters += restFilter?.accounts?
            .compactMap { $0.id }
            .map(Account.ID.init(_:))
            .map(Budget.Filter.account)
            ?? []

        filters += restFilter?.categories?
            .compactMap { $0.code }
            .map(Category.Code.init(_:))
            .map(Budget.Filter.category)
            ?? []

        filters += restFilter?.tags?
            .compactMap { $0.key }
            .map(Budget.Filter.tag)
            ?? []

        if let query = restFilter?.freeTextQuery {
            filters.append(.search(query))
        }

        return filters
    }
}
