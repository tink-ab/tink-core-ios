import Foundation

public protocol CategoryService {
    func categories(completion: @escaping (Result<[Category], Error>) -> Void) -> Cancellable?
}
