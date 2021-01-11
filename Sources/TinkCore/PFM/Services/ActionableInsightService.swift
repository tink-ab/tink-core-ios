public protocol ActionableInsightService {
    func insights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func archivedInsights(completion: @escaping (Result<[ActionableInsight], Error>) -> Void) -> RetryCancellable?

    func select(
        _ insightAction: ActionableInsight.InsightAction,
        forInsightWithID insightID: ActionableInsight.ID,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> RetryCancellable?

    @available(*, deprecated, message: "Use select(_:forInsightWithID:completion:) method instead.")
    func selectAction(insightAction: String, insightID: ActionableInsight.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?

    @available(*, deprecated, message: "Use select(_:forInsightWithID:completion:) method instead.")
    func archive(id: ActionableInsight.ID, completion: @escaping (Result<Void, Error>) -> Void) -> RetryCancellable?
}
