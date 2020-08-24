import Foundation

public protocol BudgetService {
    func budgets(includeArchived: Bool, completion: @escaping (Result<[Budget], Error>) -> Void) -> Cancellable?

    func createBudget(request: UpdateBudgetRequest, completion: @escaping (Result<Budget, Error>) -> Void) -> Cancellable?

    func editBudget(id: Budget.ID, request: UpdateBudgetRequest, completion: @escaping (Result<Budget, Error>) -> Void) -> Cancellable?

    func budgetTransactionByID(_ id: Budget.ID, start: Date, end: Date, completion: @escaping (Result<[Budget.Transaction], Error>) -> Void) -> Cancellable?

    func budgetSummaries(includeArchived: Bool, completion: @escaping (Result<[BudgetSummary], Error>) -> Void) -> Cancellable?

    func budgetDetailsByID(_ budgetID: Budget.ID, start: Date, end: Date, completion: @escaping (Result<BudgetPeriodOverview, Error>) -> Void) -> Cancellable?

    func archiveBudget(_ budgetID: Budget.ID, completion: @escaping (Result<Budget, Error>) -> Void) -> Cancellable?
}
