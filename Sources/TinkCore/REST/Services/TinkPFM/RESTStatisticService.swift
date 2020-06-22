import Foundation

class RESTStatisticService: StatisticService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func statistics(
        description: String?,
        periods: [DateComponents] = [],
        types: [Statistic.Kind] = [],
        resolution: Statistic.Resolution,
        padResultsUntilToday: Bool = false,
        completion: @escaping (Result<[Statistic], Error>) -> Void
    ) -> Cancellable? {
        let dates = periods.isEmpty ? nil : periods.compactMap { Calendar.current.date(from: $0) }

        let query = RESTStatisticQuery(
            description: description,
            padResultUntilToday: padResultsUntilToday,
            periods: dates,
            resolution: .init(statisticResolution: resolution),
            types: types.map(RESTStatisticQueryType.init)
        )

        let bodyEncoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        bodyEncoder.dateEncodingStrategy = .formatted(dateFormatter)
        let body = try! bodyEncoder.encode(query)

        let request = RESTResourceRequest<[RESTStatistic]>(path: "/api/v1/statistics/query", method: .post, body: body, contentType: .json) { result -> Void in
            completion(result.map { $0.map(Statistic.init) })
        }

        return client.performRequest(request)
    }
}
