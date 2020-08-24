import Foundation

final class RESTBudgetService: BudgetService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func createBudget(
        request: UpdateBudgetRequest,
        completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void
    ) -> Cancellable? {
        var accountIDs = [Account.ID]()
        var categoryCodes = [Category.Code]()
        var tags = [String]()
        var searchQuery = String()

        request.filter.forEach { budgetFilter in
            switch budgetFilter {
            case .account(let accountID): accountIDs.append(accountID)
            case .category(let categoryCode): categoryCodes.append(categoryCode)
            case .tag(let tagText): tags.append(tagText)
            case .search(let query): searchQuery = query
            }
        }

        let accounts = accountIDs.map { RESTBudget.Filter.Account.init(id:$0.value) }
        let category = categoryCodes.map { RESTBudget.Filter.Category.init(code: $0.value) }
        let filterTags = tags.map(RESTBudget.Filter.Tag.init(key:))

        switch request.periodicity {
        case .oneOff(let oneOffPeriodicity):
            let restOneOffPeriodicity = RESTBudget.OneOffPeriodicity.init(start: oneOffPeriodicity.start, end: oneOffPeriodicity.end)
            let oneOffRequest = RESTCreateOneOffBudgetRequest(
                name: request.name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: request.amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                oneOffPeriodicity: restOneOffPeriodicity)

            return createOneOffBudget(request: oneOffRequest, completion: completion)
        case .recurring(let recurringPeriodicity):
            let restRecurringPeriodicity = RESTBudget.RecurringPeriodicity(recurringPeriodicity: recurringPeriodicity)
            let recurringRequest = RESTCreateRecurringBudgetRequest(
                name: request.name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: request.amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                recurringPeriodicity: restRecurringPeriodicity)

            return createRecurringBudget(request: recurringRequest, completion: completion)
        }
    }

    @discardableResult
    func editBudget(
        id: Budget.ID,
        request: UpdateBudgetRequest,
        completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void
    ) -> Cancellable? {
        var accountIDs = [Account.ID]()
        var categoryCodes = [Category.Code]()
        var tags = [String]()
        var searchQuery = String()

        request.filter.forEach { budgetFilter in
            switch budgetFilter {
            case .account(let accountID): accountIDs.append(accountID)
            case .category(let categoryCode): categoryCodes.append(categoryCode)
            case .tag(let tagText): tags.append(tagText)
            case .search(let query): searchQuery = query
            }
        }

        let accounts = accountIDs.map { RESTBudget.Filter.Account.init(id:$0.value) }
        let category = categoryCodes.map { RESTBudget.Filter.Category.init(code: $0.value) }
        let filterTags = tags.map(RESTBudget.Filter.Tag.init(key:))

        switch request.periodicity {
        case .oneOff(let oneOffPeriodicity):
            let restOneOffPeriodicity = RESTBudget.OneOffPeriodicity.init(start: oneOffPeriodicity.start, end: oneOffPeriodicity.end)
            let oneOffRequest = RESTCreateOneOffBudgetRequest(
                name: request.name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: request.amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                oneOffPeriodicity: restOneOffPeriodicity)

            return editBudget(id: id, request: oneOffRequest, completion: completion)
        case .recurring(let recurringPeriodicity):
            let restRecurringPeriodicity = RESTBudget.RecurringPeriodicity(recurringPeriodicity: recurringPeriodicity)
            let recurringRequest = RESTCreateRecurringBudgetRequest(
                name: request.name,
                amount: RESTCurrencyDenominatedAmount(currencyDenominatedAmount: request.amount),
                filter: RESTBudget.Filter(accounts: accounts, categories: category, tags: filterTags, freeTextQuery: searchQuery),
                recurringPeriodicity: restRecurringPeriodicity)

            return editBudget(id: id, request: recurringRequest, completion: completion)
        }
    }

    @discardableResult
    func budgetTransactionByID(
        _ id: Budget.ID,
        start: Date,
        end: Date,
        completion: @escaping (Result<RESTBudgetTransactionsResponse, Error>) -> Void) -> Cancellable? {
        let id = id.value
        let startString = String(Int(start.timeIntervalSince1970 * 1000))
        let endString = String(Int(end.timeIntervalSince1970 * 1000))

        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.append(URLQueryItem(name: "start", value: startString))
        urlQueryItems.append(URLQueryItem(name: "end", value: endString))

        let request = RESTResourceRequest(path: "/api/v1/budgets/\(id)/transactions", method: .get, contentType: .json, parameters: urlQueryItems, completion: completion)
        return client.performRequest(request)
    }

    private func createOneOffBudget(
        request: RESTCreateOneOffBudgetRequest,
        completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void
    ) -> Cancellable? {
        let body = makeBudgetRequestBody(request)
        let request = RESTResourceRequest(path: "/api/v1/budgets/one-off", method: .post, body: body, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    private func createRecurringBudget(
        request: RESTCreateRecurringBudgetRequest,
        completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void
    ) -> Cancellable? {
        let body = makeBudgetRequestBody(request)
        let request = RESTResourceRequest(path: "/api/v1/budgets/recurring", method: .post, body: body, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    private func editBudget<Request: Encodable>(
        id: Budget.ID,
        request: Request,
        completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void
    ) -> Cancellable? {
        let body = makeBudgetRequestBody(request)
        let request = RESTResourceRequest(path: "/api/v1/budgets/\(id.value)", method: .put, body: body, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    private func makeBudgetRequestBody<Request: Encodable>(_ request: Request) -> Data {
        let bodyEncoder = JSONEncoder()
        bodyEncoder.dateEncodingStrategy = .custom { date, encoder in
            var container = encoder.singleValueContainer()
            try container.encode(Int(date.timeIntervalSince1970 * 1000))
        }
        let body = try! bodyEncoder.encode(request)
        return body
    }

    @discardableResult
    func budgets(
        includeArchived: Bool,
        completion: @escaping (Result<[Budget], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<RESTListBudgetSpecificationsResponse>(path: "/api/v1/budgets", method: .get, contentType: .json) { result in
            let newResult = result.map { ($0.budgetSpecifications ?? []).compactMap(Budget.init(restBudget:)) }
            completion(newResult)
        }
        return client.performRequest(request)
    }

    @discardableResult
    func budgetSummaries(
        includeArchived: Bool = false,
        completion: @escaping (Result<RESTListBudgetSummariesResponse, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/budgets/summaries", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }

    @discardableResult
    func budgetDetailsByID(
        _ budgetID: Budget.ID,
        start: Date,
        end: Date,
        completion: @escaping (Result<RESTBudgetDetailsResponse, Error>) -> Void
    ) -> Cancellable? {
        let id = budgetID.value
        let startString = String(Int(start.timeIntervalSince1970 * 1000))
        let endString = String(Int(end.timeIntervalSince1970 * 1000))

        var urlQueryItems = [URLQueryItem]()
        urlQueryItems.append(URLQueryItem(name: "start", value: startString))
        urlQueryItems.append(URLQueryItem(name: "end", value: endString))

        let request = RESTResourceRequest(path: "/api/v1/budgets/\(id)/details", method: .get, contentType: .json, parameters: urlQueryItems, completion: completion)
        return client.performRequest(request)
    }

    @discardableResult
    func archiveBudget(
        _ budgetID: Budget.ID,
        completion: @escaping (Result<RESTArchiveBudgetResponse, Error>) -> Void
    ) -> Cancellable? {
        let id = budgetID.value
        let request = RESTResourceRequest(path: "/api/v1/budgets/\(id)/archive", method: .put, contentType: .json, completion: completion)
        return client.performRequest(request)
    }
}

