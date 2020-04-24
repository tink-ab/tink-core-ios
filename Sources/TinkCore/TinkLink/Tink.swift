import Foundation
#if os(iOS)
    import UIKit
#endif

/// The `Tink` class encapsulates a connection to the Tink API.
///
/// By default a shared `Tink` instance will be used, but you can also create your own
/// instance and use that instead. This allows you to use multiple `Tink` instances at the
/// same time.
public class Tink {
    static var _shared: Tink?

    // MARK: - Using the Shared Instance

    /// The shared `TinkLink` instance.
    ///
    /// Note: You need to configure the shared instance by calling `TinkLink.configure(with:)`
    /// before accessing the shared instance. Not doing so will cause a run-time error.
    public static var shared: Tink {
        guard let shared = _shared else {
            fatalError("Configure Tink Link by calling `TinkLink.configure(with:)` before accessing the shared instance")
        }
        return shared
    }

    private let sdkHeaderBehavior: SDKHeaderClientBehavior
    private var authorizationBehavior = AuthorizationHeaderClientBehavior(sessionCredential: nil)
    public lazy var oAuthService = RESTOAuthService(client: client)
    private(set) var client: RESTClient

    // MARK: - Specifying the Credential

    /// Sets the credential to be used for this Tink Context.
    ///
    /// The credential is associated with a specific user which has been
    /// created and authenticated through the Tink API.
    ///
    /// - Parameter credential: The credential to use.
    public func setCredential(_ credential: SessionCredential?) {
        authorizationBehavior.sessionCredential = credential
    }

    // MARK: - Creating a Tink Link Object

    private convenience init() {
        do {
            let configuration = try Configuration(processInfo: .processInfo)
            self.init(configuration: configuration)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// Create a Tink instance with a custom configuration.
    /// - Parameters:
    ///   - configuration: The configuration to be used.
    public init(configuration: Configuration) {
        self.configuration = configuration
        let certificateURL = configuration.restCertificateURL
        let certificate = certificateURL.flatMap { try? String(contentsOf: $0, encoding: .utf8) }
        self.sdkHeaderBehavior = SDKHeaderClientBehavior(sdkName: "Tink Link iOS", clientID: configuration.clientID)
        self.client = RESTClient(restURL: self.configuration.environment.restURL, certificates: certificate, behavior: ComposableClientBehavior(
            behaviors: [
                sdkHeaderBehavior,
                authorizationBehavior
            ]
        ))
    }

    // MARK: - Configuring the Tink Link Object

    /// Configure shared instance with configration description.
    ///
    /// Here's how you could configure Tink with a `Tink.Configuration`.
    ///
    ///     let configuration = Configuration(clientID: "<#clientID#>", redirectURI: <#URL#>)
    ///     Tink.configure(with: configuration)
    ///
    /// - Parameters:
    ///   - configuration: The configuration to be used for the shared instance.
    public static func configure(with configuration: Configuration) {
        _shared = Tink(configuration: configuration)
    }

    /// The current configuration.
    public let configuration: Configuration
}
