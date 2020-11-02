import Foundation

@available(*, deprecated, renamed: "Tink.Environment")
public typealias Environment = Tink.Environment

public extension Tink {
    /// Represents which endpoints Tink will use.
    enum Environment {
        /// The production environment.
        case production
        /// A custom environment.
        /// - restURL: The URL for the REST endpoints
        case custom(restURL: URL)

        var restURL: URL {
            switch self {
            case .production:
                return URL(string: "https://api.tink.com")!
            case .custom(let url):
                return url
            }
        }
    }
}
