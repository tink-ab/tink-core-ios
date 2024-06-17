import Foundation

public enum RecurringTransactionsGroupStatus: String {
    case undefinded = "UNDEFINED"
    case active = "ACTIVE"
    case inactive = "INACTIVE"
}

public protocol RecurringTransactionsGroupService {
    func recurringTransactionsGroups(
        pageToken: String?,
        pageSize: Int?,
        status: RecurringTransactionsGroupStatus?,
        completion: @escaping (Result<([RecurringTransactionsGroup], NextPageToken), Error>) -> Void
    ) -> Cancellable?
}
