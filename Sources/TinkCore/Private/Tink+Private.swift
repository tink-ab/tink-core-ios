import Foundation

public extension Tink {
    @discardableResult
    func _createTemporaryUser(for market: Market, locale: Locale = Tink.defaultLocale, completion: @escaping (Result<Void, Swift.Error>) -> Void) -> RetryCancellable? {
        return services.oAuthService.createAnonymous(market: market, locale: locale, origin: nil) { [weak self] result in
            let mappedResult = result.mapError { UserError(createTemporaryUserError: $0) ?? $0 }
            do {
                let accessToken = try mappedResult.get()
                self?.userSession = .accessToken(accessToken.rawValue)
                completion(.success)
            } catch {
                completion(.failure(error))
            }
        }
    }

    var _sdkName: String {
        get { sdkHeaderBehavior.sdkName }
        set { sdkHeaderBehavior.sdkName = newValue }
    }
}
