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
    /// The request cannot be fulfilled because of legal/contractual reasons.
    case unavailableForLegalReasons(String)
    /// Internal error
    case internalError(String)

    init?(_ error: Swift.Error) {
        let restError = error as? RESTError
        if let statusCodeError = restError?.statusCodeError ?? error as? HTTPStatusCodeError {
            switch statusCodeError {
            case .badRequest:
                self = .invalidArgument(restError?.errorMessage ?? "")
            case .unauthorized:
                self = .unauthenticated(restError?.errorMessage ?? "User is not authenticated")
            case .forbidden:
                self = .permissionDenied(restError?.errorMessage ?? "")
            case .notFound:
                self = .notFound(restError?.errorMessage ?? "")
            case .conflict:
                self = .alreadyExists(restError?.errorMessage ?? "")
            case .preconditionFailed:
                self = .failedPrecondition(restError?.errorMessage ?? "")
            case .unavailableForLegalReasons:
                self = .unavailableForLegalReasons(restError?.errorMessage ?? "")
            case .internalServerError:
                self = .internalError(restError?.errorMessage ?? "Internal server error")
            case .serverError(let code):
                self = .internalError(restError?.errorMessage ?? "Error code \(code)")
            case .clientError(let code):
                self = .internalError(restError?.errorMessage ?? "Error code \(code)")
            }
        } else {
            return nil
        }
    }
}
