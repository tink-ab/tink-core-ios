import Foundation

class RESTCategoryService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    @discardableResult
    func categories(
        completion: @escaping (Result<[RESTCategory], Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest(path: "/api/v1/categories", method: .get, contentType: .json, completion: completion)
        //FIXME: urlComponents.queryItems = [URLQueryItem(name: "locale", value: locale?.identifier)]
        return client.performRequest(request)
    }
}
