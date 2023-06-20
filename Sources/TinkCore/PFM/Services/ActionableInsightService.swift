public protocol ActionableInsightService {
    func insights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func archivedInsights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func select(
        _ insightAction: ActionableInsight.InsightAction,
        forInsightWithID insightID: ActionableInsight.ID,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable?
}
