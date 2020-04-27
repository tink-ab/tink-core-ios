import Foundation

protocol StatisticService {
    func statistics(
    description: String,
    periods: [DateComponents],
    types: [RESTStatisticQueryType],
    periodMode: RESTPeriodMode,
    padResultsUntilToday: Bool,
    completion: @escaping (Result<[RESTStatistic], Error>) -> Void
    ) -> Cancellable?
}
