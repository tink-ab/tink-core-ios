/// An error returned by Tink service requests when something went wrong.
public enum ServiceError: Error {
    /// Cancelled
    case cancelled
    /// Invalid argument
    case invalidArgument(String)
    /// Not found
    case notFound(String)
    /// The resource already exists
    case alreadyExists(String)
    /// The user has no permission
    case permissionDenied(String)
    /// The user is not authenticated
    case unauthenticated(String)
    /// Precondition failed
    case failedPrecondition(String)
    /// Request rate limit is exceeded
    case tooManyRequests(String)
    /// The request cannot be fulfilled because of legal/contractual reasons.
    case unavailableForLegalReasons(String)
    /// Internal error
    case internalError(String)

    init(statusCodeError: HTTPStatusCodeError, message: String?) {
        switch statusCodeError {
        case .badRequest:
            self = .invalidArgument(message ?? "")
        case .unauthorized:
            self = .unauthenticated(message ?? "User is not authenticated")
        case .forbidden:
            self = .permissionDenied(message ?? "")
        case .notFound:
            self = .notFound(message ?? "")
        case .conflict:
            self = .alreadyExists(message ?? "")
        case .preconditionFailed:
            self = .failedPrecondition(message ?? "")
        case .tooManyRequests:
            self = .tooManyRequests(restError?.errorMessage ?? "")
        case .unavailableForLegalReasons:
            self = .unavailableForLegalReasons(message ?? "")
        case .internalServerError:
            self = .internalError(message ?? "Internal server error")
        case .serverError(let code):
            self = .internalError(message ?? "Error code \(code)")
        case .clientError(let code):
            self = .internalError(message ?? "Error code \(code)")
        }
    }
}
