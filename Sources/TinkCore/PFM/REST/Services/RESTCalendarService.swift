import Foundation

final class RESTCalendarService: CalendarService {
    private let client: RESTClient

    init(client: RESTClient) {
        self.client = client
    }

    @discardableResult
    func period(
        period: String,
        completion: @escaping (Result<[Period], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<[RESTPeriod]>(path: "/api/v1/calendar/periods/\(period)", method: .get, contentType: .json) { result in
            completion(result.map { $0.compactMap(Period.init) })
        }
        return client.performRequest(request)
    }
}
