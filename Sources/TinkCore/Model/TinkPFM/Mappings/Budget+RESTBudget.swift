import Foundation

extension Budget {
    init?(restBudget: RESTBudget) {
        guard let id = restBudget.id else { return nil }
        self.id = .init(id)
        self.name = restBudget.name ?? ""
        if let amount = restBudget.amount {
            self.amount = CurrencyDenominatedAmount(
                unscaledValue: Int64(amount.unscaledValue),
                scale: Int64(amount.scale),
                currencyCode: amount.currencyCode
            )
        } else {
            self.amount = nil
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
