import Foundation

// MARK: - Tink Configuration

public protocol Configuration {
    /// The client id for your app.
    var clientID: String { get }

    /// The URI you've setup in Console.
    var appURI: URL? { get }

    /// This URI will be used by the ASPSP to pass the authorization code.
    ///
    /// It corresponds to the redirect/callback URI in OAuth2/OpenId.
    ///
    /// - Note: This parameter is only applicable if you are a TPP.
    var callbackURI: URL? { get }

    /// The environment to use.
    var environment: Tink.Environment { get }

    /// Certificate to use with the API.
    var certificateURL: URL? { get }
}

extension Tink {
    /// Configuration used to set up the Tink
    public struct Configuration: TinkCore.Configuration {
        /// The client id for your app.
        public var clientID: String

        /// The URI you've setup in Console.
        public var redirectURI: URL

        public var appURI: URL?

        public var callbackURI: URL?

        /// The environment to use.
        public var environment: Environment

        /// Certificate to use with the API.
        public var certificateURL: URL?

        /// Certificate to use with the API.
        @available(*, renamed: "certificateURL")
        public var restCertificateURL: URL? {
            certificateURL
        }

        /// - Parameters:
        ///   - clientID: The client id for your app.
        ///   - appURI: The URI you've setup in Console.
        ///   - environment: The environment to use, defaults to production.
        ///   - certificateURL: URL to a certificate file to use with the API.
        public init(
            clientID: String,
            appURI: URL? = nil,
            environment: Environment = .production,
            certificateURL: URL? = nil
        ) {
            if let appURI = appURI {
                precondition(!(appURI.host?.isEmpty ?? true), "Cannot find host in the appURI")
                self.redirectURI = appURI
            } else {
                self.redirectURI = URL(string: "http://localhost:3000/callback")!
            }
            self.appURI = appURI
            self.clientID = clientID
            self.environment = environment
            self.certificateURL = certificateURL
        }

        /// - Parameters:
        ///   - clientID: The client id for your app.
        ///   - redirectURI: The URI you've setup in Console.
        ///   - environment: The environment to use, defaults to production.
        ///   - certificateURL: URL to a certificate file to use with the API.
        public init(
            clientID: String,
            redirectURI: URL,
            environment: Environment = .production,
            certificateURL: URL? = nil
        ) throws {
            guard let host = redirectURI.host, !host.isEmpty else {
                throw NSError(domain: URLError.errorDomain, code: URLError.cannotFindHost.rawValue)
            }
            self.clientID = clientID
            self.redirectURI = redirectURI
            self.appURI = redirectURI
            self.environment = environment
            self.certificateURL = certificateURL
        }
    }
}

extension Tink.Configuration {
    enum Error: Swift.Error, LocalizedError {
        case clientIDNotFound
        case redirectURINotFound

        var errorDescription: String? {
            switch self {
            case .clientIDNotFound:
                return "`TINK_CLIENT_ID` was not found in environment variable. Please configure a Tink Link client identifier before using it."
            case .redirectURINotFound:
                return "`TINK_REDIRECT_URI` was not found in environment variable. Please configure a Tink Link redirect URI before using it."
            }
        }
    }
}
