import Foundation

public protocol CalendarService {
    func period(period: String, completion: @escaping (Result<[Period], Error>) -> Void) -> Cancellable?
}
