import Foundation

// MARK: - Tink Configuration

public protocol Configuration {
    /// The client id for your app.
    var clientID: String? { get set }

    /// The URI you've setup in Console.
    var redirectURI: URL? { get set }

    /// The environment to use.
    var environment: Tink.Environment { get set }

    /// Certificate to use with the API.
    var restCertificateURL: URL? { get set }
}

