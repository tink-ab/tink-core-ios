import Foundation

final class RESTStatisticService: StatisticService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func statistics(
        description: String?,
        periods: [StatisticPeriod] = [],
        types: [Statistic.Kind] = [],
        resolution: Statistic.Resolution,
        padResultsUntilToday: Bool = false,
        completion: @escaping (Result<[Statistic], Error>) -> Void
    ) -> Cancellable? {
        let dates = periods.isEmpty ? nil : periods.compactMap { $0.stringRepresentation }

        let query = RESTStatisticQuery(
            description: description,
            padResultUntilToday: padResultsUntilToday,
            periods: dates,
            resolution: .init(statisticResolution: resolution),
            types: types.map(RESTStatisticQueryType.init)
        )

        let request = RESTResourceRequest<[RESTStatistic]>(path: "/api/v1/statistics/query", method: .post, body: query, contentType: .json) { result in
            completion(result.map { $0.compactMap(Statistic.init) })
        }

        return client.performRequest(request)
    }
}
