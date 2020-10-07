import Foundation

struct RESTError: Error, LocalizedError, Decodable {
    let errorMessage: String?
    let errorCode: String

    var statusCodeError: HTTPStatusCodeError? {
        Int(errorCode).flatMap { HTTPStatusCodeError(statusCode: $0) }
    }

    var errorDescription: String? {
        return errorMessage
    }
}
