import Foundation

class RESTCalendarService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func period(
        period: String,
        completion: @escaping (Result<[RESTPeriod], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/calendar/periods/\(period)", method: .get, contentType: .json, completion: completion)
        return client.performRequest(request)
    }
}
