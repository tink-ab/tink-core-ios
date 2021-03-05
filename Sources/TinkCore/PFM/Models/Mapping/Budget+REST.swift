import Foundation

extension Budget {
    init(restBudget: RESTBudget) {
        self.id = .init(restBudget.id)
        self.name = restBudget.name
        self.amount = restBudget.amount.flatMap(CurrencyDenominatedAmount.init(restCurrencyDenominatedAmount:))

        self.periodicity = Periodicity(restPeriodicityType: restBudget.periodicityType, restOneOffPeriodicity: restBudget.oneOffPeriodicity, restRecurringPeriodicity: restBudget.recurringPeriodicity)

        self.filter = Budget.Filter.makeFilters(restFilter: restBudget.filter)
    }
}

extension Budget.RecurringPeriodicity {
    init?(restRecurringPeriodicity: RESTBudget.RecurringPeriodicity) {
        switch restRecurringPeriodicity.periodUnit {
        case .month:
            self = .init(periodUnit: .month)
        case .week:
            self = .init(periodUnit: .week)
        case .year:
            self = .init(periodUnit: .year)
        case .unknown:
            return nil
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

extension Budget.Filter {
    static func makeFilters(restFilter: RESTInsightActionData.CreateBudget.BudgetSuggestion.Filter?) -> [Budget.Filter] {
        var filters: [Budget.Filter] = []

        filters += restFilter?.accounts?
            .map(Account.ID.init(_:))
            .map(Budget.Filter.account)
            ?? []

        filters += restFilter?.categories?
            .map(Category.Code.init(_:))
            .map(Budget.Filter.category)
            ?? []

        return filters
    }
}

extension Budget.Periodicity {
    init?(restPeriodicityType: RESTBudget.PeriodicityType?, restOneOffPeriodicity: RESTBudget.OneOffPeriodicity?, restRecurringPeriodicity: RESTBudget.RecurringPeriodicity?) {
        switch restPeriodicityType {
        case .oneOff:
            guard let oneOffPeriodicity = restOneOffPeriodicity
                .map(Budget.OneOffPeriodicity.init(restOneOffPeriodicity:))
            else { return nil }
            self = .oneOff(oneOffPeriodicity)
        case .recurring:
            guard let recurringPeriodicity = restRecurringPeriodicity
                .flatMap(Budget.RecurringPeriodicity.init(restRecurringPeriodicity:))
            else { return nil }
            self = .recurring(recurringPeriodicity)
        default:
            return nil
        }
    }
}
