import Foundation

public protocol CategoryService {
    func categories(completion: @escaping (Result<CategoryTree, Error>) -> Void) -> Cancellable?
}
