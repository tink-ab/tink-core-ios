import Foundation

class RESTStatisticService: StatisticService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    public init(tink: Tink) {
        self.client = tink.client
    }

    @discardableResult
    public func statistics(
        description: String = "",
        periods: [DateComponents] = [],
        types: [RESTStatisticQueryType] = [],
        periodMode: RESTPeriodMode,
        padResultsUntilToday: Bool = false,
        completion: @escaping (Result<[RESTStatistic], Error>) -> Void
    ) -> Cancellable? {
        let dates = periods.isEmpty ? nil : periods.compactMap { Calendar.current.date(from: $0) }

        let resolution: RESTStatisticQueryResolution
        switch periodMode {
        case .monthly:
            resolution = .monthly
        case .monthlyAdjusted:
            resolution = .monthlyAdjusted
        }

        let query = RESTStatisticQuery(
            description: nil,
            padResultUntilToday: false,
            periods: dates,
            resolution: resolution,
            types: types
        )

        let bodyEncoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        bodyEncoder.dateEncodingStrategy = .formatted(dateFormatter)
        let body = try! bodyEncoder.encode(query)

        let request = RESTResourceRequest(path: "/api/v1/statistics/query", method: .post, body: body, contentType: .json, completion: completion)

        return client.performRequest(request)
    }
}
