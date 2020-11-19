import Foundation

extension Tink {
    @discardableResult
    public func _createTemporaryUser(for market: Market, locale: Locale = Tink.defaultLocale, completion: @escaping (Result<Void, Swift.Error>) -> Void) -> RetryCancellable? {
        return services.oAuthService.createAnonymous(market: market, locale: locale, origin: nil) { [weak self] result in
            do {
                let accessToken = try result.get()
                self?.userSession = .accessToken(accessToken.rawValue)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }
    }

    public var _sdkName: String {
        get { sdkHeaderBehavior.sdkName }
        set { sdkHeaderBehavior.sdkName = newValue }
    }
}
