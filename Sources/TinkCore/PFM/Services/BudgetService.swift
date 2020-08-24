public protocol BudgetService {
    func budgets(includeArchived: Bool, completion: @escaping (Result<[Budget], Error>) -> Void) -> Cancellable?

    func createBudget(request: UpdateBudgetRequest, completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void) -> Cancellable?

    func editBudget(id: Budget.ID, request: UpdateBudgetRequest, completion: @escaping (Result<RESTUpdateBudgetResponse, Error>) -> Void) -> Cancellable?

    func budgetTransactionByID(_ id: Budget.ID, start: Date, end: Date, completion: @escaping (Result<RESTBudgetTransactionsResponse, Error>) -> Void) -> Cancellable?

    func budgets(includeArchived: Bool = false, completion: @escaping (Result<RESTListBudgetSpecificationsResponse, Error>) -> Void) -> Cancellable?

    func budgetSummaries(includeArchived: Bool = false, completion: @escaping (Result<RESTListBudgetSummariesResponse, Error>) -> Void) -> Cancellable?

    func budgetDetailsByID(_ budgetID: Budget.ID, start: Date, end: Date, completion: @escaping (Result<RESTBudgetDetailsResponse, Error>) -> Void) -> Cancellable?

    func archiveBudget(_ budgetID: Budget.ID, completion: @escaping (Result<RESTArchiveBudgetResponse, Error>) -> Void) -> Cancellable?
}
