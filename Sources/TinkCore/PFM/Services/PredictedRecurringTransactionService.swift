import Foundation

public typealias NextPageToken = String

public protocol PredictedRecurringTransactionService {
    func transactions(
        groupIdIn: String?,
        pageToken: String?,
        pageSize: Int?,
        completion: @escaping (Result<([PredictedRecurringTransaction], NextPageToken), Error>) -> Void
    ) -> Cancellable?
}
