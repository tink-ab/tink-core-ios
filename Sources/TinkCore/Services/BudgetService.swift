protocol BudgetService {
    func budgets(includeArchived: Bool, completion: @escaping (Result<[Budget], Error>) -> Void) -> Cancellable?
}
