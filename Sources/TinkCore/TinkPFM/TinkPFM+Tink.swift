import Foundation

@available(*, unavailable, renamed: "Tink")
public typealias TinkContext = Tink

/// An encapsulation of how the SDK connects to the Tink API.
///
/// The `Tink` object manages the connection between the SDK and the Tink API.
/// It is also the object you use to set which user the SDK should display data for.
public final class Tink {

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

    let configuration: Configuration

    lazy private(set) var client: Client = makeClient()
    lazy private(set) var sessionManager = SessionManager(client: client)

    private var authorizationBehavior = AuthorizationHeaderClientBehavior(sessionCredential: nil)
    private var errorBehavior: RequestErrorClientBehavior

    /// A error handler to receive errors emitted by `Tink`.
    public typealias ErrorHandler = (TinkError) -> Void

    // MARK: - Creating a Tink Object

    /// Initializes a new `Tink` object.
    /// - Parameters:
    ///   - configuration: The client configuration to use.
    ///   - errorHandler: Optional error handler.
    public init(configuration: Configuration = Configuration(environment: .production), errorHandler: ErrorHandler? = nil) {
        self.configuration = configuration
        self.errorBehavior = RequestErrorClientBehavior(handler: errorHandler ?? { _ in })
    }

    @available(*, unavailable, renamed: "init(configuration:)")
    public init(clientConfiguration: Configuration) {
        fatalError()
    }

    // MARK: - Configuring the Tink Link Object

    /// Configure shared instance with configration description.
    public static func configure(with configuration: Configuration) {
        _shared = Tink(configuration: configuration)
    }

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

    // MARK: - Managing User Data

    /// Forces a refresh of all statistics data and the latest transactions for the current user. 
    public func refresh() {
        sessionManager.refresh()
    }

    /// Resets internal cache of data for the current user.
    public func resetCache() {
        sessionManager.reset()
    }
}

extension Tink {
    private func makeClient() -> Client {
        if ProcessInfo.processInfo.environment["TINK_DEMO_DATA"] == "YES" {
            return makeDemoClient()
        } else {
            return makeRESTClient()
        }
    }

    private func makeRESTClient() -> Client {
        return RESTClient(
            restURL: configuration.environment.restURL,
            certificates: configuration.certificate,
            behavior: ComposableClientBehavior(
                behaviors: [
                    DeviceIdHeaderClientBehavior(deviceId: DeviceService.deviceId),
                    SDKHeaderClientBehavior(),
                    authorizationBehavior,
                    errorBehavior
                ]
            )
        )
    }

    private func makeDemoClient() -> Client {
        return DemoClient()
    }
}

