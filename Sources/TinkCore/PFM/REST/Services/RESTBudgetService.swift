import Foundation

final class RESTBudgetService: BudgetService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func create(
        name: String,
        amount: CurrencyDenominatedAmount,
        filter: [Budget.Filter],
        periodicity: Budget.Periodicity,
        completion: @escaping (Result<Budget, Error>) -> Void
    ) -> Cancellable? {
        var accountIDs = [Account.ID]()
        var categoryCodes = [Category.Code]()
        var tags = [String]()
        var searchQuery = String()

        filter.forEach { budgetFilter in
            switch budgetFilter {
            case .account(let accountID): accountIDs.append(accountID)
            case .category(let categoryCode): categoryCodes.append(categoryCode)
            case .tag(let tagText): tags.append(tagText)
            case .search(let query): searchQuery = query
            }
        }

        let accounts = accountIDs.map { RESTBudget.Filter.Account(id: $0.value) }
        let category = categoryCodes.map { RESTBudget.Filter.Category(code: $0.value) }
        let filterTags = tags.map(RESTBudget.Filter.Tag.init(key:))

        switch periodicity {
        case .oneOff(let oneOffPeriodicity):
            let restOneOffPeriodicity = RESTBudget.OneOffPeriodicity(start: oneOffPeriodicity.start, end: oneOffPeriodicity.end)
            let oneOffRequest = RESTCreateOneOffBudgetRequest(
                name: name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                oneOffPeriodicity: restOneOffPeriodicity,
                recurringPeriodicity: nil
            )

            return createOneOffBudget(request: oneOffRequest, completion: completion)
        case .recurring(let recurringPeriodicity):
            let restRecurringPeriodicity = RESTBudget.RecurringPeriodicity(recurringPeriodicity: recurringPeriodicity)
            let recurringRequest = RESTCreateRecurringBudgetRequest(
                name: name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                oneOffPeriodicity: nil,
                recurringPeriodicity: restRecurringPeriodicity
            )

            return createRecurringBudget(request: recurringRequest, completion: completion)
        }
    }

    @discardableResult
    func update(
        id: Budget.ID,
        name: String,
        amount: CurrencyDenominatedAmount,
        filter: [Budget.Filter],
        periodicity: Budget.Periodicity,
        completion: @escaping (Result<Budget, Error>) -> Void
    ) -> Cancellable? {
        var accountIDs = [Account.ID]()
        var categoryCodes = [Category.Code]()
        var tags = [String]()
        var searchQuery = String()

        filter.forEach { budgetFilter in
            switch budgetFilter {
            case .account(let accountID): accountIDs.append(accountID)
            case .category(let categoryCode): categoryCodes.append(categoryCode)
            case .tag(let tagText): tags.append(tagText)
            case .search(let query): searchQuery = query
            }
        }

        let accounts = accountIDs.map { RESTBudget.Filter.Account(id: $0.value) }
        let category = categoryCodes.map { RESTBudget.Filter.Category(code: $0.value) }
        let filterTags = tags.map(RESTBudget.Filter.Tag.init(key:))

        switch periodicity {
        case .oneOff(let oneOffPeriodicity):
            let restOneOffPeriodicity = RESTBudget.OneOffPeriodicity(start: oneOffPeriodicity.start, end: oneOffPeriodicity.end)
            let oneOffRequest = RESTUpdateBudgetRequest(
                name: name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                oneOffPeriodicity: restOneOffPeriodicity,
                recurringPeriodicity: nil
            )
            return update(id: id, request: oneOffRequest, completion: completion)
        case .recurring(let recurringPeriodicity):
            let restRecurringPeriodicity = RESTBudget.RecurringPeriodicity(recurringPeriodicity: recurringPeriodicity)
            let recurringRequest = RESTUpdateBudgetRequest(
                name: name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                oneOffPeriodicity: nil,
                recurringPeriodicity: restRecurringPeriodicity
            )
            return update(id: id, request: recurringRequest, completion: completion)
        }
    }

    @discardableResult
    func transactionsForBudget(
        id: Budget.ID,
        dateInterval: DateInterval,
        completion: @escaping (Result<[Budget.Transaction], Error>) -> Void
    ) -> Cancellable? {
        let id = id.value
        let startString = String(Int(dateInterval.start.timeIntervalSince1970 * 1000))
        let endString = String(Int(dateInterval.end.timeIntervalSince1970 * 1000))

        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.append(URLQueryItem(name: "start", value: startString))
        urlQueryItems.append(URLQueryItem(name: "end", value: endString))

        let request = RESTResourceRequest<RESTBudgetTransactionsResponse>(
            path: "/api/v1/budgets/\(id)/transactions",
            method: .get,
            contentType: .json,
            parameters: urlQueryItems
        ) { result in
            let newResult = result.map { $0.transactions.compactMap(
                Budget.Transaction.init(restBudgetTransaction:)
            )
            }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    private func createOneOffBudget(
        request: RESTCreateOneOffBudgetRequest,
        completion: @escaping (Result<Budget, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTCreateBudgetResponse>(
            path: "/api/v1/budgets/one-off",
            method: .post,
            body: request,
            contentType: .json
        ) { result in
            let newResult = result.map { Budget(restBudget: $0.budgetSpecification) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    private func createRecurringBudget(
        request: RESTCreateRecurringBudgetRequest,
        completion: @escaping (Result<Budget, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTCreateBudgetResponse>(
            path: "/api/v1/budgets/recurring",
            method: .post,
            body: request,
            contentType: .json
        ) { result in
            let result = result.map { Budget(restBudget: $0.budgetSpecification) }
            completion(result)
        }
        return client.performRequest(request)
    }

    private func update<Request: Encodable>(
        id: Budget.ID,
        request: Request,
        completion: @escaping (Result<Budget, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTUpdateBudgetResponse>(
            path: "/api/v1/budgets/\(id.value)",
            method: .put,
            body: request,
            contentType: .json
        ) { result in
            let result = result.map { Budget(restBudget: $0.budgetSpecification) }
            completion(result)
        }
        return client.performRequest(request)
    }

    @discardableResult
    func budgets(
        includeArchived: Bool,
        completion: @escaping (Result<[Budget], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTListBudgetSpecificationsResponse>(
            path: "/api/v1/budgets",
            method: .get,
            contentType: .json
        ) { result in
            let newResult = result.map { ($0.budgetSpecifications ?? []).compactMap(Budget.init(restBudget:)) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    @discardableResult
    func budgetSummaries(
        includeArchived: Bool = false,
        completion: @escaping (Result<[BudgetSummary], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTListBudgetSummariesResponse>(
            path: "/api/v1/budgets/summaries",
            method: .get,
            contentType: .json
        ) { result in
            let newResult = result.map { $0.budgetSummaries.compactMap(BudgetSummary.init(restBudgetSummary:)) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    @discardableResult
    func budgetDetails(
        id: Budget.ID,
        dateInterval: DateInterval,
        completion: @escaping (Result<BudgetDetails, Error>) -> Void
    ) -> Cancellable? {
        let id = id.value
        let startString = String(Int(dateInterval.start.timeIntervalSince1970 * 1000))
        let endString = String(Int(dateInterval.end.timeIntervalSince1970 * 1000))

        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.append(URLQueryItem(name: "start", value: startString))
        urlQueryItems.append(URLQueryItem(name: "end", value: endString))

        let request = RESTResourceRequest<RESTBudgetDetailsResponse>(
            path: "/api/v1/budgets/\(id)/details",
            method: .get,
            contentType: .json,
            parameters: urlQueryItems
        ) { result in
            let newResult = result.map { BudgetDetails(restBudgetDetailsResponse: $0) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    @discardableResult
    func archive(
        id: Budget.ID,
        completion: @escaping (Result<Budget, Error>) -> Void
    ) -> Cancellable? {
        let id = id.value
        let request = RESTResourceRequest<RESTArchiveBudgetResponse>(
            path: "/api/v1/budgets/\(id)/archive",
            method: .put,
            contentType: .json
        ) { result in
            let newResult = result.map { Budget(restBudget: $0.budgetSpecification) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    @discardableResult
    func recommendedBudgets(
        completion: @escaping (Result<[RecommendedBudget], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTRecommendedBudgetResponse>(
            path: "/api/v1/budgets/recommended",
            method: .get,
            contentType: .json
        ) { result in
            let newResult = result.map { $0.recommendedBudgets.compactMap(RecommendedBudget.init(restRecommendedBudget:)) }
            completion(newResult)
        }
        return client.performRequest(request)
    }
}
