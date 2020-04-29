import Foundation

public final class RESTCalendarService: CalendarService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    public init(tink: Tink) {
        self.client = tink.client
    }

    @discardableResult
    public func period(
        period: String,
        completion: @escaping (Result<[Period], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<[RESTPeriod]>(path: "/api/v1/calendar/periods/\(period)", method: .get, contentType: .json) { result in
            completion(result.map { $0.compactMap(Period.init) })
        }
        return client.performRequest(request)
    }
}
