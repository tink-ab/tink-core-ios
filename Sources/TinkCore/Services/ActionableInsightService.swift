public protocol ActionableInsightService {
    func insights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> Cancellable?

    func archivedInsights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> Cancellable?

    func archiveInsight(id: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
}
