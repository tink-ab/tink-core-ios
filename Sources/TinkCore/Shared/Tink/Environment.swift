import Foundation

@available(*, deprecated, renamed: "Tink.Environment")
typealias Environment = Tink.Environment

extension Tink {
    /// Represents which endpoints Tink will use.
    public enum Environment {
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
