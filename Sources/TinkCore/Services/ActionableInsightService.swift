public protocol ActionableInsightService {
    func insights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func archivedInsights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func selectAction(insightAction: String, insightID: String, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    
    func archive(id: String, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
}
