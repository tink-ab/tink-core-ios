public protocol ActionableInsightService {
    func insights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func archivedInsights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func archiveInsight(id: String, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
}
