public protocol ActionableInsightService {
    func insights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func archivedInsights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func selectAction(insightAction: String, insightID: ActionableInsight.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
    
    func archive(id: ActionableInsight.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
}
