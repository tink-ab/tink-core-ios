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
    private static var _shared: Tink?

    // MARK: - Using the Shared Instance

    /// The shared `Tink` instance.
    ///
    /// Note: You need to configure the shared instance by calling `Tink.configure(with:)`
    /// before accessing the shared instance. Not doing so will cause a run-time error.
    public static var shared: Tink {
        guard let shared = _shared else {
            fatalError("Configure Tink by calling `Tink.configure(with:)` before accessing the shared instance")
        }
        return shared
    }

    let sdkHeaderBehavior: SDKHeaderClientBehavior
    private var authorizationBehavior = AuthorizationHeaderClientBehavior(userSession: nil)
    let client: RESTClient
    public var sessionManagers: [SessionManager] = []

    // MARK: - Specifying the Credential

    /// The current user session associated with this Tink object.
    ///
    /// When you set this property to some value, all requests made by this Tink object or any
    /// other object associated with it will try to authenticate using the provided user session credentials.
    ///
    /// You can check if this property is not `nil` if you want to check if the Tink object
    /// is currently trying to authenticate with user session credentials.
    ///
    /// - Note: The existence of a `userSession` does not guarantee that the session is
    /// valid. It may have expired or be invalid.
    public var userSession: UserSession? {
        get { authorizationBehavior.userSession }
        set { authorizationBehavior.userSession = newValue }
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
    public init(configuration: TinkCore.Configuration) {
        self.configuration = configuration
        let certificateURL = configuration.certificateURL
        let certificate = certificateURL.flatMap { try? String(contentsOf: $0, encoding: .utf8) }
        self.sdkHeaderBehavior = SDKHeaderClientBehavior(sdkName: "Tink Link iOS", clientID: self.configuration.clientID)
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
    public static func configure(with configuration: TinkCore.Configuration) {
        _shared = Tink(configuration: configuration)
    }

    /// The current configuration.
    public let configuration: TinkCore.Configuration

    // MARK: - Services

    public private(set) lazy var services = ServiceContainer(client: client, appUri: self.configuration.appURI)
}

public extension Tink {
    enum UserError: Swift.Error {
        /// The market and/or locale was invalid. The payload from the backend can be found in the associated value.
        case invalidMarketOrLocale(String)

        init?(createTemporaryUserError error: Swift.Error) {
            switch error {
            case ServiceError.invalidArgument(let message):
                self = .invalidMarketOrLocale(message)
            default:
                return nil
            }
        }
    }

    // MARK: - Authenticating a User

    /// Authenticate a permanent user with authorization code.
    ///
    /// - Parameter authorizationCode: Authenticate with a `AuthorizationCode` that delegated from Tink to exchanged for a user object.
    /// - Parameter completion: A result representing either a success or an error.
    @discardableResult
    func authenticateUser(authorizationCode: AuthorizationCode, completion: @escaping (Result<Void, Swift.Error>) -> Void) -> RetryCancellable? {
        return services.oAuthService.authenticate(clientID: configuration.clientID, code: authorizationCode, completion: { [weak self] result in
            do {
                let accessToken = try result.get()
                self?.userSession = .accessToken(accessToken.rawValue)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        })
    }
}

public extension Tink {
    /// Sets the credential to be used for this Tink Context.
    ///
    /// The credential is associated with a specific user which has been
    /// created and authenticated through the Tink API.
    ///
    /// - Parameter credential: The credential to use.
    @available(*, deprecated, message: "Set the userSession property directly instead.")
    func setCredential(_ credential: SessionCredential?) {
        authorizationBehavior.userSession = credential
    }
}
