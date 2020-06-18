import Foundation

struct RESTCategoryService: CategoryService {

    let client: RESTClient

    @discardableResult
    func categories(
        completion: @escaping (Result<CategoryTree, Error>) -> Void
    ) -> Cancellable? {
        let request = RESTResourceRequest<[RESTCategory]>(path: "/api/v1/categories", method: .get, contentType: .json) { result in
            completion(result.map(CategoryTree.init))
        }
        //FIXME: urlComponents.queryItems = [URLQueryItem(name: "locale", value: locale?.identifier)]
        return client.performRequest(request)
    }
}
