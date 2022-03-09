import Foundation

extension Tink {
    @discardableResult
    public func _createTemporaryUser(for market: Market, locale: Locale = Tink.defaultLocale, completion: @escaping (Result<AccessToken, Swift.Error>) -> Void) -> RetryCancellable? {
        return services.oAuthService.createAnonymous(market: market, locale: locale, origin: nil, completion: completion)
    }

    public var _sdkName: String {
        get { sdkHeaderBehavior.sdkName }
        set { sdkHeaderBehavior.sdkName = newValue }
    }

    public var _version: String {
        get { sdkHeaderBehavior.version }
        set { sdkHeaderBehavior.version = newValue }
    }

    public var _urlSession: URLSession {
        get { client.session }
        set { client.session = newValue }
    }
}
