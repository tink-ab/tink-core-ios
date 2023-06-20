import Foundation

extension Tink {
    /// Represents which endpoints Tink will use.
    public enum Environment {
        /// The production environment.
        case production
        /// A custom environment.
        case custom(URL)

        var url: URL {
            switch self {
            case .production:
                return URL(string: "https://api.tink.com")!
            case .custom(let url):
                return url
            }
        }
    }
}
