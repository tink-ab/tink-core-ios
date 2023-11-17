import Foundation

public protocol BudgetService {
    func budgets(includeArchived: Bool, completion: @escaping (Result<[Budget], Error>) -> Void) -> Cancellable?

    func create(name: String, amount: CurrencyDenominatedAmount, filter: [Budget.Filter], periodicity: Budget.Periodicity, completion: @escaping (Result<Budget, Error>) -> Void) -> Cancellable?

    func update(id: Budget.ID, name: String, amount: CurrencyDenominatedAmount, filter: [Budget.Filter], periodicity: Budget.Periodicity, completion: @escaping (Result<Budget, Error>) -> Void) -> Cancellable?

    func transactionsForBudget(id: Budget.ID, dateInterval: DateInterval, completion: @escaping (Result<[Budget.Transaction], Error>) -> Void) -> Cancellable?

    func budgetSummaries(includeArchived: Bool, completion: @escaping (Result<[BudgetSummary], Error>) -> Void) -> Cancellable?

    func budgetDetails(id: Budget.ID, dateInterval: DateInterval, completion: @escaping (Result<BudgetDetails, Error>) -> Void) -> Cancellable?

    func archive(id: Budget.ID, completion: @escaping (Result<Budget, Error>) -> Void) -> Cancellable?

    func recommendedBudgets(completion: @escaping (Result<[RecommendedBudget], Error>) -> Void) -> Cancellable?
}
